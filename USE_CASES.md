

## 🧪 **KipuBank Test Cases**

## 🔍 **Case 1: Verify Initial Configuration**

### **Actions to execute:**
```
// 1. Verify bank limits
getBankCapUSD() 
// Expected result: 5000000000 (5,000 USD)

getWithdrawalLimitUSD()
// Expected result: 1000000000 (1,000 USD)

// 2. Verify oracle price
getETHPriceUSD()
// Expected result: 411788170000 ($4,117.88)

// 3. Verify initial state
getBankValueUSD()
// Expected result: 0

isBankPaused()
// Expected result: false
```

## 🔍 **Case 2: ETH Deposit (Successful)**

### **Action:**
```
// Deposit 0.1 ETH (worth ~$411.78)
deposit()
// Value: 100000000000000000 (0.1 ETH in wei)
```
### **Expected results:**
```
getUserBalanceUSD(YOUR_ADDRESS, "0x0000000000000000000000000000000000000000")
// Expected result: ~411788170 (USD with 6 decimals)

getBankValueUSD()
// Expected result: ~411788170
399898662

getDepositsCount()
// Expected result: 1

getUserETHBalance(YOUR_ADDRESS)
// Expected result: ~100000000000000000 (0.1 ETH in wei)
```
### **Expected event:**
`Deposit(your_address, 0x000...000, "ETH", 100000000000000000, 411788170)`

## 🔍 **Case 3: USDC Deposit (Successful)**

### **Preparation:**
```
// 1. First, approve USDC for KipuBank contract
// In Circle contract (USDC):
approve(KIPUBANK_ADDRESS, 1000000000)
// 1000000000 = 1,000 USDC (6 decimals)
```

### **Action:**
```
// 2. Deposit 1,000 USDC
depositUSD(1000000000)
```

### **Resultados esperados:**
```
getUserBalanceUSD(TU_DIRECCION, DIRECCION_CIRCLE)
// Resultado esperado: 1000000000

getBankValueUSD()
// Resultado esperado: ~1411788170 (411.78 + 1000)

getDepositsCount()
// Resultado esperado: 2

getBankUSDCBalance()
// Resultado esperado: 1000000000
```

### **Eventos esperados:**
`Transfer(tu_direccion, DIRECCION_KIPU_BANK, 1000000000)`
`Deposit(tu_direccion, DIRECCION_CIRCLE, "USDC", 1000000000, 1000000000)`

## 🔍 **Case 4: ETH Withdrawal (Successful)**

### **Action:**
```
// Withdraw 0.05 ETH (worth ~$205.89)
withdraw(50000000000000000)
// 50000000000000000 = 0.05 ETH en wei
```

### **Resultados esperados:**
```
getUserBalanceUSD(TU_DIRECCION, "0x0000000000000000000000000000000000000000")
// Resultado esperado: ~205894085 (411.78 - 205.89)

getWithdrawalsCount()
// Resultado esperado: 1

getBankValueUSD()
// Resultado esperado: ~1205894085
```

### **Evento esperado:**
`Withdraw(tu_direccion, 0x000...000, "ETH", 50000000000000000, 205894085)`

## 🔍 **Case 5: USDC Withdrawal (Successful)**

### **Action:**
```
// Withdraw 500 USDC
withdrawUSD(500000000)
```

### **Resultados esperados:**

```
getUserBalanceUSD(TU_DIRECCION, DIRECCION_CIRCLE)
// Resultado esperado: 500000000

getBankUSDCBalance()
// Resultado esperado: 500000000

getWithdrawalsCount()
// Resultado esperado: 2
```

### **Eventos esperados:**
`Withdraw(tu_direccion, DIRECCION_CIRCLE, "USDC", 500000000, 500000000)`
`Transfer(DIRECCION_KIPU_BANK, tu_direccion, 500000000)`


---

## 🚫 **Case 6: Attempt to Exceed Withdrawal Limit**

### **Action:**

```
// Attempt to withdraw more than $1,000 USD
// Calculate: 1000 USD / 4117.88 USD/ETH ≈ 0.243 ETH
withdraw(250000000000000000)
// 0.25 ETH en wei (más de $1,000)
```


