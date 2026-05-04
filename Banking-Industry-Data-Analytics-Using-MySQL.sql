/*                                     PROJECT TITLE : Banking Industry Data Analytics Using MySQL
OBJECTIVE: 
This project simulates real-world banking data to perform end-to-end data analytics using SQL. 
Key goals include:
- Practicing core and advanced SQL concepts such as:
- Filtering, aggregation, joins, window functions, CTEs, procedures, and functions
- Analyzing data from simulated banking tables:
- Customers, accounts, transactions, loans, branches, and products
- Deriving meaningful business insights such as:
- Customer segmentation, loan activity trends, and transactional behavior*/

-- SECTION A: Database and Schema Setup

CREATE DATABASE Banking_Industry;
USE Banking_Industry;

-- SECTION B: Table Creation

-- B1. CUSTOMERS
CREATE TABLE customers( 
customer_id INT PRIMARY KEY, 
name VARCHAR(255),
gender VARCHAR(255),
dob DATE,
city VARCHAR(255),
state VARCHAR(255),
account_open_date DATE);

-- B2. BRANCHES
CREATE TABLE branches(
branch_id INT PRIMARY KEY,
branch_name VARCHAR(255),
city VARCHAR(255),
state VARCHAR(255));

-- B3.ACCOUNTS
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,  -- declare the column first
    account_type VARCHAR(255),  -- 'Savings', 'Current', etc.
    balance DECIMAL(10,2),
    branch_id INT,  -- also declare this column before using in foreign key
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(branch_id) REFERENCES branches(branch_id)
);

-- B4. TRANSACTIONS
CREATE TABLE transactions( transaction_id INT PRIMARY KEY,
account_id INT,
FOREIGN KEY(account_id) REFERENCES accounts(account_id),
amount DECIMAL(10,2),
transaction_type VARCHAR(255), -- 'Credit', 'Debit'
transaction_date DATE);

-- B5. LOANS
CREATE TABLE loans (
loan_id INT PRIMARY KEY,
customer_id INT,
FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
loan_type VARCHAR(255),
loan_amount DECIMAL(10,2),
loan_status VARCHAR(255), -- 'Approved', 'Pending', 'Rejected'
start_date DATE,
end_date DATE);

-- SECTION C: Data Insertion 

-- C1. CUSTOMERS
INSERT INTO customers VALUES
(1, 'Ravi Kumar', 'Male', '1990-02-15', 'Delhi', 'Delhi', '2018-01-10'),
(2, 'Meena Sharma', 'Female', '1985-07-24', 'Mumbai', 'Maharashtra', '2019-06-21'),
(3, 'Amit Singh', 'Male', '1992-11-30', 'Patna', 'Bihar', '2020-03-05'),
(4, 'Priya Verma', 'Female', '1996-09-10', 'Bangalore', 'Karnataka', '2021-09-15');

-- C2.  BRANCHES
INSERT INTO branches VALUES
(101, 'Connaught Place', 'Delhi', 'Delhi'),
(102, 'Andheri', 'Mumbai', 'Maharashtra'),
(103, 'Fraser Road', 'Patna', 'Bihar'),
(104, 'MG Road', 'Bangalore', 'Karnataka');

-- C3. ACCOUNTS
INSERT INTO accounts VALUES
(1001, 1, 'Savings', 45000, 101),
(1002, 2, 'Current', 76000, 102),
(1003, 3, 'Savings', 15000, 103),
(1004, 4, 'Savings', 92000, 104);

-- C4. TRANSACTIONS
INSERT INTO transactions VALUES
(1, 1001, 10000, 'Credit', '2024-01-15'),
(2, 1001, 5000, 'Debit', '2024-02-10'),
(3, 1002, 20000, 'Credit', '2024-03-05'),
(4, 1002, 5000, 'Debit', '2024-03-10'),
(5, 1003, 10000, 'Credit', '2024-01-18'),
(6, 1004, 15000, 'Credit', '2024-04-01'),
(7, 1004, 3000, 'Debit', '2024-04-15');

