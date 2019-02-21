pragma solidity ^0.4.20;
import "./IManaged.sol";
import "./IMint.sol";
import "./IELF.sol";
import "./IApproveAndCallFallBack.sol"; 
contract IXToken is IMint, IApproveAndCallFallBack /*,IERC20*/ {
    IELF elf;
    address _elf;
    address _estate;
    address _tr;
    address _ar;
    address _xav;

    uint _manaRate;

    //Event Fired when a mint is added or removed
    event MintChange(address mint, bool state);
    event ManaRateChanged(uint amount);
    event Award(address user, uint amount);
    event Deposit(address source, uint amount);
    event InterestPaid(address user, uint amount);
    event Approval(address approver, address spender, uint tokens);
    event ApprovalReceived(address token, address user, uint amount);
    event ApprovalProcessed(address token, address user, uint amount);
    event BulkXfrFail(address source, address dest, uint amount);
    event FeeChanged(uint p, uint q);
    event DepositRateChanged(uint p, uint q);
    
    mapping(address => bool) _mints;
    
    modifier mintonly(){
        require(_mints[msg.sender]);
        _; 
    }

    function addMint(address addr) public managed{
        _mints[addr] = true;
        MintChange(addr,true);
    }

    function removeMint(address addr) public managed{
        _mints[addr] = false;
        MintChange(addr, false);
    }

    function isMint(address addr) public view returns(bool){
        return _mints[addr];
    }

    function () public payable;

    function setAR(address ar) public managed{
        _ar = ar;
    }
    function setELF(address __elf) public managed{
        _elf = __elf;
        elf = IELF(_elf);
    }

    function setEstate(address estate) public managed{
        _estate = estate;
    }

    function setTR(address tr) public managed{
        _tr = tr;
    }

    function setXAV(address xav) public managed{
        _xav = xav;
    }
    
    function setManaRate(uint rate) public managed{
        _manaRate = rate;
        ManaRateChanged(rate);
    }

    function mint(uint amount) public payable; ///mintonly
    function burn(uint amount) public; 
    function withdraw(uint amount, address dest, address _user) public;
    function withdraw(uint amount, address user) public;
    function awardMana(uint amount, address user) public; //mintonly
    
    function processWithdrawals() public returns (uint remaining); //any
    
    function depositTo(address _to) public payable returns (uint tokens);
    function setRate(uint _p, uint _q) public;
    function setFee(uint _p, uint _q) public;
    function setMinBal(uint min) public;
    function getMinBal() public view returns (uint);
    function getInterestPaid(address user) public view returns (uint paid);
    function collectInterest(address user) public returns(uint interest);
    function calcInterest(address user) public view returns(uint interest);
    function weiToTokens(uint w) public view returns (uint tokens);
    function tokensToWei(uint tokens) public view returns (uint w);
    
    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success);
    function bulkTransfer(address[] sources, address[] dest, uint[] amounts) public returns (address last);
}
