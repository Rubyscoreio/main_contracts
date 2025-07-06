// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "lib/forge-std/src/Script.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Rubyscore_Achievement_v2} from "contracts-forge/Rubyscore_Achievement.v2.sol";

contract DeployRubyscoreAchievementV2Script is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    uint256 public constant PRICE = 300_000_000_000_000;

    function run(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        bytes32 salt = keccak256("RubyscoreAchievementV2");

        _run(network, deployerPrivateKey, salt);
    }

    function _run(string calldata network, uint256 deployerPrivateKey, bytes32 salt) internal {
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
        Rubyscore_Achievement_v2(payable(proxy)).initialize(ADMIN, OPERATOR, PRICE);
    }
}
