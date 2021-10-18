// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

struct Token {
    
    uint256 id;
    address owner;

}

contract CitizenSwapper {

    // The $CITIZEN NFT contract.
    ERC721 public _token;

    // The two tokens this contract will escrow.
    Token public _tokenOne;
    Token public _tokenTwo;

    constructor(ERC721 token, uint256 tokenIdOne, uint256 tokenIdTwo) {

        _token = token;
        _tokenOne.id = tokenIdOne;
        _tokenTwo.id = tokenIdTwo;

    }

    function deposit(uint256 tokenId) external {

        _token.safeTransferFrom(msg.sender, address(this), tokenId);

        if (tokenId == _tokenOne.id) {
            _tokenOne.owner = msg.sender;
        } else if (tokenId == _tokenTwo.id) {
            _tokenTwo.owner = msg.sender;
        } else {
            revert("Unexpected token ID.");
        }

    }

    function withdraw() external claimable {

        if (msg.sender == _tokenOne.owner) {
            _token.safeTransferFrom(address(this), _tokenTwo.owner, _tokenTwo.id);
        } else if (msg.sender == _tokenTwo.owner) {
            _token.safeTransferFrom(address(this), _tokenOne.owner, _tokenOne.id);
        } else {
            revert("Caller can't claim.");
        }

    }

    modifier claimable() {

        _tokenOne.owner != address(0) && _tokenTwo.owner != address(0);
        _;

    }

}
