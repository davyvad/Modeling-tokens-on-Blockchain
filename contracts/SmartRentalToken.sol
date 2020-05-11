pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartOwnershipToken.sol";

contract SmartRentalToken is ERC20 {
    // address private owner;
    SmartOwnershipToken private _ownerToken;
    // bool private ownerSet;

    constructor(string memory name, string memory symbol)//, SmartOwnershipToken _owner)
        ERC20(name, symbol)
        public {
            _mint(msg.sender, 1);
            _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
            //_ownerToken = _owner;
            // _ownerToken.setRenter(this);
            // ownerSet = false;
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

        function getOwner() public view returns (SmartOwnershipToken){
            return _ownerToken;
        }

        function setOwner(SmartOwnershipToken _owner) public {
            _ownerToken = _owner;
            _ownerToken.setRenter(this);
            // ownerSet = true;
        }

        function changeOwnership(address buyer) public returns (bool){
            if( ! transferFrom(_msgSender(), buyer, 1))       //set allowances[msgSender][recipient] = 0 and balances
            {
                return false;
            }
            _approve(buyer, buyer, 0); //set allowances[recipient][recipient] = 0
            _approve(buyer, _msgSender(), 1); //set allowances[recipient][msgSender] = 1
        }

        // function ProofOfRent() public view {
        //     return ((allowance(_msgSender(), _msgSender()) == 1) && (balanceOf(_msgSender()) == 1));
        // }
}