pragma solidity ^0.6.0;
//import "../node_modules/openzeppelin-solidity/contracts/utils/Strings.sol";
//import "../contracts/SmartRentalToken.sol";
import "../contracts/DynamicOwnership.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract ExtensionInfo{
    //FROM ERC20 ////////////////
    using SafeMath for uint256;
    using Address for address;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    //END ERC20 ///////////////////
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
    //ERC20("Informations", "Extension")
    public {}

    function getnumExtensions() public view returns (uint256){
        return numExtensions;
    }

    function getData(string memory name) public view returns (bytes memory){
        return extensionsData[name];
    }

    function initialData(string memory varName, bytes memory value) public view returns (bytes memory){
        //Get the data of a variable and if the data was never set define it!
        bytes memory testData = extensionsData[varName];
        if (testData.length == 0) {
            return value;
        }
        return extensionsData[varName];
    }

    function compareStrings (string memory a, string memory b)
    public
    pure
    returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}