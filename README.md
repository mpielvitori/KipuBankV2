# KipuBank - Smart Contract

![Solidity](https://img.shields.io/badge/Solidity-^0.8.22-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Description

KipuBank is a smart contract developed in Solidity that simulates a multi-token decentralized bank. It allows users to deposit and withdraw ETH and USDC with implemented security restrictions, including per-transaction limits and global bank capacity.

### Main Features

- **Multi-Token Support**: Support for ETH and USDC with unified USD accounting
- **Price Oracles**: Chainlink integration for real-time ETH/USD conversions
- **Access Control**: Role-based system (Admin/Operator) with OpenZeppelin AccessControl
- **Advanced Security**: Reentrancy protection and comprehensive validations
- **Configurable Limits**: Global capacity and USD withdrawal limits
- **Events and Statistics**: Complete multi-token operation logging

## 🏗️ Contract Architecture

### Key Variables
- `withdrawalLimitUSD` (immutable): Maximum USD per withdrawal
- `bankCapUSD` (immutable): Total bank capacity in USD
- `balances`: User balances mapping by user and token (address(0) = ETH)
- `dataFeed`: Chainlink oracle for ETH/USD prices
- `usdcToken`: USDC contract address

### Main Functions

| Function | Visibility | Description |
|----------|-----------|-------------|
| `deposit()` | external payable | Deposit ETH (converted to USD internally) |
| `depositUSD(amount)` | external | Deposit USDC directly |
| `withdraw(amount)` | external | Withdraw ETH (validated in USD) |
| `withdrawUSD(amount)` | external | Withdraw USDC directly |
| `getUserBalanceUSD(user, token)` | external view | View user USD balance by token |
| `getBankValueUSD()` | external view | View total USD value of bank |
| `getETHPriceUSD()` | external view | View current ETH/USD price |

### Implemented Security
- ✅ **Reentrancy Protection**: OpenZeppelin ReentrancyGuard
- ✅ **Access Control**: Admin/Operator role-based system
- ✅ **CEI Pattern**: Checks-Effects-Interactions properly implemented
- ✅ **Custom Errors**: Specific error types for each validation
- ✅ **Safe Transfers**: Use of `.call()` for ETH and standard ERC20
- ✅ **Oracle Validation**: Verification of valid price data

## 🚀 Deployment on Remix IDE

### Step 1: Preparation
1. Open [Remix IDE](https://remix.ethereum.org)
2. Connect MetaMask to **Sepolia Testnet**
3. Ensure you have test ETH ([Sepolia Faucet](https://faucet.aragua.org/))

### Step 2: Deploy Auxiliary Contracts
1. Compile and deploy `Circle.sol` (USDC stub)
2. Compile and deploy `Oracle.sol` (Price feed stub)
3. Note the deployed addresses

### Step 3: Deploy KipuBank
1. Go to "Solidity Compiler" → Version `0.8.22+`
2. Compile `KipuBank.sol`
3. Configure constructor parameters:

```
_withdrawalLimitUSD: 1000000000     (1,000 USD with 6 decimals)
_bankCapUSD:         5000000000     (5,000 USD with 6 decimals)
_dataFeed:           DEPLOYED_ORACLE_ADDRESS
_usdcToken:          DEPLOYED_CIRCLE_ADDRESS
```

4. Click "Deploy" → Confirm in MetaMask
5. ✅ Contract deployed!

## 🔧 Contract Interaction

### Making ETH Deposits
```javascript
// In Remix:
// 1. Go to "VALUE" → Enter amount in wei
// 2. Click "deposit" button (orange)
// 3. Confirm transaction in MetaMask

Example values:
0.1 ETH = 100000000000000000 wei (~$411.78)
0.05 ETH = 50000000000000000 wei (~$205.89)
```

### Making USDC Deposits
```javascript
// 1. First approve USDC in Circle contract:
approve(KIPUBANK_ADDRESS, 1000000000) // 1,000 USDC

// 2. Then deposit in KipuBank:
depositUSD(1000000000) // 1,000 USDC (6 decimals)
```

### Making Withdrawals
```javascript
// Withdraw ETH:
withdraw(50000000000000000) // 0.05 ETH

// Withdraw USDC:
withdrawUSD(500000000) // 500 USDC

// Automatic validations:
- USD limit per transaction ✓
- Sufficient balance ✓
```

### Public Queries (No Gas)
```javascript
// View USD balance by token
getUserBalanceUSD("0xYourAddress", "0x000...000") → ETH balance in USD
getUserBalanceUSD("0xYourAddress", USDC_ADDRESS) → USDC balance

// View bank statistics
getBankValueUSD() → Total USD value of bank
getETHPriceUSD() → Current ETH/USD price from oracle
getDepositsCount() → Number of deposits
getWithdrawalsCount() → Number of withdrawals
```

## 📊 Events and Monitoring

### Emitted Events
- `Deposit(address indexed account, address indexed token, string tokenSymbol, uint256 originalAmount, uint256 usdValue)`
- `Withdraw(address indexed account, address indexed token, string tokenSymbol, uint256 originalAmount, uint256 usdValue)`
- `BankPaused(address indexed admin)` / `BankUnpaused(address indexed admin)`
- `DataFeedUpdated(address indexed operator, address oldDataFeed, address newDataFeed)`
- `RoleGrantedByAdmin(address indexed admin, address indexed account, bytes32 indexed role)`

Events appear in the Remix console after each successful transaction and include detailed information about original amounts and USD values.

## 🛡️ Custom Errors

| Error | When It Occurs |
|-------|----------------|
| `ExceedsBankCapUSD` | Deposit exceeds bank's USD capacity |
| `ExceedsWithdrawLimitUSD` | Withdrawal exceeds USD limit per transaction |
| `InsufficientBalanceUSD` | Insufficient USD balance for withdrawal |
| `TransferFailed` | ETH transfer failure |
| `InvalidContract` | Invalid contract address |
| `ZeroAmount` | Attempted deposit/withdrawal with amount 0 |
| `BankPausedError` | Operation blocked by bank pause |

## 🧪 Test Cases

See **[USE_CASES.md](USE_CASES.md)** for detailed test cases including:

1. **✅ Valid ETH/USDC deposits**: With automatic USD conversions
2. **✅ Valid ETH/USDC withdrawals**: Validated against USD limits  
3. **❌ Exceed bankCapUSD**: Attempt to deposit more than total limit
4. **❌ Exceed withdrawalLimitUSD**: Attempt to withdraw more than per-transaction limit
5. **✅ Admin functions**: Pause/unpause bank, grant roles
6. **✅ Operator functions**: Update price oracles
7. **✅ State queries**: Balances, prices, statistics

**Recommended test configuration:**
- Withdrawal Limit: 1,000 USD
- Bank Cap: 5,000 USD  
- Fixed ETH price: $4,117.88 (for testing)

## 🔗 Auxiliary Contracts

### Circle.sol (USDC Stub)
- **Purpose**: Simulates USDC token for testing
- **Decimals**: 6 (same as real USDC)
- **Functions**: `mint()`, `decimals()`, standard ERC20

### Oracle.sol (Price Feed Stub)  
- **Purpose**: Simulates Chainlink ETH/USD oracle
- **Fixed price**: $4,117.88 (for consistent testing)
- **Decimals**: 8 (Chainlink standard)
- **Compatibility**: AggregatorV3Interface

### IOracle.sol
- **Purpose**: Interface for Chainlink compatibility
- **Functions**: `latestAnswer()`, `latestRoundData()`

## ⚖️ Design Trade-offs

### **Unified USD Accounting**
- ✅ **Benefit**: Simplified limit checks across tokens
- ⚠️ **Trade-off**: Requires real-time ETH price conversion (gas cost)

### **Immutable Limits**
- ✅ **Benefit**: Gas efficient, tamper-proof security
- ⚠️ **Trade-off**: Requires contract redeployment to change limits

### **Role-Based Access**
- ✅ **Benefit**: Granular permissions, operational flexibility
- ⚠️ **Trade-off**: Additional complexity vs single-admin model

### **6-Decimal USD Standard**
- ✅ **Benefit**: USDC compatibility, precision balance
- ⚠️ **Trade-off**: ETH conversion math complexity

## ⚠️ Important Notes

- **Testing**: Stub contracts are designed only for development and testing
- **Production**: Use real Chainlink and USDC addresses on mainnet
- **Security**: Perform complete audit before production deployment
- **Oracles**: Fixed price is only for testing, use dynamic feeds in production

## 📄 License

- **KipuBank on Sepolia**: [0x09cE4B882c46c430cA28A4DfD30fFf21DCcDAD29](https://sepolia.etherscan.io/address/0x09cE4B882c46c430cA28A4DfD30fFf21DCcDAD29)
- **Custom USDC Token on Sepolia**: [0xc22c484da337f1d4be2cbf27fb1ed69fa772a240](https://sepolia.etherscan.io/address/0xc22c484da337f1d4be2cbf27fb1ed69fa772a240)
- **Custom Data Feed on Sepolia**: [0xcdb9f8df0e2224587035a0811a85ce94ec07e0ff](https://sepolia.etherscan.io/address/0xcdb9f8df0e2224587035a0811a85ce94ec07e0ff)
- **Custom fixed ETH Price**: $4,117.88 (411788170000 with 8 decimals)
- **Mint USDC from Custom Circle**: your_address, 10000000000
- **ETH/USD Chainlink Ethereum Sepolia**: [0x694AA1769357215DE4FAC081bf1f309aDC325306](https://sepolia.etherscan.io/address/0x694AA1769357215DE4FAC081bf1f309aDC325306)
- **USDC Ethereum Sepolia**: [0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238](https://sepolia.etherscan.io/address/0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238)

## 📄 License

MIT License - See `LICENSE` for complete details.

---

**⚠️ Important**: This contract is for educational purposes. Stub contracts (Circle, Oracle) are designed only for testing. Perform complete security audit before production use.
