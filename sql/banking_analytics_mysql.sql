-- ============================================================
-- BANKING ANALYTICS — CUSTOMER, TRANSACTION & LOAN ANALYSIS
-- MySQL | Simulated relational dataset
-- ============================================================

CREATE DATABASE IF NOT EXISTS Banking_Industry;
USE Banking_Industry;

-- ============================================================
-- 1. SCHEMA
-- ============================================================

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    gender VARCHAR(50),
    dob DATE,
    city VARCHAR(100),
    state VARCHAR(100),
    account_open_date DATE
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100)
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    branch_id INT NOT NULL,
    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_accounts_branch
        FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    transaction_date DATE NOT NULL,
    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type VARCHAR(100) NOT NULL,
    loan_amount DECIMAL(14,2) NOT NULL,
    loan_status VARCHAR(30) NOT NULL,
    start_date DATE,
    end_date DATE,
    CONSTRAINT fk_loans_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================================
-- 2. SAMPLE DATA
-- ============================================================

INSERT INTO customers VALUES
(1, 'Ravi Kumar', 'Male', '1990-02-15', 'Delhi', 'Delhi', '2018-01-10'),
(2, 'Meena Sharma', 'Female', '1985-07-24', 'Mumbai', 'Maharashtra', '2019-06-21'),
(3, 'Amit Singh', 'Male', '1992-11-30', 'Patna', 'Bihar', '2020-03-05'),
(4, 'Priya Verma', 'Female', '1996-09-10', 'Bangalore', 'Karnataka', '2021-09-15');

INSERT INTO branches VALUES
(101, 'Connaught Place', 'Delhi', 'Delhi'),
(102, 'Andheri', 'Mumbai', 'Maharashtra'),
(103, 'Fraser Road', 'Patna', 'Bihar'),
(104, 'MG Road', 'Bangalore', 'Karnataka');

INSERT INTO accounts VALUES
(1001, 1, 'Savings', 45000.00, 101),
(1002, 2, 'Current', 76000.00, 102),
(1003, 3, 'Savings', 15000.00, 103),
(1004, 4, 'Savings', 92000.00, 104);

INSERT INTO transactions VALUES
(1, 1001, 10000.00, 'Credit', '2024-01-15'),
(2, 1001, 5000.00, 'Debit', '2024-02-10'),
(3, 1002, 20000.00, 'Credit', '2024-03-05'),
(4, 1002, 5000.00, 'Debit', '2024-03-10'),
(5, 1003, 10000.00, 'Credit', '2024-01-18'),
(6, 1004, 15000.00, 'Credit', '2024-04-01'),
(7, 1004, 3000.00, 'Debit', '2024-04-15');

INSERT INTO loans VALUES
(201, 1, 'Home Loan', 1500000.00, 'Approved', '2022-01-01', '2032-01-01'),
(202, 2, 'Car Loan', 500000.00, 'Pending', '2023-06-01', '2028-06-01'),
(203, 4, 'Education Loan', 300000.00, 'Approved', '2021-08-01', '2026-08-01');

-- ============================================================
-- 3. CUSTOMER & ACCOUNT ANALYSIS
-- ============================================================

-- Customer distribution by gender
SELECT
    gender,
    COUNT(*) AS customer_count
FROM customers
GROUP BY gender
ORDER BY customer_count DESC;

-- Account distribution and balance by account type
SELECT
    account_type,
    COUNT(*) AS account_count,
    SUM(balance) AS total_balance,
    ROUND(AVG(balance), 2) AS avg_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- Low-balance customers
SELECT
    c.customer_id,
    c.name,
    a.account_id,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a
  ON a.customer_id = c.customer_id
WHERE a.balance < 20000
ORDER BY a.balance;

-- Customers who opened an account in 2020 or later
SELECT
    customer_id,
    name,
    account_open_date
FROM customers
WHERE account_open_date >= '2020-01-01'
ORDER BY account_open_date;

-- Top customers by account balance
SELECT
    c.customer_id,
    c.name,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a
  ON a.customer_id = c.customer_id
ORDER BY a.balance DESC
LIMIT 3;

