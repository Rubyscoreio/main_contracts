// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Portal} from "./Structs.sol";
import {IRouter} from "./IRouter.sol";

interface IPortalRegistry {
    function router() external view returns (IRouter);

    function portals(address id) external view returns (Portal memory);

    function issuers(address issuerAddress) external view returns (bool);

    function portalAddresses(uint256 index) external view returns (address);

    function initialize() external;

    function updateRouter(address _router) external;

    function setIssuer(address issuer) external;

    function removeIssuer(address issuer) external;

    function isIssuer(address issuer) external view returns (bool);

    function register(
        address id,
        string memory name,
        string memory description,
        bool isRevocable,
        string memory ownerName
    ) external;

    function revoke(address id) external;

    function deployDefaultPortal(
        address[] calldata modules,
        string memory name,
        string memory description,
        bool isRevocable,
        string memory ownerName
    ) external;

    function getPortalByAddress(address id) external view returns (Portal memory);

    function isRegistered(address id) external view returns (bool);

    function getPortalsCount() external view returns (uint256);
}
