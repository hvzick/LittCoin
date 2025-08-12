// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LittCoin is ERC20 {
    constructor(uint256 initialSUpply) ERC20("LittCoin", "LITT") {
        _mint(msg.sender, initialSUpply);
    }
}
