// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

interface IDlnFactory {
    
    function createContract(address psAddress, address epAddress, bytes32 signHash) external;
    function destructContract(address psAddress) external;
    function getContract(address psAddress) external view returns(address);
    function getAllEnterpriseContracts(address epAddress) external view returns(address[] memory);

    event newContract(address indexed psAddress, address indexed epAddress, address indexed contractAddress);
    event terminateContract(address indexed psAddress, address indexed epAddress, address indexed contractAddress);
    
}