-- 1 Covid Deaths ***

SELECT * FROM PortfolioProject.coviddeaths;
SELECT count(*) FROM PortfolioProject.coviddeaths; -- 85171

select * 
from PortfolioProject.coviddeaths
where continent is not null
order by 3,4;

select * 
from PortfolioProject.covidvaccinations
where continent is not null
order by 3,4;

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.coviddeaths
where continent is not null
order by 1,2;

-- total cases Vs total deaths
select Location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100 ,3) as DeathPercentage
from PortfolioProject.coviddeaths
where location like '%states%' or location like '%india%'
and continent is not null
order by 1,2;

-- total cases Vs population
-- Shows what percentage of population infected with Covid
select Location, date, total_cases, population, round((total_cases/population)*100 ,3) as PercentagePopulationInfected
from PortfolioProject.coviddeaths
-- where location like '%states%' or location like '%india%'
where continent is not null
order by 1,2;

-- Looking at the countries with highest infection rate compared to population
select Location, population, max(total_cases) as HighestInfectionCount,  max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject.coviddeaths
where continent is not null
group by Location, population
order by PercentagePopulationInfected desc;

-- need to convert 'total_deaths' to int. But,
-- MySQL does not support CAST(column AS INT)
-- so I'm trying with 'signed' in the syntax

-- Showing the countries with highest death count per population
-- few values are null in continent column
-- need to eliminate null values in continent column for the accurate results

-- where continent is not null
select Location, max(cast(total_deaths as signed)) as TotalDeathCount
from PortfolioProject.coviddeaths
where Continent is not null
group by Location
order by TotalDeathCount desc;

-- where continent is null
select location, max(cast(total_deaths as signed)) as TotalDeathCount
from PortfolioProject.coviddeaths
where Continent is null
group by location
order by TotalDeathCount desc;


-- not able to eliminate the null values...?
-- using below queries to find empty strings 
-- then converting empty strings to null
-- select continent from PortfolioProject.coviddeaths where  Continent != '';

-- found out that empty string does not even contain a space, so it is just '' with no space
-- then below query works
-- SELECT continent, COUNT(continent) 
-- FROM PortfolioProject.coviddeaths 
-- WHERE Continent != '' 
-- AND Continent IS NOT NULL
-- GROUP BY continent;

-- converting empty/blank strings to null - continent
UPDATE PortfolioProject.coviddeaths 
SET continent = NULL 
WHERE continent = '';
-- Error code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column To disable safe mode, toggle the option ....
-- Go to Settings(top right corner) -> SQL Editor -> others(un-check - safe updates)
-- Now - Reconnect to DBMS (Click icon on top)
-- then run above query again, it will work
-- Now run 'TotalDeathCount' query again.

-- converting empty/blank strings to null - population
UPDATE PortfolioProject.coviddeaths 
SET population = NULL 
WHERE population = '';

-- Let's break down 'TotalDeathCount' by continent
-- EVERYTHING
select continent, max(cast(total_deaths as signed)) as TotalDeathCount
from PortfolioProject.coviddeaths
group by continent
order by TotalDeathCount desc;

-- CONTINENT NOT NULL
select continent, max(cast(total_deaths as signed)) as TotalDeathCount
from PortfolioProject.coviddeaths
where Continent is not null
group by continent
order by TotalDeathCount desc;

-- Let's break down 'TotalDeathCount' by location
-- we take these out as they are not included in the above queries and want to stay consistant
-- Europe Union is a part of Europe
-- by location
select location, max(cast(total_deaths as signed)) as TotalDeathCount
from PortfolioProject.coviddeaths
where Continent is null
and location not in ('World', 'Europe Union', 'International')
group by location
order by TotalDeathCount desc;


-- GLOBAL NUMBERS
select sum(new_cases) as Total_Cases, sum(cast(new_deaths as signed)) as Total_Deaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject.coviddeaths
where continent is not null
order by 1,2;


-- 2. Covid Vaccinations ***

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

-- basic checks
select * 
from PortfolioProject.covidvaccinations
where new_tests is not null
order by 3,4;

-- 3. Joining Deaths and Vaccinations ***

select * 
from PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date;

-- looking at population and new_vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- adding the new count of vaccications every time to the previous number - Rolling People Vaccinated.
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed))
OVER(partition by dea.location
	order by dea.location, dea.date)
	AS RollingPeopleVaccinated
from PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- looking at total population vs vaccinations
-- Using CTE
with PopvsVac ( Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed))
OVER(partition by dea.location
	order by dea.location, dea.date)
	AS RollingPeopleVaccinated
from PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
select * , (RollingPeopleVaccinated/population)*100 as Percentage
from PopvsVac
;

-- 4. Population Vs Vaccinations ***

-- Creating temporary table to see the max count of vaccinations in each location
-- and percent od population vaccinated

-- looking at total population vs vaccinations
-- Using CTE

-- Temporary Table
use PortfolioProject;
DROP TABLE IF EXISTS PercentPopulationVaccinated;
use PortfolioProject;
create table PercentPopulationVaccinated
(
Continent varchar(225),
Location varchar(225),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);

insert into PercentPopulationVaccinated (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed))
OVER(partition by dea.location
	-- order by dea.location, dea.date
    -- order by dea.date
    )
	AS RollingPeopleVaccinated
from PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
-- where dea.continent is not null
-- order by 2,3
;
select * , (RollingPeopleVaccinated/population)*100 as Percentage
from PercentPopulationVaccinated
;
select location , max((RollingPeopleVaccinated/population)*100) as MaxPercentage
from PercentPopulationVaccinated
group by location
;

-- 5. Population Vs Vaccinations _ Creating View ***

-- creating view to store data for visualizations
DROP view IF EXISTS PercentPopulationVaccinated_View;
create view PercentPopulationVaccinated_View as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed))
OVER(partition by dea.location
	order by dea.location, dea.date
    )
	AS RollingPeopleVaccinated
from PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
;
select * from PortfolioProject.PercentPopulationVaccinated_View;

