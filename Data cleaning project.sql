select *
from layoffs;

create table layoffs_staging
like layoffs;

Select *
From layoffs_staging;

insert layoffs_staging
select *
from layoffs;

Select *,
row_number() OVER(Partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
From layoffs_staging;

with duplicate_cte as
(
Select *,
row_number() OVER(Partition by company, location, 
industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

Select *
From layoffs_staging
where company = 'Casper';

with duplicate_cte as
(
Select *,
row_number() OVER(Partition by company, location, 
industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
delete 
from duplicate_cte
where row_num > 1;


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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select *
From layoffs_staging2
where row_num > 1;

insert into layoffs_staging2
Select *,
row_number() OVER(Partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
From layoffs_staging;

delete 
From layoffs_staging2
where row_num > 1;

Select *
From layoffs_staging2;


Select company, trim(company)
From layoffs_staging2;

update layoffs_staging2
set company = trim(company);

Select distinct industry
From layoffs_staging2;

update layoffs_staging2 
set industry = 'Crypto'
where industry like 'Crypto%';

Select distinct country, trim(trailing '.' from country)
From layoffs_staging2
order by 1;

update layoffs_staging2 
set country = trim(trailing '.' from country)
where country like 'United States%';

Select `date`
From layoffs_staging2;

update layoffs_staging2 
set `date` = str_to_date(`date`, '%m/%d/%Y');


alter table layoffs_staging2 
modify column `date` date;


Select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';

Select *
From layoffs_staging2
where industry is null
or industry = '';

Select *
From layoffs_staging2
where company like 'bally%';

Select t1.industry, t2.industry
From layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or  t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or  t1.industry = '')
and t2.industry is not null;

Select *
From layoffs_staging2;

Select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

Select *
From layoffs_staging2;

alter table layoffs_staging2
drop column row_num;