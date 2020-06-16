pragma solidity ^0.6.0;
//import "../contracts/SmartRentalToken.sol";
import "../contracts/ExtensionInfo.sol";
//import "../contracts/Extension.sol";

contract DynamicOwnership {
    string public sign;
    address public _owner;

    mapping (string => bytes) public extensionsData;
    mapping (string => ExtensionInfo) public extensions;
    string[] public extensionNames;

    constructor()
    public
    {
        sign = "bla";
    }

    function getMapElement(string memory index) public view returns(bytes memory) {
        return extensionsData[index];
    }

    function addExtension(string memory extName, address extension)
    public {
        extensionNames.push(extName);
        extensions[extName] = (ExtensionInfo(extension)); //[extensionName] = extension;
    }

    function removeExtension(string memory extName)
    public {
        //TODO:
    }

    // Checks preconditions or postconditions of a function with signature sig
    function invokeHelper(  string memory sig, ExtensionInfo.ExtType _condType,
                            string memory extName, bytes memory params)
    public
    returns (bool)
    {
        for (uint i = 0; i < extensionNames.length; i++) {
            ExtensionInfo ext = extensions[extensionNames[i]];
            for (uint j = 0; j < ext.numExtensions(); j++) {
                (string memory extended, ExtensionInfo.ExtType condType, string memory extSignature) = ext.ExtendedFunctions(j);

                if (compareStrings(extended, sig) && condType == _condType) {
                    if (condType == ExtensionInfo.ExtType.Invokation &&
                        !compareStrings(extensionNames[i], extName)) {
                            continue;
                        }
                        return delegate(address(ext), extSignature, params);
                }
            }
        }
        require(1 == 2, "Did not find contract\n"); //TODO: remove
        return false;
    }

    function delegate(address extContract, string memory _extSignature, bytes memory params)
    public //TODO: change to private
    returns (bool)
    {
        (bool success, bytes memory data) = extContract.delegatecall(
                        abi.encodeWithSignature(_extSignature, params));
        require(success, "Did not succeed\n");
        return success;
    }

    function invoke(string memory extName, string memory signature, bytes memory params)
    public
    {
        invokeHelper(signature, ExtensionInfo.ExtType.Invokation, extName, params);
        //TODO:
        //extensionparam[signature]=params
    }

    function setVarsDelegate(string memory _sign)
    public
    payable
    {
        require(invokeHelper(_sign, ExtensionInfo.ExtType.Precondition, "", ""), "Missed preconditions");
        require(invokeHelper(_sign, ExtensionInfo.ExtType.Postcondition, "", ""), "Missed preconditions");

    }

    function compareStrings (string memory a, string memory b)
    public pure
    returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
       }
}