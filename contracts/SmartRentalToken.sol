pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartOwnershipToken.sol";

contract SmartRentalToken is ERC20 {
    address private _owner;
    SmartOwnershipToken private _ownerToken;
    mapping (address => bool) public _renters;
    address _mainRenter;
    uint public createdTimestamp;
    uint public _rentTime;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public {
            //_owner = _msgSender();
            createdTimestamp = block.timestamp;
        }

    function setRent(address[] memory rentersList, SmartOwnershipToken owner, uint rentTime) public returns (bool){
        require(_msgSender() == owner.getThis(), "Trying to set the rent from not owner account");
        _mint(owner.getOwner(), 1);
        _owner = owner.getOwner();
        _mainRenter = owner.getOwner();
        for(uint i = 0; i<rentersList.length; i++){
            _renters[rentersList[i]] = true;
        }
        _renters[owner.getOwner()] = true;
        _ownerToken = owner;
        _rentTime = rentTime;

    }

    function returnRent() public {
        require(_msgSender() == _mainRenter, "Error: only mainRenter can return rent");
        _ownerToken.endRentFromRenter();
    }

    function rentIsValid() public view returns (bool){
        return ( _rentTime * 1 minutes >= now - createdTimestamp );
    }

    function mainRenter() public view returns (address){
        return _mainRenter;
    }

    function remainingTime() public view returns (uint){
        return now - createdTimestamp;
    }

    function burn(uint amount) public {
        require(_msgSender() == _mainRenter || _msgSender() == _ownerToken.getThis(), "Trying to burn illegaly");
        _burn(_mainRenter, amount); //TODO : CHANGE AMOUNT TO 1
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(rentIsValid() == true || (rentIsValid() == false && _msgSender() == _owner), "Rent is out of date");
        require(_renters[recipient] == true, "Recipient not allowed in rent");
        require(_msgSender() == _mainRenter || (rentIsValid() == false && _msgSender() == _owner), "Not allowed to make tranfer");
        if(rentIsValid() == false){//return token to owner
            _transfer(_mainRenter, _owner, amount);
        }
        _transfer(_msgSender(), recipient, amount);
        _mainRenter = recipient;
        return true;
    }

    //TODO : CHECK IMPLEMENTATION
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(_renters[recipient] == true, "Recipient not allowed in rent");
        require(sender == _mainRenter, "Not allowed to make transfer");
        require(_msgSender() == _mainRenter, "Not allowed to make transfer in the name of the main renter");//maybe we dont need
        if(rentIsValid() == false){//return token to owner
            _transfer(_mainRenter, _owner, amount);
        }
        _transfer(sender, recipient, amount);
        _mainRenter = recipient;
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
        return false;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
        return false;
    }
}