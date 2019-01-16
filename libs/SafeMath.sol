pragma solidity ^0.4.20;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {

    int256 constant private INT256_MIN = -2**255;
    int256 constant private INT256_MAX = 2**255-1;
    
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    /**
    * @dev Subtracts a signed integer from an unsigned int
    */
    function sub(uint self, int b) internal pure returns (uint){
        if(b < 0){
            return add(self,abs(b));
        }else{
            return sub(self,uint(b));
        }
    }

    /**
    * @dev Subtracts an int from an int
    */
    function sub(int self, int b) internal pure returns(int){
        return self - b;
    }

    /**
    * @dev Subtracts an unsigned integer from a signed int
    */
    function sub(int self, uint b) internal pure returns (int){
        require(b <= uint(INT256_MAX));
        return sub(self,int(b));
    }

    /**
    * @dev Adds a signed integer to an unsigned int, reverts on overflow.
    */
    function add(uint self, int b) internal pure returns (uint){
        if(b <= 0){
            return sub(self, abs(b));
        }else{
            return add(self,uint(b));
        }
    }

    /**
    * @dev Adds an unsigned integer to a signed int, reverts on overflow.
    */
    function add(int self, uint b) internal pure returns (int){
        require(b < uint(INT256_MAX));
        int c = self + int(b);
        require(c > self || c > int(b));
        return c;
    }

   /**
    * @dev Returns the abs of an int as a uint
    */
    function abs(int a) internal pure returns (uint){
        return a >= 0 ? uint(a) : uint(0-a);
    }
}