// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AbstractPortal} from "./abstracts/AbstractPortal.sol";
import {AttestationPayload} from "./interfaces/Structs.sol";

/**
 * @title Default Portal
 * @author Consensys
 * @notice This contract aims to provide a default portal
 * @dev This Portal does not add any logic to the AbstractPortal
 */
contract RubyScorePortalClean is AbstractPortal {
    bytes32 schema;

    /**
     * @notice Contract constructor
     * @param modules list of modules to use for the portal (can be empty)
     * @param router the Router's address
     * @dev This sets the addresses for the AttestationRegistry, ModuleRegistry and PortalRegistry
     */
    constructor(address[] memory modules, address router) AbstractPortal(modules, router) {}

    function setSchema(bytes32 _schema) external {
        schema = _schema;
    }

    //TODO: only owner
    function addModule(address module) external {
        modules.push(module);
    }

    //TODO: only owner
    function removeModules() external {
        delete modules;
    }

    struct AttestationRequestData {
        uint256 level;
        bool onchain;
    }

    // struct AttestationPayload {
    //     bytes32 schemaId; // The identifier of the schema this attestation adheres to.
    //     uint64 expirationDate; // The expiration date of the attestation.
    //     bytes subject; // The ID of the attestee, EVM address, DID, URL etc.
    //     bytes attestationData; // The attestation data.
    // }

    function attestScoreSimple(uint64 level, bool onchain, bytes memory signature) public payable {
        AttestationRequestData memory attestationRequestData = AttestationRequestData(level, onchain);
        bytes[] memory validationPayload = new bytes[](1);
        validationPayload[0] = signature;
        attestScore(attestationRequestData, validationPayload);
    }

    function attestScore(
        AttestationRequestData memory attestationRequestData,
        bytes[] memory validationPayload
    ) internal {
        bytes memory attestationData = abi.encodePacked(attestationRequestData.level, attestationRequestData.onchain);
        AttestationPayload memory attestationPayload = AttestationPayload(
            schema,
            1767786495,
            abi.encode(msg.sender),
            attestationData
        );
        super.attest(attestationPayload, validationPayload);
    }

    function bulkAttest0xScore(
        AttestationRequestData[] memory attestationsRequests,
        bytes[] memory validationPayload
    ) public {
        for (uint256 i = 0; i < attestationsRequests.length; i++) {
            attestScore(attestationsRequests[i], validationPayload);
        }
    }

    /// @inheritdoc AbstractPortal
    function withdraw(address payable to, uint256 amount) external override {}
}
