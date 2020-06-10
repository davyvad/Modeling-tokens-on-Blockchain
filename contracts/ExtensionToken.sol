pragma solidity ^0.6.0;
import "../contracts/SmartOwnershipToken.sol";
import "../contracts/SmartRentalToken.sol";

contract ExtensionToken{
    address public _owner;
    uint256 public val;
    SmartRentalToken private _renterToken;
    bool public _renterSet;
    mapping (string => ExtensionToken) public extensions;

   constructor() public{
        _owner = msg.sender;
        val = 0;
        _renterSet = false;
   }

    function deco(uint a) /*uint32 a, uint32 b ,string memory functionname*/
    public
    returns (uint256){
        val = a;

        //prefunction
        //SmartOwnershipToken ownerToken = SmartOwnershipToken.at(_msgSender());
        //ownerToken.getParam();

    //    call the relevant function
      //  case functionName:
        //    function1(ownerToken, param1, param2...);

        //ownerToken.getParams();
        return 105;
    }
    function invokeExtension(uint a)
    public payable
    {
        val = a;
        _renterSet = true;
    }
    /*function1(SmartOwnershipToken token)public{



        //core of fucntion
        token.transfer(address recipient,  amount);
*/
}