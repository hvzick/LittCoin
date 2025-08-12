// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {LittCoin} from "../src/LittCoin.sol";

contract DeployLittCoin is Script {
    uint256 public constant INITTIAL_SUPPLY = 15000 ether;

    function run() external returns(LittCoin) {
        vm.startBroadcast();
        LittCoin litt = new LittCoin(INITTIAL_SUPPLY);
        vm.stopBroadcast();
        return litt;
    }
}
