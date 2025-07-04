// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Harness_RubyAchievement} from "tests-forge/harness/Harness_RubyAchievement.sol";
import {Storage_RubyAchievement} from "tests-forge/storage/Storage_RubyAchievement.sol";

abstract contract Environment_RubyAchievement is Storage_RubyAchievement {
    function _prepareEnv() internal override {
        achievementContract = new Harness_RubyAchievement();
        achievementContract.initialize(address(this), address(this), price);
    }
}
