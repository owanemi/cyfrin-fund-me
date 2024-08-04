// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Addres: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 _ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * _ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    // function convertUsdToEth(uint256 usdAmount, uint256 ethPrice) public view returns(uint256) {
    //     ethPrice = getPrice();
    //     uint256 usdAmountToEth = (usdAmount*10e31)/ethPrice;
    //     return usdAmountToEth;
    // }
}
