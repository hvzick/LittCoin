// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {LittCoin} from "../src/LittCoin.sol";
import {DeployLittCoin} from "../script/DeployLittCoin.s.sol";

contract OtTest is Test {
    LittCoin public littCoin;
    DeployLittCoin public deployer;

    uint256 public constant STARTING_BALANCE = 1000 ether;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    /// @dev Deploys LittCoin and transfers all tokens to bob before each test
    function setUp() public {
        deployer = new DeployLittCoin();
        littCoin = deployer.run();

        vm.prank(msg.sender);
        littCoin.transfer(bob, STARTING_BALANCE);
    }

    /// @dev Checks that bob's balance equals the starting balance after setup
    function testBobsBalance() public view {
        assertEq(STARTING_BALANCE, littCoin.balanceOf(bob));
    }

    /// @dev Tests approve and transferFrom: Alice spends tokens on behalf of Bob
    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        littCoin.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        littCoin.transferFrom(bob, alice, transferAmount);

        // automatically sets from as the address who calls this function
        // littCoin.transfer(alice, transferAmount);

        assertEq(littCoin.balanceOf(alice), transferAmount);
        assertEq(littCoin.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    /// @dev Tests a direct transfer from the deployer to another address
    function testTransfer() public {
        vm.prank(msg.sender);
        uint256 amount = 500;
        address receiver = address(0x1);
        littCoin.transfer(receiver, amount);
        assertEq(littCoin.balanceOf(receiver), amount);
    }

    /// @dev Checks that sender's balance decreases by the transferred amount
    function testBalanceAfterTransfer() public {
        uint256 amount = 500;
        address receiver = address(0x1);
        uint256 initialBalanceOfSender = littCoin.balanceOf(msg.sender);
        vm.prank(msg.sender);
        littCoin.transfer(receiver, amount);
        assertEq(littCoin.balanceOf(msg.sender), initialBalanceOfSender - amount);
    }

    /// @dev Expects a revert when trying to transfer more tokens than available
    function testTransferRevertsIfMoreThanExitingTokensAreSent() public {
        uint256 amount = 20000 ether;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        vm.expectRevert(); // expects revert coz the contract doesnt have enough eth
        littCoin.transfer(receiver, amount);
    }

    /// @dev Tests transferFrom after approval: contract spends tokens on behalf of deployer
    function testTransferFrom() public {
        uint256 amount = 100 ether;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        littCoin.approve(address(this), amount);
        littCoin.transferFrom(msg.sender, receiver, amount);
        assertEq(littCoin.balanceOf(receiver), amount);
    }
    /// @dev Checks that approve sets the correct allowance for Alice by Bob
    function testApproveAndAllowance() public {
        uint256 amount = 500 ether;
        vm.prank(bob);
        littCoin.approve(alice, amount);
        assertEq(littCoin.allowance(bob, alice), amount);
    }

    /// @dev Expects a revert when transferFrom is called without prior approval
    function testTransferFromWithoutApprovalReverts() public {
        uint256 amount = 100 ether;
        vm.prank(alice);
        vm.expectRevert();
        littCoin.transferFrom(bob, alice, amount);
    }

    /// @dev Checks that allowance can be set to zero and then increased by Bob
    function testApproveZeroThenIncrease() public {
        uint256 amount = 100 ether;
        vm.startPrank(bob);
        littCoin.approve(alice, 0);
        assertEq(littCoin.allowance(bob, alice), 0);
        littCoin.approve(alice, amount);
        assertEq(littCoin.allowance(bob, alice), amount);
        vm.stopPrank();
    }

    /// @dev Expects a revert when trying to decrease allowance below zero
    function testDecreaseAllowanceBelowZeroReverts() public {
        uint256 amount = 100 ether;
        vm.prank(bob);
        littCoin.approve(alice, amount);
        vm.prank(bob);
        vm.expectRevert();
        littCoin.approve(alice, amount - (amount + 1));
    }

    /// @dev Expects a revert when transferring tokens to the zero address
    function testTransferToZeroAddressReverts() public {
        uint256 amount = 10 ether;
        vm.prank(bob);
        vm.expectRevert();
        littCoin.transfer(address(0), amount);
    }

    /// @dev Expects a revert when approving the zero address as a spender
    function testApproveToZeroAddressReverts() public {
        uint256 amount = 10 ether;
        vm.prank(bob);
        vm.expectRevert();
        littCoin.approve(address(0), amount);
    }
}