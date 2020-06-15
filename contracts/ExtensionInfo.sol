pragma solidity ^0.6.0;
//import "../node_modules/openzeppelin-solidity/contracts/utils/Strings.sol";
//import "../contracts/SmartRentalToken.sol";


contract ExtensionInfo {
    enum ExtType {Precondition, Postcondition }

    struct Extension {
        string _methodSignature; // The method which is extended in Origin token
        bool preCondition;
        string _extensionSignature; // The method which is called on delegatecall
        uint256 arguments;
    }
    Extension[] public ExtendedFunctions;
    uint256 public numExtensions;

    constructor() public{
        numExtensions = 0;
    }

    function addExtension(string memory methodSignature, bool preCond, string memory extensionSignature, uint256 _parameters) public{
       // ExtType exttype = (_type == true) ? ExtType.Precondition : ExtType.Postcondition;
        ExtendedFunctions.push(Extension(methodSignature, preCond, extensionSignature, _parameters));
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

    function getnumExtensions() public view returns (uint256){
        return numExtensions;
    }

    function getExtensionIndex(uint256 i) public view returns (string memory, bool, string memory, uint256){
        return (ExtendedFunctions[i]._methodSignature, ExtendedFunctions[i].preCondition,
                ExtendedFunctions[i]._extensionSignature, ExtendedFunctions[i].arguments);
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