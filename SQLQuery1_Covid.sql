
select * 
from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations$
--order by 3,4

--Added Null to Continent column where blank cell was empty
--UPDATE PortfolioProject..CovidDeaths$ SET continent = NULL WHERE continent = ''



select location, date, total_cases, total_deaths
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking at Total cases vs Total Deaths 
--Shows the likelyhood of dying if you have covid in your country

select location, date, total_deaths, total_cases, (total_deaths / total_cases) * 100 as ChanceOfDying
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at Total cases vs Population
--Percent of the population in countries who contracted covid
select location, date, population, total_cases, (total_cases / population) * 100 as PercentOfCases
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2


--Find countries with the highest cases compared to the population 

select location, population, max(total_cases) as MostCases, max((total_cases / population)) * 100 as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths$
--where continent is not null
--where location like '%states%'
group by location, population
order by PercentOfPopulationInfected desc

--Find countries with the most deaths compared to the population 

select location, population, max(cast(total_deaths as int)) as DesceasedTotal, max((total_deaths / population)) * 100 as PercentofThoseWhoDied
from PortfolioProject..CovidDeaths$
where continent is not null
group by location, population
Order by PercentofThoseWhoDied desc

--Finding the continents with the highest death counts 

select location, max(cast(total_deaths as int)) as DesceasedTotal
from PortfolioProject..CovidDeaths$
where continent is null
group by location
order by DesceasedTotal desc

--Find the total world cases and deaths data

select SUM(new_cases) as NewCases, SUM(cast(new_deaths as int)) as NewDeaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as DeathPercent
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2



--Looking for Total Population vs Vaccinations 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as IncrementingPeopleVaccinated
--, (IncrementingPeopleVaccinated / population) * 100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USING CTE

With PopVsVac(continent, location, date, population, new_vaccinations, IncrementingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as IncrementingPeopleVaccinated
--, (IncrementingPeopleVaccinated / population) * 100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (IncrementingPeopleVaccinated/population)*100
from PopVsVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_vaccinations float,
IncrementingPeopleVaccinated float
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as IncrementingPeopleVaccinated
--, (IncrementingPeopleVaccinated / population) * 100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (IncrementingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



--Creating a view to store data for data visualization

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as IncrementingPeopleVaccinated
--, (IncrementingPeopleVaccinated / population) * 100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Create View TotalDeathsPerContinent as
select location, max(cast(total_deaths as int)) as DesceasedTotal
from PortfolioProject..CovidDeaths$
where continent is null
group by location
--order by DesceasedTotal desc

Select * 
from TotalDeathsPerContinent
