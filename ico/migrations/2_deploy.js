const BTToken = artifacts.require("BTToken");
const BTTCrowdsale = artifacts.require("BTTCrowdsale");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(BTToken, "BrainTemple", "BTT", "1000000000000000000");
  const token = await BTToken.deployed();

  const ownerAccount = accounts[0]; // Whose account would the presale token be deployed to
  await deployer.deploy(BTTCrowdsale, 50, ownerAccount, token.address);
  const crowdsale = await BTTCrowdsale.deployed();

  token.transfer(crowdsale.address, await token.totalSupply());
};
