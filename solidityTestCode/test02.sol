pragma solidity ^0.8.3;

//import "./test01.sol";

contract E {
    // mapping(uint => mapping(uint => uint)) public pair;
    // function test(uint _x, uint _y) public {
    //     require(pair[_x][_y] == 0,'test is failed.');
    //     pair[_x][_y] = 100;
    // }

    uint b;
    address owner;

    constructor(){
        owner = msg.sender;
    }


    function setB(uint _b) public payable {
        b = _b;
    }

    function getB() public payable returns(uint){
        return b;
    }

    function withdraw1(address payable add) public payable{
        add.transfer(1 ether);
    }
}