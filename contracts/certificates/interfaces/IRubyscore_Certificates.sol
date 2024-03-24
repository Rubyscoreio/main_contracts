// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/**
 * @title IRubyscore_Certificates
 * @dev IRubyscore_Certificates is an interface for Rubyscore_Certificates contract
 */
interface IRubyscore_Certificates is IERC1155 {
    /**
     * @notice Emitted when the base URI for token metadata is updated.
     * @param newBaseURI The new base URI that will be used to construct token metadata URIs.
     * @dev This event is triggered when the contract operator updates the base URI
     * for retrieving metadata associated with tokens. The 'newBaseURI' parameter represents
     * the updated base URI.
     */
    event BaseURISet(string indexed newBaseURI);

    /**
     * @notice Emitted when NFTs are minted for a user.
     * @param userAddress The address of the user receiving the NFTs.
     * @param nftId NFT IDs that were minted.
     * @dev This event is emitted when new NFTs are created and assigned to a user.
     * @dev It includes the user's address, and the ID of the minted NFT for transparency.
     */
    event Minted(address indexed userAddress, uint256 nftId);

    /**
     * @notice Emitted when NFTs are minted for a user.
     * @param userAddress The address of the user receiving the NFTs.
     * @param nftIds NFT IDs that were minted.
     * @dev This event is emitted when new NFTs are created and assigned to a user.
     * @dev It includes the user's address and the IDs of the minted NFTs for transparency.
     */
    event BatchMinted(address indexed userAddress, uint256[] nftIds);

    /**
     * @notice Emitted when the URI for a specific token is updated.
     * @param tokenId The ID of the token for which the URI is updated.
     * @param newTokenURI The new URI assigned to the token.
     * @dev This event is emitted when the URI for a token is modified, providing transparency
     * when metadata URIs are changed for specific tokens.
     */
    event TokenURISet(uint256 indexed tokenId, string indexed newTokenURI);

    /**
     * @notice Get token name.
     * @return Token name.
     */
    function name() external view returns (string memory);

    /**
     * @notice Get token symbol.
     * @return Token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @notice Get the URI of a token.
     * @param tokenId The ID of the token.
     * @return The URI of the token.
     */
    function uri(uint256 tokenId) external view returns (string memory);

    /**
     * @notice Get the token URI for a given tokenId.
     * @param tokenId The ID of the token.
     * @return The URI of the token.
     * @dev Diblicate for uri() method
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);

    /**
     * @notice Set the URI for a token.
     * @param tokenId The ID of the token.
     * @param newTokenURI The new URI to set for the token.
     * @dev Requires the MINTER_ROLE.
     */
    function setTokenURI(uint256 tokenId, string memory newTokenURI) external;

    /**
     * @notice Set the URIs for multiple tokens in a batch.
     * @param tokenIds An array of token IDs to set URIs for.
     * @param newTokenURIs An array of new URIs to set for the tokens.
     * @dev Requires the MINTER_ROLE.
     * @dev Requires that the tokenIds and newTokenURIs arrays have the same length.
     */
    function setBatchTokenURI(uint256[] calldata tokenIds, string[] calldata newTokenURIs) external;

    /**
     * @notice Set the base URI for all tokens.
     * @param newBaseURI The new base URI to set.
     * @dev Requires the OPERATOR_ROLE.
     */
    function setBaseURI(string memory newBaseURI) external;

    /**
     * @notice Safely mints NFT for a user.
     * @param to The NFT recipient.
     * @param id The NFT id.
     */
    function safeMint(address to, uint256 id) external payable;

    /**
     * @notice Check if a given interface is supported by this contract.
     * @param interfaceId The interface identifier to check for support.
     * @return Whether the contract supports the specified interface.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
