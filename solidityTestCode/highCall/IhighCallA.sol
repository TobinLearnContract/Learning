//
pragma solidity ^0.8.3;

interface A {

    function transferTest(uint256 _amount) external;

    function deposit() external payable;

    function getBalance() view external returns(uint256);

    function callEOA() external returns(bool);
    
}