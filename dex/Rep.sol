// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol";

contract Rep is ERC20, ERC20Detailed {
    constructor() ERC20Detailed("REP", "Augur Token", 18) {}
}
