-- EXPLORATORY DATA ANALYSIS

-- OVERALL LAYOFFS SCALE 
-- ** layoffs_staging1 is the raw data
-- ** layoffs_staging2 is the copied data 

SELECT *
FROM layoffs_staging1;

SELECT *
FROM layoffs_staging2;

-- Q1. Viewing the dataset 

SELECT *
FROM layoffs_staging2;

-- Q2. What was the maximum percentage of a company laid off? 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)          
FROM layoffs_staging2;

-- Q3. Which companies laid of 100% of their employees?

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; 

-- Q4. Find companies with the most layoffs number 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;             

-- Q5. Find the date range    

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Q6. Find layoffs by industry

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Q7. Find companies with the most layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Q8. Find layoffs by country

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Q9. Find layoffs by year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)       
ORDER BY 1 DESC;    

-- Q10. Find layoffs by company stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage       
ORDER BY 2 DESC;   

-- Q11. Find companies with the highest summed layoff percentages

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;



-- PROGRESSION OF LAYOFFS 

-- Q12. How did layoffs progressed by month? 

SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off)  
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

-- Q13. How many layoffs have accumulated over time?

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off) AS total_off  -- position of where it starts in the date. on the 6th and how many nmber  2
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Q14. Which companies laid off the most employees overall? From most to least 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

-- Q15. Which companies laid off the most employees in each year?

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;      

-- Q16. Which company laid off the most people per year? 

WITH Company_Year (company, years, total_laid_off) AS    -- temporary table is created 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year;

-- Q17. Which 5 companies had the highest number of layoffs in each year?

WITH Company_Year (company, years, total_laid_off) AS    
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS      
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5 
;


