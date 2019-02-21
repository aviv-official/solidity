pragma solidity ^0.4.20;

interface IEstateSale /*is IManaged*/{
    event PriceChanged(uint indexed price);
    function() external;
    function mint(uint amount, address dest) external;/*unlocked managed*/
    function getPrice() external view returns (uint price);
    function setFundsDest(address dest) external; /*locked trustonly*/ 
}