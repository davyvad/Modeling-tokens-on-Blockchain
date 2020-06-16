pragma solidity ^0.6.0;
import "../contracts/ExtensionInfo.sol";
import "../contracts/DynamicOwnership.sol";
//import "../contracts/SmartRentalToken.sol";

// NOTE: Deploy this contract first
contract Extension is ExtensionInfo {
    constructor() public
    {
        sign = "bla";
        numExtensions = 3;
        ExtendedFunctions.push(Extension(   "setVars",
                                            ExtType.Precondition,
                                            "setVarsPrecondition(string)"));
        ExtendedFunctions.push(Extension(   "setVars",
                                            ExtType.Postcondition,
                                            "setVarsPostcondition(string)"));
        ExtendedFunctions.push(Extension(   "startRent",
                                            ExtType.Invokation,
                                            "startRent(bytes)"));
        //ExtentedFunctions[0] = Extension ("setVars(string memory _sign)", ExtType.Precondition);
    }

    function setVarsPrecondition(string memory _sign) public {
        //require(compareStrings(_sign, "compareStrings (string, string)"), "Bad signature");
        sign = _sign;
        _owner = msg.sender;
        //origin.extensionsData(2) = abi.encode(new SmartRental(..))``
        //abi.decode(extensionParam(hshd), uint,adress
    }

    function setVarsPostcondition(string memory _sign) public {
        //require(compareStrings(_sign, "compareStrings (string, string)"), "Bad signature");
        sign = _sign;
    }

    function setA(address _t) public {
        origin = DynamicOwnership(_t);
    }
    function decod() public view returns(address, uint) {
        address str;
        uint res;
        bytes memory bb = origin.getMapElement("b");
        (str, res) = abi.decode(bb, (address, uint));
        return (str, res);
    }

    function setSign()
    public
    {
        sign = "bloiii";
    }

    function startRent(bytes memory params /*address[] memory rentersList, uint rentTime*/)
    public {
        //bytes memory vars = extensionsData["Extension"];
        //require(compareStrings(string(vars) ,string("")) , "Rental Already set");
        (address[] memory renters, uint time) = abi.decode(params, (address[], uint));
        _owner = renters[9];
/*
        require(_renterSet == false || (_renterToken.rentIsValid() == false), "This ownership is already rented");
        require(_msgSender() == _owner, "Error: the owner of the contract must start the rent");
        if(_renterSet == true && _renterToken.rentIsValid() == false){
            _renterToken.burn(1);
            _renterSet = false;
        }
        _renterToken = new SmartRentalToken(name(), symbol());
        _renterToken.setRent(rentersList, this, rentTime);
        _renterSet = true;
    */
    }
}