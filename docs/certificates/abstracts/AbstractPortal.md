# Solidity API

## AbstractPortal

This contract is an abstract contract with basic Portal logic
        to be inherited. We strongly encourage all Portals to implement
        this contract.

### router

```solidity
contract IRouter router
```

### modules

```solidity
address[] modules
```

### moduleRegistry

```solidity
contract IModuleRegistry moduleRegistry
```

### attestationRegistry

```solidity
contract IAttestationRegistry attestationRegistry
```

### portalRegistry

```solidity
contract IPortalRegistry portalRegistry
```

### OnlyPortalOwner

```solidity
error OnlyPortalOwner()
```

Error thrown when someone else than the portal's owner is trying to revoke

### constructor

```solidity
constructor(address[] _modules, address _router) internal
```

Contract constructor

_This sets the addresses for the IAttestationRegistry, IModuleRegistry and IPortalRegistry_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _modules | address[] | list of modules to use for the portal (can be empty) |
| _router | address | Router's address |

### withdraw

```solidity
function withdraw(address payable to, uint256 amount) external virtual
```

Optional method to withdraw funds from the Portal

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address payable | the address to send the funds to |
| amount | uint256 | the amount to withdraw |

### attest

```solidity
function attest(struct AttestationPayload attestationPayload, bytes[] validationPayloads) public payable
```

Attest the schema with given attestationPayload and validationPayload

_Runs all modules for the portal and registers the attestation using IAttestationRegistry_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationPayload | struct AttestationPayload | the payload to attest |
| validationPayloads | bytes[] | the payloads to validate via the modules to issue the attestations |

### bulkAttest

```solidity
function bulkAttest(struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) public
```

Bulk attest the schema with payloads to attest and validation payloads

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationsPayloads | struct AttestationPayload[] | the payloads to attest |
| validationPayloads | bytes[][] | the payloads to validate via the modules to issue the attestations |

### replace

```solidity
function replace(bytes32 attestationId, struct AttestationPayload attestationPayload, bytes[] validationPayloads) public payable
```

Replaces the attestation for the given identifier and replaces it with a new attestation

_Runs all modules for the portal and registers the attestation using IAttestationRegistry_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationId | bytes32 | the ID of the attestation to replace |
| attestationPayload | struct AttestationPayload | the attestation payload to create the new attestation and register it |
| validationPayloads | bytes[] | the payloads to validate via the modules to issue the attestation |

### bulkReplace

```solidity
function bulkReplace(bytes32[] attestationIds, struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) public
```

Bulk replaces the attestation for the given identifiers and replaces them with new attestations

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationIds | bytes32[] | the list of IDs of the attestations to replace |
| attestationsPayloads | struct AttestationPayload[] | the list of attestation payloads to create the new attestations and register them |
| validationPayloads | bytes[][] | the payloads to validate via the modules to issue the attestations |

### revoke

```solidity
function revoke(bytes32 attestationId) public
```

Revokes an attestation for the given identifier

_By default, revocation is only possible by the portal owner
We strongly encourage implementing such a rule in your Portal if you intend on overriding this method_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationId | bytes32 | the ID of the attestation to revoke |

### bulkRevoke

```solidity
function bulkRevoke(bytes32[] attestationIds) public
```

Bulk revokes a list of attestations for the given identifiers

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationIds | bytes32[] | the IDs of the attestations to revoke |

### getModules

```solidity
function getModules() external view returns (address[])
```

Get all the modules addresses used by the Portal

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | The list of modules addresses linked to the Portal |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceID) public pure virtual returns (bool)
```

Verifies that a specific interface is implemented by the Portal, following ERC-165 specification

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| interfaceID | bytes4 | the interface identifier checked in this call |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | The list of modules addresses linked to the Portal |

### getAttester

```solidity
function getAttester() public view virtual returns (address)
```

Defines the address of the entity issuing attestations to the subject

_We strongly encourage a reflection when overriding this rule: who should be set as the attester?_

### _onAttest

```solidity
function _onAttest(struct AttestationPayload attestationPayload, address attester, uint256 value) internal virtual
```

Optional method run before a payload is attested

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationPayload | struct AttestationPayload | the attestation payload supposed to be attested |
| attester | address | the address of the attester |
| value | uint256 | the value sent with the attestation |

### _onReplace

```solidity
function _onReplace(bytes32 attestationId, struct AttestationPayload attestationPayload, address attester, uint256 value) internal virtual
```

Optional method run when an attestation is replaced

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationId | bytes32 | the ID of the attestation being replaced |
| attestationPayload | struct AttestationPayload | the attestation payload to create attestation and register it |
| attester | address | the address of the attester |
| value | uint256 | the value sent with the attestation |

### _onBulkAttest

```solidity
function _onBulkAttest(struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) internal virtual
```

Optional method run when attesting a batch of payloads

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationsPayloads | struct AttestationPayload[] | the payloads to attest |
| validationPayloads | bytes[][] | the payloads to validate in order to issue the attestations |

### _onBulkReplace

```solidity
function _onBulkReplace(bytes32[] attestationIds, struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) internal virtual
```

### _onRevoke

```solidity
function _onRevoke(bytes32) internal virtual
```

Optional method run when an attestation is revoked or replaced

_IMPORTANT NOTE: By default, revocation is only possible by the portal owner_

### _onBulkRevoke

```solidity
function _onBulkRevoke(bytes32[]) internal virtual
```

Optional method run when a batch of attestations are revoked or replaced

_IMPORTANT NOTE: By default, revocation is only possible by the portal owner_

