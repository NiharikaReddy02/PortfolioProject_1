-- TABLEAU TABLES EXTRACTION

-- Table 1
-- GLOBAL NUMBERS - Death Percentage
select sum(new_cases) as Total_Cases, sum(cast(new_deaths as signed)) as Total_Deaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject.coviddeaths
where continent is not null
order by 1,2;

-- Table 2
-- Let's break down 'TotalDeathCount' by location
-- Europe Union is a part of Europe
-- by location
select location, max(cast(total_deaths as signed)) as TotalDeathCount
from PortfolioProject.coviddeaths
where Continent is null
and location not in ('World', 'Europe Union', 'International')
group by location
order by TotalDeathCount desc;

-- Table 3
-- Looking at the countries with highest infection rate compared to population
-- In excel, we need to replace the NULL to Zero
select Location, population, max(total_cases) as HighestInfectionCount,  max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject.coviddeaths
-- where continent is not null
group by Location, population
order by PercentagePopulationInfected desc;


-- Table 4
-- In excel, we need to replace the NULL to Zero
select Location, population, date, max(total_cases) as HighestInfectionCount,  max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject.coviddeaths
group by Location, population, date
order by PercentagePopulationInfected desc;


