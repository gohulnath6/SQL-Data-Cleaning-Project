Select *
From layoffs_staging2;

Select max(total_laid_off), max(percentage_laid_off)
From layoffs_staging2;

Select *
From layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

Select country, sum(total_laid_off)
From layoffs_staging2
group by country
order by 2 desc;

Select *
From layoffs_staging2;

Select stage, sum(total_laid_off)
From layoffs_staging2
group by stage
order by 2 desc;

Select company, sum(percentage_laid_off)
From layoffs_staging2
group by company
order by 2 desc;


Select substring(`date`,1,7) as `month`, sum(total_laid_off)
From layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;


with rolling_total as
(Select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
From layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over(order by `month`) as rolling_total
from rolling_total;


Select company, sum(total_laid_off)
From layoffs_staging2
group by company
order by 2 desc;


Select company, year(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years, total_laid_off) as
(
Select company, year(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(
select *,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5;

