const expect = require("expect");

const ICO = artifacts.require("BTTCrowdsale");
const Token = artifacts.require("BTToken");

contract("BTTCrowdsale", (accounts) => {
  let account = accounts[0];
  let $token, $crowdsale;

  before(async () => {
    $token = await Token.new("BTToken", "BTT", "2000");
    $crowdsale = await ICO.new(5, account, $token);
  });

  describe("BTToken", () => {
    it("Should mint extra 350 BTT", async () => {
      await $token.mint(350);
      const supply = await $token.totalSupply();
      expect(supply.toString()).toBe("2350");
    });

    it("Should Transfer 400 BTT to account2", async () => {
      await $token.transfer(accounts[1], 400);
      const account2 = await $token.balanceOf(accounts[1]);
      expect(account2.toString()).toBe("400");
    });

    it("Should Verify that account 1 only has 1950 BTT", async () => {
      const account1 = await $token.balanceOf(account);
      expect(account1.toString()).toBe("1950");
    });
  });

  describe("CrowdSale", () => {});
});
