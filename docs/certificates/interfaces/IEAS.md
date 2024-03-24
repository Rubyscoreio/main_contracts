# Solidity API

## Attestation

```solidity
struct Attestation {
  bytes32 uid;
  bytes32 schema;
  uint64 time;
  uint64 expirationTime;
  uint64 revocationTime;
  bytes32 refUID;
  address recipient;
  address attester;
  bool revocable;
  bytes data;
}
```

## IEAS

EAS - Ethereum Attestation Service interface.

### getAttestation

```solidity
function getAttestation(bytes32 uid) external view returns (struct Attestation)
```

Returns an existing attestation by UID.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| uid | bytes32 | The UID of the attestation to retrieve. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct Attestation | The attestation data members. |

