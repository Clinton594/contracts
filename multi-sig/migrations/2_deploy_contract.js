const Wallet = artifacts.require("Wallet");

module.exports = async (deployer, _network, accounts) => {
  await deployer.deploy(Wallet, accounts.slice(0, 3), 2);
  const wallet = await Wallet.deployed();
  await web3.eth.sendTransaction({ from: accounts[0], to: wallet.address, value: 5 * 10 ** 18 });
};
