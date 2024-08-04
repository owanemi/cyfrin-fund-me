## FOUNDRY FUND RAISER

**Crowfunding Smart Contract**

Foundry Fund Raiser allows:

-   multiple addresses to fund our contract
-   only one user to withdraw funds from our contract


## Table of Contents

- Installation
- Usage
- Testing
- Deployment
- Contributing
- License

## Installation
To get started with the Foundry Fund Raiser project, you need to have the following prerequisites installed:
- Foundry

1. Clone the repository: 
   in your terminal enter the following command:
```
git clone https://github.com/owanemi/foundry-fundraiser.git
cd foundry-fundraiser
```

## Usage
To interact with the Foundry Fund Raiser smart contract, follow these steps:

Deploy the contract to your preferred network (e.g., local development network, testnet, or mainnet).

Fund the contract by sending Ether to the contract address.

Withdraw funds from the contract (only the designated user can withdraw funds).

## Testing
To run the tests for the project, use the following command:
```
forge test
```
### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
