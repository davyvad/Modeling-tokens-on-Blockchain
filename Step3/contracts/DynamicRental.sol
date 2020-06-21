pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/DynamicOwnership.sol";

contract DynamicRental is ERC20 {
    address private _owner;
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
        require(amount == 1, "Rental :More than 1 token to burn");
        _burn(_mainRenter, amount); //TODO : CHANGE AMOUNT TO 1
    }

    function beforeTransfer(address sender, address recipient, uint256 amount)
    public
    view
    returns(bool)
    {
        if(rentIsValid() == true && _msgSender() != _mainRenter )
            require(false, "Rent is still valid, only mainRenter can transfer");
        if(rentIsValid() == true && _renters[recipient] != true )
            require(false, "Rent is still valid but recipient isn't valid");
        if(rentIsValid() == false && _msgSender() != _mainRenter )
            require(false, "Rent isn't valid, only owner can transfer it");
        if(rentIsValid() == false && recipient != _owner )
            require(false, "Rent isn't valid, you can only transfer it to owner");

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
        //if(false == rentIsValid())
          //  _approve(_mainRenter, _owner, 1); // Set allowances[mainRenter][owner] = 1
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