-- C5. LOANS
INSERT INTO loans VALUES
(201, 1, 'Home Loan', 1500000, 'Approved', '2022-01-01', '2032-01-01'),
(202, 2, 'Car Loan', 500000, 'Pending', '2023-06-01', '2028-06-01'),
(203, 4, 'Education Loan', 300000, 'Approved', '2021-08-01', '2026-08-01');

-- SECTION D: Business Queries and Analysis

-- Q1.Count the number of male vs female customers.
select count(name),gender as Number_of_customers from customers 
group by gender ;
# This query calculates the total number of customers in the database, grouped by gender, to understand the gender distribution.

-- Q2. Find the total number of accounts by account type.
select count(account_id) as Number_of_account ,account_type from accounts 
group by account_type;
# This query calculates the total number of bank accounts for each account type to analyzethe distribution of accounts preferences.

-- Q3. Identify customers with account balances below 20,000.
select customer_id, balance 
from accounts
where balance <20000;
# This query finds the customers who have less than 20000 balance in there bank account .

-- Q4 List all customers who opened their account in 2020 or later.
select customer_id, name, account_open_date
from customers
where year (account_open_date) >=2020; 
# This query retrieves all the customers who have opened their bank accounts after or on 2020 , to identify recent customers.

-- Q5. Show top 3 customers by account balance.
select customer_id, balance
from accounts
order by balance desc
limit 3;
# This query identifies the top 3 customers with the highest account balances to highlight high-value account holders.

-- Q6. Join customers and accounts to show customer name, account type, and balance.
select customers.name, accounts.account_type,accounts.balance
from customers INNER JOIN accounts
ON  customers.customer_id = accounts.customer_id;
# This query joins customer and account data to  display each customer’s name along with their account type and current balance.

-- Q7. Join accounts with branches to show city-wise balance distribution.
select branches.city, accounts.balance
from branches inner join accounts
on branches.branch_id = accounts.branch_id;
# This query joins branches and accounts data to get distribution of account balance across cities.

-- Q8. Show transaction details along with customer name and account type.
select customers.name,accounts.account_type,transactions.transaction_id,transactions.account_id,
transactions.amount,transactions.transaction_type,transactions.transaction_date
from customers inner join accounts
on customers.customer_id = accounts.customer_id 
left join transactions 
on transactions.account_id= accounts.account_id;
# This query retrieves detailed transaction records along with the  customer names and their account types for better traceability.

-- Q9. Find customers who have taken loans and their current account balance.
select customers.name,loans.loan_type,accounts.balance
from customers inner join loans 
on customers.customer_id = loans. customer_id
inner join accounts
on accounts.customer_id = loans.customer_id;
# This query identifies customers who have taken loans and displays their loan types along with their current account balances.

-- Q10. Identify customers without any loans.
select customers.name, customers.customer_id
from customers left join loans
on customers.customer_id = loans.customer_id
where loans.customer_id is null;
# This query retrieves those customers who have not take any loan

-- Q11. Calculate the total loan amount by loan type.
select sum(loan_amount) as Total_loan_amount ,loan_type
from loans
group by loan_type; 
# This query calculates the total loan amount issued for each loan type to understand the distribution of loan categories.

-- Q12. Find average account balance per state.
select avg(accounts.balance) as average_balance, customers.state
from accounts right join customers
on accounts.customer_id = customers.customer_id
group by customers.state;
# This query calculates the average account balance for each state by joining account data with customer information.

-- Q13. Count transactions per account.
select account_id,count(transaction_id) as Number_of_transaction
from transactions
group by account_id;
# This query counts the total number of transactions made for each account to measure account activity.

-- Q14. Calculate total credited and debited amount per customer.
select customers.customer_id,customers.name,
sum(case when transactions.transaction_type =  "Credit" then transactions.amount else 0 end) as Total_credit,
sum(case when transactions.transaction_type = "Debit" then transactions.amount else 0 end) as Total_debit
from  customers inner join accounts
on customers.customer_id = accounts.customer_id
inner join transactions
on transactions.account_id = accounts.account_id
group by customers.name,customers.customer_id;
#This query calculates the total credited and debited amounts for each customer by joining customers, accounts, and transactions tables.
-- It uses CASE statements to separately sum 'Credit' and 'Debit' transactions for each customer.

