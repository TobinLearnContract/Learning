//
pragma solidity ^0.8.3;

contract C {

    event suc(bool);

    function transferTest(uint256 _amount) public returns(bool){

        payable(msg.sender).transfer(_amount);
        return true;
    }

    function deposit() public payable{
        //require(msg.value > 1 ether);
    }

    function getBalance(uint256 _n) public payable returns(uint256){
        _n++;
        return address(this).balance;
        
        //emit suc(true);
    }

    function callEOA() public returns(bool){
        address addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        (bool success, ) = addr.call{value:1 ether}("");
        return success;
    }

    fallback() external payable{}
    
}