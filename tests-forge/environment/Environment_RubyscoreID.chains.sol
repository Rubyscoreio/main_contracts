// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Harness_RubyscoreID_Soneium} from "tests-forge/harness/Harness_RubyscoreID.chains.sol";
import {Harness_RubyscoreID} from "tests-forge/harness/Harness_RubyscoreID.sol";
import {Storage_RubyscoreID} from "tests-forge/storage/Storage_RubyscoreID.sol";

abstract contract Environment_RubyscoreID_Soneium is Storage_RubyscoreID {
    function _prepareEnv() internal override {
        Harness_RubyscoreID_Soneium deployment = new Harness_RubyscoreID_Soneium();

        attestationContract = Harness_RubyscoreID(address(deployment));

        attestationContract.initialize("Test", "TST", admin, operator, attestationFee);
    }
}
