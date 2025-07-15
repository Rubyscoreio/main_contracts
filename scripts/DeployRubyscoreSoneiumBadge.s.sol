// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "lib/forge-std/src/Script.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Rubyscore_Soneium_Badges} from "../contracts-forge/chains_custom/soneium/Rubyscore_Soneium_Badges.sol";

contract DeployRubyscoreSoneiumBadgeScript is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    address public constant MINTER = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    uint256 public constant PRICE = 300_000_000_000_000;
    string public constant BASE_URI = "ipfs://";

    function run(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");

        _run(network, deployerPrivateKey);
    }

    function _run(string calldata network, uint256 deployerPrivateKey) internal {
        vm.createSelectFork(network);

        address deployer = vm.addr(deployerPrivateKey);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Soneium_Badges achievementContract = new Rubyscore_Soneium_Badges(
            ADMIN,
            OPERATOR,
            MINTER,
            BASE_URI
        );

        console.log("Name: ", achievementContract.name());
        console.log("Symbol: ", achievementContract.symbol());
    }
}
