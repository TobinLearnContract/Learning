pragma solidity ^0.8.3;

contract A {
    address owner;
    uint256 totalsupply;

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 _num) public payable {
        totalsupply += _num;
    }

    function getDeposit() public view returns(uint256, uint256){
        return (address(this).balance, totalsupply);
    }
    fallback() external payable{}
    receive() external payable{}
}

contract B is A{

    function a() pure public returns(bytes memory){
        return abi.encode("function");
    }

    function b() pure public returns(bytes memory){
        return abi.encode("function b");
    }

}