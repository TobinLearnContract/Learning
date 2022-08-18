// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import '../interfaces/IDlnFactory.sol';

interface IERC721 {

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

interface IERC721Metadata {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 _tokenId) external view returns (address);
}

interface IAccessControl {
    function hasRole(bytes32 role, address account) external view returns (bool);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function grantRole(bytes32 role, address account) external;
    function revokeRole(bytes32 role, address account) external;
    function renounceRole(bytes32 role, address account) external;
}

abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface ILabourer {
    // 个人注册(上链)
    function register(bytes32 _hash, address _labourer) external;
    // 追加个人信息
    function adppend(bytes32 _hash, address _labourer) external;
    // 对个人信息进行校验
    function verify(address _labourer) external view returns (bytes32[] memory);
    function verifyLast(address _labourer) external view returns (bytes32);
    // 签约
    //function sign(address _labourer, address _enterprise, bytes32 _signHash) external;
    // 修改地址
    function transferUserOwner(address _org, address _new) external;
    //事件
    event Register(address indexed _labourer, bytes32 _hash, address indexed _sender);
    event Modify(address indexed _labourer, bytes32 _hash, address indexed _sender);
    event Sign(address indexed _labourer, address indexed enterprise, bytes32 signHash);
    event TransferUserOwner(address indexed _org, address indexed _new, address indexed _sender);
}

