// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Web3GoDaddy.sol";

contract Web3GoDaddyTest is Test {
    Web3GoDaddy public web3GoDaddy;
    address private user;

    function setUp() public {
        web3GoDaddy = new Web3GoDaddy("Web3 GoDaddy", "W3G"); // Deploy Web3GoDaddy smart contract
        user = makeAddr("User"); // create a address
        hoax(user); // provide user with some ether
    }

    function testName() public {
        assertEq(web3GoDaddy.name(), "Web3 GoDaddy");
    }

    function testSymbol() public {
        assertEq(web3GoDaddy.symbol(), "W3G");
    }

    function testOwner() public {
        assertEq(web3GoDaddy.owner(), address(this));
    }

    function testList() public {
        web3GoDaddy.list("test.eth", 10 ether);
    }

    function testTotalSupplyBeforeMinting() public {
        assertEq(web3GoDaddy.totalSupply(), 0);
    }

    function testFailList() public {
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.list("test.eth", 10 ether);
    }

    function testDomain() public {
        testList();
        // (string memory name, uint256 cost, address owner) = web3Hostinger.domains(0);
        string memory name = web3GoDaddy.getDomain(0).name;
        uint256 cost = web3GoDaddy.getDomain(0).cost;
        address owner = web3GoDaddy.getDomain(0).owner;
        assertEq(name, "test.eth");
        assertEq(cost, 10 ether);
        assertEq(owner, address(0));
    }

    function testMaxSupply() public {
        testList();
        assertEq(web3GoDaddy.maxSupply(), 1);
    }

    function testMint() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 10 ether}(0);
        assertEq(web3GoDaddy.ownerOf(0), user);
    }

    function testFailMintIncorrectId() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 10 ether}(3);
    }

    function testFailMintAlreadyMinted() public {
        testList();
        vm.startPrank(user);
        web3GoDaddy.mint{value: 10 ether}(0);
        vm.stopPrank();
        web3GoDaddy.mint{value: 10 ether}(0);
    }

    function testFailMintInsufficentValueSend() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 5 ether}(0);
    }

    function testGetBalance() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 10 ether}(0);
        assertEq(web3GoDaddy.getBalance(), 10 ether);
    }

    function testDomainOwner() public {
        testMint();
        address owner = web3GoDaddy.getDomain(0).owner;
        assertEq(owner, user);
    }

    function testTotalSupplyAfterMinting() public {
        testMint();
        assertEq(web3GoDaddy.totalSupply(), 1);
    }

    function testWithdraw() public {
        testMint();
        web3GoDaddy.withdraw();
        assertEq(address(web3GoDaddy).balance, 0);
    }

    function testFailWithdraw() public {
        testMint();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.withdraw();
    }

    function testUpdateBalance() public {
        uint256 balanceBefore = address(this).balance;
        testWithdraw();
        uint256 balanceAfter = address(this).balance;
        assertGt(balanceAfter, balanceBefore); // assetGt(a, b) => true if a is greater than b
    }

    receive() external payable {}
}
