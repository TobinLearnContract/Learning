pragma solidity ^0.8.7;

import "./IERC721.sol";
import "./IERC165.sol";

interface ERC721TokenReceiver{
    // return 'bytes(keccak256("onERC721Received(address,address,uint256,bytes)"))'

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
}

contract ERC721 is IERC165, IERC721{
    //ERC165
    mapping(bytes4 => bool) supportsInterfaces;
    bytes4 constant invalidID = 0xffffffff;

    bytes4 constant ERC165_InterfaceID = 0x01ffc9a7;
    bytes4 constant ERC721_InterfaceID = 0x80ac58cd;
    //ERC721
    mapping(address => uint256) ercTokenCount;
    mapping(uint256 => address) ercTokenOwner;
    mapping(uint256 => address) ercTokenApproved;
    mapping(address => mapping(address => bool)) ercOperatorForAll;

    constructor(){
        _registerInterface(ERC165_InterfaceID);
        _registerInterface(ERC721_InterfaceID);
    }

    //授权
    modifier canOperator(uint256 _tokenId){
        address owner = ercTokenOwner[_tokenId];
        require(msg.sender == owner || ercOperatorForAll[owner][msg.sender]);
        _;
    }
    modifier canTransfer(uint256 _tokenId, address _from){
        address owner = ercTokenOwner[_tokenId];
        require(owner == _from);
        require(msg.sender == owner || ercOperatorForAll[owner][msg.sender] || ercTokenApproved[_tokenId] == msg.sender);
        _;
    }

    function _registerInterface(bytes4 interfaceID) internal {
        supportsInterfaces[interfaceID] = true;
    }
    function supportsInterface(bytes4 interfaceID) override external returns(bool){
        require(invalidID != interfaceID, "invalid interfaceID");
        return supportsInterfaces[interfaceID];
    }

    //IERC721
    function balanceOf(address _owner) override external view returns (uint256){
        return ercTokenCount[_owner];
    }
    function ownerOf(uint256 _tokenId) override external view returns (address){
        return ercTokenOwner[_tokenId];
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) override external payable{
        _safeTransferFrom(_from, _to, _tokenId, data);
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external payable{
        _safeTransferFrom(_from, _to, _tokenId, "");
    }
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) internal{
        _transferFrom(_from, _to, _tokenId);

        if(Address.isContract(_to)){
            bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data);
            require(retval == ERC721TokenReceiver.onERC721Received.selector, "retval != interfaceID");
        }
    }
    function transferFrom(address _from, address _to, uint256 _tokenId) override external payable{
        _transferFrom(_from, _to, _tokenId);
    }
    function _transferFrom(address _from, address _to, uint256 _tokenId)  canTransfer(_tokenId, _from) internal{
        ercTokenOwner[_tokenId] = _to;
        ercTokenCount[_from] -= 1;
        ercTokenCount[_to] += 1;
        ercTokenApproved[_tokenId] = address(0);
    }
    function approve(address _approved, uint256 _tokenId) override canOperator(_tokenId) external payable{
        ercTokenApproved[_tokenId] = _approved;
    }
    function setApprovalForAll(address _operator, bool _approved) override external{
        ercOperatorForAll[msg.sender][_operator] = _approved;
    }
    function getApproved(uint256 _tokenId) override external view returns (address){
        return ercTokenApproved[_tokenId];
    }
    function isApprovedForAll(address _owner, address _operator) override external view returns (bool){
        return ercOperatorForAll[_owner][_operator];
    }

}

//openzepplin
library Address{
    function isContract(address account) internal view returns(bool){
        uint256 size;
        assembly{
            size := extcodesize(account)//计算地址上代码长度
        }
        return size > 0;
    }
}