# Placebo 🧪

Placebo is a minimal Solana Anchor test program used to validate local and CI-based test harnesses — particularly the [Beargrease](https://github.com/rgmelvin/beargrease) Docker test harness.

---

## 📁 Project Structure

```
placebo/
├── Anchor.toml
├── Cargo.toml
├── programs/
│   └── placebo/
├── tests/
│   └── placebo.test.mts
├── .github/
│   └── workflows/
│       └── ci.yml
└── README.md
```

---

## 📦 Requirements

- Node.js ≥ 18
- Yarn (or npm)
- Rust + Cargo
- Solana CLI (`solana`)
- Anchor CLI (`anchor`)
- Docker + Docker Compose
- [Beargrease](https://github.com/rgmelvin/beargrease) (for local or CI test orchestration)

---

## 🚀 Getting Started

### 1. Install dependencies

```bash
anchor --version        # Anchor CLI must be installed
solana --version        # Solana CLI must be installed
yarn install            # or: npm install
```

### 2. Build the program

```bash
anchor build
```

### 3. Run local tests with Beargrease

```bash
../beargrease/scripts/create-test-wallet.sh
../beargrease/scripts/run-tests.sh
```

This will:
- Launch a local validator in Docker
- Deploy the Placebo program
- Run the test suite via Mocha/ts-node
- Shut down the validator afterward

---

## 🧪 Test File Overview

Tests live in: `tests/placebo.test.mts`

This uses:
- ESM imports (`.mts`)
- Program ID auto-loaded from `Anchor.toml`
- IDL loaded from `target/idl/placebo.json`
- Wallet keypair from `.ledger/wallets/test-user.json`

---

## 🏗️ CI Integration

Placebo uses the [Beargrease GitHub Action](https://github.com/rgmelvin/beargrease-by-cabrillo) in CI.

### ✅ To trigger tests in GitHub Actions

Ensure your workflow includes:

```yaml
- name: 🐻 Run Beargrease CI
  uses: rgmelvin/beargrease-by-cabrillo@v1
```

You must define a secret:
- `BEARGREASE_WALLET_SECRET_BASE64` → base64-encoded wallet used inside CI container

---

## 📚 Resources

- [Beargrease Beginner Guide](https://github.com/rgmelvin/beargrease/blob/main/docs/Beargrease_Beginner_Guide.md)
- [Beargrease GitHub Action](https://github.com/rgmelvin/beargrease-by-cabrillo)

---

## 🧼 Cleanup

To remove validator containers and networks:

```bash
docker compose down
```

Or use the cleanup logic already embedded in `run-tests.sh`.

---

## 📝 License

MIT © Cabrillo! Labs
cabrilloweb3@gmail.com