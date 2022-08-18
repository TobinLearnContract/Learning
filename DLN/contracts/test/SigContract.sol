// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

contract SigContract {
    address immutable public personAddress;
    address immutable public enterpriseAddress;
    bytes32 immutable public signHash;

    uint256 immutable public CONTRACT_START_TIME;

    constructor(address _psAddress, address _epAddress, bytes32 _signHash){
        personAddress = _psAddress;
        enterpriseAddress = _epAddress;
        CONTRACT_START_TIME = block.timestamp;
        signHash = _signHash;
    }
}

