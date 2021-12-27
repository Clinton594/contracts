// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1;

contract Ponzi{
    uint256 public balance;
    mapping(address => uint256[])  contributions;

    function provideHelp() payable external minPH(msg.value){
        contributions[msg.sender].push(msg.value * 2); 
         balance += msg.value;
    }

    modifier minPH(uint256 _amount){
        require(_amount >= 3 ether, "PH amount is low");
        _;
    }

    function getContributions(address sender) external view returns(uint256[] memory){
        return  contributions[sender];
    }

    function getHelp(uint256 _amount) external{
        uint256[] memory myContributions = contributions[msg.sender];
        // String.concat("Hi", String.toString(temp ))
        
        // Validations
        require(myContributions.length > 0, "You have no active helps" );
        require(myContributions[0] == _amount,  "");
        require(myContributions[0] <= balance, "getHelp unavailable at the moment" );

        // Proceed
        address payable sender = payable(msg.sender);
        sender.transfer(myContributions[0]);
        balance -= myContributions[0];
        delete myContributions[0];
    } 
}