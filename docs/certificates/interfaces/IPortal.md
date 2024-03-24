# Solidity API

## IPortal

This contract is the interface to be implemented by any Portal.
        NOTE: A portal must implement this interface to registered on
        the PortalRegistry contract.

### getModules

```solidity
function getModules() external view returns (address[])
```

Get all the modules addresses used by the Portal

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | The list of modules addresses linked to the Portal |

### getAttester

```solidity
function getAttester() external view returns (address)
```

Defines the address of the entity issuing attestations to the subject

_We strongly encourage a reflection when implementing this method_

