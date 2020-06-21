const DynamicOwnership = artifacts.require("DynamicOwnership");
const DynamicRental = artifacts.require("DynamicRental");
const ExtensionInfo = artifacts.require("ExtensionInfo");
const Extension = artifacts.require("Extension");

module.exports = function(deployer) {
  const name = "My car";
  const symbol = "car";
  const amount = 1;
  const rentTime = 3;
  const randomAddr = '0x36348a6598B4d414cF03dDb1c812CbA8C4a465c1';
  const array = ['0x36348a6598B4d414cF03dDb1c812CbA8C4a465c1']

  deployer.deploy(DynamicOwnership, name, symbol);
  deployer.deploy(DynamicRental, name, symbol, randomAddr, array, rentTime );
  deployer.deploy(ExtensionInfo);
  deployer.deploy(Extension);
};