-- Branch-level balance summary
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    COUNT(a.account_id) AS account_count,
    COALESCE(SUM(a.balance), 0) AS total_balance,
    ROUND(COALESCE(AVG(a.balance), 0), 2) AS avg_balance
FROM branches b
LEFT JOIN accounts a
  ON a.branch_id = b.branch_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_balance DESC;

-- Average account balance by customer state
SELECT
    c.state,
    COUNT(a.account_id) AS account_count,
    ROUND(AVG(a.balance), 2) AS avg_balance
FROM customers c
JOIN accounts a
  ON a.customer_id = c.customer_id
GROUP BY c.state
ORDER BY avg_balance DESC;

-- Rank customers by balance within each branch
SELECT
    b.branch_name,
    c.customer_id,
    c.name,
    a.balance,
    RANK() OVER (
        PARTITION BY b.branch_id
        ORDER BY a.balance DESC
    ) AS balance_rank
FROM accounts a
JOIN customers c
  ON c.customer_id = a.customer_id
JOIN branches b
  ON b.branch_id = a.branch_id
ORDER BY b.branch_name, balance_rank;

-- ============================================================
-- 4. TRANSACTION ANALYSIS
-- ============================================================

-- Transaction details with customer and account context
SELECT
    c.customer_id,
    c.name,
    a.account_id,
    a.account_type,
    t.transaction_id,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM transactions t
JOIN accounts a
  ON a.account_id = t.account_id
JOIN customers c
  ON c.customer_id = a.customer_id
ORDER BY c.customer_id, t.transaction_date, t.transaction_id;

-- Transaction count per account
SELECT
    account_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS gross_transaction_value
FROM transactions
GROUP BY account_id
ORDER BY transaction_count DESC, gross_transaction_value DESC;

-- Customer-level credit and debit totals
SELECT
    c.customer_id,
    c.name,
    SUM(CASE WHEN t.transaction_type = 'Credit' THEN t.amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN t.transaction_type = 'Debit' THEN t.amount ELSE 0 END) AS total_debit,
    SUM(CASE
        WHEN t.transaction_type = 'Credit' THEN t.amount
        WHEN t.transaction_type = 'Debit' THEN -t.amount
        ELSE 0
    END) AS net_transaction_flow
FROM customers c
JOIN accounts a
  ON a.customer_id = c.customer_id
JOIN transactions t
  ON t.account_id = a.account_id
GROUP BY c.customer_id, c.name
ORDER BY total_credit DESC;

