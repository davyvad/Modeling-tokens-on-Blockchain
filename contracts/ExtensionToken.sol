pragma solidity >=0.4.25 <0.7.0;
import "../contracts/SmartOwnershipToken.sol";

contract ExtensionToken{

   constructor() public{}

    deco(string functionname)public returns (bool){
        //prefunction
        SmartOwnershipToken ownerToken = SmartOwnershipToken.at(_msgSender());
        ownerToken.getParam();
s
        call the relevant function
        case functionName:
            function1(ownerToken, param1, param2...);

        //ownerToken.getParams();
    }

    function1(SmartOwnershipToken token)public{
       


        //core of fucntion
        token.transfer(address recipient,  amount);

}