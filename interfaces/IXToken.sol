pragma solidity ^0.4.20;

import "./IERC20.sol";
import "./IManaged.sol";
import "./IELF.sol";

contract IXToken is IManaged /*,IERC20*/{

    IELF elf;       //deal with elf as a contract
    address _elf;   //elf as address
    address _estate;//estate as address
    address _tr;    //tr as address
    address _ar;    //ar as address
    address _xav;   //xav as address (xav contract this is self)

    uint fees;      //Sum total of currently collected fees
    uint _manaRate;//Exchange rate for mana from awards

    //Rational is a ratio of p / q used for rates such as interest
    struct Rational {
        uint p;
        uint q;
    }
    Rational fee;   //fee for actions such as deposits, withdrawals & transfers
    Rational rate;  //exchange rate to / from wei
    

    mapping(address => uint) lastIDate; //Last time interest was paid to address
    mapping(address => uint) intPaid;   //total interest paid to address
    mapping(address => bool) _mints;    //authorized mints for this token

    //Fired when a mint is added or removed
    event MintChange(address mint, bool state);
    //Fired whed manarate is changed
    event ManaRateChanged(uint amount);
    //Fired when an award is granted
    event Award(address user, uint amount);
    //Fired when a deposit is received
    event Deposit(address source, uint amount);
    //Fired when interest is paid
    event InterestPaid(address user, uint amount);
    //Fired when approval is given
    event Approval(address approver, address spender, uint tokens);
    //Fired when approvale has been received but not processed
    event ApprovalReceived(address token, address user, uint amount);
    //Fired when approval has been processed
    event ApprovalProcessed(address token, address user, uint amount);
    //Fired when an element from bulkTransfer has failed
    event BulkXfrFail(address source, address dest, uint amount);
    //Fired when fee has changed
    event FeeChanged(uint p, uint q);
    //Fired when the exchange rate to/from wei has changed
    event DepositRateChanged(uint p, uint q);
    
    //Only authorized mints
    modifier mintonly(){
        require(_mints[msg.sender]);
        _; 
    }

    /**
    * @dev Add a new mint
    * @param addr - Address to authorize for minting 
    */
    function addMint(address addr) public managed{
        _mints[addr] = true;
        MintChange(addr,true);
    }

    /**
    * @dev Remove a mint
    * @param addr - Address to de-authorize from minting 
    */
    function removeMint(address addr) public managed{
        _mints[addr] = false;
        MintChange(addr, false);
    }

    /**
    * @dev Determine if addr is a mint for this token
    * @param addr - Address to check
    */
    function isMint(address addr) public view returns(bool){
        return _mints[addr];
    }

    /**
    * @dev public fallback function
    * All IXTokens must be payable, 
    * in most cases they just emit 
    * Deposit(address source, uint amount);
    */
    function() public payable{
        Deposit(msg.sender, msg.value);
    }
    
    /**
    * @dev set the AwardRights contract 
    */
    function setAR(address ar) public managed{
        _ar = ar;
    }

    /**
    * @dev set the ELF contract
    */
    function setELF(address __elf) public managed{
        _elf = __elf;
        elf = IELF(_elf);
    }

    /**
    * @dev set the Estate contract  
    */
    function setEstate(address estate) public managed{
        _estate = estate;
    }

    /**
    * @dev set the TreasuryRights contract 
    */
    function setTR(address tr) public managed{
        _tr = tr;
    }

    /**
    * @dev set the XAV contract (will be this.address for XAV itself)
    */
    function setXAV(address xav) public managed{
        _xav = xav;
    }

    /**
    * @dev set the manaRate which is from AR contracts 
    */
    function setManaRate(uint __rate) public managed{
        _manaRate = __rate;
        ManaRateChanged(_manaRate);
    }

    /**
    * @dev set the exchange rate to / from wei (or XAV) 
    */
    function setRate(uint _p, uint _q) public;

    /**
    * @dev Most actions charge a fee, this sets the fee
    */
    function setFee(uint _p, uint _q) public;

    /**
    * @dev get the current fee 
    */
    function getFee() public returns (uint[2] _fee);

    /**
    * @dev transfer funds, overrides ERC20 transfer 
    */
    function transfer(address to, uint256 value) public returns (bool status);

    /**
    * @dev get the interest paid so far to address user, this is in tokens
    */
    function getInterestPaid(address user) public view returns (uint paid);

    /**
    * @dev collect any interest due on behalf of user 
    */
    function collectInterest(address user) public returns(uint interest);

    /**
    * @dev calculate the fee applied to value, feeAmt is in tokens
    */
    function calcFee(uint value) public view returns (uint feeAmt);

    /**
    * @dev calculate interest owed to user, interest is in tokens 
    */
    function calcInterest(address user) public view returns(uint interest);

    /**
    * @dev AwardMana to a user, must be AR contract, this is called from 
    */
    function awardMana(uint amount, address user) public;

    /**
    * @dev Mint new tokens 
    */
    function mint(uint amount) public payable;

    /**
    * @dev burn existing tokens 
    */
    function burn(uint amount) public;
    
    /**
    * @dev deposit wei on behalf of _to, returns the tokens created 
    */
    function depositTo(address _to) public payable returns (uint tokens);

    /**
    * @dev All IXTokens implement approveAndCall semantics from ERC20
    */
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success);
    
    /**
    * @dev All IXTokens implement approveAndCall.receiveApproval semantics from ERC20
    */
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
    
    /**
    * @dev withdraw tokens as XAV, unless this is XAV contract in which case we get wei
    * If dest is a contract this function will call depositTo on dest, otherwise must be a normal address 
    */
    function withdraw(uint amount, address dest, address _user) public;

    /**
    * @dev shortcut for withdraw(uint amount, address dest, address _user)
    * Use when using a normal address for withdrawal in order to save some gas
    */
    function withdraw(uint amount, address user) public;

    /**
    * @dev convenience function to let you know how many tokens for wei 
    */
    function weiToTokens(uint w) public view returns (uint tokens);

    /**
    * @dev convenience function to let you know how many wei each token is worth
    */
    function tokensToWei(uint tokens) public view returns (uint w);

    /**
    * @dev called when this token is added as a agent for an Estate in Elf 
    */
    function onAgencyAdded(uint tokenId) public;

    /**
    * @dev called when this token is removed as an agent for an Estate in Elf 
    */
    function onAgencyRemoved(uint tokenId) public;

    /**
    * @dev this permits fee free bulk transfers by outside parties, in order to facilitate mass adoption by third party payment processors 
    */
    function bulkTransfer(address[] sources, address[] dest, uint[] amounts) public returns (address last);
}