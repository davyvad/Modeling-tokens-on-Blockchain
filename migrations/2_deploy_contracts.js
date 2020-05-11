const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const RentalToken = artifacts.require("RentalToken");
const OwnershipToken = artifacts.require("OwnershipToken");
const SmartRentalToken = artifacts.require("SmartRentalToken");
const SmartOwnershipToken = artifacts.require("SmartOwnershipToken");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);

  const name = "My car";
  const symbol = "car";
  const amount = 1;
  deployer.deploy(OwnershipToken, name, symbol, amount);
  deployer.deploy(RentalToken, name, symbol);
  deployer.deploy(SmartOwnershipToken, name , symbol);
  deployer.deploy(SmartRentalToken, name, symbol);
  //deployer.deploy(RentalToken, "rental1", "symb");

};
