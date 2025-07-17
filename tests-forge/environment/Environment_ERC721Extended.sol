// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Harness_ERC721Extended} from "tests-forge/harness/Harness_ERC721Extended.sol";
import {Storage_ERC721Extended} from "tests-forge/storage/Storage_ERC721Extended.sol";

abstract contract Environment_ERC721Extended is Storage_ERC721Extended {
    function _prepareEnv() internal override {
        erc721Extended = new Harness_ERC721Extended();

        erc721Extended.initialize("Test", "TST");
    }
}
