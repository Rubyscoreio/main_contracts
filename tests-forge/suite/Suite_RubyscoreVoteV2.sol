// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Harness_RubyscoreVoteV2} from "tests-forge/harness/Harness_RubyscoreVoteV2.sol";
import {Storage_RubyscoreVoteV2} from "tests-forge/storage/Storage_RubyscoreVoteV2.sol";
import { RubyscoreVoteV2 } from "contracts-forge/base/RubyscoreVote.v2.sol";

abstract contract Suite_RubyscoreVoteV2 is Storage_RubyscoreVoteV2 {
    mapping(address => uint256) public withdrawAmounts;

    function expectNotOwner(address _sender) public {
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, _sender)
        );
    }

    function test_Deployment() public view {
        assertEq(voteContract.owner(), owner);
        assertEq(voteContract.voteCounter(), initialCounter);
        assertEq(voteContract.price(), price);
    }

    function test_vote_Ok(address _caller, uint256 _price) public {
        voteContract.helper_setPrice(_price);
        vm.deal(_caller, _price);

        uint256 balanceBefore = address(voteContract).balance;
        uint256 counterBefore = voteContract.voteCounter();

        vm.expectEmit();
        emit RubyscoreVoteV2.Voted(_caller);

        vm.prank(_caller);
        voteContract.vote{ value: _price }();

        uint256 balanceAfter = address(voteContract).balance;

        assertEq(balanceAfter, balanceBefore + _price);
        assertEq(voteContract.voteCounter(), counterBefore + 1);
    }

    function test_claimAchievement_RevertIfPaymentIsNotEnough(address _caller, uint256 _price, uint256 _payment) public {
        vm.assume(_payment < _price);

        voteContract.helper_setPrice(_price);
        vm.deal(_caller, _payment);

        uint256 balanceBefore = address(voteContract).balance;
        uint256 counterBefore = voteContract.voteCounter();

        vm.expectRevert(abi.encodeWithSelector(RubyscoreVoteV2.InsufficientPayment.selector, _price, _payment));

        vm.prank(_caller);
        voteContract.vote{ value: _payment }();

        uint256 balanceAfter = address(voteContract).balance;

        assertEq(balanceAfter, balanceBefore);
        assertEq(voteContract.voteCounter(), counterBefore);
    }

    function test_withdraw_Ok_ERC20asset(address payable _receiver, address _asset, uint256 _amount) public {
        vm.assume(_receiver != address(voteContract));
        vm.assume(_receiver != address(0));
        assumeUnusedAddress(_asset);

        deployERC20(_asset);

        deal(_asset, address(voteContract), _amount);

        uint256 contractBalanceBefore = IERC20(_asset).balanceOf(address(voteContract));
        uint256 receiverBalanceBefore = IERC20(_asset).balanceOf(_receiver);

        vm.expectEmit();
        emit RubyscoreVoteV2.Withdrew(_receiver, _asset, _amount);

        vm.prank(owner);
        voteContract.withdraw(_receiver, _asset, _amount);

        uint256 contractBalanceAfter = IERC20(_asset).balanceOf(address(voteContract));
        uint256 receiverBalanceAfter = IERC20(_asset).balanceOf(_receiver);

        assertEq(contractBalanceAfter, contractBalanceBefore - _amount);
        assertEq(receiverBalanceAfter, receiverBalanceBefore + _amount);
    }

    function test_withdraw_Ok_NativeAsset(address payable _receiver, address _asset, uint256 _amount)
        public
    {
        vm.assume(_receiver != address(voteContract));
        assumePayable(_receiver);

        deal(address(voteContract), _amount);
        _asset = address(0);

        uint256 contractBalanceBefore = address(voteContract).balance;
        uint256 receiverBalanceBefore = address(_receiver).balance;

        vm.expectEmit();
        emit RubyscoreVoteV2.Withdrew(_receiver, _asset, _amount);

        vm.prank(owner);
        voteContract.withdraw(_receiver, _asset, _amount);

        uint256 contractBalanceAfter = address(voteContract).balance;
        uint256 receiverBalanceAfter = address(_receiver).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore - _amount);
        assertEq(receiverBalanceAfter, receiverBalanceBefore + _amount);
    }

    function test_withdraw_RevertIf_NotAnOwner(address payable _receiver, address _asset, uint256 _amount, address _anonymous)
        public
    {
        vm.assume(_anonymous != owner);
        vm.assume(_receiver != address(voteContract));
        assumePayable(_receiver);

        deal(address(voteContract), _amount);
        _asset = address(0);

        uint256 contractBalanceBefore = address(voteContract).balance;
        uint256 receiverBalanceBefore = address(_receiver).balance;

        expectNotOwner(_anonymous);

        vm.prank(_anonymous);
        voteContract.withdraw(_receiver, _asset, _amount);

        uint256 contractBalanceAfter = address(voteContract).balance;
        uint256 receiverBalanceAfter = address(_receiver).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore);
        assertEq(receiverBalanceAfter, receiverBalanceBefore);
    }

    function test_setPrice_Ok(uint256 _newPrice) public {
        vm.expectEmit();
        emit RubyscoreVoteV2.PriceUpdated(_newPrice);

        vm.prank(owner);
        voteContract.setPrice(_newPrice);

        vm.assertEq(voteContract.price(), _newPrice);
    }

    function test_setPrice_RevertIfNotAnOwner(uint256 _newPrice, address _anonymous) public {
        vm.assume(_anonymous != owner);

        uint256 oldPrice = voteContract.price();

        expectNotOwner(_anonymous);

        vm.prank(_anonymous);
        voteContract.setPrice(_newPrice);

        vm.assertEq(voteContract.price(), oldPrice);
    }

    function test_withdrawAllEth_Ok(uint256 _amount) public {
        deal(address(voteContract), _amount);

        uint256 contractBalanceBefore = address(voteContract).balance;
        uint256 ownerBalanceBefore = owner.balance;

        vm.expectEmit();
        emit RubyscoreVoteV2.Withdrew(owner, address(0), contractBalanceBefore);

        vm.prank(owner);
        voteContract.withdrawAllEth();

        uint256 contractBalanceAfter = address(voteContract).balance;
        uint256 ownerBalanceAfter = owner.balance;

        assertEq(contractBalanceAfter, 0);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + _amount);
    }

    function test_withdrawAllEth_RevertIfNotAnOwner(uint256 _amount, address _anonymous) public {
        vm.assume(_anonymous != owner);

        deal(address(voteContract), _amount);

        uint256 contractBalanceBefore = address(voteContract).balance;
        uint256 senderBalanceBefore = _anonymous.balance;

        expectNotOwner(_anonymous);
        vm.prank(_anonymous);
        voteContract.withdrawAllEth();

        uint256 contractBalanceAfter = address(voteContract).balance;
        uint256 senderBalanceAfter = _anonymous.balance;

        assertEq(contractBalanceAfter, contractBalanceBefore);
        assertEq(senderBalanceAfter, senderBalanceBefore);
    }
}
