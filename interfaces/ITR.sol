pragma solidity ^0.4.20;

/**
* Functions related to treasury rights
*/
contract ITR /* is ERC20, IManaged*/{
    //This will mint to the designated agent for the Estate token tokenId, if unset will throw
    function mint(uint tokenId) public returns (uint minted);
    //Burn a TR from an account that has given permission to msg.sender
    function burnFrom(address account, uint amount) public;
    //Set the token used for Estates (breaks a circular dependency), this is manager only
    function setEstate(address estate) public;

    //Function to determine if an Estate can mint a TR and if so, how many
    function canMint(uint tokenId) public view returns (uint avail);
}