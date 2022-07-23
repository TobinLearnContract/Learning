pragma solidity ^0.8.3;

contract A {
    address addr;
    
    function setAddress(address _addr) public{
        addr = _addr;
        uint256 a = 100;
        bytes32 b;
        //a = uint256(_addr);//不能转换
        //b = bytes32(_addr);//不能转换
        b = bytes32(a);
    }

    function getEncodeWithSignature() pure public returns(bytes memory a, bytes memory b, bytes memory c){
        //bytes memory a;
        uint256 num = 111;
        a = abi.encodeWithSignature("set(uint256)", num, num);
        b = abi.encodePacked(bytes4(keccak256("set(uint256)")), num, num);
        c = abi.encodeWithSelector(bytes4(keccak256("set(uint256)")), num, num);
    }

}