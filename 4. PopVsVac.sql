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





