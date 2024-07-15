// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Waveforms} from "src/Waveforms.sol";


/// local deployment
/// forge script script/deploy.s.sol:DeployScript --rpc-url http://127.0.0.1:8545 --broadcast
/// sepolia
/// forge script script/deploy.s.sol:DeployScript --rpc-url $BSEP --broadcast --verify

/// forge script script/deploy.s.sol:DeployScript --ledger --rpc-url $BASE --broadcast --verify

contract DeployScript is Script {

        uint256 public mintPrice = 0.001 ether;

    function setUp() public {
        // This function can be used to set up any required state before deployment
    }

    function run() public {
        // Replace with your private key
        // uint256 deployerPrivateKey = vm.envUint("KEY");
        // vm.startBroadcast(deployerPrivateKey);
        vm.startBroadcast();

        Waveforms waveforms = new Waveforms();
        waveforms.toggleMinting();
        waveforms.mint{value: mintPrice}(1);
        vm.stopBroadcast();
    }
}