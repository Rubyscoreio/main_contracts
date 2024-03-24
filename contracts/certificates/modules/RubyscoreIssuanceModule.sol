// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AbstractModule} from "../abstracts/AbstractModule.sol";
import {AttestationPayload} from "../interfaces/Structs.sol";
import {IPortalRegistry} from "../interfaces/IPortalRegistry.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IRubyscore_Certificates} from "../interfaces/IRubyscore_Certificates.sol";

/**
 * @title Rubyscore Issuance Module
 * @notice This module can be used for issues NFT certificates .
 */
contract RubyscoreIssuanceModule is AbstractModule, Ownable {
    address public portal;
    IRubyscore_Certificates public certificateNFT;

    mapping(bytes32 schemaId => uint256 certificateId) public certificates;

    /// @notice Error thrown when an array length mismatch occurs
    error ArrayLengthMismatch();
    error InvalidCertificateId();
    error ZeroAddressCheck();

    modifier onlyPortal() {
        require(msg.sender == portal, "Not portal");
        _;
    }

    /**
     * @notice Contract constructor sets the portal registry
     */
    constructor(address initialOwner, address _portal, IRubyscore_Certificates _certificateNFT) Ownable(initialOwner) {
        if (_portal == address(0)) revert ZeroAddressCheck();
        if (address(_certificateNFT) == address(0)) revert ZeroAddressCheck();
        portal = _portal;
        certificateNFT = _certificateNFT;
    }

    function setUpCertificates(bytes32[] memory schemaIds, uint256[] memory certificateIds) external onlyOwner {
        if (schemaIds.length != certificateIds.length) revert ArrayLengthMismatch();
        for (uint256 i = 0; i < schemaIds.length; i++) {
            certificates[schemaIds[i]] = certificateIds[i];
        }
    }

    function setPortal(address _portal) external onlyOwner {
        portal = _portal;
    }

    /**
     * @notice The main method for the module, running the check
     * @param _txSender Sender of transaction
     */
    function run(
        AttestationPayload memory _attestationPayload,
        bytes memory /*_validationPayload*/,
        address _txSender,
        uint256 /*_value*/
    ) public override {
        require(msg.sender == portal, "Only Ruby portal");
        uint256 certificateId = certificates[_attestationPayload.schemaId];
        if (certificateId == 0) revert InvalidCertificateId();
        certificateNFT.safeMint(_txSender, certificateId);
    }
}
