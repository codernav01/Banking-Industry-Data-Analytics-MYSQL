# Banking Analytics — Customer, Transaction & Loan Analysis in MySQL

## Project Overview

This project uses a **simulated relational banking dataset** to demonstrate SQL-based analysis across customers, accounts, transactions, branches, and loans.

The focus is not on completing a list of SQL exercises. The repository is structured around common analytical questions a banking or financial-services team could investigate: customer value, account activity, deposit balances, loan exposure, transaction behaviour, and branch performance.

## Business Questions

- Which customers hold the highest account balances?
- How are balances distributed across account types and branches?
- Which customers are active based on transaction behaviour?
- How much value flows through credits and debits?
- Which customers currently hold approved loans?
- How is approved-loan exposure distributed across branches and loan types?
- How do customer transactions change over time?
- Which accounts or customers should be segmented for deeper review?

## Data Model

| Table | Purpose |
|---|---|
| `customers` | Customer demographics and account-open date |
| `branches` | Branch location and identity |
| `accounts` | Customer account type, balance, and branch |
| `transactions` | Credit/debit activity by account |
| `loans` | Loan type, amount, status, and term |

## SQL Techniques Demonstrated

- relational joins
- grouped aggregations
- conditional aggregation
- CTEs
- window functions
- `RANK()`
- `LAG()`
- running totals
- stored procedures
- user-defined functions
- date calculations
- reusable segmentation logic

## Analytical Areas

### Customer & account value
- customers by geography
- account mix
- high- and low-balance customers
- customer ranking by balance
- customer-level transaction value

### Transaction behaviour
- transaction frequency
- credit vs debit totals
- running credit totals
- previous-transaction comparison
- activity based on the most recent date in the dataset

### Loan analysis
- approved-loan customers
- loan amount by type
- loan duration
- EMI and interest calculations
- loan-exposure segmentation

### Branch performance
- branch balances
- customer counts
- approved-loan customer counts
- within-branch customer ranking

## Important Methodology Notes

- The dataset is **simulated and intentionally small**, so this project demonstrates SQL logic rather than production-scale banking analysis.
- Account balance is a snapshot field; it is not reconstructed from transaction history.
- The loan segmentation function is a **rule-based exposure band**, not a statistical credit-risk model.
- “Recent activity” is measured relative to the latest transaction date available in the dataset so the analysis remains reproducible.

## Repository Structure

```text
Banking-Industry-Data-Analytics-MYSQL/
├── README.md
└── sql/
    └── banking_analytics_mysql.sql
```

## What This Project Demonstrates

This repository demonstrates how a relational banking schema can be queried to move from raw operational tables to **customer, transaction, loan, and branch-level analytical views** using MySQL.
