pragma solidity ^0.6.0;
//import "../node_modules/openzeppelin-solidity/contracts/utils/Strings.sol";
//import "../contracts/SmartRentalToken.sol";
import "../contracts/DynamicOwnership.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract ExtensionInfo is ERC20{
    string public sign;
    address public _owner;
    mapping (string => bytes) public extensionsData;
    // NOTE: storage layout must be the same as contract A
    // i.e. the state variables we want to be able to access during the delegate call should be
    // at the same position that in the Origin (calling) contract

    enum ExtType {Precondition, Postcondition, Invokation}
    struct Extension {
        string  methodSignature; // The method which is extended in Origin token
        ExtType extensionType;
        string  extensionSignature; // The method which is called on delegatecall
    }
    Extension[] public ExtendedFunctions;
    uint256 public numExtensions;
    //DynamicOwnership public origin;

    constructor()
    ERC20("Informations", "Extension")
    public {}

    function getnumExtensions() public view returns (uint256){
        return numExtensions;
    }

    function getData(string memory name) public view returns (bytes memory){
        return extensionsData[name];
    }

    function initialData(string memory varName, bytes memory value) public returns (bytes memory){
        //Get the data of a variable and if the data was never set define it!
        bytes memory testData = extensionsData[varName];
        //flag allows us to check if the data is not set (ie if the bytes at this place is 0)
        bool flag;
        assembly {
            flag := eq(eq(sload(testData),0),1)
        }
        if( flag == true){
            extensionsData[varName] = value;
        }
        return extensionsData[varName];
    }

   /* function setA(address _t) public {
        origin = A(_t);
    }

    function decod()
    public
    view
    returns(address, uint) {
        address str;
        uint res;
        bytes memory bb = origin.getMapElement(1);
        (str, res) = abi.decode(bb, (address, uint));
        return (str, res);
    }
    */

    function compareStrings (string memory a, string memory b)
    public
    pure
    returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }

    function compare(string memory _a, string memory _b)
    private
    pure
    returns (int) {
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

    /* function addExtension(string memory methodSignature, bool preCond, string memory extensionSignature) public{
       // ExtType exttype = (_type == true) ? ExtType.Precondition : ExtType.Postcondition;
        ExtendedFunctions.push(Extension(methodSignature, preCond, extensionSignature, _parameters));
        numExtensions++;
    }

    function removeExtension(string memory extensionSignature) public{
        uint i;
        for(i = 0; i < ExtendedFunctions.length; i++){
            if(compare(ExtendedFunctions[i]._extensionSignature, extensionSignature) == 0){
               delete ExtendedFunctions[i];
            }
        }
    }
    */
    /*function getExtensionIndex(uint256 i) public view returns (string memory, bool, string memory, uint256){
        return (ExtendedFunctions[i]._methodSignature, ExtendedFunctions[i].preCondition,
                ExtendedFunctions[i]._extensionSignature, ExtendedFunctions[i].arguments);
    }
    */
}