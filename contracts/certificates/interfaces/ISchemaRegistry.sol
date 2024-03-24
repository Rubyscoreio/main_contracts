// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface ISchemaRegistry {
    struct Schema {
        string name;
        string description;
        string context;
        string schemaString;
    }

    function router() external view returns (address);

    function schemaIds(uint256 index) external view returns (bytes32);

    function schemasIssuers(bytes32 id) external view returns (address);

    function getIdFromSchemaString(string calldata schema) external pure returns (bytes32);

    function createSchema(
        string calldata name,
        string calldata description,
        string calldata context,
        string calldata schemaString
    ) external;

    function updateContext(bytes32 schemaId, string calldata context) external;

    function getSchema(bytes32 schemaId) external view returns (Schema memory);

    function getSchemasNumber() external view returns (uint256);

    function isRegistered(bytes32 schemaId) external view returns (bool);
}
