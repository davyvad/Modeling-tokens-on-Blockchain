const SmartRentalToken = artifacts.require("SmartRentalToken");
const SmartOwnershipToken = artifacts.require("SmartOwnershipToken");

module.exports = function(deployer) {
  const name = "My car";
  const symbol = "car";
  const amount = 1;

  deployer.deploy(SmartOwnershipToken, name , symbol);
  deployer.deploy(SmartRentalToken, name, symbol);
};
