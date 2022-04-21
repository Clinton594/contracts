// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BTToken is Context, ERC20, Ownable {
    address thisowner;

    constructor(
        string memory name, //Name of the token
        string memory symbol, //Token symbol
        uint256 initailSupply
    ) ERC20(name, symbol) {
        thisowner = _msgSender();
        _mint(_msgSender(), initailSupply);
    }

    // Get Address of the Owner
    function getAddress() public view returns (address) {
        return thisowner;
    }

    // Mint Extra token
    function mint(uint256 amount) public onlyOwner {
        _mint(_msgSender(), amount);
    }
}
