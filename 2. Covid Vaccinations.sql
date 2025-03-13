select * 
from PortfolioProject.covidvaccinations;

-- basic checks
-- Select count(*) from PortfolioProject.covidvaccinations;

select distinct continent
from PortfolioProject.covidvaccinations;

select distinct location
from PortfolioProject.covidvaccinations;

-- looking into the count of each continent
select continent, count(continent)
from PortfolioProject.covidvaccinations
group by continent;

-- converting empty strings to null
UPDATE PortfolioProject.covidvaccinations 
SET continent = NULL 
WHERE continent = '';
-- converting empty strings to null
UPDATE PortfolioProject.covidvaccinations
SET new_tests = NULL 
WHERE new_tests = '';
-- converting empty strings to null
UPDATE PortfolioProject.covidvaccinations
SET new_vaccinations = NULL 
WHERE new_vaccinations = '';

select * 
from PortfolioProject.covidvaccinations
where new_tests is not null
order by 3,4;

