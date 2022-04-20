// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1;

contract Wallet {
    // Wallet Balance
    uint256 public balance;

    // Create owner
    address owner;

    // Create max of 3 Admins container
    address[3] admins;

    // Withdrwal Request Struct
    struct Request {
        address sender;
        uint32 amount;
        bool status;
        address[3] approval;
    }
    Request[] requests;
    Request[] compeleted;

    constructor() payable {
        // Set the contract owner
        owner = msg.sender;
        balance += msg.value;
    }

    // Only Owner Validation
    modifier onlyOwner() {
        require(owner == msg.sender, "ONLY_OWNER_OPERATION");
        _;
    }

    // Search address in admins
    function checkAdmin(address _address, address[3] memory _addresses)
        internal
        pure
        returns (bool)
    {
        bool isAdmin;
        uint16 index;
        while (!isAdmin) {
            isAdmin = (_addresses[index] == _address);
            index++;
        }
        return isAdmin;
    }

    // Deposit into the wallet
    receive() external payable onlyOwner {
        // //
        //   require(msg.value >= 0.4 ether, "CAN_NO_BE_LESS_THAN_0.3ETHER");
        balance += msg.value;
    }

    // Creates a withdrawal request
    function withdraw(uint32 _amount) external {
        address[3] memory emptyArray;
        Request memory request = Request({
            sender: msg.sender,
            amount: _amount,
            status: false,
            approval: emptyArray
        });
        // Push the request to await approval
        requests.push(request);
    }

    // Multi signature approval
    function approve() external payable {
        bool isAdmin = checkAdmin(msg.sender, admins);
        require(isAdmin, "ONLY_ADMIN_OPERATION");
        Request memory currentRequest = requests[0];
        if (currentRequest.approval.length <= 3) {
            bool hasApproved = checkAdmin(msg.sender, currentRequest.approval);
            require(!hasApproved, "THIS_ADMIN_HAS_APPROVED_ALREADY");

            // current admin approves
            uint256 len = currentRequest.approval.length;
            currentRequest.approval[len] = msg.sender;

            if (currentRequest.approval.length == admins.length) {
                address payable _sender = payable(
                    address(currentRequest.sender)
                );

                // Verify the withdrawl amount is available in the wallet
                require(
                    currentRequest.amount <= balance,
                    "INSUFFICIENT_BALANCE"
                );

                // Pay the customer
                _sender.transfer(currentRequest.amount);
                balance -= currentRequest.amount;
                compeleted.push(currentRequest);
                delete requests[0];
            }
        } else {
            compeleted.push(currentRequest);
        }
    }
}
