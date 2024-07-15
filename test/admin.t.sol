// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Waveforms} from "src/Waveforms.sol";

contract AdminTest is Test {
    Waveforms public mintContract;

    /// airdrop setup
    address deployer = address(77);
    address anon = address(69);

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

        vm.stopPrank();
    }

    function testMintToggle() public {
        vm.startPrank(deployer);
        // test toggle mint works
        mintContract.toggleMinting();
        assertTrue(mintContract.mintEnabled());

        // test toggle mint works
        mintContract.toggleMinting();
        assertFalse(mintContract.mintEnabled());
        vm.stopPrank();

        // test toggle can only be called by deployer
        vm.startPrank(anon);
        vm.expectRevert();
        mintContract.toggleMinting();
        vm.stopPrank();
    }

    function testWithdraw() public {
        // Fund the contract with some ether for testing
        vm.deal(address(mintContract), 1 ether);

        vm.startPrank(deployer);

        // Record the initial balance of the deployer
        uint256 initialDeployerBalance = deployer.balance;

        // Check the initial balance of the contract
        uint256 contractBalance = address(mintContract).balance;

        // Withdraw funds
        mintContract.withdraw();

        // Check that the contract's balance is now 0
        assertEq(address(mintContract).balance, 0);

        // Check that the deployer's balance has increased by the contract balance
        assertEq(deployer.balance, initialDeployerBalance + contractBalance);

        vm.stopPrank();

        // Test that withdraw can only be called by deployer
        vm.startPrank(anon);
        vm.expectRevert();
        mintContract.withdraw();
        vm.stopPrank();
    }
}
