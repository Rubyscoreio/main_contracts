// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Rubyscore_Soneium_ID} from "contracts-forge/chains_custom/soneium/Rubyscore_Soneium_ID.sol";
import {Rubyscore_Katana_ID} from "contracts-forge/chains_custom/katana/Rubyscore_Katana_ID.sol";
import {Harness_RubyscoreID} from "tests-forge/harness/Harness_RubyscoreID.sol";

contract Harness_RubyscoreID_Soneium is Rubyscore_Soneium_ID, Harness_RubyscoreID {}

contract Harness_RubyscoreID_Katana is Rubyscore_Katana_ID, Harness_RubyscoreID {}
