// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Rubyscore_Badges} from "contracts-forge/base/Rubyscore_Badges.sol";

contract Rubyscore_Soneium_Badges is Rubyscore_Badges {
    string public constant NAME = "Rubyscore: Soneium_Badges";
    string public constant SYMBOL = "Rubyscore: Soneium_Badges";

    constructor(
        address admin,
        address operator,
        address minter,
        string memory baseURI
    ) Rubyscore_Badges(admin, operator, minter, baseURI, NAME, SYMBOL) {}
}
