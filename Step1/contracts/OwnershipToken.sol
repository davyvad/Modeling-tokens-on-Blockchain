pragma solidity >=0.4.25 <0.7.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract OwnershipToken is ERC20 {
    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {
        _mint(_msgSender(), 1);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(this.balanceOf(_msgSender()) == 1, "No permission to make transfer");
        require(amount == 1, "Require to transfer more than one unit");
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(amount == 1, "Require to transfer more than one unit");
        _transfer(sender, recipient, amount);
        return true;
    }

}

