pragma solidity ^0.4.20;
import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Enumerable.sol";
import "./IManaged.sol";

contract IEstate is IManaged, IERC721, IERC721Metadata, IERC721Enumerable{

    //Set the elf contract to enable surrenders, trustonly
    function setELF(address elf) public;

    //Mint a new token, managed
    function mint(address addr) public payable returns (uint);
    
    //Burn a token, managed
    function burn(uint tokenID) public payable returns (bool);
    
    //Tokens held by owner
    function tokensOfOwner(address owner) public view returns (uint256[]);

    //Called by the ELF contract when a token has been surrendered by its owner
    //This transfers the token to the ELF contract with no intervention by the user other than initiating it
    function surrendered(uint tokenId) public;

    //Trasfer a tokenId to an address
    function transfer(uint tokenId, address to) public;

} 