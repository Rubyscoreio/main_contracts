# Solidity API

## ISchemaRegistry

### Schema

```solidity
struct Schema {
  string name;
  string description;
  string context;
  string schemaString;
}
```

### router

```solidity
function router() external view returns (address)
```

### schemaIds

```solidity
function schemaIds(uint256 index) external view returns (bytes32)
```

### schemasIssuers

```solidity
function schemasIssuers(bytes32 id) external view returns (address)
```

### getIdFromSchemaString

```solidity
function getIdFromSchemaString(string schema) external pure returns (bytes32)
```

### createSchema

```solidity
function createSchema(string name, string description, string context, string schemaString) external
```

### updateContext

```solidity
function updateContext(bytes32 schemaId, string context) external
```

### getSchema

```solidity
function getSchema(bytes32 schemaId) external view returns (struct ISchemaRegistry.Schema)
```

### getSchemasNumber

```solidity
function getSchemasNumber() external view returns (uint256)
```

### isRegistered

```solidity
function isRegistered(bytes32 schemaId) external view returns (bool)
```

