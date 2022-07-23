pragma solidity^0.8.7;

interface IEvidence{
    function verify(address _signer) external view returns(bool);
    function getSigner(uint256 _index) external view returns(address);
    function getSignersSize() external view returns(uint256);
}

contract Evidence {
    string evidence;
    address[] signers;
    address public factoryAddr;

    event NewSingnaturesEvidence(string _evi, address sender);
    event AddRepeatSingnaturesEvidence(string _evi, address sender);
    event AddSingnaturesEvidence(string _evi, address sender);

    function callVerify(address _signer) public view returns(bool){
        return IEvidence(factoryAddr).verify(_signer);
    }

    constructor(string memory _evi, address _factory){
        factoryAddr = _factory;
        require(callVerify(tx.origin), "signer is invalid.");
        evidence = _evi;
        signers.push(tx.origin);

        emit NewSingnaturesEvidence(_evi, tx.origin);
    }

    function getEvidence() public view returns(string memory, address[] memory, address[] memory){
        uint256 iSize = IEvidence(factoryAddr).getSignersSize();
        address[] memory signerList = new address[](iSize);
        for(uint256 i = 0; i < iSize; i++){
            signerList[i] = IEvidence(factoryAddr).getSigner(i);
        }
        return (evidence, signerList, signers);
    }

    function sign() public returns(bool){
        require(callVerify(tx.origin), "signer is invalid.");
        if(isSigned(tx.origin)){
                emit AddRepeatSingnaturesEvidence(evidence, tx.origin);
                return true;
        }
        emit AddSingnaturesEvidence(evidence, tx.origin);
        return true;
    }

    function isSigned(address _signer) internal view returns(bool){
        for(uint256 i = 0; i < signers.length; i++){
            if(signers[i] == _signer){
                return true;
            }
        }
        return false;
    }

    function isAllSigned() public view returns(bool, string memory){
        for(uint256 i = 0; i < signers.length; i++){
            if(!isSigned(IEvidence(factoryAddr).getSigner(i))){
                return (false, "");
            }
        }
        return (true, evidence);
    }
 
}

contract EvidenceFactory is IEvidence{

    address[] signers;
    mapping(string => address) evi_keys;

    event NewEvidence(string _evi, address _sender, address _eviAddr);

    constructor(address[] memory _signers){
        for(uint256 i = 0; i < _signers.length; i++){
            signers.push(_signers[i]);
        }
    }
    
    function verify(address _signer) override external view returns(bool){
        for(uint256 i = 0; i < signers.length; i++){
            if(_signer == signers[i]){
                return true;
            }
        }
        return false;
    }
    function getSigner(uint256 _index) override external view returns(address){
        if(_index < signers.length){
            return signers[_index];
        } else{
            return address(0);
        }
    }
    function getSignersSize() override external view returns(uint256){
        return signers.length;
    }

    function newEvidence(string memory _evi, string memory _key) public returns(address){
        Evidence evidence = new Evidence(_evi, address(this));
        evi_keys[_key] = address(evidence);

        emit NewEvidence(_evi, msg.sender, address(evidence));

        return address(evidence);
    }

    function getEvidence(string memory _key) public view returns(string memory, address[] memory, address[] memory){
        
        return Evidence(evi_keys[_key]).getEvidence();
    }

    function sign(string memory _key) public returns(bool){
        return Evidence(evi_keys[_key]).sign();
    }

    function isAllSigned(string memory _key) public view returns(bool, string memory){
        return Evidence(evi_keys[_key]).isAllSigned();
    }

}
