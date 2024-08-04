// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

// types of test
// 1) unit tests: testing a specific part of our code
// 2) Integration tests: Testing how our code works with other parts of our code
// 3) Forked tests: Testing ourcode on a simulated work environment
// 4) Staging: Testing the entirety of our code in a real environment thats not prod

contract FundMeTest is Test {
    uint256 private constant VERSION = 4;
    uint256 private constant MIN_USD = 20e18;
    uint256 private constant SEND_VALUE = 0.1 ether;
    address private constant ETHPRICEFEED = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    uint256 private constant STARTING_BALANCE = 1 ether;
    uint256 private constant GAS_PRICE = 1;
    // uint256 number = 1;
    address USER = makeAddr("owanemi");

    FundMe fundMe;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        vm.deal(USER, STARTING_BALANCE);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumIsTwenty() public view {
        assertEq(fundMe.MINIMUM_USD(), MIN_USD);
    }

    function testOwnerisSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        // address version2 = address(fundMe.s_priceFeed());
        // console.log(version2);
        assertEq(version, VERSION);
    }

    function testFundFailsWithoutETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFundersToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundeMeBalance = address(fundMe).balance;

        //Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);
        console.log(tx.gasprice);

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundeMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(address(fundMe.getOwner()));
        fundMe.withdraw();

        // patrick used assert instead of assertEq find out why
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(address(fundMe.getOwner()));
        fundMe.cheaperWithdraw();

        // patrick used assert instead of assertEq find out why
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }
    // custom test i wrote to check if PRICE FEED addresses match(price feed is a private constant in FundMe.sol, so chnage back)
    // function testEthPriceFeedAddressIsCorrect() public view {
    //     address Interface = address(fundMe.s_priceFeed());
    //     assertEq(Interface, ETHPRICEFEED);
    //     console.log(Interface);
    // }

    // to test a function seperately we use --match-test
    // and when we want to test still using anvil but connect to a blockchain to get some data we fork the blockchain
    // and testing in blockchain is done by --fork-url or --rpc-url

    // forge coverage is used to see how much % of our code us actually being tested
}
