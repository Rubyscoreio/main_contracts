// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Attestation, AttestationPayload} from "./Structs.sol";
import {IRouter} from "./IRouter.sol";

interface IAttestationRegistry {
    /// @notice Event emitted when an attestation is registered
    event AttestationRegistered(bytes32 indexed attestationId);

    function router() external view returns (IRouter);

    function attestations(bytes32 attestationId) external view returns (Attestation memory);

    function initialize() external;

    function updateRouter(address _router) external;

    function updateChainPrefix(uint256 _chainPrefix) external;

    function onlyPortals(address portal) external view;

    function attest(AttestationPayload calldata attestationPayload, address attester) external;

    function bulkAttest(AttestationPayload[] calldata attestationsPayloads, address attester) external;

    function massImport(AttestationPayload[] calldata attestationsPayloads, address portal) external;

    function replace(bytes32 attestationId, AttestationPayload calldata attestationPayload, address attester) external;

    function bulkReplace(
        bytes32[] calldata attestationIds,
        AttestationPayload[] calldata attestationPayloads,
        address attester
    ) external;

    function revoke(bytes32 attestationId) external;

    function bulkRevoke(bytes32[] memory attestationIds) external;

    function isRegistered(bytes32 attestationId) external view returns (bool);

    function isRevocable(address portalId) external view returns (bool);

    function getAttestation(bytes32 attestationId) external view returns (Attestation memory);

    function incrementVersionNumber() external returns (uint16);

    function getVersionNumber() external view returns (uint16);

    function getAttestationIdCounter() external view returns (uint32);

    function getChainPrefix() external view returns (uint256);

    function balanceOf(address account, uint256 id) external view returns (uint256);

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) external view returns (uint256[] memory);
}
