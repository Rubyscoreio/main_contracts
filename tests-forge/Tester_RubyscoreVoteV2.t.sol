// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Suite_RubyscoreVoteV2} from "./suite/Suite_RubyscoreVoteV2.sol";
import {Environment_RubyscoreVoteV2} from "./environment/Environment_RubyscoreVoteV2.sol";

contract Tester_RubyscoreVoteV2 is Environment_RubyscoreVoteV2, Suite_RubyscoreVoteV2 {}
