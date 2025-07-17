// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "lib/forge-std/src/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {RubyscoreVote} from "contracts-forge/base/RubyscoreVote.sol";
import {Rubyscore_Soneium_Badges} from "contracts-forge/chains_custom/soneium/Rubyscore_Soneium_Badges.sol";
import {Rubyscore_Soneium_ID} from "contracts-forge/chains_custom/soneium/Rubyscore_Soneium_ID.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";

contract DeployRubyscoreSoneiumContractsScript is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    address public constant MINTER = 0x381c031bAA5995D0Cc52386508050Ac947780815;

    uint256 public constant BADGE_PRICE = 300_000_000_000_000;
    string public constant BADGE_BASE_URI = "ipfs://";

    string public constant ID_NAME = "RubyScore ID: Soneium";
    string public constant ID_SYMBOL = "RubyScore ID: Soneium";
    uint256 public constant ID_FEE = 1_500_000_000_000_000;

    function deployBadge(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.createSelectFork(network);

        address deployer = vm.addr(deployerPrivateKey);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Soneium_Badges badgesContract = new Rubyscore_Soneium_Badges(
            ADMIN,
            OPERATOR,
            MINTER,
            BADGE_BASE_URI
        );

        vm.broadcast(deployerPrivateKey);
        badgesContract.setPrice(BADGE_PRICE);

        console.log("Name: ", badgesContract.name());
        console.log("Symbol: ", badgesContract.symbol());
    }

    function deployId(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Soneium_ID implementation = new Rubyscore_Soneium_ID();

        vm.broadcast(deployerPrivateKey);
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Soneium_ID(address(proxy)).initialize(ID_NAME, ID_SYMBOL, ADMIN, OPERATOR, ID_FEE);
    }

    function deployVote(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        RubyscoreVote voteContract = new RubyscoreVote();
    }
}
