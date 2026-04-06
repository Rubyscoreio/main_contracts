// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "lib/forge-std/src/Script.sol";
import {Rubyscore_Achievement} from "contracts/Rubyscore_Achievement.sol";
import {IRubyscore_Achievement} from "contracts/interfaces/IRubyscore_Achievement.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract MintParamsGeneratorScript is Script {
    bytes32 private constant TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    string public constant CHAIN = 'katana';
    uint256 public constant BADGE = 10;
    address public constant CONTRACT = 0xF57Cb671D50535126694Ce5Cc3CeBe3F32794896;
    address public constant WALLET = 0xC1E42F862d202B4A0eD552c1145735EE088f6Ccf;

    uint256[] public nftIds;

    function helper_sign(uint256 _privateKey, bytes32 _digest) public returns (bytes memory signature) {
        address signer = vm.addr(_privateKey);

        vm.startPrank(signer);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_privateKey, _digest);

        signature = abi.encodePacked(r, s, v);
        vm.stopPrank();
    }

    function getBadgeParams() public {
        uint256 operatorPrivateKey = vm.envUint("OPERATOR_KEY");
        address operator = vm.addr(operatorPrivateKey);
        console.log('Operator', operator);
        vm.createSelectFork(CHAIN);

        Rubyscore_Achievement badges = Rubyscore_Achievement(CONTRACT);

        nftIds.push(BADGE);

        uint256 nonce = badges.getUserNonce(WALLET);

        bytes32 digestRaw = keccak256(
            abi.encode(
                keccak256("MintParams(address userAddress,uint256 userNonce,uint256[] nftIds)"),
                WALLET,
                nonce,
                keccak256(abi.encodePacked(nftIds))
            )
        );

        string memory name = badges.NAME();
        string memory version = badges.VERSION();
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));

        bytes32 domainSeparator = keccak256(
            abi.encode(
                TYPE_HASH,
                hashedName,
                hashedVersion,
                block.chainid,
                CONTRACT
            )
        );
        console.log('Digest raw');
        console.logBytes32(digestRaw);
        console.log('Domain separator');
        console.logBytes32(domainSeparator);

        bytes32 digest = MessageHashUtils.toTypedDataHash(domainSeparator, digestRaw);

        console.log('Digest');
        console.logBytes32(digest);

        bytes memory signature = helper_sign(operatorPrivateKey, digest);

        IRubyscore_Achievement.MintParams memory mintParams =
            IRubyscore_Achievement.MintParams(WALLET, nonce, nftIds);

        uint256 fee = badges.getPrice();

        vm.deal(WALLET, fee);

        vm.prank(WALLET);
        badges.safeMint{ value: fee }(mintParams, signature);

        console.log();
        console.log('Checked');

        console.log();
        console.log('=======');
        console.log();


        console.log('====', WALLET, '====');
        console.log('Value:', '0.0003');
        console.log('userAddress:', WALLET);
        console.log('userNonce:', nonce);
        console.log('nftIds:', BADGE);
        console.log('operatorSignature:');
        console.logBytes(signature);
    }
}
