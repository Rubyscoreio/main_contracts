# Solidity API

## AbstractModule

Defines the minimal Module interface

### OnlyPortalOwner

```solidity
error OnlyPortalOwner()
```

Error thrown when someone else than the portal's owner is trying to revoke

### run

```solidity
function run(struct AttestationPayload attestationPayload, bytes validationPayload, address txSender, uint256 value) public virtual
```

Executes the module's custom logic.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationPayload | struct AttestationPayload | The incoming attestation data. |
| validationPayload | bytes | Additional data required for verification. |
| txSender | address | The transaction sender's address. |
| value | uint256 | The transaction value. |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceID) public view virtual returns (bool)
```

Checks if the contract implements the Module interface.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| interfaceID | bytes4 | The ID of the interface to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | A boolean indicating interface support. |