/* STEPS:
   1. Join with accounts table:
     - To get each customers accounts using customers.customer_id = accounts.customer_id.
   2. Join with transactions table:
     - To fetch transaction details for each account using accounts.account_id = transactions.account_id.
   3.Use CASE statements inside SUM():
     - To separate credits and debits.
   4. Only sum the amount if it matches the transaction type.
     - Group By customers.customer_id and customers.name:
	 - Because the result is per customer. */


-- Q15. Find total number of active loan customers per branch.
SELECT branches.branch_name,
COUNT(DISTINCT loans.customer_id) AS active_loan_customers
FROM loans INNER JOIN customers 
ON loans.customer_id = customers.customer_id
INNER JOIN branches  
ON customers.city = branches.city AND customers.state = branches.state
WHERE loans.loan_status = "Approved"
GROUP BY branches.branch_name;
# This query returns the number of unique customers with approved loans in each branch, helping analyze loan activity per location.

/*STEPS:
1. Start from the loans table to focus on customers with loans.
2. Join with customers to get each customers location.
3. Join with branches on both city and state to ensure accurate branch mapping.
4. Filter for loans with status "Approved" to count only active loan customers.
5.Group by branch_name to get a per-branch summary.
6.Use COUNT(DISTINCT customer_id) to avoid double-counting customers with multiple loans.*/

-- Q16. Rank customers by account balance within each branch.
select customers.customer_id,customers.name,accounts.balance,branches.branch_name,
rank() over (partition by branches.branch_name order by accounts.balance desc) as Balance_Rank 
from accounts Inner join customers
on accounts.customer_id = customers.customer_id
right join branches
on customers.city = branches.city and customers.state = branches.state;
# This query ranks customers based on their account balance within each branch, helping identify top account holders at every location.

/*STEPS:
1.Start from the accounts table:
  - You want to rank based on accounts.balance.
2.Join with customers:
  - To get customer details like name and id .
3.Right Join with branches:
  - To associate each customer with a branch based on matching city and state.
4.RIGHT JOIN ensures all branches are included, even if some branches have no customers.
  - Use RANK() window function:
  - PARTITION BY branches.branch_name: This resets the ranking for each branch.
  - ORDER BY accounts.balance DESC: Customers with the highest balance get rank 1.
5.Output includes:
  - Customer ID and Name
  - Balance
  - Branch name
  - Calculated rank (Balance_Rank)*/

-- Q17. Get running total of credits per customer.
select transactions.transaction_type,customers.name,customers.customer_id,
sum(amount) over(partition by customers.customer_id order by transactions.transaction_date asc) as Total_credits 
from customers inner join accounts
on customers.customer_id = accounts.customer_id
left join transactions
on transactions.account_id = accounts.account_id
where transactions.transaction_type = "C redit";
# This query calculates a running total  credited amounts per customer, allowing analysis of how their account balance has grown through credits.

/*STEPS:
1. Start from customers table:
   - Because the running total is calculated per customer.
2. Join with accounts:
   - To link each customer to their account(s).
3. Left Join with transactions:
   - To fetch all transactions related to each account.
4. Filter only Credit transactions:
   - Using WHERE transactions.transaction_type = 'Credit' to exclude Debits.
5. Apply a window function SUM():
   - PARTITION BY customers.customer_id: Keeps running total per customer.
   - ORDER BY transactions.transaction_date ASC: Ensures the total grows over time by transaction date.
6. Select fields:
   - transaction_type: Just for clarity (will always be "Credit")
   - Customer details: name, customer_id
   - Total_credits: The growing sum of credits*/

-- Q 18.Get previous transaction amount for each account using LAG.
select account_id,transaction_date,transaction_type,amount,
lag(amount) over( partition by account_id order by transaction_date asc) as Previous_transaction
from transactions;
# This query retrieves the amount of each transaction along with the previous transaction amount for the same account using the LAG() window function.

/*STEPS: 
1. Start from the transactions table:
   - transacting details per account.
2. Use the LAG() window function:
   - LAG(amount) retrieves the amount from the previous row.
   - OVER (PARTITION BY account_id ...) ensures the window function restarts for each account.
   - ORDER BY transaction_date ASC orders transactions chronologically.
3. Select relevant fields:
   - account_id, transaction_date, transaction_type, amount.*/

