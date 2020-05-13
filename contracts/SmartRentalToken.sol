pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartOwnershipToken.sol";

contract SmartRentalToken is ERC20 {
    address private _rentalOwner;
    SmartOwnershipToken private _ownerToken;
    bool private _ownerSet;

    constructor(string memory name, string memory symbol) //, address owner)
        ERC20(name, symbol)
        public {
            //require(msg.sender == owner.getOwner(), "Not the owner call");
            _mint(msg.sender, 1);
            _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
            //_ownerToken = owner;
            _rentalOwner = _msgSender();
            //_ownerToken = 0;
            _ownerSet = false;
        }

        modifier onlyOwner {
            require(_msgSender() == _rentalOwner, "Not owner call");
            _;
        }

        function rent_begin(address recipient) public returns (bool){
            // msgSender is owner of the token
            require(_ownerSet == true, "No owner for the SmartRental contract");
            require(_msgSender() == _ownerToken.getOwner(), "Trying to start a rent by someone else than the owner");
            if( ! transferFrom(_msgSender(), recipient, 1))       //set balance[owner] = 0 and balance[recipient]=1
            {                                                     // and allowance[owner][owner] = 0
                return false;
            }
            _approve(_msgSender(), recipient, 0); //set allowances[owner][recipient] = 0
            _approve(recipient, recipient, 1); //set allowances[recipient][recipient] = 1
            return true;
        }

        function rent_end() public returns (bool) { //the renter ends the rent
            // msgSender is the renter
            require(_ownerSet == true, "No owner for the SmartRental contract");
            require(balanceOf(_msgSender()) == 1, "Trying to end rent from a non renter");
            if ( !transferFrom(_msgSender(), _rentalOwner, 1))     //set balance[renter] = 0 and balance[owner]=1
            {                                               //set allowances[renter][renter] = 0
                return false;
            }
            _approve(_rentalOwner, _rentalOwner, 1); //set allowances[owner][owner] = 1
            _approve(_msgSender(), _rentalOwner, 0); //set allowances[renter][owner]=0
            return true;
        }

        function getOwnerToken() public view returns (SmartOwnershipToken){
            return _ownerToken;
        }

        function getOwner() public view returns (address){  //this fn is view in order to return the address only
            return _rentalOwner;
        }

        function setOwnerContract(SmartOwnershipToken ownerToken) public {
            require(tx.origin == ownerToken.getOwner(), "setOwnerContract : Not owner call");
            require(tx.origin == _rentalOwner, "Owner of rental is not same as owner of Ownership contract");
            _ownerToken = ownerToken;
            _ownerSet = true;
        }

        function changeOwnership(address new_renter) public returns (bool){
            //require(_msgSender() == _ownerToken., "not the owner call");
            if( ! transferFrom(_msgSender(), new_renter, 1))       //set allowances[msgSender][recipient] = 0 and balances
            {
                return false;
            }
            _approve(new_renter, new_renter, 1); //set allowances[recipient][recipient] = 1
            _approve(new_renter, _msgSender(), 0); //set allowances[recipient][msgSender] = 0
        }

        // function ProofOfRent() public view {
        //     return ((allowance(_msgSender(), _msgSender()) == 1) && (balanceOf(_msgSender()) == 1));
        // }
}