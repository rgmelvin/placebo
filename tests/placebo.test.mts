import { assert } from "chai";
// @ts-ignore
import { getProgram } from "file:///home/rgmelvin/Projects/cabrillo/beargrease/test-utils/program.mts";

describe("placebo", () => {
  it("calls say_hello", async () => {
    const program = await getProgram("placebo");
    const tx = await program.methods.sayHello().rpc();
    console.log("tx:", tx);
    assert.isString(tx);
  });
});
