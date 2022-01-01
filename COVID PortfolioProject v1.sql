select * from PortfolioProject..CovidDeaths
order by 3,4

--CovidDeaths Table
--Select Useful columns in the Data.
select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths order by 1,2 

--Total Cases Vs Total Deaths
select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercent from PortfolioProject..CovidDeaths
where location like '%india%' order by 1,2

--Total cases Vs Population (it helps us find how much of the population got covid)
select location, date, population,  total_cases, (total_cases/population)*100 as CovidPopulationInfected from PortfolioProject..CovidDeaths
where location like '%india%' order by 1,2

--country with highest infection rate
select location, population,  MAX(total_cases) as MaxInfectionCount, MAX((total_cases/population))*100 as CovidPopulationInfected from PortfolioProject..CovidDeaths
Group by location,population order by CovidPopulationInfected desc

--countries with highest death count per population
select location, population,  MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is not null
Group by location,population order by TotalDeathCount desc

--continent with lowest death count
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is not null group by continent order by TotalDeathCount asc

---segregation of total cases and total deaths from around the world on the basis of date 
select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage from PortfolioProject..CovidDeaths
where continent is not null group by date order by 1,2

--join table.CovidDeaths and table.CovidVaccination
select * from
PortfolioProject..CovidDeaths cd join PortfolioProject..CovidVaccinations cv
on cd.date=cv.date and cd.location=cv.location

--Total Population vs Vaccinations
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location,cd.date) as RollingPeopleVaccinated
from
PortfolioProject..CovidDeaths cd join PortfolioProject..CovidVaccinations cv
on cd.date=cv.date and cd.location=cv.location
where cd.continent is not null
order by 2,3

--Creating a View for Tableau
Create View PercentPopulationVaccinated as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location,cd.date) as RollingPeopleVaccinated
from
PortfolioProject..CovidDeaths cd join PortfolioProject..CovidVaccinations cv
on cd.date=cv.date and cd.location=cv.location
where cd.continent is not null
--order by 2,3

Create View CountryWithHighestInfectionRate as
select location, population,  MAX(total_cases) as MaxInfectionCount, MAX((total_cases/population))*100 as CovidPopulationInfected from PortfolioProject..CovidDeaths
Group by location,population

Create View CountriesWithHighestDeathCount as
select location, population,  MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is not null
Group by location,population
