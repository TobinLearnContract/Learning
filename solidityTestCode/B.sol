//
pragma solidity ^0.8.3;

contract B{

    address addr = 0x09197b6faf9f5ADE46D476A0061F0119FB681367;

    function aDeposit(uint256 _amount) public payable returns(bool){

        (bool success, ) = addr.call{value:_amount}(abi.encodeWithSignature("deposit()"));
        return success;

    }

    function aTransfer1(address _addr) public returns(bool){

        (bool success, ) = _addr.call(abi.encodeWithSignature("transferTest(uint256)", 1000000000000000000));
        return success;
    }

    /*
    function aTransfer2() public payable returns(bool){

        (bool success, ) = addr.call(abi.encode("transferTest()"));
        return success;

    }
    */

    function getBalance() view public returns(uint256){
        return address(this).balance;
    }

    receive() external payable{}

    fallback() external payable{}

}