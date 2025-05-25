#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(pwd)"
ANCHOR_PROVIDER_URL="http://localhost:8899"
export  ANCHOR_PROVIDER_URL

echo "📦 Running Beargrease CI pipeline"

# ----------------------------------------------------------------------
# 1. Start Validator
# ----------------------------------------------------------------------
echo "🚀 Starting Solana validator"
docker compose -f .beargrease/docker-compose.yml up -d

# ----------------------------------------------------------------------
# 2. Wait for validator health
# ----------------------------------------------------------------------
echo "⏳ Waiting for validator health check..."
for i in {1..60}; do
    if curl -s --fail "$ANCHOR_PROVIDER_URL" > /dev/null; then
        echo "✅ Validator RPC is responisve (attempt $i)"
        break
    fi
    sleep 1
done

# ----------------------------------------------------------------------
# 3. Use injected CI wallet
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# 3B. Decode BEARGREASE_WALLET_SECRET (if available)
# ----------------------------------------------------------------------
if [[ -n "${BEARGREASE_WALLET_SECRET:-}" ]]; then
    echo "📬 Decoding injected wallet from BEARGREASE_WALLET_SECRET"
    mkdir -p .wallet
    echo "$BEARGREASE_WALLET_SECRET" | base64 -d > .wallet/id.json
    touch .wallet/_was_injected
fi

WALLET_PATH="$PROJECT_ROOT/.wallet/id.json"
export ANCHOR_WALLET="$WALLET_PATH"

if [[ ! -f "$WALLET_PATH" ]]; then
    echo "❌ Wallet not found at $WALLET_PATH"
    exit 1
fi

echo "🔐 Using CI wallet: $ANCHOR_WALLET"



# ------------------------------------------------------------------------
# 4. Build and deploy
# ------------------------------------------------------------------------
echo "🔨 Building program..."
anchor build

echo "⛵ Deploying program..."
anchor deploy

# ----------------------------------------------------------------------
# 5. Get program ID
# ----------------------------------------------------------------------
IDL_PATH="$PROJECT_ROOT/target/idl/placebo.json"
PROGRAM_ID=$(jq -r '.metadata.address // empty' "$IDL_PATH")

if [[ -z "$PROGRAM_ID" ]]; then
    echo "❌ Could not extract program ID from IDL"
    exit 1
fi

# ----------------------------------------------------------------------
# 6. Wait for validator to index program
# ----------------------------------------------------------------------
echo "⏳ Waiting for validator to recognize program ID..."
for i in {1..60}; do
    if solana program show "$PROGRAM_ID" > /dev/null 2>&1; then
        echo "✅ Program indexed (attempt $i)"
        break
    fi
    echo "⏳ Attempt $i: still waiting..."
    sleep 1
done

# ----------------------------------------------------------------------
# 7. Run tests
# ----------------------------------------------------------------------
if [ -f "package.json" ] && jq -e '.scripts.test' package.json > /dev/null; then
    echo " ⚙️☕ Running mocha tests via yarn..."
    yarn test
else
    echo "⚙️⚓ Running anchor test (fallback)..."
    anchor test --skip-local-validator
fi

# ----------------------------------------------------------------------
# Shut down validator
# ----------------------------------------------------------------------
echo "🛑 Shutting down validator"
docker compose -f .beargrease/docker-compose.yml down

echo "✅ CI Pipeline complete"