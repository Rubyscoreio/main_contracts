// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {RubyscoreBadges} from "contracts-forge/base/RubyscoreBadges.sol";

contract Rubyscore_Soneium_Badges is RubyscoreBadges {
    string public constant NAME = "Rubyscore: Soneium_Badges";
    string public constant SYMBOL = "Rubyscore: Soneium_Badges";

    constructor(
        address admin,
        address operator,
        address minter,
        string memory baseURI
    ) RubyscoreBadges(admin, operator, minter, baseURI, NAME, SYMBOL) {}
}
