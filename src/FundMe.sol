// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FundMe__notOwner();

contract FundMe {
    using PriceConverter for uint256;
    // using MathLibrary for uint256;

    address[] public s_funders;

    uint256 public constant MINIMUM_USD = 20 * 1e18;
    // constants in soldiity are named wiyh all caps

    mapping(address funder => uint256 amountFunded) public s_addressToAmountFunded;
    mapping(address funder => uint256 amountFunded) public s_addressToContributionCount;

    address public immutable i_owner;
    AggregatorV3Interface public s_priceFeed; //jj

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // myValue = myValue + 1;
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "ETH sent too small");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_addressToContributionCount[msg.sender] += 1;
    }

    // function calculateSum(uint256 a, uint256 b ) public pure returns (uint256) {
    //     return a.sum(b);
    // }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "Only owner can withdraw")
        for (uint256 funderIndex; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        // payable(msg.sender).transfer(address(this).balance);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        // we used "fundersLentgh" here as a memory variable instead of a storage variable to make it cheaper
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // ways of tranfserring eth with smart contract
    // 1) trnasfer
    // 2) send
    // 3) call

    // setting global variables to private are more gas efficient

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Only owner of the contract can withdraw");
        if (msg.sender != i_owner) revert FundMe__notOwner();
        _;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    // what happens if somsone sends the contract ETH without calling the fund() function

    // a magic number in solidity is a number in the codebase added without any description or context as to what the no does

    /**
     * view/pure functions (getters)
     */
    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
