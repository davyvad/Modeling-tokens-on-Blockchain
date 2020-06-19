pragma solidity ^0.6.0;
import "../contracts/ExtensionInfo.sol";
import "../contracts/DynamicOwnership.sol";
import "../contracts/DynamicRental.sol";

// NOTE: Deploy this contract first
contract Extension is ExtensionInfo {
    constructor() public
    {
        sign = "bla";
        ExtendedFunctions.push(Extension(   "startRent",
                                            ExtType.Invokation,
                                            "startRent(bytes)"));

        ExtendedFunctions.push(Extension(   "transfer",
                                            ExtType.Precondition,
                                            "transferPreCond(bytes)")); 
        ExtendedFunctions.push(Extension(   "transfer",
                                            ExtType.Postcondition,
                                            "transferPost(bytes)"));            
        ExtendedFunctions.push(Extension(   "transferFrom",
                                            ExtType.Precondition,
                                            "transferFromPreCond(bytes)")); 
        ExtendedFunctions.push(Extension(   "transferFrom",
                                            ExtType.Postcondition,
                                            "transferFromPost(bytes)"));       
/*
        ExtendedFunctions.push(Extension(   "burn",
                                            ExtType.Precondition,
                                            "burnPreCond(bytes)")); 
        ExtendedFunctions.push(Extension(   "burn",
                                            ExtType.Postcondition,
                                            "burnPost(bytes)"));    */                                                                                 
        //ExtentedFunctions[0] = Extension ("setVars(string memory _sign)", ExtType.Precondition);
        numExtensions = ExtendedFunctions.length;
    }

    modifier onlyOwner {
        require(_msgSender() == _owner,  "Extention Error: the owner of the contract must start the rent");
        _;
    }

    function setSign()
    public
    {
        sign = "bloiii";
    }

    function transferPreCond(bytes memory params) public
     returns (bool) {
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        
        (address recipient, uint256 amount) = abi.decode(params, (address, uint256));

        require(amount == 1, "Requesting tranfer for more than one unit");
        //require(renterSet == false || (renterToken.rentIsValid() == false), "Error: the item is on rent");
        if(renterSet == true ){
            DynamicRental renterToken = DynamicRental(abi.decode( extensionsData["Extension_renterToken"], (address) ));
            require(renterToken.rentIsValid() == false, "Error: the item is on rent");
        } else {
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

    function transferFromPreCond(bytes memory params) 
    public
    onlyOwner
    returns (bool) {
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
       
        (address sender, address recipient, uint256 amount) = abi.decode(params, (address, address, uint256));
        require(amount == 1, "Requesting tranfer for more than one unit");
        //require(renterSet == false || (renterToken.rentIsValid() == false), "Error: the item is on rent");
        if(renterSet == true ){
            DynamicRental renterToken = DynamicRental(abi.decode( extensionsData["Extension_renterToken"], (address) ));
            require(renterToken.rentIsValid() == false, "Error: the item is on rent");
        }else{
            require(renterSet == false , "Error: the item is on rent"); //not really needed actually
        }
        return true;
    }
/*
    function transferFromPost(bytes memory params)public returns (bool){
        //variables
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        //DynamicRental renterToken = abi.decode( initialData( "Extension_renterToken", abi.encode(new DynamicRental("Rental Token", "Rent", msg.sender, renters, time) ) ) , (DynamicRental));

        //parameters
        (address sender, address recipient, uint256 amount) = abi.decode(params, (address, address, uint256));

        _owner = recipient;
        if(renterSet == true ){
            DynamicRental renterToken = abi.decode( extensionsData["Extension_renterToken"], (DynamicRental) );
            if(renterToken.rentIsValid() == false){//burn the rent
                renterToken.burn(1);
                extensionsData["Extension_renterSet"] = abi.encode(false);
            }
        }
        return true;
    }*/
/*
    function burnPreCond(bytes memory params) public returns(bool){
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        
        (uint256 amount) = abi.decode(params, (uint256));

        require(_msgSender() == _owner, "Trying to burn illegaly");

        if(renterSet == true ){
            DynamicRental renterToken = abi.decode( extensionsData["Extension_renterToken"], (DynamicRental) );
            require((renterToken.rentIsValid() == false) || (renterToken.mainRenter() == _owner), "Error: the item is on rent");
            renterToken.burn(1);
            extensionsData["Extension_renterSet"] = abi.encode(false);
        }else{
            require(renterSet == false , "Error: the item is on rent"); //not really needed actually
        }

    }

    function burnPost(bytes memory params) public returns (bool){
        return true;
    }
*/
    /* 
        params encodes: (address[] memory rentersList, uint rentTime)
    */
    function startRent(bytes memory params )
    public 
    onlyOwner
    {
        DynamicRental renterToken;
        address renterTokenAddress;
        bool renterSet;
        //require(compareStrings(string(vars) ,string("")) , "Rental Already set");
        (address[] memory renters, uint time) = abi.decode(params, (address[], uint));
        //extensionsData["msgssender"] = abi.encode(msg.sender);
        //address msgSender = abi.decode(extensionsData["msgSender"], (address));

        renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        require(renterSet == false , "This ownership is already rented");
        renterTokenAddress = abi.decode( initialData( "Extension_renterToken", abi.encode(address(0)) ), (address));
        if(address(0) == renterTokenAddress)
            renterToken = new DynamicRental("Rental Token", "Rent", msg.sender, renters, time);
        else {
            renterToken = DynamicRental(renterTokenAddress);
            require(renterToken.rentIsValid() == false, "The rentalToken is still valid");
        }
        if(renterSet == true && renterToken.rentIsValid() == false){
            renterToken.burn(1);
            extensionsData["Extension_renterSet"] = abi.encode(false);
        }
        //renterToken.setRent(rentersList, this, rentTime);
        extensionsData["Extension_renterSet"] = abi.encode(true);
        extensionsData["Extension_renterToken"] = abi.encode(address(renterToken));
    }
}