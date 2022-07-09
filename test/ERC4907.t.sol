// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {ERC4907} from "../src/ERC4907.sol";

contract CustomToken is ERC4907 {
  constructor(
    string memory name,
    string memory symbol
  ) ERC4907(name, symbol) {}

  function mint(address to, uint256 tokenId) external {
    _mint(to, tokenId);
  }
}

contract ERC4907Test is Test {
  ERC4907 collection;
  CustomToken ct;

  function setUp() public {
    string memory name = "name";
    string memory symbol = "symbol";
    collection = new ERC4907(name, symbol);
    ct = new CustomToken(name, symbol);
  }

  function testMintingAnERC4907Token() public {
    uint256 tokenId = 0;
    ct.mint(address(this), tokenId);
    assertEq(ct.balanceOf(address(this)), 1);
    assertEq(ct.ownerOf(tokenId), address(this));
  }
}
