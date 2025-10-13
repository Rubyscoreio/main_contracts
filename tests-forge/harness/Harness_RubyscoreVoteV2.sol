// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {RubyscoreVoteV2} from "contracts-forge/base/RubyscoreVote.v2.sol";

contract Harness_RubyscoreVoteV2 is RubyscoreVoteV2 {
    constructor(address _admin, uint256 _initialPrice, uint256 _initialCounter) RubyscoreVoteV2(_admin, _initialPrice, _initialCounter) {}

    function exposed_withdraw(address payable _receiver, address _asset, uint256 _amount) public {
        _withdraw(_receiver, _asset, _amount);
    }

    function exposed_sendNativeToken(address payable _receiver, uint256 _amount) public {
        _sendNativeToken(_receiver, _amount);
    }

    function exposed_sendERC20Token(address _receiver, address _token, uint256 _amount) public {
        _sendERC20Token(_receiver, _token, _amount);
    }

    function helper_setVoteCounter(uint256 _newValue) public {
        voteCounter = _newValue;
    }

    function helper_setPrice(uint256 _newValue) public {
        price = _newValue;
    }
}
