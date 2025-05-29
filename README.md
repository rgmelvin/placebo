# Placebo – Example Solana Anchor Project Using Beargrease

This is a minimal, working Solana Anchor test program built to demonstrate local and CI-based testing using [Beargrease](https://github.com/rgmelvin/beargrease-by-cabrillo).

Maintained by **Cabrillo! Labs** – contact: cabrilloweb3@gmail.com

---

## 🧪 What’s in This Repo

This project is a functional Anchor program and test suite that demonstrates:

- Local testing using Beargrease v1.0.x
- GitHub CI testing using Beargrease v1.1.0 Directory Checkout Mode
- Dynamic program ID injection and validator setup
- Mocha test integration via TypeScript ESM

---

## 🧰 Prerequisites

You will need:

- Anchor v0.31.1
- Solana CLI
- Docker (for validator)
- Node.js with `pnpm` or `npm`
- `ts-node` and `mocha`

See the [Beargrease Beginner Guides](https://github.com/rgmelvin/beargrease-by-cabrillo/tree/main/docs) for installation instructions.

---

## 🧭 How to Use This Project

### ▶️ Local Mode

1. Clone this repo and Beargrease:
   ```bash
   git clone https://github.com/rgmelvin/placebo
   git clone https://github.com/rgmelvin/beargrease-by-cabrillo
Copy the Beargrease scripts:

cp -r ../beargrease-by-cabrillo/scripts ./scripts/beargrease
chmod +x ./scripts/beargrease/*.sh
Create a test wallet:

./scripts/beargrease/create-test-wallet.sh
Run the full test harness:

./scripts/beargrease/run-tests.sh
For complete walkthrough, see:
📘 Beginner’s Guide (Local Mode)

🧪 GitHub CI Mode
This repo includes a preconfigured .github/workflows/ci.yml workflow that uses Beargrease via directory checkout and runs tests automatically in GitHub CI.

For setup, secrets, and workflow reference, see:
📘 Beginner’s Guide to Directory Checkout Mode (CI)

🗃️ Project Structure

placebo/
├── Anchor.toml
├── Cargo.toml
├── programs/
├── scripts/
│   └── beargrease/   <- copied from Beargrease repo
├── tests/
│   └── placebo.test.mts
└── .github/
    └── workflows/
        └── ci.yml
👩‍🔬 Developer Notes
This project uses modern TypeScript ESM syntax and dynamic test loading via ts-node. The test file automatically loads the deployed program ID from Anchor.toml.

🧷 License
MIT License
© 2025 Cabrillo! Labs
