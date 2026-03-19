# SQL Business Analytics — Pet Supplement Sales

### ERP Sales Order Analysis | Sharon Paulraj

---

## Project Overview

End-to-end SQL analysis of pet supplement sales 
order data modeled after real ERP and WooCommerce 
workflows at a pet supplement distribution company. 
This project demonstrates practical SQL skills 
applied to real business scenarios — from database 
design through to executive-level reporting queries.

---

## Business Questions Answered

- Which products generate the most revenue?
- Which brand drives the highest percentage 
  of total sales?
- Which region is our strongest market?
- How does WooCommerce compare to Wholesale 
  in revenue and average order value?
- Which customers are High Value, Mid Value, 
  or Low Value?

---

## Queries Included

| Query | Business Purpose |
|---|---|
| Product Revenue Ranking | Identify top and 
bottom performing products |
| Brand Revenue + % Share | Compare Herbsmith 
vs SFP vs MVD with subquery |
| Revenue by Region | Geographic performance 
analysis with DISTINCT count |
| Channel Comparison | WooCommerce vs Wholesale 
revenue and avg order value |
| Customer Segmentation | CASE WHEN value 
tiering — High, Mid, Low |

---

## SQL Concepts Demonstrated

- `JOIN` — linking customers, products, 
  and orders tables
- `GROUP BY` — aggregating revenue per 
  product, brand, region, channel
- `SUM` / `COUNT` / `AVG` — business 
  metric calculations
- `ROUND` — clean decimal formatting 
  for reporting
- `COUNT DISTINCT` — accurate unique 
  customer counts
- `Subquery` — calculating revenue 
  percentage share
- `CASE WHEN` — customer value 
  segmentation logic
- `ORDER BY DESC` — ranking results 
  for executive reporting

---

## Database Schema

Four tables — customers, products, 
orders, order_items

- **customers** — customer_id, name, 
  region, channel, signup_date
- **products** — product_id, name, 
  brand, category, unit_price
- **orders** — order_id, customer_id, 
  product_id, date, quantity, 
  total_amount, status
- **order_items** — item_id, order_id, 
  product_id, quantity, line_total

---

## Key Insights From Analysis

- Herbsmith brand led with ~68% of 
  total revenue
- Wholesale channel generated 2x the 
  average order value vs WooCommerce
- Northeast had the fewest orders but 
  ranked 2nd in revenue — highest 
  revenue per order of all regions
- No customer crossed the $500 High 
  Value threshold — entire base sits 
  in Mid or Low tier

---

## Tools Used

- SQLite via sqliteonline.com
- SQL — intermediate level
- HackerRank SQL Intermediate Certificate 
  (March 2026)

---

## Files

- `Herbsmith Sales Order.sql` — all 
  CREATE TABLE, INSERT, and SELECT 
  query scripts

---

## Business Context

This project mirrors the SQL reporting 
work performed by Business Data Analysts 
supporting ERP operations — extracting, 
joining, and aggregating sales order data 
to answer strategic business questions 
around product performance, channel 
strategy, and customer value.

---

## About the Author

**Sharon Paulraj**
ERP Operations Analyst | Milwaukee, WI
Skills: SQL · Power BI · Excel · 
Sage 100 ERP · WooCommerce · 
Business Analysis

- [Power BI Sales Dashboard](https://github.com/sharonpaul604-wq/powerbi-sales-dashboard)
- [Free Order Cost Dashboard](https://github.com/sharonpaul604-wq/free-order-cost-dashboard)
- [Invoice Analytics — Python](https://github.com/sharonpaul604-wq/ai_data_training)

---

*This project is part of an end-to-end 
Sales Performance Analytics capstone 
covering SQL, Excel, and Power BI.*
