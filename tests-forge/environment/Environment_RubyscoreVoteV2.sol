// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Harness_RubyscoreVoteV2} from "tests-forge/harness/Harness_RubyscoreVoteV2.sol";
import {Storage_RubyscoreVoteV2} from "tests-forge/storage/Storage_RubyscoreVoteV2.sol";

abstract contract Environment_RubyscoreVoteV2 is Storage_RubyscoreVoteV2 {
    function _prepareEnv() internal override {
        voteContract = new Harness_RubyscoreVoteV2(owner, price, initialCounter);
    }
}
