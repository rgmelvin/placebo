import { AnchorProvider, Program, setProvider, Idl } from "@coral-xyz/anchor";
import { PublicKey } from "@solana/web3.js";
import { assert } from "chai";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

// ESM-compatible __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load Anchor.toml and extract program ID
const anchorTomlPath = path.resolve(__dirname, "..", "Anchor.toml");
const anchorToml = fs.readFileSync(anchorTomlPath, "utf8");
const match = anchorToml.match(/placebo\s*=\s*"([^"]+)"/);
const fallbackProgramId = "DEdLFqehJ6knPRqEYfJkhaNXowbDNxivZvqRwvsixd6L";
const programId = new PublicKey(match?.[1] ?? fallbackProgramId);

// ✅ Load and assert IDL type
import rawIdl from "../target/idl/placebo.json" with { type: "json" };
const idl: Idl = rawIdl as Idl;

// ✅ Setup provider
const provider = AnchorProvider.env();
setProvider(provider);

// ✅ Construct program with assertive types
const program: Program = new Program<Idl>(idl, programId, provider);

describe("placebo", () => {
  it("calls say_hello successfully", async () => {
    const tx = await program.methods.sayHello().rpc();
    console.log("📝 Transaction signature:", tx);
    assert.isString(tx);
  });
});
