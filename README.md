# Statesvill Bank

A desktop banking application built with Electron for managing personal finances, calculating loans, and tracking account transactions.

## Features

- **Calculator** - Basic financial calculations
- **Loan Calculator** - Calculate monthly payments, total payable amount, and interest costs
- **Account Management** - Track balance and transaction history
- **Transaction History** - Complete record of all account activity with timestamps
- **Persistent Storage** - All data automatically saved locally

## Installation

### What You Need
- Node.js and npm (developer tools for your computer)

### Setup Steps

1. **Get the files ready:**
```bash
npm install
```

2. **Test it first:**
```bash
npm start
```

## Making the App for Your Chromebook

### Build the .deb package:

```bash
npm run build
```

This creates a `.deb` file in the `dist/` folder that works on Linux.

### Install on your Chromebook:

```bash
sudo dpkg -i dist/StatesvillBank-*.deb
```

Then open Statesvill Bank from your applications!

Or run it from the command line:
```bash
statesvill-bank
```

## How to Use

### Calculator
Use the built-in calculator for financial calculations.

### Loan Calculator
- Enter the loan amount (principal)
- Enter the annual interest rate (APR)
- Enter the loan term in months
- View monthly payment, total payable amount, and total interest
- Click "Take This Loan" to record the transaction

### Transaction Management
- **Add Transaction** - Record deposits, withdrawals, or transfers
- **Transaction History** - View all account activity with timestamps
- **Reset Account** - Clear all transactions and reset balance to $1,000.00

## Data Storage

All account data is stored in `~/.fakebank/data.json` and persists between sessions.

## Development

- `src/main.js` - Electron main process
- `src/index.html` - UI
- `src/app.js` - Application logic
- `src/preload.js` - Secure IPC for file operations
