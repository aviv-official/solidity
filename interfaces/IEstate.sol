pragma solidity ^0.4.20;
/**
* Estate tokens are ERC721 tokens that allow a person to carry a line of credit and the line of credit travels with the token not the user
* Estate tokens may ve proxied so that the LOC can be utilized by a third party proxy.
* Estate LOC is limited to 2x total amount sent to credit function and can only utilized if credit > 0  
*/

contract IEstate /* is ERC721Full */{
    //Emitted when a proxy is set for a token
    event ProxySet(uint indexed tokenId, address indexed proxy);
    //Mint new Estates
    function mint(uint qty, address dest) public;
    //Credit funds to an Estate
    function credit(uint tokenId) public payable;
    //Debit funds from an Estate
    function debit(uint tokenId, uint amount) public;
    //Return the current LOC for a token
    function tokenBalance(uint tokenId) public view returns (int);
    //Set a proxy for an Estate
    function setAgent(uint tokenId, address agent) public;
    //Get the current proxy agent for an Estate
    function getAgent(uint tokenId) public view returns (address agent);
    //Get a list of all tokens proxied to agent
    function getProxies(address agent) public view returns (uint[] proxied);
}