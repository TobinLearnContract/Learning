//
pragma solidity ^0.8.3;

contract A {

    address admin;
    address payable user;
    uint256 money;

    constructor(address _addr) {
        admin = _addr;
    }

    function deposit() public payable{
        
        user = payable(msg.sender);
        money = msg.value;
    }

    function getContractBalance() view public returns(uint256){
        
        return address(this).balance;

    }

    function withdraw(uint256 _money) public payable{
        
        require(msg.sender == user);
        user.transfer(_money);
        
    }
}