pragma solidity ^0.4.20;

contract IManaged{

    //Event Fired when a manager is added or removed
    event ManagerChange(address manager,bool state);
    
    event OwnerChange(address owner, bool state);


    address owner;

    mapping(address => bool) managers;
    

    modifier owneronly(){
        require(msg.sender == owner);
        _;
    }

    modifier managed(){
        require(managers[msg.sender]);
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
        OwnerChange(owner,false);
        OwnerChange(_newOwner,true);
        owner = _newOwner;
    }

}