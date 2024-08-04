// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant FUND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: FUND_VALUE}();
        vm.stopBroadcast();

        console.log("Funded with %s", FUND_VALUE);
    }

    function run() external {
        // vm.startBroadcast();
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployedContract);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        // console.log("Funded with %s", FUND_VALUE);
    }

    function run() external {
        // vm.startBroadcast();
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployedContract);
        // vm.stopBroadcast();
    }
}
