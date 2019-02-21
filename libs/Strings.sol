pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;

library Strings{
    function concat(bytes memory a, bytes memory b)
            internal pure returns (bytes memory) {
        return abi.encodePacked(a, b);
    }
    
}