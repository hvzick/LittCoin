# LittCoin ERC20 Token

LittCoin is an ERC20 token project built with [Foundry](https://book.getfoundry.sh/), using OpenZeppelin's secure contract library. This repository contains the smart contract, deployment scripts, and tests for LittCoin.

## Contract Details

- **Token Name:** LittCoin
- **Symbol:** LITT
- **Decimals:** 18
- **Initial Supply:** 15,000 LITT (minted to deployer)
- **Contract Address:** [`0x61A398a48BD1eBF24913A63937E8b02dfF5cB68e`](https://sepolia.etherscan.io/address/0x61A398a48BD1eBF24913A63937E8b02dfF5cB68e)

## Project Structure

- `src/LittCoin.sol` — Main ERC20 contract
- `script/DeployLittCoin.s.sol` — Deployment script
- `test/LittCoinTest.t.sol` — Foundry tests

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html) installed

### Build Contracts

```bash
forge build
```

### Run Tests

```bash
forge test
```

### Deploy LittCoin

Update the script or use your own RPC URL and private key:

```bash
forge script script/DeployLittCoin.s.sol:DeployLittCoin --rpc-url <your_rpc_url> --private-key <your_private_key> --broadcast
```


The deployed contract address on Sepolia:

[`0x61A398a48BD1eBF24913A63937E8b02dfF5cB68e`](https://sepolia.etherscan.io/address/0x61A398a48BD1eBF24913A63937E8b02dfF5cB68e)

## Interacting with LittCoin

You can interact with the contract using [Cast](https://book.getfoundry.sh/cast/), Etherscan, or any Ethereum wallet supporting custom tokens.

### Example: Check Balance

```bash
cast call 0x61A398a48BD1eBF24913A63937E8b02dfF5cB68e "balanceOf(address)" <your_address>
```

## Testing

Unit tests are provided in `test/LittCoinTest.t.sol` and cover:

- Transfers
- Approvals and allowances
- Edge cases (reverts, zero address, etc.)

Run all tests with:

```bash
forge test
```

## License

MIT
