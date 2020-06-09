pragma solidity >=0.4.25 <0.7.0;
import "../contracts/SmartOwnershipToken.sol";

contract ExtensionToken{
    address public _owner;
    uint256 public val;
    SmartRentalToken private _renterToken;
    bool private _renterSet;
    mapping (string => ExtensionToken) public extensions;

   constructor() public{
        _owner = msg.sender;
        val = 0;
   }

    function deco(uint value) /*uint32 a, uint32 b ,string memory functionname*/
    public
    returns (uint256){
        require (value == 10, "problem");
        require (value != 10, "problem");

        val = value;
        //prefunction
        //SmartOwnershipToken ownerToken = SmartOwnershipToken.at(_msgSender());
        //ownerToken.getParam();

    //    call the relevant function
      //  case functionName:
        //    function1(ownerToken, param1, param2...);

        //ownerToken.getParams();
        return 105;
    }

    /*function1(SmartOwnershipToken token)public{



        //core of fucntion
        token.transfer(address recipient,  amount);
*/
}