interface IEnterPrise {
    // 企业注册(上链)
    function epRegister(bytes32 _hash, string calldata _name, string calldata _code, address _enterprise) external;
    // 修改企业信息
    function epModify(bytes32 _hash, address _enterprise) external;
    // 企业信息进行校验
    function epVerify(address _enterprise) external view returns (bytes32);
    //事件
    event EpRegister(address indexed _enterprise, bytes32  _hash, address indexed _sender, string _name, string _code);
    event EpModify(address indexed _enterprise, bytes32  _hash, address indexed _sender);
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

library Strings {
    bytes16 private constant alphabet = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = alphabet[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {

    using Address for address;

    mapping(address => uint256) _balances;
    mapping(uint256 => address) _owners;
    mapping(uint256 => address) _tokenApprovals;
    mapping(address => mapping(address => bool)) _approvedForAll;

    string _name;
    string _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC721).interfaceId
            || interfaceId == type(IERC721Metadata).interfaceId
            || super.supportsInterface(interfaceId);
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    
    function tokenURI(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        return address(uint160(tokenId));
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function approve(address to, uint256 tokenId) public override payable {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _approvedForAll[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _approvedForAll[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public override payable {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override payable {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override payable {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

}

abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping (address => bool) members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    modifier onlyRole(bytes32 role) {
        _checkRole(role, _msgSender());
        _;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId
            || super.supportsInterface(interfaceId);
    }

    function hasRole(bytes32 role, address account) public view override returns (bool) {
        return _roles[role].members[account];
    }

    function _checkRole(bytes32 role, address account) internal view {
        if(!hasRole(role, account)) {
            revert(string(abi.encodePacked(
                "AccessControl: account ",
                Strings.toHexString(uint160(account), 20),
                " is missing role ",
                Strings.toHexString(uint256(role), 32)
            )));
        }
    }

    function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
        return _roles[role].adminRole;
    }

    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// 劳动者信息
struct Labourer {
    //劳动者账户上链数据hash值：手机号、姓名，性别，出生日期，学历信息。工龄、签约状态。
    bytes32[] personHash;
    //bytes epHash;
    //签约企业
    //address enterpriseAddr;
    //签约信息哈希值（包含签约时间，薪酬，岗位等信息）
    //bytes32 signHash;
}

struct Enterprise {
    //企业名称
    string epName;
    //信用代码
    string epCode;
    //企业上链hash值
    bytes32 epHash;
}

contract ResumeNft is ERC721, AccessControl, ILabourer, IEnterPrise ,IERC721Receiver{

    mapping(address => Labourer) _Labourers;

    mapping(address => Enterprise) _Enterprises;

    address public Factory;
    address public immutable DLNC;//人才币地址

    bytes32 public constant RESUMENft_ADMIN_ROLE = 0x0000000000000000000000000000000000000000000000000000000000000001;

    constructor(address DLNC_)ERC721("ResumeNft", "RNFT"){
        DLNC = DLNC_;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }
    
    function initialize(address factory_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        Factory = factory_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return interfaceId == type(ILabourer).interfaceId
            || interfaceId == type(IEnterPrise).interfaceId
            || interfaceId == type(IERC721Receiver).interfaceId
            || super.supportsInterface(interfaceId);
    }
    
    function register(bytes32 _hash, address _labourer) external override {
        require(_msgSender() == _labourer || hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only can regist yourself');
        uint256 tokenId = uint256(uint160(_labourer));
        require(!_exists(tokenId), 'already registed');

        _safeMint(_labourer, tokenId);

        _Labourers[_labourer].personHash.push(_hash);

        emit Register(_labourer, _hash, _msgSender());
    }
    
    function adppend(bytes32 _hash, address _labourer) external override {
        require(_msgSender() == _labourer || hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only can adppend yourself');
        uint256 tokenId = uint256(uint160(_labourer));
        require(_exists(tokenId), 'not registed yet');

        _Labourers[_labourer].personHash.push(_hash);

        emit Modify(_labourer, _hash, _msgSender());
    }

    function verify(address _labourer) external view override returns(bytes32[] memory) {
        return _Labourers[_labourer].personHash;
    }

    function verifyLast(address _labourer) external view override returns(bytes32) {
        return _Labourers[_labourer].personHash[_Labourers[_labourer].personHash.length - 1];
    }
    
    function remove(address _labourer) external returns (bool){
        require(hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only owner can remove');
        uint256 tokenId = uint256(uint160(_labourer));
        require(IDlnFactory(Factory).getContract(_labourer) == address(0), 'there is a ongoing contract');

        _burn(tokenId);

        delete _Labourers[_labourer];

        return true;
    }

    function transferUserOwner(address _org, address _new) external override {
        require(_msgSender() == _org || hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only can transfer yourself');

        uint256 tokenId_new = uint256(uint160(_new));
        uint256 tokenId_org = uint256(uint160(_org));
        require(_Labourers[_org].personHash.length > 0, 'invalid org address');
        require(_Labourers[_new].personHash.length == 0, 'new address has been registed');

        require(IDlnFactory(Factory).getContract(_org) == address(0), 'there is a ongoing contract');
        
        _Labourers[_new].personHash = _Labourers[_org].personHash;
        _burn(tokenId_org);
        _safeMint(_new, tokenId_new);

        emit TransferUserOwner(_org, _new, _msgSender());
    }

    function epRegister(bytes32 _hash, string calldata _name, string calldata _code, address _enterprise) external override {
        require(_msgSender() == _enterprise || hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only can regist yourself');
        require(bytes(_name).length != 0, 'invalid name');
        require(bytes(_code).length != 0, 'invalid code');
        require(bytes(_Enterprises[_enterprise].epName).length == 0, 'already registed');

        _Enterprises[_enterprise].epName = _name;
        _Enterprises[_enterprise].epCode = _code;
        _Enterprises[_enterprise].epHash = _hash;

        emit EpRegister(_enterprise, _hash, _msgSender(), _name, _code);
    }
    
    function epModify(bytes32 _hash, address _enterprise) external override {
        require(_msgSender() == _enterprise || hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only can modify yourself');
        require(bytes(_Enterprises[_enterprise].epName).length > 0, 'not registed yet');

        _Enterprises[_enterprise].epHash = _hash;

        emit EpModify(_enterprise, _hash, _msgSender());
    }
    
    function epVerify(address _enterprise) external view override returns(bytes32) {
        return _Enterprises[_enterprise].epHash;
    }
    
    function epRemove(address _enterprise) external returns (bool){
        require(hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only owner can remove');
        require(IDlnFactory(Factory).getAllEnterpriseContracts(_enterprise).length == 0, 'there is a ongoing contract');

        delete _Enterprises[_enterprise];

        return true;
    }

    function epSign(bytes32 _signHash, address _labourer) external {
        require(bytes(_Enterprises[_msgSender()].epName).length > 0, 'not registed yet');
        uint256 tokenId = uint256(uint160(_labourer));

        safeTransferFrom(_labourer, address(this), tokenId);//质押到NFT合约地址上

        IDlnFactory(Factory).createContract(_labourer, _msgSender(), _signHash);

        emit Sign(_labourer, _msgSender(), _signHash);
    }

    function epTerminateContract(address _labourer) external {
        address psContractAddr = IDlnFactory(Factory).getContract(_labourer);
        (bool success, bytes memory _data) = psContractAddr.call(abi.encodeWithSignature("enterpriseAddress()"));
        require(success == true, 'labourer do not sign contract');
        require(_msgSender() == abi.decode(_data, (address)), 'there is no contract between the labourer and you now');
        
        IDlnFactory(Factory).destructContract(_labourer);

        uint256 tokenId = uint256(uint160(_labourer));
        _safeTransfer(address(this), _labourer, tokenId, "");
    }
    
    function terminateContract(address _labourer, address _enterprise) external {
        require(hasRole(RESUMENft_ADMIN_ROLE, _msgSender()), 'only owner can remove');
        address psContractAddr = IDlnFactory(Factory).getContract(_labourer);
        (bool success, bytes memory _data) = psContractAddr.call(abi.encodeWithSignature("enterpriseAddress()"));
        require(success == true, 'labourer do not sign contract');
        require(_enterprise == abi.decode(_data, (address)), 'there is no contract between the labourer and you now');
        
        IDlnFactory(Factory).destructContract(_labourer);

        uint256 tokenId = uint256(uint160(_labourer));
        _safeTransfer(address(this), _labourer, tokenId, "");
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) pure external override returns (bytes4){
        return ResumeNft.onERC721Received.selector;
    }

}