const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
// const RentalToken = artifacts.require("RentalToken");
// const ExtensionToken = artifacts.require("ExtensionToken");
// const OwnershipToken = artifacts.require("OwnershipToken");
// const SmartRentalToken = artifacts.require("SmartRentalToken");
//const SmartOwnershipToken = artifacts.require("SmartOwnershipToken");
const DynamicOwnership = artifacts.require("DynamicOwnership");
const DynamicRental = artifacts.require("DynamicRental");
//const B = artifacts.require("B");
const ExtensionInfo = artifacts.require("ExtensionInfo");
const Extension = artifacts.require("Extension");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);

  const name = "My car";
  const symbol = "car";
  const amount = 1;
  //const owner, address[] memory rentersList,
  const rentTime = 3;
  //SmartOwnership = new SmartOwnershipToken;
  const randomAddr = '0x36348a6598B4d414cF03dDb1c812CbA8C4a465c1';
  const array = ['0x36348a6598B4d414cF03dDb1c812CbA8C4a465c1']
  //deployer.deploy(OwnershipToken, name, symbol, amount);
  //deployer.deploy(RentalToken, name, symbol);
  
  // deployer.deploy(ExtensionToken);
  // deployer.deploy(SmartOwnershipToken, name , symbol);
  // deployer.deploy(SmartRentalToken, name, symbol);
  deployer.deploy(DynamicOwnership, name, symbol);
  deployer.deploy(DynamicRental, name, symbol, randomAddr, array, rentTime );
  deployer.deploy(ExtensionInfo);
  deployer.deploy(Extension);

};
