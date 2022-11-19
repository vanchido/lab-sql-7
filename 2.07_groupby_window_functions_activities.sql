-- Activity 1
-- 1. 
select type as card_type, count(*) as num_issued
from bank.card
group by type
order by num_issued desc;
-- 2.
select district_id, count(*) num_customers
from bank.client
group by district_id
order by num_customers desc;
-- 3.
select type, round(avg(amount),2) as avg_amount
from bank.trans
group by type
order by avg_amount desc;

-- Activity 2
select type, round(avg(amount),2) as avg_amount
from bank.trans
where k_symbol <> '' and k_symbol <> ' '
group by type
order by avg_amount desc;

-- Activity 3
-- 1.
select district_id, count(*) num_customers
from bank.client
group by district_id
having num_customers > 100
order by num_customers desc;
-- 2. 
select type, operation, round(avg(amount),2) as avg_amount
from bank.trans
group by type, operation
having avg_amount>10000
order by avg_amount desc;
