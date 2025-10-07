// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "../contracts-forge/Rubyscore_Achievement.v2.sol";
import "lib/forge-std/src/Script.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {RubyscoreBadges} from "contracts-forge/base/RubyscoreBadges.sol";
import {RubyscoreVote} from "contracts-forge/base/RubyscoreVote.sol";
import {Rubyscore_Soneium_ID} from "contracts-forge/chains_custom/soneium/Rubyscore_Soneium_ID.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";

contract DeployGeneralContractsScript is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    address public constant MINTER = 0x381c031bAA5995D0Cc52386508050Ac947780815;

    uint256 public constant ACHIEVEMENTS_PRICE = 0.0003e18;

    function deployVoteAndV2Achievements(string calldata network) public {
        deployVote(network);
        deployV2Achievements(network);
    }

    function deployVote(string calldata network) public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        RubyscoreVote voteContract = new RubyscoreVote();
    }

    function deployV2Achievements(string calldata network) public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");

        vm.createSelectFork(network);

        address deployer = vm.addr(deployerPrivateKey);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Achievement_v2 achievementContract = new Rubyscore_Achievement_v2();

        vm.broadcast(deployerPrivateKey);
        ERC1967Proxy proxy = new ERC1967Proxy(address(achievementContract), "");

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Achievement_v2(payable(proxy)).initialize(ADMIN, OPERATOR, ACHIEVEMENTS_PRICE);
    }

    function deployV2AchievementsSSD(string calldata network) public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        bytes32 salt = keccak256("RubyscoreAchievementV2");

        vm.createSelectFork(network);

        address deployer = vm.addr(deployerPrivateKey);

        address achievementContract = SafeSingletonDeployer.broadcastDeploy({
            deployerPrivateKey: deployerPrivateKey,
            creationCode: type(Rubyscore_Achievement_v2).creationCode,
            args: "",
            salt: salt
        });

        address proxy = SafeSingletonDeployer.broadcastDeploy({
            deployerPrivateKey: deployerPrivateKey,
            creationCode: type(ERC1967Proxy).creationCode,
            args: abi.encode(address(achievementContract), ""),
            salt: salt
        });

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Achievement_v2(payable(proxy)).initialize(ADMIN, OPERATOR, ACHIEVEMENTS_PRICE);
    }
}
