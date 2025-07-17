// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title Rubyscore_Achievement_v2
 */
contract Rubyscore_Achievement_v2 is
    EIP712Upgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable
{
    using SafeERC20 for IERC20;

    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    string public constant NAME = "Rubyscore_Achievement";
    string public constant VERSION = "0.0.2";

    uint256 public price;

    mapping(address => uint256) public userNonce;
    mapping(address => mapping(uint256 level => uint8 status)) public userClaims;

    event PriceUpdated(uint256 indexed newPrice);
    event LevelClaimed(address indexed receiver, uint256 indexed level);
    event Withdrew(address indexed receiver, address indexed asset, uint256 amount);

    function initialize(address _admin, address _operator, uint256 _price) public initializer {
        __AccessControl_init();
        __EIP712_init(NAME, VERSION);

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(OPERATOR_ROLE, _operator);
        _setPrice(_price);
    }

    function setPrice(uint256 _newPrice) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setPrice(_newPrice);
    }

    function claimAchievement(address _receiver, uint256 _level, bytes calldata _signature) public payable {
        require(msg.value >= price, "Not enough payment");

        bytes32 digest = generateNextClaimDigest(_receiver, _level);

        _checkRole(OPERATOR_ROLE, ECDSA.recover(digest, _signature));

        userClaims[_receiver][_level] = 1;

        userNonce[_receiver] += 1;

        emit LevelClaimed(_receiver, _level);
    }

    function generateNextClaimDigest(address _receiver, uint256 _level) public view returns (bytes32) {
        return _generateClaimDigest(_receiver, _level, userNonce[_receiver] + 1);
    }

    function withdraw(address payable _receiver, address _asset, uint256 _amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _withdraw(_receiver, _asset, _amount);
    }

    function _generateClaimDigest(address _receiver, uint256 _level, uint256 _nonce) internal view returns (bytes32) {
        require(userClaims[_receiver][_level] == 0, "Already claimed");
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256("ClaimLevelParams(address receiver,uint256 level,uint256 nonce)"),
                    _receiver,
                    _level,
                    _nonce
                )
            )
        );
    }

    function _setPrice(uint256 _newPrice) internal {
        price = _newPrice;

        emit PriceUpdated(_newPrice);
    }

    function _withdraw(address payable _receiver, address _asset, uint256 _amount) internal {
        if (_asset == address(0)) {
            _sendNativeToken(_receiver, _amount);
        } else {
            _sendERC20Token(_receiver, _asset, _amount);
        }

        emit Withdrew(_receiver, _asset, _amount);
    }

    function _sendNativeToken(address payable _receiver, uint256 _amount) internal {
        (bool sent,) = _receiver.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function _sendERC20Token(address _receiver, address _token,uint256 _amount) internal {
        IERC20(_token).safeTransfer(_receiver, _amount);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(OPERATOR_ROLE) {}
}
