pragma solidity ^0.8.3;

contract A {

    uint256 num;

    constructor() {
        num = 10;
    }

    function sum() public returns(uint256){
        
        for (uint256 i = 1; i <= 100; i++) {
            num += i;
        }
        return num;
    }

    function isEqual(string memory a, string memory b) pure public returns(bool){

        //return bytes(a) == bytes(b);

        bytes32 aHash = keccak256(abi.encode(a));
        bytes32 bHash = keccak256(abi.encode(b));
        return aHash == bHash;

    }

    function re1(string memory a) pure public returns(bytes memory){
        return bytes(a);
    }

    function re2(string memory a) pure external returns(bool){
        string memory b;
        b = a;
        return true;
    }

}

struct Car{
    string name;
    address owner;
    uint8 age;
}

contract B {

    uint256 num;
    Car car1;

    constructor() {
        num = 10;
        car1 = Car({owner: msg.sender, age: 10, name: "toyota"});
    }

    function sum() view public returns(uint256){
        
        return num;
    }

    function getCar1() view public returns(Car memory){

        return car1;
    }

}
