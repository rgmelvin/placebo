import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { assert } from "chai";

describe("placebo", () => {
    const provider = anchor.AnchorProvider.env();
    anchor.setProvider(provider);

    const program = anchor.workspace.placebo as Program;

    it("says hello", async () => {
        const tx = await program.methods.sayHello().rpc();
        console.log("📦 Transaction signature", tx);
        assert.ok(tx);
    });
});