pragma solidity ^0.6.0;
import "../contracts/SmartRentalToken.sol";
import "../contracts/Origin.sol";


// contract ExtentionInfo {
//     enum ExtType {Precondition, Postcondition }

//     struct Extension {
//         string methodSignature; // The method which is extended in Origin token
//         ExtType _type;
//         string extensionSignature; // The method which is called on delegatecall

//     }
//     Extension[] public ExtentedFunctions;
//     uint256 public numExtensions;
// }
// NOTE: Deploy this contract first
contract B {
    string public sign;
    address public _owner;
    bytes4 public val;
    SmartRentalToken private _renterToken;
    bool public _renterSet;
    // NOTE: storage layout must be the same as contract A

    enum ExtType {Precondition, Postcondition, Method }

    struct Extension {
        string methodSignature; // The method which is extended in Origin token
        ExtType _type;
        string extensionSignature; // The method which is called on delegatecall

    }
    Extension[] public ExtentedFunctions;
    uint256 public numExtensions;
    A public origin;

    constructor() public
    {
        sign = "bla";
        numExtensions = 1;
        ExtentedFunctions.push(Extension(   "setVars(string memory _sign)",
                                            ExtType.Precondition,
                                            "setVarsPrecond(string memory _sign)"));
        ExtentedFunctions.push(Extension(   "setVars(string memory _sign)",
                                            ExtType.Postcondition,
                                            "setVarsPostcondition(string memory _sign)"));

        //ExtentedFunctions[0] = Extension ("setVars(string memory _sign)", ExtType.Precondition);
    }

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

    function setA(address _t) public {
        origin = A(_t);
    }
    function decod() public view returns(address, uint) {
        address str;
        uint res;
        bytes memory bb = origin.getMapElement(1);
        (str, res) = abi.decode(bb, (address, uint));
        return (str, res);
    }
}