pragma solidity >=0.4.25 <0.7.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartRentalToken.sol";
import "../contracts/ExtensionToken.sol";

contract SmartOwnershipToken is ERC20 {
    address public _owner;
    uint256 public val;
    SmartRentalToken private _renterToken;
    bool private _renterSet;
    mapping (string => ExtensionToken) public extensions;
    //list of param;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {
        _mint(_msgSender(), 1);
        _owner = _msgSender();
        _renterSet = false;
        val = 0;
    }
    modifier onlyOwner {
            require(_msgSender() == _owner, "Not owner call");
            _;
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function getRentalToken() public view returns (address) {
        return address(_renterToken);
    }

    function hasRenter() public view returns (bool) {
        return _renterSet;
    }
    function getThis() public view returns (address) {
        return address(this);
    }
    function startRent(address[] memory rentersList, uint rentTime) public onlyOwner {
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
    }

    function addExtension(string memory extensionName, ExtensionToken extension) public {
        extensions[extensionName] = extension;
    }
   // event AddedValuesByDelegateCall(uint256 a, uint256 b, bool success);

    function invokeExtension(address extension /*string memory extensionName, list of params*/)
    public
    returns (uint256){//without parameter
        uint256 res;
        //updata list of param;
     //   return  extensions[extensionName].delegatecall(bytes4(keccak256("function1()")));

        (bool success, bytes memory result) = extension.delegatecall(abi.encodeWithSignature("deco(uint256)", 10));
        //emit AddedValuesByDelegateCall(a, b, success);
        _renterSet = success;
        res = abi.decode(result, (uint256));
        return res;
    }

    //TODO : CHECK IMPLEMENTATION
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(spender == address(0), "sstma");
        require(amount == 0, "sstma");
        return false;
    }

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
}
