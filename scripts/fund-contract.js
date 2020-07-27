const MyContract = artifacts.require('MyContract')
const { LinkToken } = require('@chainlink/contracts/truffle/v0.4/LinkToken')

/*
  This script is meant to assist with funding the requesting
  contract with LINK. It will send 1 LINK to the requesting
  contract for ease-of-use. Any extra LINK present on the contract
  can be retrieved by calling the withdrawLink() function.
*/

const payment = process.env.TRUFFLE_CL_BOX_PAYMENT || '1000000000000000000'

module.exports = async callback => {
  
  const mc = await MyContract.deployed() //0x20fe562d797a42dcb3399062ae9546cd06f63280
  console.log(mc.address)
  const tokenAddress =  0x20fE562d797A42Dcb3399062AE9546cd06f63280  //await mc.getChainlinkToken()
  console.log("funding one")
  console.log(LinkToken.at)
  const token = await LinkToken.at(tokenAddress)
  console.log('Funding contract:', mc.address)
  const tx = await token.transfer(mc.address, payment)
  callback(tx.tx)
}