-- Q19. Use a CTE to find customers who transacted in the last 30 days.
with customer_transaction as (select distinct accounts.customer_id 
from transactions inner join accounts 
on transactions.account_id= accounts.account_id
where  transaction_date >= (current_date()-interval 30 day))
select customers.customer_id, customers.name
from customers where customers.customer_id in (select customer_id from customer_transaction) ;
# This query uses a CTE to identify customers who have made at least one transaction in the past 30 days, helping track recent activity.

/*STEPS:
1. Using  Common Table Expression (CTE) named customer_transaction:
   - This extracts the customer_id of customers who have had at least one transaction in the last 30 days.
2.Join transactions with accounts:
   - So you can trace each transaction back to a customer  accounts.customer_id.
3. Filter on recent transactions:
   - WHERE transaction_date >= CURRENT_DATE() - INTERVAL 30 DAY ensures only last 30 days are considered.
4. In the main query:
   - Extract customer names and IDs from the customers table.
5. Restrict to only those customer_ids found in the CTE.*/

-- Q20. With a CTE, list customers who have more than one transaction.
with customers_list as (select  accounts.customer_id , count(transactions.account_id)
from transactions inner join accounts 
on transactions.account_id= accounts.account_id
group by  accounts.customer_id
having  count(transactions.account_id)>1 )
select customers.customer_id, customers.name
from customers where customers.customer_id in (select customer_id from customers_list) ;
# This query uses a CTE to list customers who have made more than one transaction, helping identify active account holders.

/*STEPS:
1. Use a CTE (customers_list):
   - This identifies customers who have more than one transaction.
2. Join transactions with accounts:
   - To trace each transaction back to the customer using accounts.customer_id.
3. Group by accounts.customer_id:
   - To count how many transactions each customer has.
4. Filter with HAVING COUNT(transactions.account_id) > 1:
   - Keeps only those customers who made more than one transaction.*/

-- Q21. Create a CTE to show customers whose loan duration exceeds 5 years.
with loan_duration as (select customers.customer_id,customers.name,timestampdiff(year,start_date,end_date) as year_difference
from customers inner join loans 
on customers.customer_id = loans.customer_id)
select * from loan_duration
where year_difference > 5;
# This query uses a CTE to identify customers whose loan duration exceeds 5 years, helping flag long-term borrowers.

/*STEPS:
1. CTE loan_duration:
   - Joins customers with loans to get relevant customer details and their loan timelines.
2. Calculates loan duration in years using TIMESTAMPDIFF(YEAR, start_date, end_date).
3.Main Query:
  - Filters the CTE to include only those loans with a duration greater than 5 years.
4.Output:
  - customer_id, name, and year_difference (loan duration in years).*/

-- Q22. Create a procedure to fetch all accounts for a given state.
select* from accounts;
select* from customers;
DELIMITER //
CREATE PROCEDURE Accounts ( in state_name varchar(255))
BEGIN
select accounts.customer_id, accounts.account_id,customers.name ,accounts.balance
from accounts inner join customers
on accounts.customer_id = customers.customer_id
where customers.state = state_name;
END //
delimiter ;
call Accounts ("Delhi");
# This procedure retrieves all customer accounts located in a given state, enabling region-specific account analysis.

/*STEPS:
1. Define the procedure Accounts:
   - It takes one input parameter: state_name (the state you want to filter by).
2. Inside the procedure:
   - Join the accounts and customers tables to relate account info to customer location.
3. Filter using WHERE customers.state = state_name:
   - Only accounts where the customer lives in the given state are returned.
4. Use CALL Accounts('StateName') to run:
   - For example, CALL Accounts('Delhi'); returns all accounts in Delhi.*/
   
-- Q23. Procedure to find all transactions for a customer within a date range.
delimiter //
create procedure customer_transaction ( in customerID int , in StartDate date , in EndDate date)
begin
select transactions.transaction_id, transactions.amount, transactions.transaction_type, 
transactions.transaction_date , customers.customer_id, customers.name, accounts.customer_id
from transactions inner join accounts
on transactions.account_id = accounts.account_id
inner join customers
on customers.customer_id = accounts.customer_id
where customers.customer_id = customerID and transactions.transaction_date between StartDate and EndDate;
end //
delimiter ;
call customer_transaction(1,"2024-01-01", "2024-03-01");
# This procedure returns all transactions made by a specific customer within a given date range, allowing time-bound activity analysis.

