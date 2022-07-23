//
pragma solidity ^0.8.3;

contract A {

    function sendTest() public returns(bool){
        address payable _user = payable(msg.sender);
        bool sent1 = _user.send(10 ether);
        bool sent2 = _user.send(1 ether);
        payable(msg.sender).transfer(10 ether);
        return sent1||sent2;
    }

    function transferTest(uint256 _amount) public{

        payable(msg.sender).transfer(_amount);
    }

    function deposit() public payable{
        //require(msg.value > 1 ether);
    }

    function getBalance() view public returns(uint256){
        return address(this).balance;
    }

    function callEOA() public returns(bool){
        address addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        (bool success, ) = addr.call{value:1 ether}("");
        return success;
    }

    fallback() external payable{}
    
}

contract B {

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