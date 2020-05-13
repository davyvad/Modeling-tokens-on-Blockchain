pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartOwnershipToken.sol";

contract SmartRentalToken is ERC20 {
    address private _owner;
    SmartOwnershipToken private _ownerToken;
    // bool private ownerSet;

    constructor(string memory name, string memory symbol) //, address owner)
        ERC20(name, symbol)
        public {
            //require(msg.sender == owner.getOwner(), "Not the owner call");
            _mint(msg.sender, 1);
            _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
            //_ownerToken = owner;
            _owner = _msgSender();
            _ownerToken = 0;
            // ownerSet = false;
        }

        modifier onlyOwner {
            require(_msgSender() == _owner, "Not owner call");
            _;
        }

        function rent_begin(address recipient) public returns (bool){
            // require(ownerSet == true, "No owner for the SmartRental contract");
            if( ! transferFrom(_msgSender(), recipient, 1))       //set allowances[msgSender][recipient] = 0
            {
                return false;
            }
            _approve(recipient, recipient, 0); //set allowances[recipient][recipient] = 0
            _approve(recipient, _msgSender(), 1); //set allowances[recipient][msgSender] = 1
            return true;
        }

        function rent_end(address owner) public returns (bool) { //the renter ends the rent
            // require(ownerSet == true, "No owner for the SmartRental contract");
            if ( !transferFrom(_msgSender(), owner, 1)) {       //set allowances[msgSender][owner] = 0
                return false;
            }
            _approve(owner, owner, 1); //set allowances[owner][owner] = 1
            _ownerToken.setNoRent();
        }

        function getOwnerToken() public view returns (SmartOwnershipToken){
            return _ownerToken;
        }

        function getOwner() public view returns (address){  //this fn is view in order to return the address only
            return _owner;
        }

        function setOwnerContract(SmartOwnershipToken ownerToken) public {
            require(ownerToken.getOwner2() == _owner, "setOwnerContract : Not owner call");
            ownerToken.getOwner2();
            _ownerToken = ownerToken;
        }

        function setOwner(address owner) public{
            require(_msgSender() == _owner, "setOwner : Not an owner call22");
            _owner = owner;
            //_ownerToken.setRenter(this);
            // ownerSet = true;
        }

        function changeOwnership(address buyer) public returns (bool){
            //require(_msgSender() == _ownerToken., "not the owner call");
            if( ! transferFrom(_msgSender(), buyer, 1))       //set allowances[msgSender][recipient] = 0 and balances
            {
                return false;
            }
            _approve(buyer, buyer, 1); //set allowances[recipient][recipient] = 0
            _approve(buyer, _msgSender(), 0); //set allowances[recipient][msgSender] = 1
        }

        // function ProofOfRent() public view {
        //     return ((allowance(_msgSender(), _msgSender()) == 1) && (balanceOf(_msgSender()) == 1));
        // }
}