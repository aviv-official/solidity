pragma solidity ^0.4.20;

import "./IERC20.sol";
import "./IERC165.sol";
import "./IERC721.sol";

contract IManaged{

    //Event Fired when a manager is added or removed
    event ManagerChanged(address manager,bool state);
    event OwnerChanged(address owner);
    event TrustChanged(address trust);
    event ContractReplaced(address indexed replacement);
    event ContractLocked(bool indexed state);

    address internal _owner;
    address internal _trust;

    bool internal _locked = false;

    mapping(address => bool) managers;
    
    modifier trustonly(){
        require(msg.sender == _trust || msg.sender == _owner);
        _;
    }

    modifier owneronly(){
        require(msg.sender == _owner);
        _;
    }

    modifier managed(){
        require(managers[msg.sender] || msg.sender == _owner || msg.sender == _trust);
        _;
    }

    modifier locked(){
        require(_locked == true);
        _;
    }

    modifier unlocked(){
        require(_locked == false);
        _;
    }

    function setTrust(address addr) public{
        require(msg.sender == _trust || msg.sender == _owner);
        _trust = addr;
        TrustChanged(addr);
    }

    function addManager(address addr) public owneronly{
        managers[addr] = true;
        ManagerChanged(addr,true);
    }

    function removeManager(address addr) public managed{
        managers[addr] = false;
        ManagerChanged(addr,false);
    }

    function changeOwner(address _newOwner) public owneronly{
        OwnerChanged(_newOwner);
        _owner = _newOwner;
        addManager(_newOwner);
    }

    function lock() public managed{
        _locked = true;
        ContractLocked(_locked);
    }

    function unlock() public managed{
        _locked = false;
        ContractLocked(_locked);
    }

    function isLocked() public view returns (bool){
        return _locked;
    }
    //Used to kill the contract and forward funds to a replacement contract, this is owner only
    function replace(address dest) public trustonly locked{
        ContractReplaced(dest);
        selfdestruct(dest);
    }

    function sweep(uint amount, address to) public managed{
        address(to).transfer(amount);
    }

    function sweepERC20(address token, address to,  address from) public managed{
        uint allowance = 0;
        uint bal = IERC20(token).balanceOf(address(this));
        if(bal > 0){
            IERC20(token).transfer(to,bal);
        }
        if(from != address(0)){
            allowance = IERC20(token).allowance(from, address(this));
            if(allowance > 0){
                IERC20(token).transferFrom(from, to, allowance);
            }
        }
    }
    
    function sweepERC721(address token, address to, address from, uint[] ids) public managed{
        if(IERC165(token).supportsInterface(0x80ac58cd)){
            for(uint x = 0; x <= ids.length -1; x++){
                uint tokenId = ids[x];
                IERC721(token).transferFrom(from,to,tokenId);
            }
        }
    }
}