// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Harness_RubyAchievement} from "tests-forge/harness/Harness_RubyAchievement.sol";
import {Storage_RubyAchievement} from "tests-forge/storage/Storage_RubyAchievement.sol";
import { Rubyscore_Achievement_v2 } from "contracts-forge/Rubyscore_Achievement.v2.sol";

abstract contract Suite_RubyAchievement is Storage_RubyAchievement {
    using ECDSA for bytes32;

    mapping(address => uint256) public withdrawAmounts;

    function helper_sign(uint256 _privateKey, bytes32 _digest) public returns (bytes memory signature) {
        address signer = vm.addr(_privateKey);

        vm.startPrank(signer);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_privateKey, _digest);

        signature = abi.encodePacked(r, s, v);
        vm.stopPrank();
    }

    function expectUnauthorizedAccount(address _sender, bytes32 _role) public {
        vm.expectRevert(
            abi.encodeWithSelector(IAccessControl.AccessControlUnauthorizedAccount.selector, _sender, _role)
        );
    }

    function test_reinitialize_Revert() public {
        vm.expectRevert();
        achievementContract.initialize(address(this), address(this), price);
    }

    function test_Deployment() public view {
        assertTrue(achievementContract.hasRole(DEFAULT_ADMIN_ROLE, address(this)));
        assertTrue(achievementContract.hasRole(OPERATOR_ROLE, address(this)));
        assertEq(achievementContract.price(), price);
    }

    function test_claimAchievement_Ok(address _receiver, uint256 _level, address _caller, uint32 _operatorId) public {
        vm.assume(_caller != address(achievementContract));

        (uint256 operatorPk, address operator) = generateAddress(_operatorId, "operator");

        achievementContract.helper_grantRole(OPERATOR_ROLE, operator);
        vm.deal(_caller, 1 ether);

        bytes32 digest = achievementContract.generateNextClaimDigest(_receiver, _level);
        bytes memory signature = helper_sign(operatorPk, digest);

        uint256 claimPrice = achievementContract.price();
        uint256 balanceBefore = address(achievementContract).balance;

        assertEq(achievementContract.userNonce(_receiver), 0);

        vm.expectEmit();
        emit Rubyscore_Achievement_v2.LevelClaimed(_receiver, _level);

        vm.prank(_caller);
        achievementContract.claimAchievement{ value: claimPrice }(_receiver, _level, signature);

        uint256 balanceAfter = address(achievementContract).balance;

        assertEq(balanceAfter, balanceBefore + claimPrice);
        assertEq(achievementContract.userNonce(_receiver), 1);
        assertEq(achievementContract.userClaims(_receiver, _level), 1);
    }

    function test_claimAchievement_RevertIfDigestInvalid(address _receiver, address _fakeReceiver, uint256 _level, address _caller, uint32 _operatorId) public {
        (uint256 operatorPk, address operator) = generateAddress(_operatorId, "operator");

        achievementContract.helper_grantRole(OPERATOR_ROLE, operator);
        vm.deal(_caller, 1 ether);

        bytes32 digest = achievementContract.generateNextClaimDigest(_fakeReceiver, _level);
        bytes memory signature = helper_sign(operatorPk, digest);

        uint256 claimPrice = achievementContract.price();
        uint256 balanceBefore = address(achievementContract).balance;

        assertEq(achievementContract.userNonce(_receiver), 0);

        vm.expectPartialRevert(IAccessControl.AccessControlUnauthorizedAccount.selector);

        vm.prank(_caller);
        achievementContract.claimAchievement{ value: claimPrice }(_receiver, _level, signature);

        uint256 balanceAfter = address(achievementContract).balance;

        assertEq(balanceAfter, balanceBefore);
        assertEq(achievementContract.userNonce(_receiver), 0);
        assertEq(achievementContract.userClaims(_receiver, _level), 0);
    }

    function test_claimAchievement_RevertIfPaymentIsNotEnough(address _receiver, uint256 _level, address _caller, uint256 _payment, uint32 _operatorId) public {
        vm.assume(_payment < achievementContract.price());

        (uint256 operatorPk, address operator) = generateAddress(_operatorId, "operator");

        achievementContract.helper_grantRole(OPERATOR_ROLE, operator);
        vm.deal(_caller, 1 ether);

        bytes32 digest = achievementContract.generateNextClaimDigest(_receiver, _level);
        bytes memory signature = helper_sign(operatorPk, digest);

        uint256 balanceBefore = address(achievementContract).balance;

        assertEq(achievementContract.userNonce(_receiver), 0);

        vm.expectRevert("Not enough payment");

        vm.prank(_caller);
        achievementContract.claimAchievement{ value: _payment }(_receiver, _level, signature);

        uint256 balanceAfter = address(achievementContract).balance;

        assertEq(balanceAfter, balanceBefore);
        assertEq(achievementContract.userNonce(_receiver), 0);
        assertEq(achievementContract.userClaims(_receiver, _level), 0);
    }

    function test_claimAchievement_RevertIfSignerIsNotAnOperator(address _receiver, uint256 _level, address _caller, uint32 _anonymousId) public {
        (uint256 anonymousPk, address anonymous_) = generateAddress(_anonymousId, "anonymous");

        vm.deal(_caller, 1 ether);

        bytes32 digest = achievementContract.generateNextClaimDigest(_receiver, _level);
        bytes memory signature = helper_sign(anonymousPk, digest);

        uint256 claimPrice = achievementContract.price();
        uint256 balanceBefore = address(achievementContract).balance;

        assertEq(achievementContract.userNonce(_receiver), 0);

        expectUnauthorizedAccount(anonymous_, OPERATOR_ROLE);

        vm.prank(_caller);
        achievementContract.claimAchievement{ value: claimPrice }(_receiver, _level, signature);

        uint256 balanceAfter = address(achievementContract).balance;

        assertEq(balanceAfter, balanceBefore);
        assertEq(achievementContract.userNonce(_receiver), 0);
        assertEq(achievementContract.userClaims(_receiver, _level), 0);
    }

    function test_withdraw_Ok_ERC20asset(address payable _receiver, address _asset, uint256 _amount, uint32 _adminPrivateKeyIndex) public {
        assumeUnusedAddress(_receiver);
        assumeUnusedAddress(_asset);

        deployERC20(_asset);

        deal(_asset, address(achievementContract), _amount);
        (, address admin) = generateAddress(_adminPrivateKeyIndex, "admin");
        achievementContract.helper_grantRole(DEFAULT_ADMIN_ROLE, admin);

        uint256 contractBalanceBefore = IERC20(_asset).balanceOf(address(achievementContract));
        uint256 receiverBalanceBefore = IERC20(_asset).balanceOf(_receiver);

        vm.expectEmit();
        emit Rubyscore_Achievement_v2.Withdrew(_receiver, _asset, _amount);

        vm.prank(admin);
        achievementContract.withdraw(_receiver, _asset, _amount);

        uint256 contractBalanceAfter = IERC20(_asset).balanceOf(address(achievementContract));
        uint256 receiverBalanceAfter = IERC20(_asset).balanceOf(_receiver);

        assertEq(contractBalanceAfter, contractBalanceBefore - _amount);
        assertEq(receiverBalanceAfter, receiverBalanceBefore + _amount);
    }

    function test_withdraw_Ok_NativeAsset(address payable _receiver, address _asset, uint256 _amount, uint32 _adminPrivateKeyIndex)
        public
    {
        vm.assume(_receiver != address(achievementContract));
        assumePayable(_receiver);

        deal(address(achievementContract), _amount);
        (, address admin) = generateAddress(_adminPrivateKeyIndex, "admin");
        achievementContract.helper_grantRole(DEFAULT_ADMIN_ROLE, admin);
        _asset = address(0);

        uint256 contractBalanceBefore = address(achievementContract).balance;
        uint256 receiverBalanceBefore = address(_receiver).balance;

        vm.expectEmit();
        emit Rubyscore_Achievement_v2.Withdrew(_receiver, _asset, _amount);

        vm.prank(admin);
        achievementContract.withdraw(_receiver, _asset, _amount);

        uint256 contractBalanceAfter = address(achievementContract).balance;
        uint256 receiverBalanceAfter = address(_receiver).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore - _amount);
        assertEq(receiverBalanceAfter, receiverBalanceBefore + _amount);
    }

    function test_withdraw_RevertIf_NotAnAdmin(address payable _receiver, address _asset, uint256 _amount, uint32 _anonymousPrivateKeyIndex)
        public
    {
        vm.assume(_receiver != address(achievementContract));
        assumePayable(_receiver);

        deal(address(achievementContract), _amount);
        (, address anonymousAddress) = generateAddress(_anonymousPrivateKeyIndex, "anonymous");
        _asset = address(0);

        uint256 contractBalanceBefore = address(achievementContract).balance;
        uint256 receiverBalanceBefore = address(_receiver).balance;

        expectUnauthorizedAccount(anonymousAddress, DEFAULT_ADMIN_ROLE);
        vm.prank(anonymousAddress);
        achievementContract.withdraw(_receiver, _asset, _amount);

        uint256 contractBalanceAfter = address(achievementContract).balance;
        uint256 receiverBalanceAfter = address(_receiver).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore);
        assertEq(receiverBalanceAfter, receiverBalanceBefore);
    }

    function test_setPrice_Ok(uint256 _newPrice, address _admin) public {
        achievementContract.helper_grantRole(DEFAULT_ADMIN_ROLE, _admin);

        vm.expectEmit();
        emit Rubyscore_Achievement_v2.PriceUpdated(_newPrice);

        vm.prank(_admin);
        achievementContract.setPrice(_newPrice);

        vm.assertEq(achievementContract.price(), _newPrice);
    }

    function test_setPrice_RevertIfNotAnAdmin(uint256 _newPrice, address _anonymous) public {
        vm.assume(!achievementContract.hasRole(DEFAULT_ADMIN_ROLE, _anonymous));

        uint256 oldPrice = achievementContract.price();

        expectUnauthorizedAccount(_anonymous, DEFAULT_ADMIN_ROLE);

        vm.prank(_anonymous);
        achievementContract.setPrice(_newPrice);

        vm.assertEq(achievementContract.price(), oldPrice);
    }
}
