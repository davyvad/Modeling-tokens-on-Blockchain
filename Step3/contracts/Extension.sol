pragma solidity ^0.6.0;
import "../contracts/ExtensionInfo.sol";
import "../contracts/DynamicOwnership.sol";
import "../contracts/DynamicRental.sol";

// NOTE: Deploy this contract first
contract Extension is ExtensionInfo {
    constructor() public
    {
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

        ExtendedFunctions.push(Extension(   "burn",
                                            ExtType.Precondition,
                                            "burnPreCond(bytes)")); 
        ExtendedFunctions.push(Extension(   "burn",
                                            ExtType.Postcondition,
                                            "burnPost(bytes)"));
        //ExtentedFunctions[0] = Extension ("setVars(string memory _sign)", ExtType.Precondition);
        numExtensions = ExtendedFunctions.length;
    }

    modifier onlyOwner {
        require(msg.sender == _owner,  "Extention Error: the owner of the contract must start the rent");
        _;
    }

    function transferPreCond(bytes memory params)
    public 
    returns (bool) {
        _checkRentalStatus();
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        (address recipient, uint256 amount) = abi.decode(params, (address, uint256));
        //require(renterSet == false || (renterToken.rentIsValid() == false), "Error: the item is on rent");
        if(renterSet == true ){
            DynamicRental renterToken = DynamicRental(abi.decode( extensionsData["Extension_renterToken"], (address) ));
            require(renterToken.rentIsValid() == false, "Error: the item is on rent");
        }
        return true;
    }

    function transferFromPreCond(bytes memory params) 
    public
    returns (bool) {
        _checkRentalStatus();
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        if(true == renterSet){
            DynamicRental renterToken = DynamicRental(abi.decode( extensionsData["Extension_renterToken"], (address) ));
            require(renterToken.rentIsValid() == false, "Error: the item is on rent");
        }
        return true;
    }


    function burnPreCond() public returns(bool){
        _checkRentalStatus();
        //bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        uint temp = 33;
        if(temp== 0){
            return false;
        }
        bool renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
       require(msg.sender == _owner, "Trying to burn illegaly");

        if(true == renterSet ){
            DynamicRental renterToken = DynamicRental(abi.decode( extensionsData["Extension_renterToken"], (address) ));
            require((renterToken.rentIsValid() == false) || (renterToken.mainRenter() == _owner), "Error: the item is on rent");
            renterToken.burn(1);
            extensionsData["Extension_renterSet"] = abi.encode(false);
        }
        return true;
    }

    function burnPost(bytes memory params) public returns (bool){
        return true;
    }

   function transferFromPost(bytes memory params)
    public pure
    returns (bool){
        return true;
    }

    function transferPost(bytes memory params)public pure returns (bool){
        return true;
    }

    function _checkRentalStatus()
    private
    returns(bool)
    {
        DynamicRental renterToken;
        address renterTokenAddress;
        bool renterSet;
        renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        renterTokenAddress = abi.decode( initialData( "Extension_renterToken", abi.encode(address(0)) ), (address));
        if(address(0) != renterTokenAddress) {
            renterToken = DynamicRental(renterTokenAddress);
            if(renterToken.rentIsValid() == false) {
                renterToken.burn(1);
                extensionsData["Extension_renterSet"] = abi.encode(false);
                extensionsData["Extension_renterToken"] = abi.encode(address(0));
                return true;
            }
            return false;
        }
    }
    /* 
        params should encodes: (address[] memory rentersList, uint rentTime)
    */
    function startRent(bytes memory params )
    public 
    onlyOwner
    {
        DynamicRental renterToken;
        address renterTokenAddress;
        bool renterSet;
        (address[] memory renters, uint time) = abi.decode(params, (address[], uint));

        _checkRentalStatus();
        renterSet = abi.decode(initialData("Extension_renterSet", abi.encode(false)), (bool));
        require(renterSet == false , "This ownership is already rented");
        renterTokenAddress = abi.decode( initialData( "Extension_renterToken", abi.encode(address(0)) ), (address));
        if(address(0) == renterTokenAddress){
            require(false == renterSet,"Extension : rentalToken is null but renterSet is true");
            renterToken = new DynamicRental("Rental Token", "Rent", msg.sender, renters, time);
        } else {
            renterToken = DynamicRental(renterTokenAddress);
            require(renterToken.rentIsValid() == false, "The rentalToken is still valid");
        }
        if(renterSet == true && renterToken.rentIsValid() == false) {
            renterToken.burn(1);
            extensionsData["Extension_renterSet"] = abi.encode(false);
        }
        //renterToken.setRent(rentersList, this, rentTime);
        extensionsData["Extension_renterSet"] = abi.encode(true);
        extensionsData["Extension_renterToken"] = abi.encode(address(renterToken));
    }
}