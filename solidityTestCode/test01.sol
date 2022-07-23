pragma solidity ^0.8.7;

contract C {
    //bytes32 b1 = 0x6c6979;
    
    
    // function C(){
        
    // }

    // function get(bytes32 x) constant public returns(bytes32){
    //     return x;
    // }

    //uint a1 = 123;
    // function setNget() pure public returns(uint[], uint[]){
    //     uint[] memory a = new uint[](2);//= 123;
    //     uint[] memory nums = [300,301];
    //     //a = nums;
        
    //     return (a,nums);
    // }

    uint a = 100;
    function getA() public returns(uint){
        a = a + 1;
        return a;
    }
}

contract D {
    C c1 = new C();
    function getCofa() public returns(uint){
        return c1.getA();
    }
    function getAddress() public view returns(address){
        return address(c1);
    }
}
