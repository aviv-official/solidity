pragma solidity ^0.4.20;

/**
* Functions related to award rights
*/
contract IAR /* is ERC20, IManaged*/{
    function setEstate(address estate) public;
    
    function mint(uint tokenId, address user) public returns (uint minted);

    function burn(uint amount) public;

    function canMint(uint tokenId) public view returns (uint avail);

    function claimMana(address userAddr, address destAddr) public;

    function getMana(address userAddr) public view returns(uint mana);
}