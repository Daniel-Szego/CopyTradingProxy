const CopyTradingProxy = artifacts.require("CopyTradingProxy");

module.exports = function(deployer) {
  deployer.deploy(CopyTradingProxy);
};