/*STEPS:
1. Name: customer_transaction
2. Parameters:
   - customerID: ID of the customer whose transactions you want
   - StartDate, EndDate: the date range filter
3.Joins:
  - transactions with accounts table: to find which account_id the transaction belongs to
  - accounts with customers: to identify the customer_id associated with that account
4. Filter Logic:
  - Match the customer_id to the input value
5. Filter transactions that fall between the given start and end date*/

-- Q24. Procedure to show all customers with approved loans.
delimiter //
create procedure CustomersWithApprovedLoans()
begin
select customers.customer_id , customers.name, loans.loan_status , loans.loan_type, loans.loan_amount
from customers inner join loans
on customers.customer_id = loans.customer_id
where loans.loan_status = "Approved";
end //
delimiter ;
call CustomersWithApprovedLoans();
# This procedure retrieves all customers who have approved loans, providing details of loan type and amount.

/*STEPS:
1. Procedure Definition:
   - Named: CustomersWithApprovedLoans
2. No input parameters since we want all approved loans
3.Joins:
  - Joins customers with loans on customer_id to relate customer details with loan information
4.Filter:
  - WHERE loans.loan_status = "Approved" ensures only approved loans are shown
5.Output Includes:
  - Customer ID, Name
  - Loan Status 
  - Loan Type and Loan Amount*/
  
-- Q25. Create a UDF to calculate customer age.
DELIMITER $$
CREATE FUNCTION calculating_customersage(dob date)
returns  int
deterministic
begin 
declare age int ;
set age =  timestampdiff(year,dob,curdate()) ;
return age;
END $$
DELIMITER ;
SELECT customer_id, name , calculating_customersage(dob) as customers_Age from customers;
# This user-defined function calculates a customer's age based on their date of birth.

/*STEPS:
1. Function Name: calculating_customersage
   - Input Parameter: dob (date of birth)
2. Logic:
   - Calculates difference in years between DOB and current date using TIMESTAMPDIFF(YEAR, dob, CURDATE())
3. Output:
   - Returns the customer's age in years*/  
   
-- Q26. Create a UDF to classify account balance as 'Low', 'Medium', or 'High'.
delimiter //
create function account_balance(balance decimal(10,2))
returns varchar(50)
deterministic
begin
return case 
when balance <10000 then "Low"
when balance between 10001 and 50000 then "Medium"
else "High"
end ;
end //
delimiter ;
select customer_id , account_type , balance , account_balance(balance) as classify_account from accounts;
# This function categorizes account balances as "Low", "Medium", or "High" based on predefined ranges.

/*STEPS:
1. Function Name: account_balance
   - Input Parameter: balance (decimal value)
2. Logic:
   - use CASE statement to categorizes account balances as "Low", "Medium", or "High"
   - Categorizes balance into:
   - Low: < 10,000
   - Medium: 10,001–50,000
   - High: > 50,000*/
   
-- Q27. Create a UDF to calculate remaining loan duration in years. 
delimiter //
create function remaining_loan(end_date date)
returns int
deterministic
begin
declare pending_year int;
set pending_year = timestampdiff(year,curdate(),end_date);
return pending_year ;
end //
delimiter ;
select customer_id, loan_type, loan_amount, loan_status, remaining_loan(end_date) as Remaining_loan_years
 from loans
 where loan_status = "Approved";
 # This user-defined function calculates the remaining loan duration in years based on the loan's end date.
 
 /*STEPS:
 1. Function Name: remaining_loan
    - Input Parameter: end_date – the end date of the loan
2. Logic:
   - Uses TIMESTAMPDIFF(YEAR, CURDATE(), end_date) to calculate how many years are left until loan maturity
3.Output:
  - Returns the remaining loan period in years*/
  
