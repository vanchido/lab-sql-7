-- "Summary" queries: Group By and Window Functions

-- Group by:
-- Tip 1: on SELECT you'll have only the aggregation functions and/or the columns you are using in the group by statement.
-- Tip 2: if you're thinking about filtering a Group By, instead of 'where' you might need 'having':
	-- having: after agg - when you're filtering the result of the aggregation
    -- where: before agg - when you're filtering before calculating the result of the aggregation

-- Average balances for the different statuses of people who have taken loans:
select round(avg(amount),2) as "Avg Amount", round(avg(payments),2) as "Avg Payment", status
from bank.loan
group by status -- 4
order by status; -- 4

select round(avg(amount) - avg(payments),2) as "Avg Balance", status
from bank.loan
group by status
order by status;

select amount - payments as "Avg Balance", status
from bank.loan
group by status
order by status; -- Tip 1

-- Average amount of transactions for each different kind of k_symbol:
select round(avg(amount),2) as Average, k_symbol from bank.order
-- where amount > 100 -- where not k_symbol = ' ' -- Tip 2
group by k_symbol
-- having k_symbol <> ' ' -- but it's not as efficient, because it happens after the agg and calculation
order by Average asc; 

-- Average balance by status and duration
select round(avg(amount),2) - round(avg(payments),2) as "Avg Balance", status, duration
from bank.loan
group by status, duration
order by status, duration;

-- Average balance based on the type, operation and k_symbol
select type, operation, k_symbol, round(avg(balance),2)
from bank.trans
group by type, operation, k_symbol
order by type, operation, k_symbol;

-- Having
select type, operation, k_symbol, round(avg(balance),2) as Average
from bank.trans
where k_symbol <> '' and k_symbol <> ' ' and  operation <> '' -- Tip 2
group by type, operation, k_symbol
having Average > 30000 -- Tip 2
order by type, operation, k_symbol;

-- Why not the other way around?:
select type, operation, k_symbol, round(avg(balance),2) as Average
from bank.trans
where Average > 30000 -- because this doesn't work (the aggregation is not done yet so 'Average' does not exist yet)
group by type, operation, k_symbol
-- having k_symbol <> '' and k_symbol <> ' ' -- and because this is less eficient, you don't need to include k_symbol ' ' in the calculation
order by type, operation, k_symbol;

-- Window Functions:
-- RANK, DENSE_RANK, ROW_NUMBER, LAG, PERCENT_RANK, FIRST_VALUE, LAST_VALUE, CUME_DIST, LEAD, NTH_VALUE, NTILE;

/* 
Window functions also operate on a subset (like Group By) but they do not reduce the result to a single value.
They operate on a 'moving window' which is specified by PARTITION BY.
*/

-- The OVER statement:

-- Compare individual balances with the average balance for that particular duration of the loan.
-- This would be very complicated to get using a GROUP BY clause.
select duration, avg(amount-payments) from loan
group by duration;

select loan_id, account_id, amount, payments, duration, amount-payments as "Balance",
avg(amount-payments) over (partition by duration) as Avg_Balance
from bank.loan
where amount > 100000
order by duration, balance desc;

-- differences using over():
select loan_id, duration, avg(amount-payments) over() as balance
from bank.loan;
select avg(amount-payments) from loan; -- there is just one unique value

-- You can also have ORDER BY in the partition:
select loan_id, account_id, amount, payments, duration, amount-payments as "Balance",
sum(amount-payments) over (partition by duration order by duration asc) as sum_
from bank.loan
where amount > 100000;

select loan_id, account_id, amount, payments, duration, amount-payments as "Balance",
rank() over (partition by duration order by duration asc, amount desc) as ranking
from bank.loan
where amount > 100000;

-- Give me the total amount borrowed per duration, once using Group By and once using Window Functions
select sum(amount), duration from loan group by duration;

select loan_id, duration, sum(amount) over(partition by duration) from loan;

select loan_id, account_id, amount, payments, duration, dense_rank() over(order by duration asc) as 'total borrowed' from loan
where amount > 100000;