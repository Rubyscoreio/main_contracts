# Solidity API

## RubyscoreSignCheckModule

This module can be used by portal to
        require a signature from an authorized signer
        before issuing attestations.

### NAME

```solidity
string NAME
```

### VERSION

```solidity
string VERSION
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch()
```

Error thrown when an array length mismatch occurs

### SignerNotAuthorized

```solidity
error SignerNotAuthorized()
```

Error thrown when a signer is not authorized by the module

### SignerAuthorized

```solidity
event SignerAuthorized(address signer)
```

Event emitted when the authorized signers are set

### constructor

```solidity
constructor(address initialOwner, address _signer) public
```

Contract constructor sets the portal registry

### getSigner

```solidity
function getSigner() external view returns (address)
```

### setAuthorizedSigners

```solidity
function setAuthorizedSigners(address _signer) public
```

Set the accepted status of schemaIds

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | The signers to be set |

### run

```solidity
function run(struct AttestationPayload _attestationPayload, bytes _validationPayload, address _txSender, uint256) public view
```

The main method for the module, running the check

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _attestationPayload | struct AttestationPayload | The Payload of the attestation |
| _validationPayload | bytes | The validation payload required for the module |
| _txSender | address |  |
|  | uint256 |  |

