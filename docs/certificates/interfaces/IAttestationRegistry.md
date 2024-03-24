# Solidity API

## IAttestationRegistry

### AttestationRegistered

```solidity
event AttestationRegistered(bytes32 attestationId)
```

Event emitted when an attestation is registered

### router

```solidity
function router() external view returns (contract IRouter)
```

### attestations

```solidity
function attestations(bytes32 attestationId) external view returns (struct Attestation)
```

### initialize

```solidity
function initialize() external
```

### updateRouter

```solidity
function updateRouter(address _router) external
```

### updateChainPrefix

```solidity
function updateChainPrefix(uint256 _chainPrefix) external
```

### onlyPortals

```solidity
function onlyPortals(address portal) external view
```

### attest

```solidity
function attest(struct AttestationPayload attestationPayload, address attester) external
```

### bulkAttest

```solidity
function bulkAttest(struct AttestationPayload[] attestationsPayloads, address attester) external
```

### massImport

```solidity
function massImport(struct AttestationPayload[] attestationsPayloads, address portal) external
```

### replace

```solidity
function replace(bytes32 attestationId, struct AttestationPayload attestationPayload, address attester) external
```

### bulkReplace

```solidity
function bulkReplace(bytes32[] attestationIds, struct AttestationPayload[] attestationPayloads, address attester) external
```

### revoke

```solidity
function revoke(bytes32 attestationId) external
```

### bulkRevoke

```solidity
function bulkRevoke(bytes32[] attestationIds) external
```

### isRegistered

```solidity
function isRegistered(bytes32 attestationId) external view returns (bool)
```

### isRevocable

```solidity
function isRevocable(address portalId) external view returns (bool)
```

### getAttestation

```solidity
function getAttestation(bytes32 attestationId) external view returns (struct Attestation)
```

### incrementVersionNumber

```solidity
function incrementVersionNumber() external returns (uint16)
```

### getVersionNumber

```solidity
function getVersionNumber() external view returns (uint16)
```

### getAttestationIdCounter

```solidity
function getAttestationIdCounter() external view returns (uint32)
```

### getChainPrefix

```solidity
function getChainPrefix() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address account, uint256 id) external view returns (uint256)
```

### balanceOfBatch

```solidity
function balanceOfBatch(address[] accounts, uint256[] ids) external view returns (uint256[])
```

