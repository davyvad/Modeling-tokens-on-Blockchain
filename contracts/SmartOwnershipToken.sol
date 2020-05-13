pragma solidity >=0.4.25 <0.7.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartRentalToken.sol";

contract SmartOwnershipToken is ERC20 {
    address private _owner;
    SmartRentalToken private _renter;
    bool private _renterSet;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {
        _mint(_msgSender(), 1);
        //_setupDecimals(1);
        _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
        _owner = _msgSender();
        //renter is by default set to 0
        _renterSet = false;
    }
    modifier onlyOwner {
            require(_msgSender() == _owner, "Not owner call");
            _;
    }

    function getOwner2() public view returns (address) {
        return _owner;
    }
    function setRenter(SmartRentalToken rentalToken) public onlyOwner {
        require(rentalToken.getOwnerToken() == this, "Trying to set a renter while owner is not matching");
        require(rentalToken.getOwner() == _owner, "Owner of Rental differs from the owner of OwnerShip");
        _renter = rentalToken;
        _renterSet = true;
    }

    function sell(address buyer) public returns (bool) { //TODO: add update of the renter!!
        require(_msgSender() == _owner, "The contract doesn't belong to the seller");
        require(false = _renterSet, "This ownership is rented, can't sell it.");
        if(_renterSet){
            //require(_renter.allowance(_msgSender(), _msgSender()) == 1,"The contract is in rent, you can't sell it");
        }
        if( !transferFrom(_msgSender(), buyer, 1)){ //set balances[_msgSender()]-=1 and balances[buyer]+=1
            return false;
        }
        _owner = buyer;
        return true;
    }

    function setNoRent() public {
        renterSet = false;
    }

    // function proofOfOwnership() public view returns (bool){
    //     return (this.balanceOf(_msgSender()) == 1);
    // }
}
