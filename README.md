# Placebo

A minimal Solana Anchor program used to demonstrate the Beargrease testing harness.

Placebo contains a single instruction (`say_hello`) and is designed as a sandbox for testing Solana program workflows using real-world tooling: TypeScript, Docker, and Beargrease.

---

## 🧪 What It Does

Placebo defines one instruction:

```rust
pub fn say_hello(_ctx: Context<Hello>) -> Result<()> {
    msg!("👋 Hello from Placebo!");
    Ok(())
}
```

It logs a message on-chain. That’s it. But that’s enough to prove a full test loop works.

---

## 🧰 Tech Stack

- [Anchor Framework](https://book.anchor-lang.com/)  
- [Mocha](https://mochajs.org/) + [ts-mocha](https://www.npmjs.com/package/ts-mocha)
- [Beargrease](https://github.com/rgmelvin/beargrease-by-cabrillo) (Docker-based test harness)
- Solana CLI + Local validator
- GitHub Actions (optional CI)

---

## 🐻 Beargrease Dependency

Placebo uses [Beargrease](https://github.com/rgmelvin/beargrease-by-cabrillo) to:

- Launch a clean Dockerized Solana validator
- Fund test wallets
- Build and deploy the Anchor program
- Run end-to-end TypeScript tests

---

### 🧷 Symlink Requirement

This file is a **symlink** to Beargrease:

```bash
scripts/run-tests.sh -> ../../beargrease/scripts/run-tests.sh
```

In order for that symlink to work, clone both repos side-by-side:

```
Projects/
├── beargrease/
└── placebo/
```

If you clone them separately, you’ll need to recreate the symlink or call Beargrease directly.

---

## 🚀 Running Tests

To run the full Beargrease-powered test pipeline:

```bash
./scripts/run-tests.sh
```

This will:
- Spin up a Docker validator
- Build + deploy the program
- Inject the program ID into `Anchor.toml` and `lib.rs`
- Run `yarn test` with your TypeScript suite
- Tear everything down cleanly

---

## 📦 Test Output

The test lives in [`tests/placebo.test.ts`](./tests/placebo.test.ts). It looks like:

```ts
it("says hello", async () => {
  const tx = await program.methods.sayHello().rpc();
  console.log("📦 Transaction signature", tx);
});
```

The expected output from the local validator:

```bash
👋 Hello from Placebo!
```

---

## 📝 License

MIT © 2024 Richard G. Melvin, Cabrillo!, Labs  
Contact: [cabrilloweb3@gmail.com](mailto:cabrilloweb3@gmail.com)

---

## 💬 About Cabrillo!, Labs

Cabrillo!, Labs builds transparent tools for decentralized systems and scientific ownership.  
Beargrease and Placebo are part of a broader effort to bring clarity, reproducibility, and equity to Web3 and research ecosystems!

---