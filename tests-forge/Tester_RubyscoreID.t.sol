// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Suite_RubyscoreID} from "tests-forge/suite/Suite_RubyscoreID.sol";
import {Environment_RubyscoreID} from "tests-forge/environment/Environment_RubyscoreID.sol";
import {Environment_RubyscoreID_Soneium} from "tests-forge/environment/Environment_RubyscoreID.chains.sol";

contract Tester_RubyscoreId is Environment_RubyscoreID, Suite_RubyscoreID {}

contract Tester_Rubyscore_Soneium_Id is Environment_RubyscoreID_Soneium, Suite_RubyscoreID {}
