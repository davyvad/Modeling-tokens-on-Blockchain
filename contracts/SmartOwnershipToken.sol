pragma solidity >=0.4.25 <0.7.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../contracts/SmartRentalToken.sol";

contract SmartOwnershipToken is ERC20 {

    SmartRentalToken private renter;
    bool private renterSet;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {
        _mint(_msgSender(), 1);
        //_setupDecimals(1);
        _approve(_msgSender(), _msgSender(), 1); //set allowances[msgSender][msgSender] = 1
        //renter is by default set to 0
        renterSet = false;
    }

    function setRenter(SmartRentalToken new_renter) public {
        require(new_renter.getOwner() == this, "Trying to set a renter while owner is not matching");
        renter = new_renter;
        renterSet = true;
    }

    function sell(address buyer) public returns (bool) { //TODO: add update of the renter!!
        // require(_msgSender() == this.address, "The contract doesn't belong to the seller");
        if(renterSet){
            require(renter.allowance(_msgSender(), _msgSender()) == 1,"The contract is in rent, you can't sell it");
        }
        if( !transferFrom(_msgSender(), buyer, 1)){ //set balances[_msgSender()]-=1 and balances[buyer]+=1
            return false;
        }
        _approve(_msgSender(),_msgSender(),0); // set allowances[msgSender][msgSender]=0
        _approve(buyer, buyer, 1); //set allowances[buyer][buyer] = 1
        if(renterSet){
            return renter.changeOwnership(buyer);
        }
        return true;
    }

    function setNoRent() public {
        renterSet = false;
    }

    // function proofOfOwnership() public view returns (bool){
    //     return (this.balanceOf(_msgSender()) == 1);
    // }
}
