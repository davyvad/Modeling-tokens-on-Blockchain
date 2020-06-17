pragma solidity ^0.6.0;
import "../contracts/ExtensionInfo.sol";
import "../contracts/DynamicOwnership.sol";
import "../contracts/DynamicRental.sol";

// NOTE: Deploy this contract first
contract Extension is ExtensionInfo {
    constructor() public
    {
        sign = "bla";
        numExtensions = 5;
        ExtendedFunctions.push(Extension(   "setVars",
                                            ExtType.Precondition,
                                            "setVarsPrecondition(string)"));
        ExtendedFunctions.push(Extension(   "setVars",
                                            ExtType.Postcondition,
                                            "setVarsPostcondition(string)"));
        ExtendedFunctions.push(Extension(   "startRent",
                                            ExtType.Invokation,
                                            "startRent(bytes)"));

        ExtendedFunctions.push(Extension(   "transfer",
                                            ExtType.Precondition,
                                            "transferPreCond(bytes)")); 
        ExtendedFunctions.push(Extension(   "transfer",
                                            ExtType.Postcondition,
                                            "transferPost(bytes)"));                                            
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

    

    function setSign()
    public
    {
        sign = "bloiii";
    }

    function transferPreCond(bytes memory params) public returns (bool) {
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        
        (address recipient, uint256 amount) = abi.decode(params, (address, uint256));

        require(amount == 1, "Requesting tranfer for more than one unit");
        //require(renterSet == false || (renterToken.rentIsValid() == false), "Error: the item is on rent");
        if(renterSet == true ){
            DynamicRental renterToken = abi.decode( extensionsData["Extension_renterToken"], (DynamicRental) );
            require(renterToken.rentIsValid() == false, "Error: the item is on rent");
        }else{
            require(renterSet == false , "Error: the item is on rent"); //not really needed actually
        }
        require(_msgSender() == _owner, "Only owner is allowed to make transfer");        
        return true;
    }

    function transferPost(bytes memory params)public returns (bool){
        //variables
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        //DynamicRental renterToken = abi.decode( initialData( "Extension_renterToken", abi.encode(new DynamicRental("Rental Token", "Rent", msg.sender, renters, time) ) ) , (DynamicRental));

        //parameters
        (address recipient, uint256 amount) = abi.decode(params, (address, uint256));

        _owner = recipient;
        if(renterSet == true ){
            DynamicRental renterToken = abi.decode( extensionsData["Extension_renterToken"], (DynamicRental) );
            if(renterToken.rentIsValid() == false){//burn the rent
                renterToken.burn(1);
                extensionsData["Extension_renterSet"] = abi.encode(false);
            }
        }
        return true;
    }

    function startRent(bytes memory params /*address[] memory rentersList, uint rentTime*/)
    public {
        //bytes memory vars = extensionsData["Extension"];
        //require(compareStrings(string(vars) ,string("")) , "Rental Already set");
        (address[] memory renters, uint time) = abi.decode(params, (address[], uint));
        //_owner = renters[9];
        //extensionsData["msgssender"] = abi.encode(msg.sender);
        //address msgSender = abi.decode(extensionsData["msgSender"], (address));
        //_owner = msg.sender;
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        DynamicRental renterToken = new DynamicRental("Rental Token", "Rent", msg.sender, renters, time);
        renterToken = DynamicRental(abi.decode( initialData( "Extension_renterToken", abi.encode( address(renterToken) ) ) , (address)) );
        require(renterSet == false || (renterToken.rentIsValid() == false), "This ownership is already rented");
        require(msg.sender == _owner, "Error: the owner of the contract must start the rent");
        if(renterSet == true && renterToken.rentIsValid() == false){
            renterToken.burn(1);
            extensionsData["Extension_renterSet"] = abi.encode(false);
        }
        //renterToken.setRent(rentersList, this, rentTime);
        extensionsData["Extension_renterSet"] = abi.encode(true);
        extensionsData["Extension_renterToken"] = abi.encode(address(renterToken));

     //   require(renterSet == false, "This ownership is already rented");
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