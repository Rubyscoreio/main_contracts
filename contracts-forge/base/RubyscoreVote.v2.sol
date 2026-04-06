// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RubyscoreVoteV2 is Ownable {
    using SafeERC20 for IERC20;

    uint256 public voteCounter;
    uint256 public price;

    event Voted(address indexed voter);
    event PriceUpdated(uint256 indexed newPrice);
    event VotesCounterUpdated(uint256 indexed newValue);
    event Withdrew(address indexed receiver, address indexed asset, uint256 amount);

    error InsufficientPayment(uint256 expected, uint256 received);

    constructor(address _admin, uint256 _price, uint256 _initialCounter) Ownable(_admin) {
        _setPrice(_price);
        _setVotesCounter(_initialCounter);
    }

    function vote() external payable {
        if (msg.value < price) revert InsufficientPayment(price, msg.value);

        voteCounter += 1;

        emit Voted(msg.sender);
    }

    function setVoteCounter(uint256 _newVoteCounter) external onlyOwner {
        _setVotesCounter(_newVoteCounter);
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        _setPrice(_newPrice);
    }

    function withdraw(address payable _receiver, address _asset, uint256 _amount) external onlyOwner {
        _withdraw(_receiver, _asset, _amount);
    }

    function withdrawAllEth() external onlyOwner {
        _withdraw(payable(msg.sender), address(0), address(this).balance);
    }

    function _setPrice(uint256 _newPrice) internal {
        price = _newPrice;

        emit PriceUpdated(_newPrice);
    }

    function _setVotesCounter(uint256 _newValue) internal {
        voteCounter = _newValue;

        emit VotesCounterUpdated(_newValue);
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
}
