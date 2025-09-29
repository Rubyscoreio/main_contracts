// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "lib/forge-std/src/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {RubyscoreVote} from "contracts-forge/base/RubyscoreVote.sol";
import {Rubyscore_Achievement} from "contracts/Rubyscore_Achievement.sol";
import {Rubyscore_Somnia_ID} from "contracts-forge/chains_custom/somnia/Rubyscore_Somnia_ID.sol";
import {SafeSingletonDeployer} from "./helpers/SafeSingletonDeployer.sol";

contract DeployRubyscoreSomniaContractsScript is Script {
    address public constant ADMIN = 0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361;
    address public constant OPERATOR = 0x381c031bAA5995D0Cc52386508050Ac947780815;
    address public constant MINTER = 0x381c031bAA5995D0Cc52386508050Ac947780815;

    string public constant ACHIEVEMENT_NAME = "RubyScore Reputation Boxes: Somnia";
    string public constant ACHIEVEMENT_SYMBOL = "RubyScore Reputation Boxes: Somnia";
    uint256 public constant ACHIEVEMENT_PRICE = 1e18;
    string public constant ACHIEVEMENT_BASE_URI = "ipfs://bafybeiecqknzppl3hhmvuo4d7uejht6cy5ztaqmwaj2pvhbx7xvrfloswa/";

    string public constant ID_NAME = "RubyScore ID: Somnia";
    string public constant ID_SYMBOL = "RubyScore ID: Somnia";
    uint256 public constant ID_FEE = 1_500_000_000_000_000;

    uint256[] public tokenIds;
    string[] public tokenUris;

    function deployAchievements(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        uint256 operatorPrivateKey = vm.envUint("OPERATOR_KEY");
        vm.createSelectFork(network);

        address deployer = vm.addr(deployerPrivateKey);
        address operator = vm.addr(operatorPrivateKey);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Achievement badgesContract = Rubyscore_Achievement(0x9c89e169A5552b5ac8b79b2b4BFcCB18e846579d);
        Rubyscore_Achievement badgesContract = new Rubyscore_Achievement(
            ADMIN,
            OPERATOR,
            MINTER,
            ACHIEVEMENT_BASE_URI,
            ACHIEVEMENT_NAME,
            ACHIEVEMENT_SYMBOL
        );

        vm.broadcast(deployerPrivateKey);
        badgesContract.setPrice(3e18);

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
        Rubyscore_Somnia_ID implementation = new Rubyscore_Somnia_ID();

        require(address(implementation).code.length > 0, "implementation not deployed");

        vm.broadcast(deployerPrivateKey);
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");

        require(address(proxy).code.length > 0, "proxy not deployed");

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Somnia_ID(address(proxy)).initialize(ID_NAME, ID_SYMBOL, deployer, deployer, ID_FEE);

        vm.broadcast(deployerPrivateKey);
        Rubyscore_Somnia_ID(0x1B723fe70CBc01eaad304cE6733B70F8F988c21e).setAttestationFee(15e18);
    }

    function deployVote(string calldata network) external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.createSelectFork(network);

        vm.broadcast(deployerPrivateKey);
        RubyscoreVote voteContract = new RubyscoreVote();
    }
}
