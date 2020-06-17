pragma solidity ^0.6.0;
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

//import "../contracts/SmartRentalToken.sol";
import "../contracts/ExtensionInfo.sol";
//import "../contracts/Extension.sol";

contract DynamicOwnership is ERC20{
    string public sign;
    address public _owner;

    mapping (string => bytes) public extensionsData;
    mapping (string => ExtensionInfo) public extensions;
    string[] public extensionNames;

    constructor(string memory name, string memory symbol)
    ERC20(name, symbol)
    public {
        sign = "bla";
        _owner = _msgSender();
        _mint(_msgSender(), 1);
    }

    function getOwner()public view returns (address){
        return _owner;
    }
    function getSign()public view returns(string memory){
        return sign;
    }
    function getMapElement(string memory index) public view returns(bytes memory) {
        return extensionsData[index];
    }

    function addExtension(string memory extName, address extension)
    public {
        extensionNames.push(extName);
        extensions[extName] = (ExtensionInfo(extension)); //[extensionName] = extension;
    }

    //TODO: check if this function works fine (or is it leaving a gap??)
    function removeExtension(string memory extName)
    public {
        for (uint i = 0; i<extensionNames.length; i++){
            if(compareStrings(extName, extensionNames[i])){
                delete extensionNames[i];
            }
        }
        delete extensions[extName];
    }

    function invokeExtension(string memory extName, string memory signature, bytes memory params)
    public
    {
        invokeHelper(signature, ExtensionInfo.ExtType.Invokation, extName, params);
    }

    function invokePreCond(string memory signature, bytes memory params)
    public
    returns (bool)
    {
        return invokeHelper(signature, ExtensionInfo.ExtType.Precondition, "", params);
    }

    function invokePost(string memory signature, bytes memory params)
    public
    returns (bool)
    {
        return invokeHelper(signature, ExtensionInfo.ExtType.Postcondition, "", params);
    }


    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(invokePreCond("transfer", abi.encode(recipient, amount)), "Preconditions didn't pass");
        _transfer(_msgSender(), recipient, amount);
        require(invokePost("transfer", abi.encode(recipient,amount)), "PostCondition didn't pass");
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(invokePreCond("transferFrom", abi.encode(sender, recipient, amount)), "Preconditions didn't pass");
        _transfer(sender, recipient, amount);
        require(invokePost("transferFrom", abi.encode(sender, recipient,amount)), "PostCondition didn't pass");
        return true;
    }
 
    function burn(uint amount) public returns (bool) {
        require(invokePreCond("burn", abi.encode(amount)), "Preconditions didn't pass");
        _burn(_msgSender(), amount); //TODO : CHANGE AMOUNT TO 1
        require(invokePost("burn", abi.encode(amount)), "PostCondition didn't pass");
        return true;
    }


    // Checks preconditions or postconditions of a function with signature sig
    function invokeHelper(  string memory sig, ExtensionInfo.ExtType _condType,
                            string memory extName, bytes memory params)
    private
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
    private //TODO: change to private
    returns (bool)
    {
        (bool success, bytes memory data) = extContract.delegatecall(
                        abi.encodeWithSignature(_extSignature, params));
        require(success, "Did not succeed\n");
        return success;
    }


    function setVarsDelegate(string memory _sign)
    public
    payable
    {
        require(invokeHelper(_sign, ExtensionInfo.ExtType.Precondition, "", ""), "Missed preconditions");
        require(invokeHelper(_sign, ExtensionInfo.ExtType.Postcondition, "", ""), "Missed preconditions");

    }

    function compareStrings (string memory a, string memory b)
    private pure
    returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}