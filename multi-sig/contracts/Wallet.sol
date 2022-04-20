// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

contract Wallet {
    // Possible approvers
    address[] public approvers;
    // Maximum Number of approvers
    uint256 public quorum;
    // Transfer Struct
    struct Transfer {
        uint256 id;
        uint256 amount;
        address payable receipient;
        uint256 approvals;
        bool sent;
    }
    Transfer[] public transfers;
    mapping(address => mapping(uint256 => bool)) public approvals;

    constructor(address[] memory _approvers, uint256 _quorum) {
        approvers = _approvers;
        quorum = _quorum;
    }

    function getApprovers() external view returns (address[] memory) {
        return approvers;
    }

    function getQuorum() external view returns (uint256) {
        return quorum;
    }

    function createTransfer(uint256 _amount, address payable _reciepient)
        external
    {
        transfers.push(
            Transfer(transfers.length, _amount, _reciepient, 0, false)
        );
    }

    function getTransfers() external view returns (Transfer[] memory) {
        return transfers;
    }

    function approveTransfer(uint256 id) external onlyApprover {
        // Can't approve an already completed transaction
        require(
            transfers[id].sent == false,
            "Transaction has already been sent"
        );

        // An admin can't approve twice
        require(
            approvals[msg.sender][id] == false,
            "You have already approved this transaction"
        );

        approvals[msg.sender][id] == true;
        transfers[id].approvals++;
        if (transfers[id].approvals >= quorum) {
            transfers[id].sent = true;
            payable(transfers[id].receipient).transfer(transfers[id].amount);
        }
    }

    receive() external payable {}

    modifier onlyApprover() {
        bool allowed = false;
        for (uint256 index = 0; index < approvers.length; index++) {
            if (approvers[index] == msg.sender) {
                allowed = true;
                break;
            }
        }
        require(allowed == true, "Only approver is allowed");
        _;
    }
}
