# Solidity API

## IPortalRegistry

### router

```solidity
function router() external view returns (contract IRouter)
```

### portals

```solidity
function portals(address id) external view returns (struct Portal)
```

### issuers

```solidity
function issuers(address issuerAddress) external view returns (bool)
```

### portalAddresses

```solidity
function portalAddresses(uint256 index) external view returns (address)
```

### initialize

```solidity
function initialize() external
```

### updateRouter

```solidity
function updateRouter(address _router) external
```

### setIssuer

```solidity
function setIssuer(address issuer) external
```

### removeIssuer

```solidity
function removeIssuer(address issuer) external
```

### isIssuer

```solidity
function isIssuer(address issuer) external view returns (bool)
```

### register

```solidity
function register(address id, string name, string description, bool isRevocable, string ownerName) external
```

### revoke

```solidity
function revoke(address id) external
```

### deployDefaultPortal

```solidity
function deployDefaultPortal(address[] modules, string name, string description, bool isRevocable, string ownerName) external
```

### getPortalByAddress

```solidity
function getPortalByAddress(address id) external view returns (struct Portal)
```

### isRegistered

```solidity
function isRegistered(address id) external view returns (bool)
```

### getPortalsCount

```solidity
function getPortalsCount() external view returns (uint256)
```

