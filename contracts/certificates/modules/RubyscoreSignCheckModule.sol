// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AbstractModule} from "../abstracts/AbstractModule.sol";
import {AttestationPayload} from "../interfaces/Structs.sol";
import {IPortalRegistry} from "../interfaces/IPortalRegistry.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Rubyscore Signature Check Module
 * @notice This module can be used by portal to
 *         require a signature from an authorized signer
 *         before issuing attestations.
 */
contract RubyscoreSignCheckModule is AbstractModule, EIP712, Ownable {
    using ECDSA for bytes32;

    string public constant NAME = "Rubyscore_SignCheckModule";
    string public constant VERSION = "0.0.1";

    address private signer;

    /// @notice Error thrown when an array length mismatch occurs
    error ArrayLengthMismatch();
    /// @notice Error thrown when a signer is not authorized by the module
    error SignerNotAuthorized();

    /// @notice Event emitted when the authorized signers are set
    event SignerAuthorized(address signer);

    /**
     * @notice Contract constructor sets the portal registry
     */
    constructor(address initialOwner, address _signer) EIP712(NAME, VERSION) Ownable(initialOwner) {
        require(_signer != address(0), "Zero address check");
        signer = _signer;
    }

    function getSigner() external view returns (address) {
        return signer;
    }

    /**
     * @notice Set the accepted status of schemaIds
     * @param _signer The signers to be set
     */
    function setAuthorizedSigners(address _signer) public onlyOwner {
        signer = _signer;
        emit SignerAuthorized(signer);
    }

    /**
     * @notice The main method for the module, running the check
     * @param _attestationPayload The Payload of the attestation
     * @param _validationPayload The validation payload required for the module
     */
    function run(
        AttestationPayload memory _attestationPayload,
        bytes memory _validationPayload,
        address _txSender,
        uint256 /*_value*/
    ) public view override {
        bytes32 digest = _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256(
                        "AttestationPayload(bytes32 schemaId,uint64 expirationDate,bytes subject,bytes attestationData)"
                    ),
                    _attestationPayload.schemaId,
                    _attestationPayload.expirationDate,
                    keccak256(abi.encode(_txSender)),
                    keccak256(_attestationPayload.attestationData)
                )
            )
        );
        if (signer != ECDSA.recover(digest, _validationPayload)) revert SignerNotAuthorized();
    }
}
