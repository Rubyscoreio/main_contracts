# Solidity API

## RubyscoreFeeModule

This module can be used by portal creators to enforce a fee on attestations.

### attestationFees

```solidity
mapping(bytes32 => uint256) attestationFees
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch()
```

Error thrown when an array length mismatch occurs

### InvalidAttestationFee

```solidity
error InvalidAttestationFee()
```

Error thrown when an invalid attestation fee is provided

### ZeroAddressCheck

```solidity
error ZeroAddressCheck()
```

### FeesSet

```solidity
event FeesSet(bytes32[] schemaIds, uint256[] attestationFees)
```

### constructor

```solidity
constructor(address initialOwner) public
```

Contract constructor sets the portal registry

### setFees

```solidity
function setFees(bytes32[] schemaIds, uint256[] _attestationFees) public
```

Set the fee required to attest

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| schemaIds | bytes32[] | The schemaIds to set the fee for |
| _attestationFees | uint256[] | The fees required to attest |

### run

```solidity
function run(struct AttestationPayload _attestationPayload, bytes, address, uint256 _value) public view
```

The main method for the module, running the check

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _attestationPayload | struct AttestationPayload |  |
|  | bytes |  |
|  | address |  |
| _value | uint256 | The value sent for the attestation |

