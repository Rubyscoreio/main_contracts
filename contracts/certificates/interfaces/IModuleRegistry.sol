// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Module, AttestationPayload} from "./Structs.sol";
import {IRouter} from "./IRouter.sol";

interface IModuleRegistry {
    function router() external view returns (IRouter);

    function modules(address moduleAddress) external view returns (Module memory);

    function moduleAddresses(uint256 index) external view returns (address);

    function initialize() external;

    function updateRouter(address _router) external;

    function isContractAddress(address contractAddress) external view returns (bool);

    function onlyIssuers(address issuer) external view;

    function register(string memory name, string memory description, address moduleAddress) external;

    function runModules(
        address[] memory modulesAddresses,
        AttestationPayload memory attestationPayload,
        bytes[] memory validationPayloads,
        uint256 value
    ) external;

    function bulkRunModules(
        address[] memory modulesAddresses,
        AttestationPayload[] memory attestationsPayloads,
        bytes[][] memory validationPayloads
    ) external;

    function getModulesNumber() external view returns (uint256);

    function isRegistered(address moduleAddress) external view returns (bool);
}
