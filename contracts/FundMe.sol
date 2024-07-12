// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from './PriceConverter.sol';
import { MathLibrary } from './MathLibrary.sol';

contract FundMe {
    using PriceConverter for uint256;
    using MathLibrary for uint256;


    address[] public funders;

    uint256 public minimumUSD = 20 * 1e18;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    mapping(address funder => uint256 amountFunded) public addressToContributionCount;
    

    function fund() public payable {
        // myValue = myValue + 1;
        require( msg.value.getConversionRate() >= minimumUSD, "ETH sent too small");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
        addressToContributionCount[msg.sender] = addressToContributionCount[msg.sender] + 1;        
    }

    function calculateSum(uint256 a, uint256 b ) public pure returns (uint256) {
        return a.sum(b);
    }
}
