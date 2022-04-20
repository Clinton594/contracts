import React, { useState, useEffect } from "react";
import { getContract, connection, getAccount } from "./utils";
import Transfers from "./components/Transfers";

function App() {
  const [state, setState] = useState({
    web3: undefined,
    accounts: [],
    contract: undefined,
    quorum: 0,
    approvers: [],
    myAccount: undefined,
    transfers: [],
  });

  let [formdata, setFormdata] = useState({ amount: "", address: "" });
  const updateForm = (event) => {
    setFormdata({ ...formdata, [event.target.name]: event.target.value });
  };

  const submitForm = async (event) => {
    event.preventDefault();
    try {
      await state.contract.methods
        .createTransfer(formdata.amount, formdata.address)
        .send({ from: formdata.address, gas: 3000000 });
    } catch (error) {
      console.log(error);
    }

    updateData();
  };
  // update data
  const updateData = async () => {
    const _accounts = await state.web3.eth.getAccounts();
    const accounts = await Promise.all(
      _accounts.map(async (address) => {
        const balance = await state.web3.eth.getBalance(address);
        return { balance: (balance / 10 ** 18).toFixed(5), address };
      })
    );
    const myAccount = await getAccount(state.web3);
    const transfers = await state.contract.methods.getTransfers().call();
    setState({ ...state, accounts, myAccount, transfers });
  };
  // Approve a transaction
  const sendApprover = async (event) => {
    event.preventDefault();
    const { name, value } = event.target;
    try {
      await state.contract.methods.approveTransfer(name).send({ from: value, gas: 3000000 });
    } catch (error) {
      console.log(error);
    }
    updateData();
  };
  // useEffect
  useEffect(() => {
    const initialize = async () => {
      const web3 = await connection();
      const contract = await getContract(web3);
      const myAccount = await getAccount(web3);
      const _accounts = await web3.eth.getAccounts();
      const accounts = await Promise.all(
        _accounts.map(async (address) => {
          const balance = await web3.eth.getBalance(address);
          return { balance: (balance / 10 ** 18).toFixed(2), address };
        })
      );
      const quorum = await contract.methods.getQuorum().call();
      const approvers = await contract.methods.getApprovers().call();
      const transfers = await contract.methods.getTransfers().call();
      setState({ web3, contract, accounts, quorum, approvers, myAccount, transfers });
    };
    initialize();
  }, []);

  if (state.web3 === undefined || state.accounts.length === 0) {
    return <div>Loading ... </div>;
  }
  return (
    <div className="App">
      <header className="App-header">
        <h2>My multi signature wallet</h2>
        <ul>
          <li>
            <strong>Contract</strong>
          </li>
          <li>
            <i>
              {state.myAccount && state.myAccount.contract} :{" "}
              {state.myAccount && (state.myAccount.balance / 10 ** 18).toFixed(2)}
              ETH
            </i>
            <hr />
          </li>
          <li>
            <strong>Accounts</strong>
          </li>
          {state.accounts.map((account) => (
            <li key={account.address}>
              {account.address} : ({account.balance} ETH)
            </li>
          ))}
          <hr />
          <li>
            <strong>Approvers [ Any {state.quorum} persons]</strong>
          </li>
          {state.approvers.map((approver) => (
            <li key={approver}>{approver}</li>
          ))}
          <hr />
        </ul>
        <form
          onSubmit={(event) => {
            submitForm(event);
          }}
        >
          <div style={{ width: "100%" }}>
            <input
              style={{ width: 200 }}
              value={formdata.amount}
              name="amount"
              required
              type="number"
              placeholder="in Ethers"
              onChange={(event) => updateForm(event)}
            />
          </div>
          <div style={{ width: "100%" }}>
            <select
              style={{ width: 200 }}
              name="address"
              required
              type="text"
              defaultValue={state.accounts[0]}
              onChange={(event) => updateForm(event)}
            >
              <option>Select Address</option>
              {state.accounts.map((account) => (
                <option key={account.address} value={account.address}>
                  {account.address} : ({account.balance} ETH)
                </option>
              ))}
            </select>
          </div>
          <div>
            <button>Create Transfer</button>
          </div>
        </form>
      </header>
      <Transfers state={state} sendApprover={sendApprover} />
    </div>
  );
}

export default App;
