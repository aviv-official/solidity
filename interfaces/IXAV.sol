pragma solidity ^0.4.20;

contract IXAV {
    function mint(uint amount) public;
    function burn(uint amount) public;
    function withdraw(uint amount, address dest, address _user) public;
    function depositTo(address _to) public payable returns (uint tokens);
} 