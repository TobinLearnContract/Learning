// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import '../interfaces/IDlnFactory.sol';
import './SigContract.sol';

contract DlnFactory is IDlnFactory {

    mapping(address => address) _personContracts;//第一个是个人钱包地址，第二个是合同合约地址
    mapping(address => address[]) _enterpriseContracts;//第一个是企业钱包地址，第二个是企业现有合同地址

    address public owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the DLN");
        _;
    }
    //传入NFT的合约地址，用于设置合约调用权限
    constructor(address NFTAddress){
        owner = NFTAddress;
    }

    function createContract(address psAddress, address epAddress, bytes32 signHash) external override onlyOwner {
        SigContract sigContract = new SigContract(psAddress, epAddress, signHash);
        address contractAddr = address(sigContract);
        _personContracts[psAddress] = contractAddr;
        _enterpriseContracts[epAddress].push(contractAddr);

        emit newContract(psAddress, epAddress, contractAddr);
    }

    function destructContract(address psAddress) external override onlyOwner {
        address contractAddr = _personContracts[psAddress];
        _personContracts[psAddress] = address(0);
        address epAddress = SigContract(contractAddr).enterpriseAddress();
        
        uint256 len = _enterpriseContracts[epAddress].length;
        for(uint i = 0; i < len;i++){
            if (_enterpriseContracts[epAddress][i] == contractAddr) {
                _enterpriseContracts[epAddress][i] = _enterpriseContracts[epAddress][len - 1];
            }
        }
        _enterpriseContracts[epAddress].pop();

        emit terminateContract(psAddress, epAddress, contractAddr);
    }

    function getContract(address psAddress) external view override returns(address){
        return _personContracts[psAddress];
    }

    function getAllEnterpriseContracts(address epAddress) external view override returns(address[] memory){
        return _enterpriseContracts[epAddress];
    }

}

