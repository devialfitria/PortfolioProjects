-- SELECT DATA

--SELECT 
--	location, 
--	population, 
--	MAX(total_cases) as highest_infection_count, 
--	MAX((total_cases/population))*100 as percent_population_infected
--FROM 
--	PortfolioProject..CovidDeaths
--WHERE 
--	location = 'Indonesia' and
--	continent is not null
--GROUP BY 
--	location,
--	population
--ORDER BY 4 desc



--SELECT
--	location,
--	MAX(cast(total_deaths as int)) as total_deaths_count
--FROM
--	PortfolioProject..CovidDeaths
--WHERE
--	continent is not null
--GROUP BY location
--ORDER BY 2 desc



--SELECT
--	continent,
--	MAX(cast(total_deaths as int)) as total_deaths_count
--FROM
--	PortfolioProject..CovidDeaths
--WHERE
--	continent is not null
--GROUP BY
--	continent
--ORDER BY
--	total_deaths_count desc



--SELECT
--	SUM(new_cases) as total_cases,
--	SUM(cast(new_deaths as int)) as total_deaths,
--	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
--FROM
--	PortfolioProject..CovidDeaths
--WHERE
--	continent is not null
--ORDER BY
--	1, 2





--JOIN TABLE

--SELECT
--	*
--FROM
--	PortfolioProject..CovidDeaths dea
--JOIN
--	PortfolioProject..CovidVaccinations vac
--ON
--	dea.location = vac.location and
--	dea.date = vac.date





--CTE

--WITH PopVSVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as
--(
--SELECT 
--	dea.continent, 
--	dea.location, 
--	dea.date, 
--	dea.population, 
--	vac.new_vaccinations,
--	SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
--FROM
--	PortfolioProject..CovidDeaths dea
--JOIN
--	PortfolioProject..CovidVaccinations vac
--ON
--	dea.location = vac.location and
--	dea.date = vac.date
--WHERE
--	dea.continent is not null
--)

--SELECT
--	*,
--	(rolling_people_vaccinated/population)*100
--FROM
--	PopVSVac





-- TEMP TABLE

--DROP TABLE if exists #PercentPopulationVaccinated

--CREATE TABLE 
--	#PercentPopulationVaccinated (
--continent nvarchar (255),
--location nvarchar (255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--rolling_people_vaccinated numeric)

--INSERT INTO
--	#PercentPopulationVaccinated
--SELECT 
--	dea.continent, 
--	dea.location, 
--	dea.date, 
--	dea.population, 
--	vac.new_vaccinations,
--	SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
--FROM
--	PortfolioProject..CovidDeaths dea
--JOIN
--	PortfolioProject..CovidVaccinations vac
--ON
--	dea.location = vac.location and
--	dea.date = vac.date

--SELECT
--	*,
--	(rolling_people_vaccinated/population)*100
--FROM
--	#PercentPopulationVaccinated





--VIEW

CREATE VIEW PercentPopulationVaccinated as
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
ON
	dea.location = vac.location and
	dea.date = vac.date
WHERE
	dea.continent is not null

SELECT
	*
FROM
	PercentPopulationVaccinated