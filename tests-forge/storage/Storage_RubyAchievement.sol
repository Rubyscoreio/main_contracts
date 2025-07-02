// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "tests-forge/mock/Mock_ERC20.sol";
import "forge-std/Test.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Harness_RubyAchievement} from "tests-forge/harness/Harness_RubyAchievement.sol";

abstract contract Storage_RubyAchievement is Test {
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    string public constant TEST_MNEMONIC = "test test test test test test test test test test test junk";

    uint256 public price = 1e9;
    Harness_RubyAchievement public achievementContract;

    function deployERC20(address _address) public {
        Mock_ERC20 _erc20 = new Mock_ERC20("ERC20", "ERC20");
        vm.etch(_address, address(_erc20).code);
    }

    function generateAddress(uint32 _id, string memory _name) public returns (uint256 privateKey, address addr) {
        privateKey = vm.deriveKey(TEST_MNEMONIC, _id);
        addr = vm.addr(privateKey);

        vm.label(addr, _name);
    }

    function _prepareEnv() internal virtual;

    function setUp() public virtual {
        _prepareEnv();
    }
}
