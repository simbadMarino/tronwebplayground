var MyContract = artifacts.require("./BookVotes.sol");

module.exports = function (deployer) {
  deployer.deploy(MyContract);
};
