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
    //mapping (string => ExtensionToken) public extensions;
    address public sender;
    address[] public extensions;
    B.ExtType public _type;

    constructor()
    public
    {
        sign = "bla";
    }

    function addExtension(address extension)
    public {
        extensions.push(extension); //[extensionName] = extension;
    }

    function check_preconditions(string memory _sign) public returns (bool) {
        for (uint i = 0; i < extensions.length; i++) {
            B ext = B(extensions[i]);
            for (uint j = 0; j < ext.numExtensions(); j++) {
                (string memory str, B.ExtType typ) = ext.ExtentedFunctions(j);
                if sign == str;
                _type = typ;
            }
        }
        return true;
    }

    function setVars(address _contract, string memory _sign) public payable {
        require(check_preconditions("setVars(address _contract, string memory _sign)"),
                                    "Missed preconditions");
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(string)", _sign)
        );
        _renterSet = success;
        require(success, "DelegateCall not succeded");
    }
}