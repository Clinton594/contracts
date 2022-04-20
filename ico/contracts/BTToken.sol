// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract BTToken is Context, ERC20 {
    constructor(
        string memory name, //Name of the token
        string memory symbol, //Token symbol
        uint256 initailSupply
    ) ERC20(name, symbol) {
        _mint(_msgSender(), initailSupply);
    }
}
