// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from './PriceConverter.sol';
import { MathLibrary } from './MathLibrary.sol';

error notOwner() ;
contract FundMe {
    using PriceConverter for uint256;
    using MathLibrary for uint256;


    address[] public funders;


    uint256 public constant MINIMUM_USD = 20 * 1e18;
    // constants in soldiity are named wiyh all caps

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    mapping(address funder => uint256 amountFunded) public addressToContributionCount;

    address public immutable i_owner;

    constructor ()  {
        i_owner = msg.sender;
    }
    

    function fund() public payable {
        // myValue = myValue + 1;
        require( msg.value.getConversionRate() >= MINIMUM_USD, "ETH sent too small");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        addressToContributionCount[msg.sender] = addressToContributionCount[msg.sender] + 1;        
    }

    function calculateSum(uint256 a, uint256 b ) public pure returns (uint256) {
        return a.sum(b);
    }

    function withdraw() public onlyOwner {

        // require(msg.sender == owner, "Only owner can withdraw")
        for (uint256 funderIndex; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        // payable(msg.sender).transfer(address(this).balance);
            (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
            require(callSuccess, "Call failed");
    }

    // ways of tranfserring eth with smart contract
    // 1) trnasfer 
    // 2) send
    // 3) call

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Only owner of the contract can withdraw");
        if(msg.sender != i_owner) { revert notOwner(); }
        _; 
    }
    // what happens if somsone sends the contract ETH without calling the fund() function

    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }
}
