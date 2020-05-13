pragma solidity >=0.4.25 <0.7.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartRentalToken.sol";

contract SmartOwnershipToken is ERC20 {
    address private _owner;
    SmartRentalToken private _renterToken;
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

    function getOwner() public view returns (address) {
        return _owner;
    }

    function getRentalToken() public view returns (SmartRentalToken) {
        return _renterToken;
    }

    function hasRenter() public view returns (bool) {
        return _renterSet;
    }
    function getThis() public view returns (address) {
        return address(this);
    }
    function setRenter(SmartRentalToken rentalToken) public onlyOwner {
        require(rentalToken.getOwner() == _owner, "Owner of Rental differs from the owner of OwnerShip");
        require(false == rentalToken.belongsToOwner(), "Trying to set a renter while the Rental has an Ownership");
        require(false == _renterSet, "This ownership is already rented");

        rentalToken.setOwnerContract(this);
        _renterToken = rentalToken;
        _renterSet = true;
    }

    // function setNoRenter() public {
    //     require(_msgSender() == _renterToken, "nj");

    // }
    function sell(address buyer) public onlyOwner returns (bool) { //TODO: add update of the renter!!
        require(_msgSender() == _owner, "The contract doesn't belong to the seller");
        require(false == _renterSet, "This ownership is rented, can't sell it.");
        if( !transferFrom(_msgSender(), buyer, 1)){ //set balances[_msgSender()]-=1 and balances[buyer]+=1
            return false;
        }
        _approve(buyer, buyer, 1);
        _owner = buyer;
        return true;
    }

    // function proofOfOwnership() public view returns (bool){
    //     return (this.balanceOf(_msgSender()) == 1);
    // }
}
