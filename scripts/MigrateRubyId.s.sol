// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "../contracts-forge/Rubyscore_Achievement.v2.sol";

import "../contracts-forge/chains_custom/somnia/Rubyscore_Somnia_ID.sol";
import "lib/forge-std/src/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {RubyscoreBadges} from "contracts-forge/base/RubyscoreBadges.sol";
import {RubyscoreID} from "contracts-forge/base/RubyscoreID.sol";
import {RubyscoreVote} from "contracts-forge/base/RubyscoreVote.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";

contract MigrateRubyIdScript is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;

    string public constant SOURCE = 'katana';
    string public constant TARGET = 'katana';

    uint256 public sourceFork;
    uint256 public targetFork;

    uint256 public constant BATCH_SIZE = 100;

    address[] public batch;
    address[] public targetBatch;

    RubyscoreID public sourceContract = RubyscoreID(0x09B18EFC623bf4a6247B23320920C3044a45cC2c);
    RubyscoreID public targetContract = RubyscoreID(0xb0F3b3553cE518339c1B5807A392ae904fB658Ec);

    uint256 public constant VALIDATION_START = 0;
    uint256 public constant VALIDATION_END = 1093;

    event ValidationSuccess(uint256 tokenId, address tokenOwner);

    error ValidationError(address expectedOwner, address actualOwner);

    function validate() public {
        sourceFork = vm.createFork(SOURCE);
        targetFork = vm.createFork(TARGET);

        uint256 sourceMinted = getMintedAtSource();
        uint256 targetMinted = getMintedAtTarget();


        collectBatch(VALIDATION_START, VALIDATION_END);
        collectTargetBatch(VALIDATION_START, VALIDATION_END);

        validateBatch();
    }

    function run() public {
        sourceFork = vm.createFork(SOURCE);
        targetFork = vm.createFork(TARGET);

//        addFakeContract();

        uint256 sourceMinted = getMintedAtSource();
        uint256 targetMinted = getMintedAtTarget();

        require(sourceMinted > targetMinted, "Nothing to migrate");

        collectBatch(501, sourceMinted);

        executeBatch();
    }

    function addFakeContract() public {
        vm.selectFork(targetFork);

        Rubyscore_Somnia_ID implementation = new Rubyscore_Somnia_ID();

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");

        targetContract = RubyscoreID(address(proxy));

        targetContract.initialize("TestId", "TIS", ADMIN, OPERATOR, 3e14);
    }

    function getMintedAtSource() public returns(uint256) {
        vm.selectFork(sourceFork);

        return sourceContract.tokenCounter();
    }

    function getMintedAtTarget() public returns(uint256) {
        vm.selectFork(targetFork);

    return targetContract.tokenCounter();
    }

    function collectBatch(uint256 _batchStart, uint256 _batchEnd) public {
        vm.selectFork(sourceFork);

        for (uint256 tokenId = _batchStart + 1; tokenId <= _batchEnd; tokenId++) {
            address owner = sourceContract.ownerOf(tokenId);

            batch.push(owner);
        }
    }

    function collectTargetBatch(uint256 _batchStart, uint256 _batchEnd) public {
        vm.selectFork(targetFork);

        for (uint256 tokenId = _batchStart + 1; tokenId <= _batchEnd; tokenId++) {
            address owner = targetContract.ownerOf(tokenId);

            targetBatch.push(owner);
        }
    }

    function executeBatch() public {
        vm.selectFork(targetFork);
        uint256 deployerPrivateKey = vm.envUint("OPERATOR_KEY");

        vm.broadcast(deployerPrivateKey);
        targetContract.attestBatch(batch);
    }

    function validateBatch() public {
        vm.selectFork(targetFork);

        for (uint256 i = 0; i < batch.length; i++) {
            if (targetBatch[i] != batch[i]) {
                revert ValidationError(batch[i], targetBatch[i]);
            }
            emit ValidationSuccess(VALIDATION_START + i + 1, batch[i]);
        }
    }
}
