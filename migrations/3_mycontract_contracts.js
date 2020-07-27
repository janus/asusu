var MyContract = artifacts.require("MyContract");

module.exports = function (deployer, network, [defaultAccount]) {

    deployer.deploy(MyContract)
};