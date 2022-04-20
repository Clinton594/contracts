// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "../node_modules/@openzeppelin/contracts/GSN/Context.sol";

contract BTToken is Context, ERC20, ERC20Detailed {
    constructor(
        string memory name, //Name of the token
        string memory symbol, //Token symbol
        uint256 initailSupply
    ) ERC20Detailed(name, symbol, 18) {
        _mint(_msgSender(), initailSupply);
    }
}
