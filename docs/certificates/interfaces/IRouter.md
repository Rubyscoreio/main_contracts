# Solidity API

## IRouter

This contract aims to provides a single entrypoint for the Verax registries

### getAttestationRegistry

```solidity
function getAttestationRegistry() external view returns (address)
```

Gives the address for the AttestationRegistry contract

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The current address of the AttestationRegistry contract |

### getModuleRegistry

```solidity
function getModuleRegistry() external view returns (address)
```

Gives the address for the ModuleRegistry contract

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The current address of the ModuleRegistry contract |

### getPortalRegistry

```solidity
function getPortalRegistry() external view returns (address)
```

Gives the address for the PortalRegistry contract

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The current address of the PortalRegistry contract |

### getSchemaRegistry

```solidity
function getSchemaRegistry() external view returns (address)
```

Gives the address for the SchemaRegistry contract

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The current address of the SchemaRegistry contract |

