const { convert } = require("../convert");
const assert = require("assert");

describe("convert", () => {
  it("should convert USD to USD", () => {
    const result = convert("usd", "usd", 3.5);
    assert.equal(result, 3.5);
  });

  it("should convert from USD", () => {
    const result = convert("usd", "gbp", 3.5);
    assert.equal(result, 2.6);
  });

  it("should convert to USD", () => {
    const result = convert("gbp", "usd", 2.6);
    assert.equal(result, 3.49);
  });

  it("should convert between non-USD", () => {
    const result = convert("gbp", "eur", 2.6);
    assert.equal(result, 2.88);
  });

  it("should convert GBP to GBP", () => {
    const result = convert("gbp", "gbp", 3.5);
    assert.equal(result, 3.5);
  });
});
