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
            createdTimestamp = now; //block.timestamp;
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
        require(amount == 1, "Rental :More than 1 token to burn");
        _burn(_mainRenter, amount); //TODO : CHANGE AMOUNT TO 1
    }

    function beforeTransfer(address sender, address recipient, uint256 amount)
    public
    //view
    returns(bool)
    {
        if(rentIsValid() == true && (_msgSender() != _mainRenter || _renters[recipient] != true ))
            require(false, "Rent is still valid, only mainRenter can transfer");
        if(rentIsValid() == true && _renters[recipient] != true )
            require(false, "Rent is still valid but recipient isn't valid");
        if(rentIsValid() == false && (_msgSender() != _owner || sender != _msgSender()))
            require(false, "Rent isn't valid, only owner can transfer it");
        if(rentIsValid() == false && recipient != _owner )
            require(false, "Rent isn't valid, you can only transfer it to owner");

        /*require((rentIsValid() == true && _msgSender() == _mainRenter && _renters[recipient] == true ) ||
                (rentIsValid() == false && _msgSender() == _owner && recipient == _owner && sender == _msgSender()),
                "Rent is out of date or cannot transfer valid rental"   ); */
        require(1 == amount, "Amount is more than 1");
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        beforeTransfer(_msgSender(), recipient,amount);
        _transfer(_msgSender(), recipient, amount);
        _mainRenter = recipient;
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        beforeTransfer(sender, recipient,amount);
        _transfer(sender, recipient, amount);
        _mainRenter = recipient;
        return true;
    }

    //TODO : CHECK IMPLEMENTATION
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(spender == address(0), "sstma");
        require(amount == 0, "sstma");
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