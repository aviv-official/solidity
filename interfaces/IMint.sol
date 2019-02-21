pragma solidity ^0.4.20;
import "./IManaged.sol";

contract IMint is IManaged{
    
    //Called when a mint is given an agent status on an Estate token
    //Mint contract should remain locked until at least one agency is added
    function onAgencyAdded(uint tokenId) public;
    
    //Called when a mint is removed as agent on an Estate token
    //When there are no agencies, a mint should lock its contract until there is at least one
    function onAgencyRemoved(uint tokenId) public;

    //Function to set Estate token contract if needed
    function setEstate(address estate) public; //locked

    //Function to set TR contract
    function setTR(address tr) public; //locked

}