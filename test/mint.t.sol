// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Waveforms} from "src/Waveforms.sol";

contract MintTest is Test {
    Waveforms public mintContract;

    /// airdrop setup
    address deployer = address(77);
    address minter = address(1);
    address minter2 = address(2);
    address minter3 = address(3);
    address public apexSafe = 0x3415CD5FcAa35F986c8129c7a80E3AF75e5cF262;

    uint256 public mintPrice = 0.001 ether;

    function setUp() public {
        // start fork
        string memory rpcUrl = vm.envString("BASE");
        uint256 forkId = vm.createFork(rpcUrl);
        vm.selectFork(forkId);

        uint256 currentBlockNumber = block.number;
        console.log("Current Block Number:", currentBlockNumber);

        vm.deal(deployer, 1 ether);
        vm.startPrank(deployer);

        mintContract = new Waveforms();
        mintContract.toggleMinting();

        vm.stopPrank();
    }

    function testMintWithExactETH() public {
        vm.startPrank(minter);
        vm.deal(minter, 1 ether); // Fund minter with some ether

        console.log("safe balance before", address(apexSafe).balance);

        // Mint with the correct amount of ETH
        mintContract.mint{value: mintPrice}(1);

        console.log("safe balance after", address(apexSafe).balance);

        vm.stopPrank();
    }

    // function testMintWithIncorrectETH() public {
    //     vm.startPrank(minter);
    //     vm.deal(minter, 1 ether); // Fund minter with some ether

    //     // Expect revert if the incorrect amount of ETH is sent
    //     vm.expectRevert("Please send the exact ETH amount");
    //     mintContract.mint{value: mintPrice - 0.00001 ether}(1);

    //     vm.stopPrank();
    // }

    // function testMintWhenMintingDisabled() public {
    //     vm.startPrank(deployer);
    //     mintContract.toggleMinting(); // Disable minting
    //     vm.stopPrank();
    //     vm.startPrank(minter);
    //     vm.deal(minter, 1 ether); // Fund minter with some ether

    //     // Expect revert if minting is not enabled
    //     vm.expectRevert();
    //     mintContract.mint{value: mintPrice}(1);

    //     vm.stopPrank();
    // }

    // function testMintingUpdatesBalances() public {
    //     vm.startPrank(minter);
    //     vm.deal(minter, 1 ether); // Fund minter with some ether
    //     uint256 initialBalance = minter.balance;

    //     // Mint with the correct amount of ETH
    //     mintContract.mint{value: mintPrice}(1);

    //     // Check that the minter's balance is reduced by the mint price
    //     assertEq(minter.balance, initialBalance - mintPrice);

    //     vm.stopPrank();
    // }

    // function testMintUpdatesMinter() public {
    //     uint256 amount = 5;
    //     vm.deal(minter, 1 ether); // Fund minter with some ether
    //     vm.startPrank(minter);

    //     // Mint with the correct amount of ETH
    //     mintContract.mint{value: mintPrice * amount}(amount);

    //     vm.stopPrank();

    //     // Check that the minter's address is recorded
    //     for (uint256 i = 1; i < amount; i++) {
    //         // assertEq(mintContract.minter(i), minter);
    //         console.log("Minter:", mintContract.mintedBy(i), "Token ID:", i);
    //         console.log("Owner:", mintContract.ownerOf(i), "Token ID:", i);
    //     }

    // vm.deal(minter2, 1 ether); // Fund minter2 with some ether
    // vm.startPrank(minter2);

    // // Mint with the correct amount of ETH
    // mintContract.mint{value: mintPrice * amount}(amount);

    // // Check that the minter's address is recorded
    // for (uint256 i = 0; i < amount; i++) {
    //     assertEq(mintContract.minter(i + amount), minter2);
    //     /// console log the minter address and tokenId
    //     console.log("Minter Address:", minter2, "Token ID:", i + amount);
    // }

    // vm.stopPrank();

    // // go back and check the first minter and output to console
    // for (uint256 i = 0; i < amount; i++) {
    //     console.log("Minter Address:", mintContract.minter(i), "Token ID:", i);
    // }
}
