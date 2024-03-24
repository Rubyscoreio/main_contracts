// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

import {IRubyscore_Certificates} from "./interfaces/IRubyscore_Certificates.sol";
import {ERC1155URIStorage} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC1155, ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/**
 * @title Rubyscore_Certificates
 * @dev An ERC1155 token contract for minting and managing certificates with URI support.
 * @dev Rubyscore_Certificates can be minted by users with the MINTER_ROLE after proper authorization.
 * @dev Rubyscore_Certificates can have their URIs set by operators with the MINTER_ROLE.
 * @dev Rubyscore_Certificates can be safely transferred with restrictions on certain tokens.
 */

contract Rubyscore_Certificates is ERC1155, AccessControl, ERC1155Supply, ERC1155URIStorage, IRubyscore_Certificates {
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    string public name;
    string public symbol;

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, AccessControl, IRubyscore_Certificates) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function totalSupply(uint256 id) public view override(ERC1155Supply) returns (uint256) {
        return super.totalSupply(id);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function uri(
        uint256 tokenId
    ) public view override(ERC1155, ERC1155URIStorage, IRubyscore_Certificates) returns (string memory) {
        return super.uri(tokenId);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return uri(tokenId);
    }

    /**
     * @notice Constructor for the Rubyscore_Achievement contract.
     * @dev Initializes the contract with roles and settings.
     * @param admin The address of the admin role, which has overall control.
     * @param operator The address of the operator role, responsible for unlock tokens and set base URI.
     * @param minter The address of the minter role, authorized to mint achievements and responsible for setting token URIs.
     * @param baseURI The base URI for token metadata.
     * @dev It sets the base URI for token metadata to the provided `baseURI`.
     * @dev It grants the DEFAULT_ADMIN_ROLE, OPERATOR_ROLE, and MINTER_ROLE to the specified addresses.
     * @dev It also initializes the contract with EIP712 support and ERC1155 functionality.
     */
    constructor(
        address admin,
        address operator,
        address minter,
        string memory baseURI,
        string memory _name,
        string memory _symbol
    ) ERC1155("ipfs://") {
        require(admin != address(0), "Zero address check");
        require(operator != address(0), "Zero address check");
        require(minter != address(0), "Zero address check");
        name = _name;
        symbol = _symbol;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(OPERATOR_ROLE, msg.sender);
        _grantRole(OPERATOR_ROLE, operator);
        _grantRole(MINTER_ROLE, minter);
        _setBaseURI(baseURI);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function setTokenURI(uint256 tokenId, string memory newTokenURI) public onlyRole(OPERATOR_ROLE) {
        super._setURI(tokenId, newTokenURI);
        emit TokenURISet(tokenId, newTokenURI);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function setBatchTokenURI(
        uint256[] calldata tokenIds,
        string[] calldata newTokenURIs
    ) external onlyRole(OPERATOR_ROLE) {
        require(tokenIds.length == newTokenURIs.length, "Invalid params");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            setTokenURI(tokenIds[i], newTokenURIs[i]);
        }
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function setBaseURI(string memory newBaseURI) external onlyRole(OPERATOR_ROLE) {
        super._setBaseURI(newBaseURI);
        emit BaseURISet(newBaseURI);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function safeMint(address to, uint256 nftId) external payable onlyRole(MINTER_ROLE) {
        _mint(to, nftId, "");
        emit Minted(to, nftId);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function safeBatchMint(address to, uint256[] memory nftIds) external payable onlyRole(MINTER_ROLE) {
        _mintBatch(to, nftIds, "");
        emit BatchMinted(to, nftIds);
    }

    /**
     * @dev See {IRubyscore_Certificates}
     */
    function _mint(address to, uint256 id, bytes memory data) internal {
        // require(balanceOf(to, id) == 0, "You already have this certificate");
        super._mint(to, id, 1, data);
    }

    /**
     * @notice Internal function to safely mint multiple NFTs in a batch for a specified recipient.
     * @param to The address of the recipient to mint the NFTs for.
     * @param ids An array of NFT IDs to mint.
     * @param data Additional data to include in the minting transaction.
     * @dev This function checks if the recipient already owns any of the specified NFTs to prevent duplicates.
     * @dev It is intended for batch minting operations where multiple NFTs can be minted at once.
     */
    function _mintBatch(address to, uint256[] memory ids, bytes memory data) internal {
        uint256[] memory amounts = new uint256[](ids.length);
        for (uint8 i = 0; i < ids.length; i++) {
            require(balanceOf(to, ids[i]) == 0, "You already have this certificate");
            amounts[i] = 1;
        }
        super._mintBatch(to, ids, amounts, data);
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        for (uint256 i = 0; i < ids.length; i++) {
            if (from != address(0)) revert("This token only for you");
        }
        super._update(from, to, ids, values);
    }
}
