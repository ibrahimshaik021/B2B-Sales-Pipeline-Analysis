Here is the consolidated SQL code used for this project, from database creation to the final analysis.

1. Database & Table Creation
This is the final, correct schema we developed.

SQL

CREATE DATABASE salesdb;

USE salesdb;

CREATE TABLE sales_data (
    opportunity_id INT PRIMARY KEY AUTO_INCREMENT,
    reporting_date DATE NOT NULL,
    deal_owner VARCHAR(100) NOT NULL,
    customer VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    sales_stage VARCHAR(100) NOT NULL,
    deal_size INT NOT NULL,
    probability DECIMAL(3,2) NOT NULL,
    weighted_forecast DECIMAL(10,2) NOT NULL,
    sales_channel VARCHAR(50) NOT NULL,
    close_date DATE NOT NULL,
    sales_cycle INT
);
2. Data Loading
This was the final, advanced LOAD DATA INFILE command that successfully handled the empty strings in the sales_cycle column.

SQL

TRUNCATE TABLE sales_data;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/Sales-Pipeline-Dataset_Clean.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
-- Load CSV columns into temporary user variables
(@deal_owner, @customer, @country, @sales_stage, @deal_size, @probability, @weighted_forecast, @sales_channel, @sales_cycle, @reporting_date, @close_date)
-- Assign variables to table columns, converting empty strings to NULL
SET
deal_owner = @deal_owner,
customer = @customer,
country = @country,
sales_stage = @sales_stage,
deal_size = @deal_size,
probability = @probability,
weighted_forecast = @weighted_forecast,
sales_channel = @sales_channel,
sales_cycle = NULLIF(@sales_cycle, ''), -- Fixes the empty string error
reporting_date = @reporting_date,
close_date = @close_date;

3. Analytical Queries
These are the key queries we used to find our insights.

Investigating sales_cycle Data Quality
This query proved that the sales_cycle column was 100% NULL for all 'Won' deals, making it unreliable for our analysis.

SQL

SELECT COUNT(opportunity_id)
FROM sales_data
WHERE sales_stage = 'Won' AND sales_cycle IS NULL;

SELECT COUNT(opportunity_id)
FROM sales_data
WHERE sales_stage = 'Lost' AND sales_cycle IS NULL;
Average Deal Size: Won vs. Lost
This query proved that deal size was not a significant factor in winning or losing.

SQL

SELECT
    sales_stage,
    AVG(deal_size)
FROM sales_data
WHERE sales_stage IN ('Won', 'Lost')
GROUP BY sales_stage;
Win Rate % by Sales Channel
This query identified the 'Partners' channel as the most effective.

SQL

SELECT
    sales_channel,
    SUM(CASE WHEN sales_stage = 'Won' THEN 1 ELSE 0 END) AS Won_count,
    SUM(CASE WHEN sales_stage = 'Lost' THEN 1 ELSE 0 END) AS loss_count,
    ROUND((
        SUM(CASE WHEN sales_stage = 'Won' THEN 1 ELSE 0 END) /
        (SUM(CASE WHEN sales_stage = 'Won' THEN 1 ELSE 0 END) + SUM(CASE WHEN sales_stage = 'Lost' THEN 1 ELSE 0 END))
    ) * 100.0, 2) AS win_percentage
FROM sales_data
WHERE sales_stage IN ('Won', 'Lost') -- Added filter to only include completed deals
GROUP BY sales_channel;
Win Rate % by Rep & Channel (Final Deep-Dive Analysis)
This was our final and most complex query, used to find the channel specialists.

SQL

SELECT
    deal_owner,
    sales_channel,
    SUM(CASE WHEN sales_stage = 'Won' THEN 1 ELSE 0 END) AS Won_count,
    SUM(CASE WHEN sales_stage = 'Lost' THEN 1 ELSE 0 END) AS loss_count,
    ROUND((
        SUM(CASE WHEN sales_stage = 'Won' THEN 1 ELSE 0 END) /
        (SUM(CASE WHEN sales_stage = 'Won' THEN 1 ELSE 0 END) + SUM(CASE WHEN sales_stage = 'Lost' THEN 1 ELSE 0 END))
    ) * 100.0, 2) AS win_percentage
FROM sales_data
WHERE sales_stage IN ('Won', 'Lost') -- Added filter to only include completed deals
GROUP BY
    deal_owner,
    sales_channel
HAVING (Won_count > 0 OR loss_count > 0);