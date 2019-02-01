pragma solidity ^0.4.20;

/**
* XVault maintains XAV balances on behalf of XTokens
*/
contract IXVault /*is IManaged*/{ 
    function addXToken(address at, string symbol, uint p, uint q) public;
    function getRate(string symbol) public view returns (uint[2] rate);
    function getRate(address addr) public view returns (uint[2] rate);
    function withdraw(uint units, address dest) public validtoken returns (uint amount);
}