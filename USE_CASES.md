

## 🧪 **Casos de Prueba para KipuBank en Sepolia**

### 📋 **Configuración Inicial:**

- **Withdrawal Limit USD**: 1,000 USD (1000000000 con 6 decimales)
- **Bank Cap USD**: 5,000 USD (5000000000 con 6 decimales)
- **Data Feed**: 0xcdb9f8df0e2224587035a0811a85ce94ec07e0ff (Custom Oracle ETH/USD Sepolia)
- **USDC Token**: 0xc22c484da337f1d4be2cbf27fb1ed69fa772a240 (Custom Circle USDC Sepolia)


## 🔍 **Caso 1: Verificar Configuración Inicial**

### **Acciones a ejecutar:**
```
// 1. Verificar límites del banco
getBankCapUSD() 
// Resultado esperado: 5000000000 (5,000 USD)

getWithdrawalLimitUSD()
// Resultado esperado: 1000000000 (1,000 USD)

// 2. Verificar precio del oracle
getETHPriceUSD()
// Resultado esperado: 411788170000 ($4,117.88)

// 3. Verificar estado inicial
getBankValueUSD()
// Resultado esperado: 0

isBankPaused()
// Resultado esperado: false
```

## 🔍 **Caso 2: Depósito de ETH (Exitoso)**

### **Acción:**
```
// Depositar 0.1 ETH (que vale ~$411.78)
deposit()
// Value: 100000000000000000 (0.1 ETH en wei)
```
### **Resultados esperados:**
```
getUserBalanceUSD(TU_DIRECCION, "0x0000000000000000000000000000000000000000")
// Resultado esperado: ~411788170 (USD con 6 decimales)

getBankValueUSD()
// Resultado esperado: ~411788170
399898662

getDepositsCount()
// Resultado esperado: 1

getUserETHBalance(TU_DIRECCION)
// Resultado esperado: ~100000000000000000 (0.1 ETH en wei)
```
### **Evento esperado:**
`Deposit(tu_direccion, 0x000...000, "ETH", 100000000000000000, 411788170)`

## 🔍 **Caso 3: Depósito de USDC (Exitoso)**

### **Preparación:**
```
// 1. Primero, aprobar USDC para el contrato KipuBank
// En el contrato Circle (USDC):
approve(DIRECCION_KIPUBANK, 1000000000)
// 1000000000 = 1,000 USDC (6 decimales)
```

### **Acción:**
```
// 2. Depositar 1,000 USDC
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

## 🔍 **Caso 4: Retiro de ETH (Exitoso)**

### **Acción:**
```
// Retirar 0.05 ETH (que vale ~$205.89)
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

## 🔍 **Caso 5: Retiro de USDC (Exitoso)**

### **Acción:**
```
// Retirar 500 USDC
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

## 🚫 **Caso 6: Intentar Exceder Withdrawal Limit**

### **Acción:**

```
// Intentar retirar más de $1,000 USD
// Calcular: 1000 USD / 4117.88 USD/ETH ≈ 0.243 ETH
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

## 🚫 **Caso 7: Intentar Exceder Bank Cap**

### **Preparación:**

```
// Calcular cuánto falta para llegar al cap de $5,000
getBankValueUSD()
// Supongamos que devuelve 705894085 (~$705.89)
// Falta: 5000 - 705.89 = $4,294.10
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

## 🔍 **Caso 8: Funciones de Admin**

### **Pausar como user NO admin:**

```
// Como usuario NO admin, pausar el banco
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
// Como admin, pausar el banco
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

## 🔍 **Caso 9: Funciones de Operator**

### **Acción:**

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

## 📊 **Notas:**

- **Precio ETH del Oracle**: $4,117.88 (411788170000 con 8 decimales)
- **Mint USDC desde Circle**: tu_direccion, 10000000000
- **ETH/USD Chainlink Ethereum Sepolia**: 0x694AA1769357215DE4FAC081bf1f309aDC325306
- **USDC Ethereum Sepolia**: 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238

```
// Depósitos ETH en wei:
10000000000000000    // 0.01 ETH
50000000000000000    // 0.05 ETH  
100000000000000000   // 0.1 ETH
250000000000000000   // 0.25 ETH
1000000000000000000  // 1 ETH

// Depósitos/Retiros USDC (6 decimales):
1000000     // 1 USDC
100000000   // 100 USDC
500000000   // 500 USDC
1000000000  // 1,000 USDC
5000000000  // 5,000 USDC

// Direcciones especiales:
0x0000000000000000000000000000000000000000  // address(0) para ETH
```