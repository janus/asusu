const HDWalletProvider = require('@truffle/hdwallet-provider')

module.exports = {
  networks: {
    cldev: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    live: {
      provider: () => {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.RPC_URL)
      },
      network_id: '*',
      // Necessary due to https://github.com/trufflesuite/truffle/issues/1971
      // Should be fixed in Truffle 5.0.17

      //from: 0xe8f9957630AF8d1992FcE8369c4EB7BBD17150A5,
      skipDryRun: true,
    },
  },
  compilers: {
    solc: {
      version: '0.5.0',
    },
  },
}
//0.4.24 version: '0.5.0'