-- Q28. Create a UDF to calculate EMI for loans
delimiter //
create function calculate_emi(loan_amount decimal(10,2), annual_interest_rate decimal(5,2), tenure_years int)
returns decimal(10,2)
deterministic
begin
    declare monthly_rate decimal(10,6);
    declare months int;
    declare emi decimal(10,2);
    set monthly_rate = annual_interest_rate / (12 * 100);
    set months = tenure_years * 12;
    set emi = (loan_amount * monthly_rate * power(1 + monthly_rate, months)) 
              / (power(1 + monthly_rate, months) - 1);
    return emi;
end //
delimiter ;

select customer_id,loan_type,loan_amount,calculate_emi(loan_amount, 8, 5) as emi
from loans
where loan_status = 'Approved';
# This user-defined function calculates the EMI (Equated Monthly Installment) for loans based on loan amount, interest rate, and tenure.

/* STEPS:
1. Function Name: calculate_emi
   - Input Parameters:
     a) loan_amount – total loan amount
     b) annual_interest_rate – yearly interest rate (%)
     c) tenure_years – loan duration in years

2. Logic:
   - Converts annual interest rate into monthly rate:
       monthly_rate = annual_interest_rate / (12 * 100)
   - Converts tenure into total months:
       months = tenure_years * 12
   - Applies EMI formula:
       EMI = [P * R * (1+R)^N] / [(1+R)^N - 1]
       where:
       P = loan_amount
       R = monthly_rate
       N = number of months

3. Output:
   - Returns the EMI amount (monthly installment)*/
   
   
-- Q29. Create a UDF to calculate total interest paid on a loan
delimiter //
create function calculate_total_interest(
    loan_amount decimal(10,2), 
    annual_interest_rate decimal(5,2), 
    tenure_years int)
returns decimal(10,2)
deterministic
begin
    declare emi decimal(10,2);
    declare total_payment decimal(10,2);
    declare total_interest decimal(10,2);
    set emi = calculate_emi(loan_amount, annual_interest_rate, tenure_years);
    set total_payment = emi * (tenure_years * 12);
    set total_interest = total_payment - loan_amount;
    return total_interest;
end //
delimiter ;

select loan_id,loan_amount,calculate_total_interest(loan_amount, 8, 5) 
as total_interest
from loans;
# This user-defined function calculates the total interest paid over the loan tenure.

/* STEPS:
1. Function Name: calculate_total_interest
   - Input Parameters:
     a) loan_amount – total loan amount
     b) annual_interest_rate – yearly interest rate (%)
     c) tenure_years – loan duration in years

2. Logic:
   - Calls calculate_emi function to get monthly EMI
   - Calculates total payment:
       total_payment = EMI × total months
   - Calculates total interest:
       total_interest = total_payment - loan_amount

3. Output:
   - Returns total interest paid during the loan tenure*/

-- Q30. Create a UDF to classify loan risk based on loan amount and remaining duration
delimiter //
create function loan_risk_category(loan_amount decimal(10,2), end_date date)
returns varchar(20)
deterministic
begin
    declare remaining_years int;
    set remaining_years = timestampdiff(year, curdate(), end_date);
    return case
        when loan_amount > 1000000 and remaining_years > 5 then 'High Risk'
        when loan_amount between 500000 and 1000000 and remaining_years between 3 and 5 then 'Medium Risk'
        else 'Low Risk'
    end;
end //
delimiter ;

select customer_id,loan_type,loan_amount,loan_risk_category(loan_amount, end_date) 
as risk_level
from loans
where loan_status = 'Approved';
# This user-defined function classifies loans into risk categories based on loan amount and remaining duration.

/* STEPS:
1. Function Name: loan_risk_category
   - Input Parameters:
     a) loan_amount – total loan amount
     b) end_date – loan end date

2. Logic:
   - Calculates remaining loan duration:
       remaining_years = TIMESTAMPDIFF(YEAR, CURDATE(), end_date)
   - Applies risk classification using CASE:
       - High Risk:
           loan_amount > 10,00,000 AND remaining_years > 5
       - Medium Risk:
           loan_amount between 5,00,000 and 10,00,000 
           AND remaining_years between 3 and 5
       - Low Risk:
           all other cases

3. Output:
   - Returns loan risk category (High Risk / Medium Risk / Low Risk)*/