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
select Location,  max(total_cases) as HighestInfectionCount, population, max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject.coviddeaths
where continent is not null
group by Location, population
order by PercentageInfected desc;

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

-- converting empty strings to null
UPDATE PortfolioProject.coviddeaths 
SET continent = NULL 
WHERE continent = '';
-- Error code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column To disable safe mode, toggle the option ....
-- Go to Settings(top right corner) -> SQL Editor -> others(un-check - safe updates)
-- Now - Reconnect to DBMS (Click icon on top)
-- then run above query again, it will work
-- Now run 'TotalDeathCount' query again.


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

-- GLOBAL NUMBERS
select sum(new_cases) as Total_Cases, sum(cast(new_deaths as signed)) as Total_Deaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject.coviddeaths;

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as signed)) as Total_Deaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject.coviddeaths
where continent is not null;




