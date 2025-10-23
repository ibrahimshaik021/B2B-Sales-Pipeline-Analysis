# B2B-Sales-Pipeline-Analysis
End-to-end analysis of B2B sales data using SQL and Power BI to identify key drivers of win/loss performance.

B2B Sales Pipeline Analysis
README.md
Project Objective
The initial goal of this project was to analyze a B2B sales pipeline to identify major "leaks" between sales stages (e.g., Prospecting, Qualification, etc.).
However, a deep dive into the data revealed that it was a snapshot (showing only the current stage of a deal) rather than a historical log. This made a traditional funnel analysis impossible.
The project objective was therefore pivoted to a more robust and achievable goal: To identify the key characteristics and drivers of 'Won' versus 'Lost' deals and provide actionable recommendations for the sales leadership.

Tools Used
MySQL: Used for data loading, all cleaning, transformation, and analysis (CTEs, Window Functions, CASE statements).

Power Query: Used as a preliminary tool to investigate the raw data and fix major formatting errors (e.g., text-to-date) before loading to SQL.

Power BI: Used as the final visualization tool to build the executive dashboard and present the findings.

The Process
1. Data Cleaning & ETL
This was the most challenging phase of the project. The raw .csv data was unusable and required significant cleaning before it could be loaded into MySQL.

Problem: The MySQL Import Wizard repeatedly failed due to massive data integrity issues.

Solution:

Used Power Query to pre-format all date columns to a universal YYYY-MM-DD text format.

Transformed the Probability column from text (e.g., "65.0%") to a decimal number (e.g., 0.65).

Wrote an advanced LOAD DATA INFILE script in MySQL to bypass the GUI's failures.

Used the NULLIF(@variable, '') function within the script to correctly handle blank cells in the sales_cycle column, solving the final "Incorrect integer value" error.

2. Analysis (SQL)
With the data successfully loaded, I used SQL to test several hypotheses and compare 'Won' vs. 'Lost' outcomes across three key dimensions:

Deal Size

Sales Channel

Sales Representative (Deal Owner)

3. Visualization (Power BI)
I connected Power BI to the clean MySQL database and built an interactive, one-page dashboard. This involved writing several DAX measures (e.g., Total Deals Won, Overall Win Rate %, Avg Deal Size Won) to create the final visuals.

Key Findings & Insights
My analysis uncovered several key insights, including one "myth-busting" finding:

Finding 1: Deal Size Has No Significant Impact. The analysis proved that the average deal_size for 'Won' deals ($2,584) was nearly identical to that of 'Lost' deals ($2,492). This tells the team to pursue all qualified leads with confidence, regardless of size.

Finding 2: The 'Partners' Channel is the Most Effective. The 'Partners' channel was identified as the clear top performer, combining a high win rate (65.5%) with a significant volume of deals.

Finding 3: The Sales Team is Built of 'Specialists.' This was the deepest insight. Reps are not just "good" or "bad"; they are specialists. For example, some reps had a 100% win rate in one channel (e.g., 'Partners') but a 0% win rate in another ('F2F').

Finding 4: Critical Data Integrity Issue. The analysis uncovered that the sales_cycle column was 100% NULL for all 'Won' deals, revealing a fundamental flaw in the data collection process and making 'deal velocity' analysis impossible.

Final Dashboard
Sales Dashboard.png

Actionable Recommendations
Based on the analysis, the following recommendations were presented to sales leadership:

Prioritize the 'Partners' Channel: Focus all new investment and resources on this proven, high-performing channel.

Assign Deals by Specialization: Stop random assignments. Assign high-value deals to reps who are proven specialists in that specific channel (e.g., Lynda for F2F, William for Telesales, Angela/Cameron/Rachael for Partners).

Implement Data-Driven Coaching: Use the data to realign reps. Move Angela off F2F (where she struggles) and onto Partners (where she has a 100% win rate). Develop immediate improvement plans for underperformers like Joe and Greg.

Fix the Data Process: Correct the business process to ensure sales_cycle is recorded for all completed deals.
