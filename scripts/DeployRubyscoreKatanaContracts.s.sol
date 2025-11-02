// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "lib/forge-std/src/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {RubyscoreVote} from "contracts-forge/base/RubyscoreVote.sol";
import {Rubyscore_Achievement} from "contracts/Rubyscore_Achievement.sol";
import {Rubyscore_Katana_ID} from "contracts-forge/chains_custom/katana/Rubyscore_Katana_ID.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";
import {RubyscoreVoteV2} from "contracts-forge/base/RubyscoreVote.v2.sol";
import {Rubyscore_Katana_Badges} from "../contracts-forge/chains_custom/katana/Rubyscore_Katana_Badges.sol";

contract DeployRubyscoreKatanaContractsScript is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    address public constant MINTER = 0x381c031bAA5995D0Cc52386508050Ac947780815;

    uint256 public constant VOTE_PRICE = 0.000005e18;
    uint256 public constant VOTE_INITIAL_COUNTER = 0e6;

    uint256 public constant BADGE_PRICE = 300_000_000_000_000;
    string public constant BADGE_BASE_URI = "ipfs://";

    string public constant ID_NAME = "RubyScore ID: Katana";
    string public constant ID_SYMBOL = "RubyScore ID: Katana";
    uint256 public constant ID_FEE = 1_500_000_000_000_000;

    uint256[] public tokenIds;
    string[] public tokenUris;

    function deployBadge(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        uint256 operatorPrivateKey = vm.envUint("OPERATOR_KEY");
        vm.createSelectFork(network);

        address deployer = vm.addr(deployerPrivateKey);
        address operator = vm.addr(operatorPrivateKey);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Katana_Badges badgesContract = new Rubyscore_Katana_Badges(
            ADMIN,
            OPERATOR,
            MINTER,
            BADGE_BASE_URI
        );

        vm.broadcast(deployerPrivateKey);
        badgesContract.setPrice(BADGE_PRICE);

        tokenIds.push(1);
        tokenIds.push(2);
        tokenIds.push(3);
        tokenIds.push(4);
        tokenIds.push(5);
        tokenIds.push(6);
        tokenIds.push(7);
        tokenIds.push(8);
        tokenIds.push(9);
        tokenIds.push(10);
        tokenIds.push(11);

        tokenUris.push("1.json");
        tokenUris.push("2.json");
        tokenUris.push("3.json");
        tokenUris.push("4.json");
        tokenUris.push("5.json");
        tokenUris.push("6.json");
        tokenUris.push("7.json");
        tokenUris.push("8.json");
        tokenUris.push("9.json");
        tokenUris.push("10.json");
        tokenUris.push("11.json");

        vm.broadcast(operatorPrivateKey);
        badgesContract.setBatchTokenURI(tokenIds, tokenUris);

        console.log("Name: ", badgesContract.name());
        console.log("Symbol: ", badgesContract.symbol());
    }

    function deployId(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Katana_ID implementation = new Rubyscore_Katana_ID();

        require(address(implementation).code.length > 0, "implementation not deployed");

        vm.broadcast(deployerPrivateKey);
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");

        require(address(proxy).code.length > 0, "proxy not deployed");

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Katana_ID(address(proxy)).initialize(ID_NAME, ID_SYMBOL, ADMIN, OPERATOR, ID_FEE);
    }

    function deployVote(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        RubyscoreVote voteContract = new RubyscoreVote();
    }

    function deployVoteV2(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        RubyscoreVoteV2 voteContract = new RubyscoreVoteV2(deployer, VOTE_PRICE, VOTE_INITIAL_COUNTER);
    }
}
