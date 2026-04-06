// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {WithdrawingModule, Asset} from "./modules/WithdrawingModule.sol";

struct DappVotes {
    string dapp;
    uint256 votes;
}

contract RubyscoreDappVote is Ownable, WithdrawingModule {
    using SafeERC20 for IERC20;

    uint256 public totalVotes;
    uint256 public price;

    mapping(string dapp => uint256 votes) public dappVotes;

    event Voted(address indexed voter, string indexed dapp);
    event PriceUpdated(uint256 indexed newPrice);
    event Withdrew(address indexed receiver, address indexed asset, uint256 amount);

    error InsufficientPayment(uint256 expected, uint256 received);

    constructor(address _admin, uint256 _price) Ownable(_admin) {
        _setPrice(_price);
    }

    function dappVotesBatch(string[] calldata _dapps) external view returns(DappVotes[] memory) {
        DappVotes[] memory votes = new DappVotes[](_dapps.length);

        for (uint256 i;i < _dapps.length; i++) {
            votes[i] = DappVotes(_dapps[i], dappVotes[_dapps[i]]);
        }

        return votes;
    }

    function vote(string calldata _dapp) external payable {
        if (msg.value < price) revert InsufficientPayment(price, msg.value);

        totalVotes += 1;
        dappVotes[_dapp] += 1;

        emit Voted(msg.sender, _dapp);
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        _setPrice(_newPrice);
    }

    function withdraw(address payable _receiver, address _asset, uint256 _amount) external onlyOwner {
        _withdraw(_receiver, Asset(_asset, _amount));
    }

    function withdrawAllEth() external onlyOwner {
        _withdraw(payable(msg.sender), Asset(address(0), address(this).balance));
    }

    function _setPrice(uint256 _newPrice) internal {
        price = _newPrice;

        emit PriceUpdated(_newPrice);
    }
}
