pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "/Users/davidvalensi/Documents/TECHNION/Blockchain/MetaCoin/contracts/OwnershipToken.sol";

contract SmartRentalToken is ERC20 {
    address private owner;
    OwnershipToken private ownerToken;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public {
            _mint(msg.sender, 1);
            _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
            owner = _msgSender();
            ownerToken = new OwnershipToken(name, symbol, 1);
        }

        function rent_begin(address recipient) public returns (bool){
            if( ! transferFrom(_msgSender(), recipient, 1))       //set allowances[msgSender][recipient] = 0
            {
                return false;
            }
            _approve(recipient, recipient, 0); //set allowances[recipient][recipient] = 0
            _approve(recipient, _msgSender(), 1); //set allowances[recipient][msgSender] = 1
            return true;
        }

        function rent_end(address recipient) public returns (bool) {
            if ( !transferFrom(recipient, _msgSender(), 1)) {       //set allowances[recipient][msgSender] = 0
                return false;
            }
            _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
        }


}