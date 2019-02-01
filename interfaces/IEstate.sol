pragma solidity ^0.4.20;
/**
* Estate tokens are ERC721 tokens that allow a person to carry a line of credit and the line of credit travels with the token not the user
* Estate tokens may ve proxied so that the LOC can be utilized by a third party proxy.
* Estate LOC is limited to 2x total amount sent to credit function and can only utilized if credit > 0  
*/

contract IEstate /* is ERC721Full */{
    //Emitted when a proxy is set for a token
    event ProxySet(uint indexed tokenId, address indexed proxy);
    //Emitted when a deposit is received
    event Deposit(address indexed source,address indexed dest, uint amount);
    //Emitted when a withdrawal is processed
    event Withdrawal(address indexed source, address indexed dest, uint amount);
    //Emitted when the price changes
    event PriceChanged(uint indexed amount);
    //Set the price in wei to mint new tokens if not owner
    function setPrice(uint price) public;
    //Treasury Rights (TRs) must be burnt in order to debit a token beyond it's available funds
    //setTR allows us to set the contract which tracks TRs
    function setTR(address tr) public;
    //Mint new Estates (payment required of qty * price)
    function mint(uint qty, address dest) public payable;
    //Credit funds to an Estate
    function credit(uint tokenId) public payable;
    //Debit funds from an Estate
    function debit(uint tokenId, uint requested, address dest, address who) public returns (uint amount);
    //Return the current LOC for a token
    function tokenBalance(uint tokenId) public view returns (int);
    //Set a proxy for an Estate
    function setAgent(uint tokenId, address agent) public;
    //Get the current proxy agent for an Estate
    function getAgent(uint tokenId) public view returns (address agent);
    //Get a list of all tokens proxied to agent
    function getProxies(address agent) public view returns (uint[] proxied);

    //Get a list of tokens proxied that have a positive balance
    //CAUTION!!!  If there are a large number of proxies to the agent, 
    //This has a non-zero chance of running out of gas even with the block gas maximum
    //Therefore, do not call this from within a contract, or the contract could permalock.
    //Instead, use getProxies and cache the result, then order it by balance as needed in chunks, 
    //Best practice for this function is to call this function from an external oracle 
    //and post the results back to your contract
    function getLiveProxies(address agent) public view returns (uint[] proxied);
}