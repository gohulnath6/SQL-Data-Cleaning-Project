# SQL-Data-Cleaning-Project
A SQL-based project focused on cleaning and preparing raw datasets by handling duplicates, null values, and formatting issues.

# SQL Data Cleaning Project

This project focuses on using SQL to clean and prepare raw data for analysis. The script includes steps to remove inconsistencies, handle null values, and format data into a usable structure.

## 📁 File

- `Data cleaning project.sql`  
  Contains SQL queries for:
  - Removing duplicates
  - Handling NULL or missing values
  - Standardizing text and formatting
  - Filtering invalid or inconsistent records

# SQL Data Cleaning Project

This project demonstrates how to clean and standardize raw data using SQL. It includes common data-cleaning operations such as removing duplicates, handling NULL values, and reformatting fields to prepare datasets for analysis or reporting.

## 🔧 Key Cleaning Operations

### ✅ Remove Duplicates
```sql
DELETE FROM sales_data
WHERE id NOT IN (
  SELECT MIN(id)
  FROM sales_data
  GROUP BY order_id, product_id
);

UPDATE customer_data
SET phone_number = 'Not Provided'
WHERE phone_number IS NULL;

UPDATE product_data
SET category = UPPER(category);

UPDATE product_data
SET category = UPPER(category);

DELETE FROM orders
WHERE order_date > CURRENT_DATE;
