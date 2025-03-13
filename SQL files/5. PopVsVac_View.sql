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