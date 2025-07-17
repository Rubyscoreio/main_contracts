// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Suite_RubyAchievement} from "./suite/Suite_RubyAchievement.sol";
import {Environment_RubyAchievement} from "./environment/Environment_RubyAchievement.sol";

contract Tester_QstmeSponsor is Environment_RubyAchievement, Suite_RubyAchievement {}
