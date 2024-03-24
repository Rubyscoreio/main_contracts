// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AbstractModule} from "../abstracts/AbstractModule.sol";
import {AttestationPayload} from "../interfaces/Structs.sol";
import {IPortalRegistry} from "../interfaces/IPortalRegistry.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Rubyscore Fee Module
 * @notice This module can be used by portal creators to enforce a fee on attestations.
 */
contract RubyscoreFeeModule is AbstractModule, Ownable {
    mapping(bytes32 => uint256) public attestationFees;

    /// @notice Error thrown when an array length mismatch occurs
    error ArrayLengthMismatch();
    /// @notice Error thrown when an invalid attestation fee is provided
    error InvalidAttestationFee();
    error ZeroAddressCheck();

    event FeesSet(bytes32[] schemaIds, uint256[] attestationFees);

    /**
     * @notice Contract constructor sets the portal registry
     */
    constructor(address initialOwner) Ownable(initialOwner) {}

    /**
     * @notice Set the fee required to attest
     * @param _attestationFees The fees required to attest
     * @param schemaIds The schemaIds to set the fee for
     */
    function setFees(bytes32[] memory schemaIds, uint256[] memory _attestationFees) public onlyOwner {
        if (schemaIds.length != _attestationFees.length) revert ArrayLengthMismatch();

        for (uint256 i = 0; i < schemaIds.length; i++) {
            attestationFees[schemaIds[i]] = _attestationFees[i];
        }

        emit FeesSet(schemaIds, _attestationFees);
    }

    /**
     * @notice The main method for the module, running the check
     * @param _value The value sent for the attestation
     */
    function run(
        AttestationPayload memory _attestationPayload,
        bytes memory /*_validationPayload*/,
        address /*_txSender*/,
        uint256 _value
    ) public view override {
        uint256 attestationFee = attestationFees[_attestationPayload.schemaId];
        if (_value < attestationFee) revert InvalidAttestationFee();
    }
}
