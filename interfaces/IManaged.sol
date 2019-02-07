pragma solidity ^0.4.20;

import "./IERC20.sol";
import "./IERC165.sol";
import "./IERC721.sol";

contract IManaged{

    //Event Fired when a manager is added or removed
    event ManagerChange(address manager,bool state);
    event OwnerChange(address owner, bool state);
    event ContractReplaced(address indexed replacement);
    event ContractLocked(bool state);

    address internal _owner;
    bool internal _locked = false;

    mapping(address => bool) managers;
    
    modifier owneronly(){
        require(msg.sender == _owner);
        _;
    }

    modifier managed(){
        require(managers[msg.sender]);
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

    function addManager(address addr) public owneronly{
        managers[addr] = true;
        ManagerChange(addr,true);
    }

    function removeManager(address addr) public managed{
        managers[addr] = false;
        ManagerChange(addr,false);
    }

    function changeOwner(address _newOwner) public owneronly{
        OwnerChange(_owner,false);
        OwnerChange(_newOwner,true);
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
    function replace(address dest) public owneronly locked{
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