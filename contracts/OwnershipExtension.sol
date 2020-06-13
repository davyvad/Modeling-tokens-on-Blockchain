pragma solidity ^0.6.0;
import "../contracts/ExtensionInfo.sol";

// NOTE: Deploy this contract first
contract OwnershipExtension is ExtensionInfo{
    string public sign;
    address public _owner;
    bytes4 public val;
    //SmartRentalToken private _renterToken;
    //bool public _renterSet;
    // NOTE: storage layout must be the same as contract A


    
    constructor()
    ExtensionInfo()
    public
    {}

    function setVarsPrecondition(string memory _sign) public payable {
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

       }
}