### **Resultado esperado:**

```
❌ Error: ExceedsWithdrawLimitUSD

{
 "attemptedUSD": {
  "value": "1029470425",
  "documentation": "USD value attempted to withdraw"
 },
 "limitUSD": {
  "value": "1000000000",
  "documentation": "Maximum withdrawal limit in USD"
 }
}
```


---

## 🚫 **Case 7: Attempt to Exceed Bank Cap**

### **Preparation:**

```
// Calculate how much is left to reach $5,000 cap
getBankValueUSD()
// Suppose it returns 705894085 (~$705.89)
// Remaining: 5000 - 705.89 = $4,294.10
```


### **Acción:**

```
// Intentar depositar más USDC del permitido
// Depositar 5000 USDC completos (sumado al balance existente, excede el cap)
depositUSD(5000000000)
```


### **Resultado esperado:**

```
❌ Error: ExceedsBankCapUSD
{
 "attemptedUSD": {
  "value": "5000000000",
  "documentation": "USD value attempted to deposit"
 },
 "availableUSD": {
  "value": "4294105915",
  "documentation": "Available USD capacity in the bank"
 }
}
```


---

## 🔍 **Case 8: Admin Functions**

### **Pause as NON-admin user:**

```
// As NON-admin user, pause the bank
pauseBank()
```

### **Resultado esperado:**
```
❌ Error: AccessControlUnauthorizedAccount
{
 "account": {
  "value": "tu_direccion"
 },
 "neededRole": {
  "value": "0xa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775"
 }
}
```

### **Pausar como user admin:**

```
// As admin, pause the bank
pauseBank()
```

### **Verificación:**

```
isBankPaused()
// Resultado esperado: true

// Intentar depositar con banco pausado
deposit()
// Value: 10000000000000000 (0.01 ETH)
// Resultado esperado: ❌ Error: BankPausedError
```
### **Evento esperado:**
`BankPaused(tu_direccion)`

### **Despausar:**

```
unpauseBank()

isBankPaused()
// Resultado esperado: false
```

### **Evento esperado:**
`BankUnpaused(tu_direccion)`

### **Otorgar rol de operador:**

### **Acción:**

```
// Como admin, otorgar rol de operador a otra cuenta
grantOperatorRole(DIRECCION_OPERADOR)
```

### **Verificación:**

```
ROLE_OPERADOR -> 0x97667070c54ef182b0f5858b034beac1b6f3089aa2d3188bb1e8929f4fa9b929
hasRole(ROLE_OPERADOR, DIRECCION_OPERADOR)
// Resultado esperado: true
```

### **Evento esperado:**
`RoleGranted(ROLE_OPERADOR, DIRECCION_OPERADOR, DIRECCION_ADMIN)`
`RoleGrantedByAdmin(DIRECCION_ADMIN, DIRECCION_OPERADOR, ROLE_OPERADOR)`


---

## 🔍 **Case 9: Operator Functions**

### **Action:**

```
// Como operator, actualizar el data feed
updateDataFeed(NUEVA_DIRECCION_ORACLE)
```

### **Verificación:**

```
getDataFeed()
// Resultado esperado: NUEVA_DIRECCION_ORACLE
```

### **Evento esperado:**
`DataFeedUpdated(tu_direccion, ANTIGUA_DIRECCION_ORACLE, NUEVA_DIRECCION_ORACLE)`

---

## 📊 **Quick reference:**

```
// ETH deposits in wei:
10000000000000000    // 0.01 ETH
50000000000000000    // 0.05 ETH  
100000000000000000   // 0.1 ETH
250000000000000000   // 0.25 ETH
1000000000000000000  // 1 ETH

// USDC deposits/withdrawals (6 decimals):
1000000     // 1 USDC
100000000   // 100 USDC
500000000   // 500 USDC
1000000000  // 1,000 USDC
5000000000  // 5,000 USDC

// Special addresses:
0x0000000000000000000000000000000000000000  // address(0) for ETH
```