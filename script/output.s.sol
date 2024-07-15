// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Waveforms} from "../src/Waveforms.sol";

// forge script script/output.s.sol:output

contract output is Script {
    function run() external {
        // Start a local fork
        string memory rpcUrl = vm.envString("BASE");
        uint256 forkId = vm.createFork(rpcUrl);
        vm.selectFork(forkId);

        address deployer = address(0x777c47498b42dbe449fB4cB810871A46cD777777);
        address minter = address(1);

        // Fund the deployer and minter accounts
        vm.deal(deployer, 1 ether);
        vm.deal(minter, 1 ether);

        vm.startPrank(deployer);
        // Deploy the contract
        Waveforms waveforms = new Waveforms();
        waveforms.toggleMinting();
        vm.stopPrank();

        // Mint a token
        uint256 mintPrice = 0.001 ether;
        vm.startPrank(minter);
        waveforms.mint{value: mintPrice}(1);
        vm.stopPrank();

        // Get the token URI
        string memory tokenURI = waveforms.tokenURI(1);
        console.log("Token URI:", tokenURI);

        // Write the token URI to a file
        string memory path = "tokenURI.txt";
        vm.writeFile(path, tokenURI);
    }
}