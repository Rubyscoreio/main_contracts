// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AbstractPortal} from "./abstracts/AbstractPortal.sol";
import {AttestationPayload} from "./interfaces/Structs.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IRubyscore_Certificates} from "./interfaces/IRubyscore_Certificates.sol";

/**
 * @title RubyScoreVeraxPortal
 * @dev RubyScoreVeraxPortal is a smart contract that handles the attestation process for RubyScore certificates.
 * It manages fees, signatures based on specific schemas.
 */
contract RubyScoreVeraxPortal is AbstractPortal, Ownable, Pausable {
    // State variables
    bool public bulkStatus = false;
    bool public feeStatus = true;

    // Storage
    mapping(bytes32 => bool) public certificates; // schemaId => certificateStatus
    mapping(bytes32 => uint256) public attestationFees; // schemaId => attestationFee

    // Errors
    error InvalidCertificateId();
    error ArrayLengthMismatch();
    error InvalidAttestationFee();
    error ZeroAddressCheck();
    error WithdrawFail();

    // Events
    event FeesSet(bytes32[] schemaIds, uint256[] attestationFees);

    /**
     * @dev Contract constructor.
     * @param modules List of modules to use for the portal.
     * @param router The Router's address.
     */
    constructor(address[] memory modules, address router) AbstractPortal(modules, router) Ownable(msg.sender) {
        if (router == address(0)) revert ZeroAddressCheck();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Check if the provided value meets the attestation fee requirement.
     * @param schemaId The schemaId for which to check the fee.
     * @param _value The value sent for the attestation.
     */
    function checkFee(bytes32 schemaId, uint256 _value) public view {
        if (_value < attestationFees[schemaId]) revert InvalidAttestationFee();
    }

    /**
     * @dev Set the fee, signature, and issuance statuses.
     * @param fee Fee status.
     */
    function setCheckStatuses(bool fee, bool bulk) external onlyOwner {
        feeStatus = fee;
        bulkStatus = bulk;
    }

    /**
     * @dev Add a new module to the list of modules.
     * @param module The address of the new module.
     */
    function addModule(address module) external onlyOwner {
        modules.push(module);
    }

    /**
     * @dev Remove all modules from the list of modules.
     */
    function removeModules() external onlyOwner whenPaused {
        delete modules;
    }

    /**
     * @dev Set the fees for specific schemaIds.
     * @param schemaIds The schemaIds to set the fee for.
     * @param _attestationFees The fees required to attest.
     */
    function setFees(bytes32[] memory schemaIds, uint256[] memory _attestationFees) public onlyOwner {
        if (schemaIds.length != _attestationFees.length) revert ArrayLengthMismatch();
        for (uint256 i = 0; i < schemaIds.length; i++) {
            attestationFees[schemaIds[i]] = _attestationFees[i];
        }
        emit FeesSet(schemaIds, _attestationFees);
    }

    /**
     * @dev Set up certificate mappings for schemaIds.
     * @param schemaIds The schemaIds for which to set up certificates.
     * @param certificateStatuses The corresponding certificate statuses.
     */
    function setUpCertificates(bytes32[] calldata schemaIds, bool[] calldata certificateStatuses) public onlyOwner {
        if (schemaIds.length != certificateStatuses.length) revert ArrayLengthMismatch();
        for (uint256 i = 0; i < schemaIds.length; i++) {
            certificates[schemaIds[i]] = certificateStatuses[i];
        }
    }

    /**
     * @dev Attest a score with a given attestation payload and validation payloads.
     * @param attestationPayload The payload of the attestation.
     * @param validationPayload The validation payload required for the module.
     */
    function attestRubyscore(
        AttestationPayload memory attestationPayload,
        bytes[] memory validationPayload
    ) external payable {
        super.attest(attestationPayload, validationPayload);
    }

    /**
     * @dev Withdraw ETH from the contract.
     * @param to The address to which the ETH will be withdrawn.
     * @param amount The amount of ETH to withdraw.
     */
    function withdraw(address payable to, uint256 amount) external override onlyOwner {
        (bool status, ) = to.call{value: amount}("");
        if (!status) revert WithdrawFail();
    }

    /**
     * @notice Optional method run before a payload is attested
     * @param attestationPayload the attestation payload supposed to be attested
     * @param attester the address of the attester
     * @param value the value sent with the attestation
     */
    function _onAttest(
        AttestationPayload memory attestationPayload,
        address attester,
        uint256 value
    ) internal override whenNotPaused {
        if (!certificates[attestationPayload.schemaId]) revert InvalidCertificateId();
        if (feeStatus) checkFee(attestationPayload.schemaId, value);
        super._onAttest(attestationPayload, attester, value);
    }

    /**
     * @notice Optional method run when attesting a batch of payloads
     */
    function _onBulkAttest(
        AttestationPayload[] memory attestationsPayloads,
        bytes[][] memory validationPayloads
    ) internal override whenNotPaused {
        if (!bulkStatus) revert("Only single attest");
        for (uint256 i = 0; i < attestationsPayloads.length; i++) {
            if (!certificates[attestationsPayloads[i].schemaId]) revert InvalidCertificateId();
        }
        super._onBulkAttest(attestationsPayloads, validationPayloads);
    }

    /**
     * @notice Optional method run when an attestation is replaced
     * @param attestationId the ID of the attestation being replaced
     * @param attestationPayload the attestation payload to create attestation and register it
     * @param attester the address of the attester
     * @param value the value sent with the attestation
     */
    function _onReplace(
        bytes32 attestationId,
        AttestationPayload memory attestationPayload,
        address attester,
        uint256 value
    ) internal override whenNotPaused {
        if (!certificates[attestationPayload.schemaId]) revert InvalidCertificateId();
        if (feeStatus) checkFee(attestationPayload.schemaId, value);
        super._onReplace(attestationId, attestationPayload, attester, value);
    }

    function _onBulkReplace(
        bytes32[] memory attestationIds,
        AttestationPayload[] memory attestationsPayloads,
        bytes[][] memory validationPayloads
    ) internal override whenNotPaused {
        if (!bulkStatus) revert("Only single replace");
        for (uint256 i = 0; i < attestationsPayloads.length; i++) {
            if (!certificates[attestationsPayloads[i].schemaId]) revert InvalidCertificateId();
        }
        super._onBulkReplace(attestationIds, attestationsPayloads, validationPayloads);
    }
}
