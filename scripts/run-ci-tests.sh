#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(pwd)"
ANCHOR_PROVIDER_URL="http://localhost:8899"
WALLET_PATH="$PROJECT_ROOT/.wallet/id.json"

export ANCHOR_PROVIDER_URL
export ANCHOR_WALLET="$WALLET_PATH"
export PATH="$HOME/.cargo/bin:$HOME/.local/share/solana/install/active_release/bin:$PATH"

echo "📦 Running Beargrease CI pipeline"

# ----------------------------------------------------------------------
# 1. Start Validator
# ----------------------------------------------------------------------
echo "🚀 Starting Solana validator in Docker"
docker compose -f .beargrease/docker-compose.yml up -d

# Ensure solana CLI targets the test validator
solana config set --url "$ANCHOR_PROVIDER_URL"

# ----------------------------------------------------------------------
# 2. Wait for Validator Health
# ----------------------------------------------------------------------
echo "⏳ Waiting for validator to become responsive..."
for i in {1..60}; do
    if solana cluster-version > /dev/null 2>&1; then
        echo "✅ Validator RPC is responsive (attempt $i)"
        break
    fi
    echo "⏳ Attempt $i: still waiting..."
    sleep 1
done

# ----------------------------------------------------------------------
# 3A. Inject Wallet from Secret (if present)
# ----------------------------------------------------------------------
if [[ -n "${BEARGREASE_WALLET_SECRET:-}" ]]; then
    echo "📬 Decoding injected wallet from BEARGREASE_WALLET_SECRET"
    mkdir -p "$(dirname "$WALLET_PATH")"

    # Decode and rewrite the array to valid keypair format
    RAW_ARRAY=$(echo "$BEARGREASE_WALLET_SECRET" | base64 --decode)
    TMP_FILE=$(mktemp)

    # Write raw array to temp file
    echo "$RAW_ARRAY" > "$TMP_FILE"

    # Convert to valid keypair JSON format
    PUBKEY=$(solana-keygen pubkey "$TMP_FILE")
    echo "{\"publicKey\":\"$PUBKEY\",\"secretKey\":$RAW_ARRAY}" > "$WALLET_PATH"

    echo "🪪 Reconstructed keypair file:"
    cat "$WALLET_PATH"
fi



# ----------------------------------------------------------------------
# 3B. Ensure Wallet Exists
# ----------------------------------------------------------------------
if [[ ! -f "$WALLET_PATH" ]]; then
    echo "❌ Wallet not found at $WALLET_PATH"
    exit 1
fi

echo "🔐 Using wallet: $WALLET_PATH"

# ----------------------------------------------------------------------
# 4. Build and Deploy
# ----------------------------------------------------------------------
echo "🔨 Building program with Anchor..."
anchor build

echo "⛵ Deploying program..."
anchor deploy

# ----------------------------------------------------------------------
# 5. Extract Program ID
# ----------------------------------------------------------------------
IDL_PATH="$PROJECT_ROOT/target/idl/placebo.json"
PROGRAM_ID=$(jq -r '.metadata.address // empty' "$IDL_PATH")

if [[ -z "$PROGRAM_ID" ]]; then
    echo "❌ Could not extract program ID from IDL"
    exit 1
fi

# ----------------------------------------------------------------------
# 6. Wait for Program to Be Indexed
# ----------------------------------------------------------------------
echo "🔎 Waiting for validator to recognize program ID: $PROGRAM_ID"
for i in {1..60}; do
    if solana program show "$PROGRAM_ID" > /dev/null 2>&1; then
        echo "✅ Program indexed (attempt $i)"
        break
    fi
    echo "⏳ Attempt $i: still waiting..."
    sleep 1
done

# ----------------------------------------------------------------------
# 7. Run Tests
# ----------------------------------------------------------------------
if [ -f "package.json" ] && jq -e '.scripts.test' package.json > /dev/null; then
    echo "☕ Running Mocha tests via yarn..."
    yarn test
else
    echo "⚓ Running anchor test (fallback)..."
    anchor test --skip-local-validator
fi

# ----------------------------------------------------------------------
# 8. Shut Down Validator
# ----------------------------------------------------------------------
echo "🛑 Shutting down validator"
docker compose -f .beargrease/docker-compose.yml down

echo "✅ Beargrease CI pipeline complete"
