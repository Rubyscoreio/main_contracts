# Solidity API

## AttestationPayload

```solidity
struct AttestationPayload {
  bytes32 schemaId;
  uint64 expirationDate;
  bytes subject;
  bytes attestationData;
}
```

## Attestation

```solidity
struct Attestation {
  bytes32 attestationId;
  bytes32 schemaId;
  bytes32 replacedBy;
  address attester;
  address portal;
  uint64 attestedDate;
  uint64 expirationDate;
  uint64 revocationDate;
  uint16 version;
  bool revoked;
  bytes subject;
  bytes attestationData;
}
```

## Schema

```solidity
struct Schema {
  string name;
  string description;
  string context;
  string schema;
}
```

## Portal

```solidity
struct Portal {
  address id;
  address ownerAddress;
  address[] modules;
  bool isRevocable;
  string name;
  string description;
  string ownerName;
}
```

## Module

```solidity
struct Module {
  address moduleAddress;
  string name;
  string description;
}
```

