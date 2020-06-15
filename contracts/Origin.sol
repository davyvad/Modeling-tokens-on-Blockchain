pragma solidity ^0.6.0;
import "../contracts/SmartRentalToken.sol";
import "../contracts/ExtensionToken.sol";
import "../contracts/Extension.sol";

contract A {
    string public sign;
    address public _owner;
    bytes4 public val;
    SmartRentalToken private _renterToken;
    bool public _renterSet;
    mapping (uint => bytes) public extensionsData;
    address public sender;
    address[] public extensions;
    B.ExtType public _type;

    constructor()
    public
    {
        sign = "bla";
    }

    function getMapElement(uint index) public view returns(bytes memory) {
        return extensionsData[index];
    }

    function addExtension(address extension)
    public {
        extensions.push(extension); //[extensionName] = extension;
        extensionsData[1] = abi.encode(extension, 2333);
    }

    function check_preconditions(string memory _sign)
    public
    returns (bool)
    {
        for (uint i = 0; i < extensions.length; i++) {
            B ext = B(extensions[i]);
            for (uint j = 0; j < ext.numExtensions(); j++) {
                (string memory extended, B.ExtType typ, string memory extSignature) = ext.ExtentedFunctions(j);
                if (compareStrings(extended, _sign)) {
                    _type = typ;
                    sign = extSignature;
                }
            }
        }
        return true;
    }

    function setVars(address _contract, string memory _sign)
    public
    payable
    {
        require(check_preconditions("setVars(address _contract, string memory _sign)"),
                                    "Missed preconditions");
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(string)", _sign)
        );
        _renterSet = success;
        require(success, "DelegateCall not succeded");
    }

    function compareStrings (string memory a, string memory b)
    public pure
    returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );

       }
}