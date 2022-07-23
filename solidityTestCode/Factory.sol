pragma solidity^0.8.7;

contract Car {
    string brandName;
    uint256 value;
    string version;

    constructor(string memory _brandName, uint256 _value, string memory _version){
        brandName = _brandName;
        value = _value;
        version = _version;
    }
    function getInfo() public view returns(string memory, uint256, string memory){
        return (brandName, value, version);
    }
}

contract factory {
    address[] cars;

    function produce(string memory _brandName, uint256 _value, string memory _version) public{
        Car car = new Car(_brandName, _value, _version);//新创建合约通过构造函数传入参数
        cars.push(address(car));
    }
    function getAllCars() public view returns(address[] memory){
        return cars;
    }
}