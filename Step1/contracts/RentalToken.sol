pragma solidity >=0.4.25 <0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
contract RentalToken is ERC20 {
    mapping (address => bool) public _renters;
    uint public _createdTimestamp;
    uint public _rentTime; //expressed in minutes

    constructor(string memory name, string memory symbol, address[] memory rentersList, uint time)
        ERC20(name, symbol)
        public {
            _mint(msg.sender, 1);
            for(uint i = 0; i<rentersList.length; i++){
                _renters[rentersList[i]] = true;
            }
            _renters[_msgSender()] = true;
            _createdTimestamp = block.timestamp;
            _rentTime = time;
        }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(_renters[recipient] == true, "Can't transfer the rent to this recipient");
        require(_rentTime * 1 minutes >= now - _createdTimestamp, "Rent is out of date" );
        require(amount == 1, "Require to transfer more than one unit");
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(_renters[recipient] == true, "Can't transfer the rent to this recipient");
        require(_rentTime * 1 minutes >= now - _createdTimestamp, "Rent is out of date" );
        require(amount == 1, "Require to transfer more than one unit");
        _transfer(sender, recipient, amount);
        return true;
    }

}