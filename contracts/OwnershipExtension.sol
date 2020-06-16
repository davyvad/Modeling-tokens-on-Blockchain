pragma solidity ^0.6.0;
import "../contracts/ExtensionInfo.sol";

// NOTE: Deploy this contract first
contract OwnershipExtension is ExtensionInfo{
    //address[] extensions;
    string[] extensionsNames;
    mapping (string => OwnershipExtension) extensions;
    //mapping (string => address) public extensions;
    mapping (string => bytes) informations;
    event setValFunc();

    bool public success;

    constructor()
    ExtensionInfo()
    public
    {
        success = false;
    }

    function setVal() public{
        val = 3;
        emit setValFunc();
    }
    function getVal()public view returns (uint256){
        return val;
    }
/*
    function startRent(address[] memory rentersList, uint rentTime) public {
        require(_msgSender() == _owner, "Not owner call");
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
*/
  
  
  /*  function setVarsPrecondition(string memory _sign) public payable {
        require(compareStrings(_sign, "compareStrings (string, string)"), "Bad signature");
        sign = _sign;
        _owner = msg.sender;
        val = msg.sig;
    }

    function setVarsPostcond(string memory _sign) public payable {
        require(compareStrings(_sign, "compareStrings (string, string)"), "Bad signature");
        sign = _sign;
        _owner = msg.sender;
        val = msg.sig;
    }
    // function setNum(uint256 np) private {
    //     num = np;
    // }
    function compareStrings (string memory a, string memory b)
    public pure
    returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );

       }*/
}