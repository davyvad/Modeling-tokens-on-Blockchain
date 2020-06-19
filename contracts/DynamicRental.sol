pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/DynamicOwnership.sol";

contract DynamicRental is ERC20 {
    address private _owner;
    DynamicOwnership private _ownerToken;//to remove??
    mapping (address => bool) public _renters;
    address _mainRenter;
    uint public createdTimestamp;
    uint public _rentTime;

    constructor(string memory name, string memory symbol, address owner, address[] memory rentersList, uint rentTime)
        ERC20(name, symbol)
        public {
            _owner = owner;
            for(uint i = 0; i<rentersList.length; i++){
                _renters[rentersList[i]] = true;
            }
            _mainRenter = owner;
            createdTimestamp = block.timestamp;
            _rentTime = rentTime;
            _mint(owner, 1);

        }

  /*  function setRent(address[] memory rentersList, DynamicOwnership owner, uint rentTime) public returns (bool){
        //to add: require(_msgSender() == owner.getThis(), "Trying to set the rent from not owner account");
        //to add: _mint(owner.getOwner(), 1);
        //to add: _owner = owner.getOwner();
        //to add: _mainRenter = owner.getOwner();
        for(uint i = 0; i<rentersList.length; i++){
            _renters[rentersList[i]] = true;
        }
        //to add: _renters[owner.getOwner()] = true;
        _ownerToken = owner;
        _rentTime = rentTime;

    }*/

    function returnRent() public view{
        require(_msgSender() == _mainRenter, "Error: only mainRenter can return rent");
        //_ownerToken.endRentFromRenter();
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
        //to add: require(_msgSender() == _mainRenter || _msgSender() == _ownerToken.getThis(), "Trying to burn illegaly");
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
        require(spender == address(0), "sstma");
        require(amount == 0, "sstma");
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(_renters[recipient] == true, "Recipient not allowed in rent");
        require(sender == _mainRenter, "Not allowed to make transfer");
        require(_msgSender() == _mainRenter, "Not allowed to make transfer in the name of the main renter");//maybe we dont need
        if(rentIsValid() == false){//return token to owner
            _transfer(_mainRenter, _owner, amount);
            return true;
        }
        _transfer(sender, recipient, amount);
        _mainRenter = recipient;
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
        require(spender == address(0), "sstma");
        require(addedValue == 0, "sstma");
        return false;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
        require(spender == address(0), "sstma");
        require(subtractedValue == 0, "sstma");
        return false;
    }
}