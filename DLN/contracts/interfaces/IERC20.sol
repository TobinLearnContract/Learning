// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

interface IERC20 {
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256);
    function allowance(address tokenOwner, address spender) external view returns (uint256);
    function transfer(address to, uint256 tokens) external returns (bool);
    function approve(address spender, uint256 tokens) external returns (bool);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}
