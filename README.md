# Banking Analytics — Customer, Transaction & Loan Analysis in MySQL

> **SQL-focused portfolio project:** relational analysis across customers, accounts, transactions, branches, and loans using MySQL.

## Recruiter Snapshot

| Area | Evidence |
|---|---|
| Data model | 5 related banking tables |
| SQL | joins, CTEs, window functions, procedures, UDFs |
| Analysis | customer value, transactions, loans, branch performance |
| Scale | intentionally small simulated dataset |
| Purpose | demonstrate SQL logic and analytical design, not production-scale banking analytics |

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
| `customers` | customer demographics and account-open date |
| `branches` | branch identity and geography |
| `accounts` | account type, balance, customer and branch |
| `transactions` | credit/debit activity by account |
| `loans` | loan type, amount, status and term |

## SQL Techniques Demonstrated

- relational joins
- grouped and conditional aggregation
- CTEs
- window functions
- `RANK()`
- `LAG()`
- running totals
- stored procedures
- user-defined functions
- date calculations
- reusable segmentation logic

## Important Methodology Notes

- The dataset is **simulated and intentionally small**.
- Account balance is treated as a snapshot field rather than reconstructed from transaction history.
- Loan segmentation is rule-based, not a statistical credit-risk model.
- Recent activity is measured relative to the latest transaction date available in the dataset to keep the analysis reproducible.

## Repository Structure

```text
Banking-Industry-Data-Analytics-MYSQL/
├── README.md
└── sql/
    └── banking_analytics_mysql.sql
```

## How to Review

**Recruiter:** use this project as evidence of SQL breadth and relational thinking.  
**Technical reviewer:** inspect `sql/banking_analytics_mysql.sql` for the actual queries, procedures, functions, and window logic.

## What This Project Demonstrates

**Relational SQL + metric logic + reusable analytical query design.**
