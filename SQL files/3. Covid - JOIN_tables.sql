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





