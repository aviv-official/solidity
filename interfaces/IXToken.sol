pragma solidity ^0.4.20;
import "./IManaged.sol";
import "./IERC20.sol";

contract IXToken /* is ERC20*/ is IManaged {

    address _estate;
    //Event Fired when a mint is added or removed
    event MintChange(address mint, bool state);
    
    mapping(address => bool) mints;
    
    modifier mintonly(){
        if(_estate != address(0)){
            require(IERC20(_estate).balanceOf(msg.sender) >= 1);
        }

        require(mints[msg.sender]);
        _;
    }

    function changeOwner(address _newOwner) public owneronly{
        OwnerChange(owner,false);
        OwnerChange(_newOwner,true);
        owner = _newOwner;
    }

    /**
    * @dev This function allows a contract to handle a deposit of ETH on behalf of another user
    */
    function depositTo(address _to) public payable returns (uint tokens); 
    function mint(uint amount) public;
    function burn(uint amount) public;
    function withdraw(uint amount, address dest, address _user) public;
}
