--select * from PortfolioProject..CovidDeaths
--select * from PortfolioProject..CovidVaccinations

--select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercent from PortfolioProject..CovidDeaths where location like 'I%i%' order by 1,2
--select location,date,total_cases,population,(total_cases/population)*100 as casepercent from PortfolioProject..CovidDeaths 
--where location like 'India' 
--order by 1,2

--select location,date,total_cases,population,(total_cases/population)*100 as casepercent from PortfolioProject..CovidDeaths 
--where location like 'India' 
--order by 5

--select location,population,max(total_cases) as highestinfectionrate,max((total_cases/population)*100) as casepercent from PortfolioProject..CovidDeaths 
--where location like 'India' 
--group by location,population
--order by 4 desc

--select location,max(cast(total_deaths as int)) as deathcount 
--from PortfolioProject..CovidDeaths 
--where continent is not null 
--group by location
--order by 2 desc

--select location,max(cast(total_deaths as int)) as deathcount 
--from PortfolioProject..CovidDeaths 
---where continent is null 
--group by location
--order by 2 desc

--select date,sum(new_cases) as tc,sum(cast(new_deaths as int)) as td,(sum(cast(new_deaths as int))/sum(new_cases)) as deathpercent 
--from PortfolioProject..CovidDeaths 
--where continent is not null 
--group by date
--order by 4 

--from PortfolioProject..CovidDeaths 
--where continent is not null 
--group by date
--order by 3 

--select * 
--from PortfolioProject..CovidVaccinations

--select *
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--on dea.location=vac.location and dea.date=vac.date

--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
---on dea.location=vac.location and dea.date=vac.date
--where dea.continent is not null
--order by 2,3 

--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location,dea.date) as totvac
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--on dea.location=vac.location and dea.date=vac.date
--where dea.continent is not null
--order by 2,3 

With popvsvac
(continent,location,date,population,new_vaccinations,rollingpeoplevac)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3 

)
select *,(rollingpeoplevac/population)*100
from popvsvac

create table #percentpopvac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vac numeric,
rollingpeoplevac numeric
)


insert into #percentpopvac
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3 

select *,(rollingpeoplevac/population)*100
from #percentpopvac

drop view if exists percentpopvacc
CREATE VIEW percentpopvacc as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3 

select *,(rollingpeoplevac/population)*100
from percentpopvacc