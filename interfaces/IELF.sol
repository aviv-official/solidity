pragma solidity ^0.4.20;

interface IELF{
    event AgentSet(uint indexed tokenId, address indexed agent);
    event MintAdded(address indexed mint);
    event MintRemoved(address indexed mint);
    event LoanCreated(address indexed dest, uint indexed tokenId, uint amount, uint fee);
    event LoanDefaulted(uint indexed tokenId, uint owed);
    event FundsAdded(address indexed source, uint indexed amount);
    event DepositReceived(address indexed source, uint indexed amount, int balance);

    function() external payable;
    function setEstate(address _estate) external;
    function setTR(address _tr) external;

    function setFee(uint p, uint q) external;
    function getFee() external view returns (uint[2] _fee);

    function setAgent(uint tokenId, address agent) external;
    function getAgent(uint tokenId) external view returns (address agent);
    function addMint(address addr) external;
    function removeMint(address addr) external;
    function isMint(address addr) external view returns (bool);
    function getPrice(uint tokenId) external view returns (uint price);

    function getCreditLimit(uint tokenId) external view returns (uint limit);
    function debit(uint tokenId, uint requested, address dest, address who) external returns (uint amount);

    function tokenBalance(uint tokenId) external view returns (int);
    function credit(uint tokenId) external payable;

    function surrender(uint tokenId) external;
    function forgive(uint tokenId) external;
    function setBalance(uint tokenId, int amount) external;
}