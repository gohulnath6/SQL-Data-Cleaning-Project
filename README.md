# SQL-Data-Cleaning-and-EDA
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

# 🧹 SQL Layoffs Data Cleaning Project

This project focuses on cleaning and transforming a dataset of layoffs in the tech industry using SQL. The cleaned dataset will be used for further analysis and insights.

---

## 🗃 Dataset Overview

The original dataset contains the following fields:

- `company`
- `location`
- `industry`
- `total_laid_off`
- `percentage_laid_off`
- `date`
- `stage`
- `country`
- `funds_raised_millions`

---

## 🔧 Cleaning Steps (Using MySQL)

### 1. Create Staging Tables
Creating a TABLE:

CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;

### 2. Remove Duplicate Rows
Using ROW_NUMBER() to identify duplicates:

CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT,
  percentage_laid_off TEXT,
  date TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT,
  row_num INT
);

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off, percentage_laid_off, date) AS row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2 WHERE row_num > 1;

### 3. Standardize Text Fields
Trim whitespace and clean up categories:

UPDATE layoffs_staging2 SET company = TRIM(company);
UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country);
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';

### 4. Fix Date Format
Convert date from text to proper DATE format:

UPDATE layoffs_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE layoffs_staging2 MODIFY COLUMN date DATE;

### 5. Handle Null and Missing Values
Set empty strings to NULL:

UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';
Fill in missing industries using self-joins:

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;
Delete rows with no layoff data:

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

### 6. Final Cleanup
Drop temporary helper columns:

ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

✅ Final Output
The layoffs_staging2 table now contains a clean, standardized dataset ready for:

Data analysis

Dashboards

Reporting

Modeling

📊 Exploratory Data Analysis (EDA)

### 1. Max Layoff Stats

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

### 2. Companies with 100% Layoffs

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

### 3. Total Layoffs by Country

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

### 4. Layoffs by Company Stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

### 5. Companies with Highest Percentage Laid Off

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

### 6. Monthly Layoff Trend

SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY month ASC;

### 7. Rolling Total of Layoffs

WITH rolling_total AS (
  SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE SUBSTRING(date, 1, 7) IS NOT NULL
  GROUP BY month
  ORDER BY month ASC
)
SELECT month, total_off, SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM rolling_total;

### 8. Top Companies by Total Layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

### 9. Yearly Layoffs by Company

SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

### 10. Top 5 Companies per Year by Layoffs

WITH company_year (company, years, total_laid_off) AS (
  SELECT company, YEAR(date), SUM(total_laid_off)
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
), company_year_rank AS (
  SELECT *,
    DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM company_year
  WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;
