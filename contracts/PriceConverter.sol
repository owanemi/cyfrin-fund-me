// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice() internal view returns (uint256) {
        // Addres: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        ( , int256 answer,,,) = priceFeed.latestRoundData();
        return uint(answer * 1e10);
    }

    function getConversionRate(uint256 _ethAmount) internal view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * _ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
       return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    // function convertUsdToEth(uint256 usdAmount, uint256 ethPrice) public view returns(uint256) {
    //     ethPrice = getPrice();
    //     uint256 usdAmountToEth = (usdAmount*10e31)/ethPrice;
    //     return usdAmountToEth;
    // }
}
