// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1;

import {Maths} from "./Maths.sol";

// tutotialspoint.com/solidity
contract Account is Maths{
    uint256 public balance;
    uint256 public savings;

    constructor(uint256 _balance) zeroValue(_balance){
        balance = _balance;
    }

    /*
    @dev This function adds to the balance
    */

    function deposit(uint256 _amount) external{
        balance = add(balance, _amount);
    }

    /*
    @dev This function deducts from the balance
    */

    function withdraw(uint256 _amount) external withinBalance(_amount, balance){
        balance = subtract(balance, _amount);
    }

    function save(uint256 _principal) external zeroValue(_principal) withinBalance(_principal, balance){
        uint256 rate = 5; // 5 percentage Rate
        uint256 reoccur = 1; //Quarterly
        uint256 duration = 7; //2 Years

        // Get compount interest
        uint256 A = _principal * ((1 + ((rate/100) / reoccur))**(duration * reoccur));

        // deduct from the Account balance
        balance = subtract(balance, _principal);

        // Verify that interest is greater than 0
        require(A > 0, "INVALID_INTEREST");


        // Add interest and capital to savings account
        savings = add(savings, (A + _principal));
    }

    function withdrawSavings(uint256 _amount) external withinBalance(_amount, savings){
         // Deduct amount from savings account
        savings = subtract(savings, _amount);

        // Add amount to account balance
        balance = add(balance, _amount);
    }

    function share(uint256 _pieces) external { //Divider
     balance = divide(balance, _pieces);
    }

   function invest(uint256 _pieces) external { // Multiplier
     balance = multiply(balance, _pieces);
   }

    // Modifer to verify that the amount requested is available in the account it's requested from
    modifier withinBalance(uint256 _amount, uint256 fromAccount){
       require(fromAccount >= _amount, "INSUFFICIENT_BALANCE");
       _;
    }
}