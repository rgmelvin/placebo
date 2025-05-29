# Placebo 🧪

This is a minimal Anchor program used for testing CI pipelines and validator harnesses. It is intentionally trivial: the contract does nothing, but the structure is complete and real. The goal is to test *the testing system itself*, not any particular Solana logic.

Placebo is developed in tandem with [Beargrease](https://github.com/rgmelvin/beargrease), a transparent Docker-based Solana test harness with full CI support. This repository is intended to serve as both a reference implementation and a live demo target for Beargrease workflows.

---

## 📦 Dependencies

You will need:

- Solana CLI ≥ 1.18.0
- Anchor CLI ≥ 0.31.1
- Docker and Docker Compose
- Node.js ≥ 18 with TypeScript and Mocha
- Beargrease v1.1.0+

---

## 🧪 Running Tests Locally

To test locally using Beargrease:

```bash
# Step into the project directory
cd placebo

# Create a test wallet
../beargrease/scripts/create-test-wallet.sh

# Run the test harness
../beargrease/scripts/run-tests.sh
```

This will:
- Start a Solana test validator in Docker
- Deploy the placebo program
- Patch the program ID dynamically
- Run Mocha tests in ESM mode
- Shut down and clean up

---

## 🤖 CI Mode: GitHub Actions

Placebo supports Beargrease **Directory Checkout Mode** as of v1.1.0. This mode avoids requiring Beargrease to be installed as a GitHub Action and instead runs directly from a local checkout of the Beargrease repo.

To use this:

```yaml
# .github/workflows/ci.yml
name: ☣️ Placebo CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: 📁 Checkout Beargrease test harness
        uses: actions/checkout@v4
        with:
          repository: rgmelvin/beargrease
          path: beargrease

      - name: 🧪 Run Beargrease Test Harness
        run: ./beargrease/scripts/run-tests.sh
```

This is the preferred approach for CI.

---

## 🔬 Tests

The test file lives in `tests/placebo.test.mts`. It is written in modern ESM TypeScript with Mocha:

- Loads the IDL from `target/idl/placebo.json`
- Reads the deployed program ID from `Anchor.toml`
- Uses `ANCHOR_PROVIDER` and `ANCHOR_WALLET` for context
- Confirms the program was deployed and reachable

You can extend this test to simulate your own program behaviors.

---

## 🧹 Cleanup

To manually clean up after a test run:

```bash
docker compose down
rm -rf .wallet .beargrease
```

---

## 📚 References

- [Beargrease Documentation](https://github.com/rgmelvin/beargrease)
- [Anchor Docs](https://book.anchor-lang.com/)
- [Solana CLI](https://docs.solana.com/cli)

---

MIT License · Cabrillo! Labs