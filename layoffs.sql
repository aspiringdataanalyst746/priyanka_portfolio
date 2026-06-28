-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns and Rows

-- Create columns for staging table
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Data inserted into the staging table
SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. REMOVE DUPLICATES
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num >1; # these are the duplicates that we want to get rid of

# doing a quick check to see if it's really duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';
-- this shows that these aren't really duplicates- we need to do the partition over ALL columns
-- after making changes, we can now see that there is a duplicate. We need to be careful to remove one of them and not both
-- can't use DELETE function in a CTE

-- Creating another table and put this in a 'staging 2' database, filter on the row_nums and filter on those that are = 2
-- Creating a table that has the duplicate row, and then deleting that duplicate row
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num >1; 

-- RHS click table-> copy to clipboard -> create statement
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2; # empty table

-- Insert info into the empty table 
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- select statement to identify what we need to delete
SELECT *
FROM layoffs_staging2
WHERE row_num > 1; # these are the duplicates. we need to delete these

DELETE
FROM layoffs_staging2
WHERE row_num > 1; 

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- Duplicates are now removed! "Row_num" is a column we no longer need- takes up memory, storage and space

-- 2. STANDARDIZING DATA: Finding issues in your data and fixing it
SELECT DISTINCT (TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; # ordering by itself

-- crypto needs to be fixed
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- update all of them (Crypto, Cryptocurrency, Crypto Currency) to Crypto
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- checking
SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- there is a "United States." entry
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2;

-- Changing the date? 
-- In our dataset, the date is a text file (this can be seen on the LHS, drop down menu of the dataset, and then the columns)
-- For time series, we would need to change the data type
-- We are formatting the date to mm/dd/yyyy
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- never do this on the 'raw' table, only on the staging tables as this will change the data type of the actual table
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. NULL AND BLANK VALUES
-- Total_laid_off column
-- Rows where total_laid_off and percentage_laid_off are null is quite useles, may visit this in step 4
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Adding this in after doing joins
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Industry column: null and blank values
SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';
-- there are a few (mine is more compared to in the video)
-- Let's see if any of these are populated:
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';
-- Travel pops up as Industry for the Company Airbnb. Thus we can populate "Travel" to the empty industry columns, for Airbnb

-- We need to do a join. Start off with a select statement, and do a join if it works. 
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company #we want airbnb to be the companies
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;
-- the first 'industry' table is blank, the second (from t2) isn't completely blank.
-- if the first one is blank, the 2nd one is going to populate the 1st one if it's not blank

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- 4. Remove Any Columns and Rows
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- deleting these rows because they might not be useful- not sure if these actually show people getting laid off

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- deleting row_num table
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
