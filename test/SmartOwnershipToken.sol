pragma solidity ^0.6.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartRentalToken.sol";
//import "../contracts/OwnershipExtension.sol";
import "../contracts/ExtensionInfo.sol";

contract SmartOwnershipToken is ERC20 {
    //////////////////////////////////////////////////////////////////////////

    address public _owner;
    uint256 public val;
    uint256 public testval;
    //SmartRentalToken private _renterToken;
    bool public _renterSet;
    //address[] extensions;
    string[] extensionsNames;
    mapping (string => OwnershipExtension) extensions;
    //mapping (string => address) public extensions;
    mapping (string => bytes) informations;

    bool public status;


    //list of param;
    function getVal()public view returns (uint256){
        return val;
    }
    function getTestVal()public view returns (uint256){
        return testval;
    }
    function getStatus()public view returns(bool){
        return status;
    }
    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {
        _mint(_msgSender(), 1);
        _owner = _msgSender();
        _renterSet = false;
        val = 0;
        testval =0;
        status =false;
    }

    function check_preconditions() public returns (bool) {
        for (uint j = 0; j < extensionsNames.length; j++){
            OwnershipExtension currentExtension = extensions[extensionsNames[j]];
            uint len = currentExtension.getnumExtensions();
            //(bool a, bytes memory  _len) = currentExtension.call("getnumExtensions()");
            //uint len = bytesToUint(_len);
            for (uint i = 0; i < len; i++){//.getnumExtensions(); i++) {
                (string memory _a, bool precond, string memory extensionSignature, uint256 arguments) = currentExtension.getExtensionIndex(i);
                //call(abi.encodeWithSignature("getExtensionIndex(uint)", i));
                if(precond == true){
      //          _contract.delegatecall(
      //      abi.encodeWithSignature(ExtendedFunctions[i]._extensionSignature, _sign)
      //  );
            testval = 2;
              if(arguments == 0){
                  testval = 3;
                (status, ) = address(extensions[extensionsNames[j]]).delegatecall(abi.encodeWithSignature(extensionSignature));
                testval = 5;
              }else if(arguments == 1){
                address(extensions[extensionsNames[j]]).delegatecall(abi.encodeWithSignature(extensionSignature, informations["parameter1"]));                  
              }else if(arguments == 2){
                address(extensions[extensionsNames[j]]).delegatecall(abi.encodeWithSignature(extensionSignature, informations["parameter1"], informations["parameter2"]));
              }else if(arguments == 3){
                address(extensions[extensionsNames[j]]).delegatecall(abi.encodeWithSignature(extensionSignature, informations["parameter1"], informations["parameter2"], informations["parameter3"]));
              }
          //  _contract.delegatecall(abi.encode(ExtendedFunctions[i]._extensionSignature));
            }
        }
        }
        return true;
    }
/*
    function invokeExtension(string memory _signature, uint256 _arguments) public returns (bool){
        for (uint j = 0; j < extensions.length; j++){
            ExtensionToken currentExtension = extensions[j];
            for (uint i = 0; i < currentExtension.getnumExtensions(); i++) {
                (string storage _a, bool _b, string storage extensionSignature, uint256 arguments) = currentExtension.getExtensionIndex(i);

                if(_signature == extensionSignature && _arguments == arguments){
      //          _contract.delegatecall(
      //      abi.encodeWithSignature(ExtendedFunctions[i]._extensionSignature, _sign)
      //  );
              if(_arguments == 0){
                extensions[j].delegatecall(abi.encodeWithSignature(extensionSignature));
                return true;
              }else if(_arguments == 1){
                extensions[j].delegatecall(abi.encodeWithSignature(extensionSignature, informations["parameter1"]));                  
                return true;
              }else if(_arguments == 2){
                extensions[j].delegatecall(abi.encodeWithSignature(extensionSignature, informations["parameter1"], informations["parameter2"]));
                return true;
              }else if(_arguments == 3){
                extensions[j].delegatecall(abi.encodeWithSignature(extensionSignature, informations["parameter1"], informations["parameter2"], informations["parameter3"]));
                return true;
              }
          //  _contract.delegatecall(abi.encode(ExtendedFunctions[i]._extensionSignature));
            }
        }
        }
        return false;
    }
*/
    modifier onlyOwner {
            require(_msgSender() == _owner, "Not owner call");
            _;
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

/*    function getRentalToken() public view returns (address) {
        return address(_renterToken);
    }
*/
    function hasRenter() public view returns (bool) {
        return _renterSet;
    }
    function getThis() public view returns (address) {
        return address(this);
    }
/*    function startRent(address[] memory rentersList, uint rentTime) public onlyOwner {
        require(_renterSet == false || (_renterToken.rentIsValid() == false), "This ownership is already rented");
        require(_msgSender() == _owner, "Error: the owner of the contract must start the rent");
        if(_renterSet == true && _renterToken.rentIsValid() == false){
            _renterToken.burn(1);
            _renterSet = false;
        }
        _renterToken = new SmartRentalToken(name(), symbol());
        _renterToken.setRent(rentersList, this, rentTime);
        _renterSet = true;
    }

    function endRentFromRenter() public {
        require(_renterSet == true, "The product is not on rent");
        require(_msgSender() == _renterToken.mainRenter(), "Request for end must be from main renter");
        _renterToken.burn(1);
        _renterSet = false;
    }

    function endRentFromOwner() public onlyOwner{
        require(_renterSet == true, "The product is not on rent");
        require(_renterToken.rentIsValid() == false, "Rent is not finished yet");
        _renterToken.burn(1);
        _renterSet = false;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(_renterSet == false || (_renterToken.rentIsValid() == false), "Error: the item is on rent");
        require(_msgSender() == _owner, "Only owner is allowed to make transfer");
        _transfer(_msgSender(), recipient, amount);
        _owner = recipient;
        if(_renterSet == true && _renterToken.rentIsValid() == false){//burn the rent
            _renterToken.burn(1);
            _renterSet = false;
        }
        return true;
    }*/

    function addExtension(string memory extensionName, OwnershipExtension extension) public {
        extensionsNames.push(extensionName);
        extensions[extensionName] = extension;
    }
   // event AddedValuesByDelegateCall(uint256 a, uint256 b, bool success);

   /* function invokeExtension(address extension, string memory _sign)
    public payable
    {
        //without parameter
        //updata list of param;
        //   return  extensions[extensionName].delegatecall(bytes4(keccak256("function1()")));

        (bool success, bytes memory result) = extension.delegatecall(
            abi.encodeWithSignature("invokeExtension(string)", _sign));
        //emit AddedValuesByDelegateCall(a, b, success);
        //_renterSet = success;
        //res = abi.decode(result, (uint256));
    }*/

    //TODO : CHECK IMPLEMENTATION
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(spender == address(0), "sstma");
        require(amount == 0, "sstma");
        return false;
    }
/*
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        // if exist precondition => check
        require(_renterSet == false || (_renterToken.rentIsValid() == false), "Error: the item is on rent");
        require(_msgSender() == _owner, "Only owner is allowed to make transfer");
        require(sender == _owner, "Only owner is allowed to make transfer");
        _transfer(sender, recipient, amount);
        _owner = recipient;
        if(_renterSet == true && _renterToken.rentIsValid() == false){//burn the rent
            _renterToken.burn(1);
            _renterSet = false;
        }
        return true;
    }
 
    function burn(uint amount) public {
        require(_msgSender() == _owner, "Trying to burn illegaly");
        require(_renterSet == false || (_renterToken.rentIsValid() == false) || (_renterToken.mainRenter() == _owner), "Asset is on rent, can't burn");
        if(_renterSet == true){//burn the rent
            _renterToken.burn(1);
            _renterSet = false;
        }
        _burn(_msgSender(), amount); //TODO : CHANGE AMOUNT TO 1
    }
*/
    ////////////////////////////////////////////////////////////////////////////////////////////

}
