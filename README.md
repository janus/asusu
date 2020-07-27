# Chainlink Truffle Box

Implementation of a [Chainlink requesting contract](https://docs.chain.link/docs/create-a-chainlinked-project).

## Requirements

- NPM

## Installation

Package installation should have occurred for you during the Truffle Box setup. However, if you add dependencies, you'll need to add them to the project by running:

```bash
npm install
```

Or

```bash
yarn install
```

## Test

```bash
npm test
```

## Deploy

If needed, edit the `truffle-config.js` config file to set the desired network to a different port. It assumes any network is running the RPC port on 8545.

```bash
npm run migrate:dev
```

For deploying to live networks, Truffle will use `truffle-hdwallet-provider` for your mnemonic and an RPC URL. Set your environment variables `$RPC_URL` and `$MNEMONIC` before running:

```bash
npm run migrate:live
```


Truffle v5.0.25 (core: 5.0.25)
Node v14.16.3
```


contract address: 0xe66f27cf79a74d90744ddf93caec61ad810cc6a3