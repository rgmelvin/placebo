// tests/placebo.test.ts

import { readFileSync } from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { PublicKey } from "@solana/web3.js";
import { assert } from "chai";

// Anchor imports (CommonJS-safe)
import pkg from "@coral-xyz/anchor";
const { Program, AnchorProvider, setProvider } = pkg;


// Required for __dirname under ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// === Load program ID dynamically from Anchor.toml ===
const anchorToml = readFileSync(path.resolve(__dirname, "../Anchor.toml"), "utf8");
const match = anchorToml.match(/placebo\s*=\s*"([^"]+)"/);
if (!match) throw new Error("❌ Could not extract program ID from Anchor.toml");
const programId = new PublicKey(match[1]);

// === Load IDL from target directory ===
const idlPath = path.resolve(__dirname, "../target/idl/placebo.json");
const placeboIdl = JSON.parse(readFileSync(idlPath, "utf8"));

// === Setup Anchor provider ===
const provider = AnchorProvider.env();
setProvider(provider);

// === Program handle ===
const program = new Program(placeboIdl, programId, provider);

// === Tests ===
describe("placebo", () => {
  it("loads the program successfully", async () => {
    assert.isTrue(program.programId instanceof PublicKey);
  });
});
