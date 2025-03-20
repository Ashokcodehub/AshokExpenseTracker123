select * from expenses;
SHOW DATABASES;
SHOW TABLES FROM expense_db;
DESCRIBE expenses;
select * from expenses;

#1)total amount spent in each category
SELECT category, SUM(amount_paid) AS total_spent
FROM expenses
GROUP BY category
ORDER BY total_spent DESC;

#2)total amount spent using each payment mode
SELECT payment_mode, SUM(amount_paid) AS total_spent
FROM expenses
GROUP BY payment_mode
ORDER BY total_spent DESC;

#3)total cashback on each payment mode
SELECT payment_mode,SUM(cashback) AS total_cashback
FROM expenses
group by payment_mode;

#4)Which are the top 5 most expensive categories in terms of spending?
SELECT category, SUM(amount_paid) AS total_spent
FROM expenses
GROUP BY category
ORDER BY total_spent DESC
LIMIT 5;

#5)How much was spent on travel using different payment modes?
SELECT payment_mode, SUM(amount_paid) AS total_spent
FROM expenses
WHERE category = 'Travel'
GROUP BY payment_mode
ORDER BY total_spent DESC;


#6)Which transactions resulted in cashback?
SELECT * 
FROM expenses 
WHERE cashback > 0 
ORDER BY cashback DESC;

#7)What is the total spending in each month of the year?
SELECT MONTH(date) AS month, SUM(amount_paid) AS total_spent
FROM expenses
GROUP BY MONTH(date)
ORDER BY month;


#8) Which months have the highest spending in categories like "Travel," "Entertainment," or "Gifts"?
SELECT MONTH(date) AS month, category, SUM(amount_paid) AS total_spent
FROM expenses
WHERE category IN ('Travel', 'Entertainment', 'Gifts')
GROUP BY MONTH(date), category
ORDER BY total_spent DESC;


#(9)Are there any recurring expenses that occur during specific months of the year (e.g., insurance premiums, property taxes)?
SELECT 
    MONTH(date) AS expense_month,
    category,
    COUNT(*) AS occurrences,
    SUM(amount_paid) AS total_amount
FROM expenses
GROUP BY expense_month, category
HAVING COUNT(*) > 1
ORDER BY expense_month, total_amount DESC;

select category,months,count(amount)as recurrence_count from expenses group by months,category having recurrence_count > 1 order by months,category;


#10)How much cashback or rewards were earned in each month?
select date_format(date, '%Y-%m') as month,sum(Cashback) as total_cashback
from expenses
group by month
order by month;

#11)How has your overall spending changed over time (e.g., increasing, decreasing, remaining stable)?
select date_format(date, '%Y-%m') as month,sum(amount_paid) as total_spent
from expenses
group by month
order by month;

#12)What are the typical costs associated with different types of travel (e.g., flights, accommodation, transportation)?
SELECT 
    MONTH(date) AS month, 
    SUM(amount_paid) AS total_spent,
    LAG(SUM(amount_paid)) OVER (ORDER BY MONTH(date)) AS previous_month_spent,
    (SUM(amount_paid) - LAG(SUM(amount_paid)) OVER (ORDER BY MONTH(date))) AS change_in_spending
FROM expenses
GROUP BY MONTH(date)
ORDER BY month;


#13)Are there any patterns in grocery spending (e.g., higher spending on weekends, increased spending during specific seasons)?
SELECT 
    DAYNAME(date) AS day_of_week, 
    SUM(amount_paid) AS total_spent
FROM expenses
WHERE category = 'Groceries'
GROUP BY day_of_week;


#14) Define High and Low Priority Categories
SELECT 
    category,
    amount_paid,
    date,
    CASE 
        WHEN category IN ("Groceries", "Travel", "Transportation","Income Tax", "Gas Bill") 
            THEN 'High Priority'
        WHEN category IN ("Entertainment", "Gifts","Subscriptions") 
            THEN 'Low Priority'
        ELSE 'Uncategorized'
    END AS priority_level
FROM expenses;



#15)Which category contributes the highest percentage of the total spending
Select Category,sum(amount_paid)as total_spent,(sum(amount_paid)*100/(select sum(amount_paid)from expenses))as highest_spent
from expenses
group by category
order by total_spent desc
limit 1;





#own queries
#1)top 5 expensive transactions
SELECT * FROM expenses ORDER BY amount_paid DESC LIMIT 5;

#2)Get the highest expense
SELECT max(amount_paid)as high_expense
from expenses;

#3)Total spending in the last 3 months
SELECT SUM(amount_paid) AS last_3_months_spent
FROM expenses WHERE date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

#4)Average spending per transaction
SELECT AVG(amount_paid) AS avg_transaction_spent FROM expenses;

#5)Which weekday has the lowest spending?
SELECT DAYNAME(date) AS day, SUM(amount_paid) AS total_spent
FROM expenses GROUP BY DAYNAME(date) ORDER BY total_spent ASC LIMIT 1;

#6)Which day of the week has the highest spending?
SELECT DAYNAME(date) AS day, SUM(amount_paid) AS total_spent
FROM expenses GROUP BY DAYNAME(date) ORDER BY total_spent DESC LIMIT 1;

#7)Total spending on weekends vs. weekdays
SELECT 
    CASE WHEN DAYOFWEEK(date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(amount_paid) AS total_spent
FROM expenses GROUP BY day_type;

#8)Month with the highest cashback received
SELECT MONTH(date) AS month, SUM(cashback) AS total_cashback
FROM expenses GROUP BY MONTH(date) ORDER BY total_cashback DESC LIMIT 1;

#9)Category with the most cashback received
SELECT category, SUM(cashback) AS total_cashback
FROM expenses GROUP BY category ORDER BY total_cashback DESC LIMIT 1;

#10)Total spending using Credit Card
SELECT SUM(amount_paid) AS credit_card_spent FROM expenses WHERE payment_mode = 'Credit Card';

#11)Highest spending month
SELECT MONTH(date) AS month, SUM(amount_paid) AS total_spent
FROM expenses GROUP BY MONTH(date) ORDER BY total_spent DESC LIMIT 1;

#12)Most used payment mode
SELECT payment_mode, COUNT(*) AS transaction_count
FROM expenses GROUP BY payment_mode ORDER BY transaction_count DESC LIMIT 1;