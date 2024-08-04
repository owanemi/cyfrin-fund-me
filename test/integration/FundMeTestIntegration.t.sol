// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;

    uint256 private constant VERSION = 4;
    uint256 private constant MIN_USD = 20e18;
    uint256 private constant SEND_VALUE = 0.1 ether;
    address private constant ETHPRICEFEED = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    uint256 private constant STARTING_BALANCE = 10 ether;
    uint256 private constant GAS_PRICE = 1;
    // uint256 number = 1;
    address USER = makeAddr("owanemi");

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
