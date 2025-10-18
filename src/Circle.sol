// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Stub del USDC 
// https://developers.circle.com/stablecoins/usdc-contract-addresses
// USDC Ethereum Sepolia: 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238
contract Circle is ERC20 {
    constructor()
        ERC20("Circle", "USDC")
    {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}