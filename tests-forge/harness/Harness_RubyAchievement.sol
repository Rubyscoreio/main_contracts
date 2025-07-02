// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Rubyscore_Achievement_v2} from "contracts-forge/Rubyscore_Achievement.v2.sol";

contract Harness_RubyAchievement is Rubyscore_Achievement_v2 {
    function exposed_generateMintDigest(address _receiver, uint256 _level, uint32 _nonce) public {
        _generateMintDigest(_receiver, _level, _nonce);
    }

    function exposed_withdraw(address payable _receiver, address _asset, uint256 _amount) public {
        _withdraw(_receiver, _asset, _amount);
    }

    function exposed_sendNativeToken(address payable _receiver, uint256 _amount) public {
        _sendNativeToken(_receiver, _amount);
    }

    function exposed_sendERC20Token(address _receiver, address _token, uint256 _amount) public {
        _sendERC20Token(_receiver, _token, _amount);
    }

    function helper_grantRole(bytes32 _role, address _account) public {
        _grantRole(_role, _account);
    }

    function helper_revokeRole(bytes32 _role, address _account) public {
        _revokeRole(_role, _account);
    }
}
