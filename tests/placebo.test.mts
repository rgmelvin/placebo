import { assert } from "chai";
// @ts-ignore
import { loadProgram } from "bg-testkit";

describe("placebo", () => {
  it("calls say_hello", async () => {
    const program = await loadProgram("placebo");
    const tx = await program.methods.sayHello().rpc();
    console.log("tx:", tx);
    assert.isString(tx);
  });
});
