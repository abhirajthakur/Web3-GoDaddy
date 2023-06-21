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

    function test_Name() public {
        assertEq(web3GoDaddy.name(), "Web3 GoDaddy");
    }

    function test_Symbol() public {
        assertEq(web3GoDaddy.symbol(), "W3G");
    }

    function test_Owner() public {
        assertEq(web3GoDaddy.owner(), address(this));
    }

    function test_List() public {
        web3GoDaddy.list("test.eth", 10 ether);
    }

    function test_TotalSupplyBeforeMinting() public {
        assertEq(web3GoDaddy.totalSupply(), 0);
    }

    function test_FailList() public {
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.list("test.eth", 10 ether);
    }

    function test_Domain() public {
        testList();
        // (string memory name, uint256 cost, address owner) = web3Hostinger.domains(0);
        string memory name = web3GoDaddy.getDomain(0).name;
        uint256 cost = web3GoDaddy.getDomain(0).cost;
        bool isOwned = web3GoDaddy.getDomain(0).isOwned;
        assertEq(name, "test.eth");
        assertEq(cost, 10 ether);
        assertEq(isOwned, false);
    }

    function test_MaxSupply() public {
        testList();
        assertEq(web3GoDaddy.maxSupply(), 1);
    }

    function test_Mint() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 10 ether}(0);
        assertEq(web3GoDaddy.ownerOf(0), user);
    }

    function testFail_MintIncorrectId() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 10 ether}(3);
    }

    function testFail_MintAlreadyMinted() public {
        testList();
        vm.startPrank(user);
        web3GoDaddy.mint{value: 10 ether}(0);
        vm.stopPrank();
        web3GoDaddy.mint{value: 10 ether}(0);
    }

    function testFail_MintInsufficentValueSend() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 5 ether}(0);
    }

    function test_GetBalance() public {
        testList();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.mint{value: 10 ether}(0);
        assertEq(web3GoDaddy.getBalance(), 10 ether);
    }

    function test_DomainOwner() public {
        testMint();
        address owner = web3GoDaddy.ownerOf(0);
        assertEq(owner, user);
    }

    function test_TotalSupplyAfterMinting() public {
        testMint();
        assertEq(web3GoDaddy.totalSupply(), 1);
    }

    function test_Withdraw() public {
        testMint();
        web3GoDaddy.withdraw();
        assertEq(address(web3GoDaddy).balance, 0);
    }

    function testFail_Withdraw() public {
        testMint();
        vm.prank(user); // Change msg.sender to user
        web3GoDaddy.withdraw();
    }

    function test_UpdateBalance() public {
        uint256 balanceBefore = address(this).balance;
        testWithdraw();
        uint256 balanceAfter = address(this).balance;
        assertGt(balanceAfter, balanceBefore); // assetGt(a, b) => true if a is greater than b
    }

    receive() external payable {}
}
