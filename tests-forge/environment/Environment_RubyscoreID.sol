// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Harness_RubyscoreID} from "tests-forge/harness/Harness_RubyscoreID.sol";
import {Storage_RubyscoreID} from "tests-forge/storage/Storage_RubyscoreID.sol";

abstract contract Environment_RubyscoreID is Storage_RubyscoreID {
    function _prepareEnv() internal override {
        attestationContract = new Harness_RubyscoreID();

        attestationContract.initialize("Test", "TST", admin, operator, attestationFee);
    }
}
