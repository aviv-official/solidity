pragma solidity ^0.4.20;
/**
* Estate tokens are ERC721 tokens that allow a person to carry a line of credit and the line of credit travels with the token not the owner
* Estate tokens may be proxied so that the LOC can be utilized by a third party proxy.
* Estate LOC is limited to 2x total amount sent to credit function and can only utilized if credit > 0  
*/

contract IEstateTrust /* is ERC721Full */{
    event ProxySet(uint indexed tokenId, address indexed proxy);
    event Deposit(address indexed from,address indexed to, uint amount);
    event Withdrawal(address indexed from, address indexed to, uint amount);
    event PriceChanged(uint indexed amount);
    event MintAdded(address indexed mint);
    event MintRemoved(address indexed mint);

    //Set current price per unit for next batch
    function setPrice(uint price) public;

    //Set the Treasury Right
    function setTR(address tr) public;

    //Curent price for a batch of tokens
    function tokenPrice() public view returns (uint256);

    //Current balance for token
    function tokenBalance(uint tokenId) public view returns (int);

    //Tokens held by owner
    function tokensOfOwner(address owner) public view returns (uint256[]);

    //Add a contract with the ability to debit funds, we call these mints
    function addMint(address addr) public;

    //Revoke the authority of a contract to act as a mint
    function removeMint(address addr) public;

    //Is the address in question currently a mint?
    function isMint(address addr) public view returns (bool);

    //Issue one or more tokens
    function issueToken(address dest) public payable returns (uint qty);

    //Add msg.value wei to balance of tokenId
    function credit(uint tokenId) public payable;

    //Set a balance for tokenId
    function setBalance(uint tokenId, int val) public;
    
    /**
    *  Debit funds from a tokenId
    *  @param tokenId - Token being used
    *  @param requested - wei requested to borrow
    *  @param dest - Address to send funds (must be mint or normal address)
    *  @param who - If dest is a mint, who is who to credit the funds to
    *
    *  @return amount of wei sent
    */
    function debit(uint tokenId, uint requested, address dest, address who) public returns (uint amount);

    /**
    * @dev A proxy allows benefits and privileges associated with an Estate to be used by a third party called an agent without transfering control
    */
    function setAgent(uint tokenId, address agent) public;

    /**
    * @dev get the current agent/proxy for a tokenId or the owner if none is set
    */
    function getAgent(uint tokenId) public view returns (address agent);

    function setBeneficiary(address addr) public;
    function sell(uint tokenId) public;

}