-- Running credit total per customer
SELECT
    c.customer_id,
    c.name,
    t.transaction_id,
    t.transaction_date,
    t.amount AS credit_amount,
    SUM(t.amount) OVER (
        PARTITION BY c.customer_id
        ORDER BY t.transaction_date, t.transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_credit_total
FROM customers c
JOIN accounts a
  ON a.customer_id = c.customer_id
JOIN transactions t
  ON t.account_id = a.account_id
WHERE t.transaction_type = 'Credit'
ORDER BY c.customer_id, t.transaction_date, t.transaction_id;

-- Previous transaction amount per account
SELECT
    account_id,
    transaction_id,
    transaction_date,
    transaction_type,
    amount,
    LAG(amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date, transaction_id
    ) AS previous_transaction_amount
FROM transactions
ORDER BY account_id, transaction_date, transaction_id;

-- Customers active in the 30 days leading up to the latest transaction in the dataset
WITH reference_date AS (
    SELECT MAX(transaction_date) AS max_transaction_date
    FROM transactions
),
active_customers AS (
    SELECT DISTINCT
        a.customer_id
    FROM transactions t
    JOIN accounts a
      ON a.account_id = t.account_id
    CROSS JOIN reference_date r
    WHERE t.transaction_date >= DATE_SUB(r.max_transaction_date, INTERVAL 30 DAY)
)
SELECT
    c.customer_id,
    c.name
FROM customers c
JOIN active_customers ac
  ON ac.customer_id = c.customer_id
ORDER BY c.customer_id;

-- Customers with more than one transaction
WITH transaction_counts AS (
    SELECT
        a.customer_id,
        COUNT(*) AS transaction_count
    FROM transactions t
    JOIN accounts a
      ON a.account_id = t.account_id
    GROUP BY a.customer_id
)
SELECT
    c.customer_id,
    c.name,
    tc.transaction_count
FROM transaction_counts tc
JOIN customers c
  ON c.customer_id = tc.customer_id
WHERE tc.transaction_count > 1
ORDER BY tc.transaction_count DESC;

-- ============================================================
-- 5. LOAN ANALYSIS
-- ============================================================

-- Customers and their loans with current account balance
SELECT
    c.customer_id,
    c.name,
    l.loan_id,
    l.loan_type,
    l.loan_status,
    l.loan_amount,
    a.balance
FROM customers c
JOIN loans l
  ON l.customer_id = c.customer_id
LEFT JOIN accounts a
  ON a.customer_id = c.customer_id
ORDER BY l.loan_amount DESC;

-- Customers without any loan
SELECT
    c.customer_id,
    c.name
FROM customers c
LEFT JOIN loans l
  ON l.customer_id = c.customer_id
WHERE l.loan_id IS NULL
ORDER BY c.customer_id;

-- Loan exposure by type and status
SELECT
    loan_type,
    loan_status,
    COUNT(*) AS loan_count,
    SUM(loan_amount) AS total_loan_amount,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loans
GROUP BY loan_type, loan_status
ORDER BY total_loan_amount DESC;

-- Approved-loan customers per branch
SELECT
    b.branch_name,
    COUNT(DISTINCT l.customer_id) AS approved_loan_customers,
    SUM(l.loan_amount) AS approved_loan_amount
FROM loans l
JOIN accounts a
  ON a.customer_id = l.customer_id
JOIN branches b
  ON b.branch_id = a.branch_id
WHERE l.loan_status = 'Approved'
GROUP BY b.branch_id, b.branch_name
ORDER BY approved_loan_amount DESC;

-- Loans with original term longer than 5 years
WITH loan_terms AS (
    SELECT
        l.loan_id,
        c.customer_id,
        c.name,
        l.loan_type,
        l.loan_amount,
        TIMESTAMPDIFF(YEAR, l.start_date, l.end_date) AS term_years
    FROM loans l
    JOIN customers c
      ON c.customer_id = l.customer_id
)
SELECT *
FROM loan_terms
WHERE term_years > 5
ORDER BY term_years DESC;

-- ============================================================
-- 6. STORED PROCEDURES
-- ============================================================

DROP PROCEDURE IF EXISTS get_accounts_by_state;
DELIMITER //
CREATE PROCEDURE get_accounts_by_state(IN p_state VARCHAR(100))
BEGIN
    SELECT
        c.customer_id,
        c.name,
        a.account_id,
        a.account_type,
        a.balance,
        b.branch_name
    FROM customers c
    JOIN accounts a
      ON a.customer_id = c.customer_id
    JOIN branches b
      ON b.branch_id = a.branch_id
    WHERE c.state = p_state
    ORDER BY a.balance DESC;
END //
DELIMITER ;

CALL get_accounts_by_state('Delhi');

DROP PROCEDURE IF EXISTS get_customer_transactions;
DELIMITER //
CREATE PROCEDURE get_customer_transactions(
    IN p_customer_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT
        c.customer_id,
        c.name,
        a.account_id,
        t.transaction_id,
        t.transaction_type,
        t.amount,
        t.transaction_date
    FROM customers c
    JOIN accounts a
      ON a.customer_id = c.customer_id
    JOIN transactions t
      ON t.account_id = a.account_id
    WHERE c.customer_id = p_customer_id
      AND t.transaction_date BETWEEN p_start_date AND p_end_date
    ORDER BY t.transaction_date, t.transaction_id;
END //
DELIMITER ;

CALL get_customer_transactions(1, '2024-01-01', '2024-03-01');

DROP PROCEDURE IF EXISTS get_approved_loans;
DELIMITER //
CREATE PROCEDURE get_approved_loans()
BEGIN
    SELECT
        c.customer_id,
        c.name,
        l.loan_id,
        l.loan_type,
        l.loan_amount,
        l.start_date,
        l.end_date
    FROM customers c
    JOIN loans l
      ON l.customer_id = c.customer_id
    WHERE l.loan_status = 'Approved'
    ORDER BY l.loan_amount DESC;
END //
DELIMITER ;

CALL get_approved_loans();

-- ============================================================
-- 7. USER-DEFINED FUNCTIONS
-- ============================================================

DROP FUNCTION IF EXISTS customer_age;
DELIMITER //
CREATE FUNCTION customer_age(p_dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_dob, CURDATE());
END //
DELIMITER ;

SELECT
    customer_id,
    name,
    customer_age(dob) AS age
FROM customers;

DROP FUNCTION IF EXISTS balance_band;
DELIMITER //
CREATE FUNCTION balance_band(p_balance DECIMAL(12,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p_balance <= 10000 THEN 'Low'
        WHEN p_balance <= 50000 THEN 'Medium'
        ELSE 'High'
    END;
END //
DELIMITER ;

SELECT
    customer_id,
    account_type,
    balance,
    balance_band(balance) AS balance_segment
FROM accounts;

DROP FUNCTION IF EXISTS remaining_loan_years;
DELIMITER //
CREATE FUNCTION remaining_loan_years(p_end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN GREATEST(TIMESTAMPDIFF(YEAR, CURDATE(), p_end_date), 0);
END //
DELIMITER ;

SELECT
    loan_id,
    customer_id,
    loan_type,
    loan_status,
    remaining_loan_years(end_date) AS remaining_years
FROM loans
WHERE loan_status = 'Approved';

DROP FUNCTION IF EXISTS calculate_emi;
DELIMITER //
CREATE FUNCTION calculate_emi(
    p_loan_amount DECIMAL(14,2),
    p_annual_interest_rate DECIMAL(6,3),
    p_tenure_years INT
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    DECLARE v_monthly_rate DECIMAL(14,10);
    DECLARE v_months INT;

    SET v_months = p_tenure_years * 12;

    IF v_months <= 0 THEN
        RETURN NULL;
    END IF;

    IF p_annual_interest_rate = 0 THEN
        RETURN ROUND(p_loan_amount / v_months, 2);
    END IF;

    SET v_monthly_rate = p_annual_interest_rate / 1200;

    RETURN ROUND(
        (p_loan_amount * v_monthly_rate * POWER(1 + v_monthly_rate, v_months))
        / (POWER(1 + v_monthly_rate, v_months) - 1),
        2
    );
END //
DELIMITER ;

SELECT
    loan_id,
    loan_type,
    loan_amount,
    calculate_emi(
        loan_amount,
        8,
        TIMESTAMPDIFF(YEAR, start_date, end_date)
    ) AS estimated_emi
FROM loans
WHERE loan_status = 'Approved';

DROP FUNCTION IF EXISTS loan_exposure_band;
DELIMITER //
CREATE FUNCTION loan_exposure_band(
    p_loan_amount DECIMAL(14,2),
    p_end_date DATE
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_remaining_years INT;
    SET v_remaining_years = GREATEST(TIMESTAMPDIFF(YEAR, CURDATE(), p_end_date), 0);

    RETURN CASE
        WHEN p_loan_amount > 1000000 AND v_remaining_years > 5 THEN 'High Exposure'
        WHEN p_loan_amount >= 500000 AND v_remaining_years >= 3 THEN 'Medium Exposure'
        ELSE 'Low Exposure'
    END;
END //
DELIMITER ;

SELECT
    loan_id,
    customer_id,
    loan_type,
    loan_amount,
    loan_exposure_band(loan_amount, end_date) AS exposure_band
FROM loans
WHERE loan_status = 'Approved';

-- ============================================================
-- METHODOLOGY NOTE
-- loan_exposure_band is a transparent rule-based segmentation.
-- It is NOT a credit-risk model and should not be interpreted as
-- probability of default, underwriting advice, or a risk score.
-- ============================================================
