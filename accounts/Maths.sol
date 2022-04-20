// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1;

contract Maths{
    constructor(){

    }

    function add(uint256 num1, uint256 num2) public pure zeroValue(num2) returns(uint256){
        return(num1 + num2);
    }

    function subtract(uint256 num1, uint256 num2) public pure zeroValue(num1) zeroValue(num2) returns(uint256){
        return(num1 - num2);
    }

    function divide(uint256 num1, uint256 num2) public pure zeroValue(num1) zeroValue(num2) returns(uint256){
        return(num1 / num2);
    }

    function multiply(uint256 num1, uint256 num2) public pure zeroValue(num1) zeroValue(num2) returns(uint256){
        return(num1 * num2);
    }

    modifier zeroValue(uint256 _amount){
       require(_amount > 0, "INVALID_AMOUNT");
       _;
    }
}