pragma solidity ^0.4.20;

contract IEstate{
    event ProxySet(uint indexed tokenId, address indexed proxy);
    function mint(uint qty, address dest) public;
    function credit(uint tokenId) public;
    function debit(uint tokenId, uint amount) public;
    function tokenBalance(uint tokenId) public view returns (int);
    function setProxy(uint tokenId, address proxy) public;
    function getProxy(uint tokenId) public view returns (address proxy);
    function getProxies(address addr) public view returns (uint[] proxied);
    
}