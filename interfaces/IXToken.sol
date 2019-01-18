pragma solidity ^0.4.20;

contract IXToken /* is ERC20*/ {
    /**
    * @dev This function allows a contract to handle a deposit of ETH on behalf of another user
    */
    function depositTo(address _to) public payable returns (uint tokens); 
}