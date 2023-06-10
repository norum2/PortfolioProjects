SELECT * FROM CovidDeaths
order by 3,4

SELECT * FROM CovidVaccinations
order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
order by 1,2

--Altered column from nvarchar(255) to float
ALTER TABLE CovidVaccinations ALTER COLUMN new_vaccinations int

-- Looking at Total Cases vs Total Deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPrecentage
FROM CovidDeaths
WHERE location like '%state%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
SELECT Location, date, Population, total_cases, (total_cases/population) * 100 AS DeathPrecentage
FROM CovidDeaths
WHERE location like '%state%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM CovidDeaths
--Where location like '%state%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
FROM CovidDeaths
where continent is not null
Group by location order by TotalDeathCount desc

--Total Death Count by continent
SELECT continent, MAX(Total_deaths) as TotalDeathCount
FROM CovidDeaths
Where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
Select SUM(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location)
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
       SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location) AS total_new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
	)
	Select *, (RollingPeopleVaccinated/Population)*100
	From PopvsVac

--TEMP TABLE
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollinGpeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
       SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
       SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL





