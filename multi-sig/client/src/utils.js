import Web3 from "web3";
import Wallet from "./contracts/Wallet.json";

const connection = () => {
  return new Promise((resolve, reject) => {
    window.addEventListener("load", async () => {
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        try {
          await window.ethereum.enable();
          resolve(web3);
        } catch (error) {
          reject(error);
        }
      } else if (window.web3) {
        resolve(window.web3);
      } else {
        reject("No Metamask installed");
      }
    });
  });
};

const getContract = async (web3) => {
  const networkId = await web3.eth.net.getId();
  const deployedNetwork = Wallet.networks[networkId];
  return new web3.eth.Contract(Wallet.abi, deployedNetwork && deployedNetwork.address);
};

const getAccount = async (web3) => {
  const networkId = await web3.eth.net.getId();
  const deployedNetwork = Wallet.networks[networkId];
  const balance = deployedNetwork.address && (await web3.eth.getBalance(deployedNetwork.address));
  return { contract: deployedNetwork.address, balance };
};

export { getContract, connection, getAccount };
