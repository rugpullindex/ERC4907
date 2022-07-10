// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

import {IERC4907} from "./IERC4907.sol";

/// @author Tim Daubenschütz and the authors of EIP-4907
///  (https://github.com/rugpullindex/ERC4907/blob/main/src/ERC4907.sol)
contract ERC4907 is ERC721, IERC4907 {
  struct UserInfo {
    address user;
    uint64 expires;
  }

  mapping (uint256 => UserInfo) internal _users;

  constructor(
    string memory name_,
    string memory symbol_
  ) ERC721(name_,symbol_) {}

  function setUser(
    uint256 tokenId,
    address user,
    uint64 expires
  ) public virtual {
    require(
      _isApprovedOrOwner(msg.sender, tokenId),
      "setUser: setUser caller is not owner nor approved"
    );
    UserInfo storage info =  _users[tokenId];
    info.user = user;
    info.expires = expires;
    emit UpdateUser(tokenId,user,expires);
  }

  function userOf(uint256 tokenId) public view virtual returns (address) {
    if(uint256(_users[tokenId].expires) >=  block.timestamp){
      return _users[tokenId].user;
    } else{
      return address(0);
    }
  }

  function userExpires(uint256 tokenId) public view virtual returns (uint256) {
    return _users[tokenId].expires;
  }

  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721, IERC4907) returns (bool) {
    return interfaceId == type(IERC4907).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override {
    super._beforeTokenTransfer(from, to, tokenId);

    if (from != to && _users[tokenId].user != address(0)) {
      delete _users[tokenId];
      emit UpdateUser(tokenId, address(0), 0);
    }
  }
}
