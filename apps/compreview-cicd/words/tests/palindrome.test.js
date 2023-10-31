const assert = require("assert");
const { isPalindrome } = require("../palindrome");

describe("isPalindrome", () => {
    it("empty string is a palindrome", () => {
      const result = isPalindrome("");
      assert.ok(result);
    });

    it("racecar is a palindrome", () => {
      const result = isPalindrome("racecar");
      assert.ok(result);
    });

    it("hello is not a palindrome", () => {
      const result = isPalindrome("hello");
      assert.ok(!result);
    });
})