-- Layoffs- Exploratory Data Analysis
-- Even though we did the cleaning, during the EDA, we may find more cleaning to do. 
SELECT *
FROM layoffs_staging2;

-- percentage_laid_off is not as useful as the dataset doesn't give the total number of employees
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
-- 12000 max(total laid off): one company laid off 12000 people! 
-- 1 for max(percentage_laid_off). 1 represents 100 so 100% of the company was laid off

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 desc;


-- Date ranges
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;
-- layoffs started around the covid pandemic

-- what industry got hit during this time and had the most layoffs?
SELECT industry, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Which countries were impacted the most?
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- which (individual) dates had the most layoffs?
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;
-- results are completely different to the video

-- which year had the most layoffs?
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
-- 2023 has the highest impact

-- What stage was the company in?
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Percentages (not much useful info)
SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Progression of layoffs (rolling total layoffs based on the month)
-- Rolling sum: start at the earliest of layoffs, rolling sum until the end of the layoffs
SELECT SUBSTRING(`date`, 6,2) AS `Month`, # getting the month (6th position, 2 values from the 6th position)
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `Month`;





