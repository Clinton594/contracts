const { assert } = require("console");

const Wallet = artifacts.require("Wallet");

contract("Wallet", (accounts) => {
  let wallet;
  let approvers = accounts.slice(0, 3);
  beforeEach(async () => {
    wallet = await Wallet.new(approvers, 2);
    await web3.eth.sendTransaction({ from: accounts[0], to: wallet.address, value: 1000 });
  });
  it("Should have approvers and quorum", async () => {
    const _approvers = await wallet.getApprovers();
    const _quorum = await wallet.quorum();
    assert(_approvers.length === 3);
    assert(approvers[0] === _approvers[0]);
    assert(approvers[1] === _approvers[1]);
    assert(approvers[2] === _approvers[2]);
    assert(_quorum.toNumber() === 2);
  });

  it("Should create transfers", async () => {
    await wallet.createTransfer(100, accounts[5]);
    const transactions = await wallet.getTransfers();
    assert(transactions[0].id === 0);
  });
});
