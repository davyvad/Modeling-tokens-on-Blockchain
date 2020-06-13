pragma solidity ^0.6.0;
//import "../node_modules/openzeppelin-solidity/contracts/utils/Strings.sol";
//import "../contracts/SmartRentalToken.sol";


contract ExtensionInfo {
    enum ExtType {Precondition, Postcondition }

    struct Extension {
        string _methodSignature; // The method which is extended in Origin token
        ExtType _type;
        string _extensionSignature; // The method which is called on delegatecall
    }
    Extension[] public ExtendedFunctions;
    uint256 public numExtensions;

    constructor() public{
        numExtensions = 0;
    }

    function addExtension(string memory methodSignature, bool _type, string memory extensionSignature) public{
        ExtType exttype = (_type == true) ? ExtType.Precondition : ExtType.Postcondition;
        ExtendedFunctions.push(Extension(methodSignature, exttype, extensionSignature));
        numExtensions++;
    }

    function removeExtension(string memory extensionSignature) public{
        uint i;
        for(i = 0; i < ExtendedFunctions.length; i++){
            if(compare(ExtendedFunctions[i]._extensionSignature , extensionSignature) == 0){
               delete ExtendedFunctions[i];
            }
        }
    }

    function check_preconditions(address _contract) public returns (bool) {
        for (uint i = 0; i < ExtendedFunctions.length; i++) {
            if(ExtendedFunctions[i]._type == ExtType.Precondition){
      //          _contract.delegatecall(
      //      abi.encodeWithSignature(ExtendedFunctions[i]._extensionSignature, _sign)
      //  );
            _contract.delegatecall(abi.encode(ExtendedFunctions[i]._extensionSignature));
            }
        }
        return true;
    }

    function getnumExtensions() public view returns (uint256){
        return numExtensions;
    }

    function compare(string memory _a, string memory _b) private returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
}