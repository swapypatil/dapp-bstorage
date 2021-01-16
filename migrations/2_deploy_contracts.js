var LogsStorage = artifacts.require("./LogsStorage.sol");

module.exports = function(deployer) {
  deployer.deploy(LogsStorage);
};