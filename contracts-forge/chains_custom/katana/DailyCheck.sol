// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {RubyscoreVoteV2Base} from "contracts-forge/base/RubyscoreVote.v2.base.sol";

contract DailyCheck is RubyscoreVoteV2Base {
    constructor(address _admin, uint256 _price, uint256 _initialCounter) RubyscoreVoteV2Base(
        _admin,
        _price,
        _initialCounter
    ) {}
}
