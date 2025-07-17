select *
from PortfolioProject..Housing

select SaleDate
from PortfolioProject..Housing

select SaleDate,convert(date,SaleDate)
from PortfolioProject..Housing

update Housing
set SaleDate=convert(date,SaleDate)
select SaleDate
from PortfolioProject..Housing
alter table Housing
add SalesDate date;
update Housing
set SalesDate=convert(date,SaleDate)
select SaleDate,SalesDate
from PortfolioProject..Housing

select * from PortfolioProject..Housing 
--where PropertyAddress is null 
order by 2

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from PortfolioProject..Housing a
join PortfolioProject..Housing b
on a.ParcelID=b.ParcelID and a.UniqueID!=b.UniqueID
where a.PropertyAddress is null 
--order by 2
--where PropertyAddress is null 
--order by 2

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Housing a
join PortfolioProject..Housing b
on a.ParcelID=b.ParcelID and a.UniqueID!=b.UniqueID
where a.PropertyAddress is null 

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Housing a
join PortfolioProject..Housing b
on a.ParcelID=b.ParcelID and a.UniqueID!=b.UniqueID
where a.PropertyAddress is null 
 

select PropertyAddress
from PortfolioProject..Housing 

select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)as addresssplit
,substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))as citysplit
from PortfolioProject..Housing 

alter table Housing
add addresssplit nvarchar(255);
update Housing
set addresssplit=SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter table Housing
add citysplit nvarchar(255);
update Housing
set citysplit=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

select Propertyaddress,addresssplit,citysplit
from PortfolioProject..Housing

select *
from PortfolioProject..Housing

select OwnerAddress 
from PortfolioProject..Housing

alter table Housing
add housenosplit numeric;

update Housing
set housenosplit=SUBSTRING(OwnerAddress,1,CHARINDEX(' ',OwnerAddress)-1)


select OwnerAddress,housenosplit
from PortfolioProject..Housing

alter table Housing
add owneraddrsplit nvarchar(255);

update Housing
set owneraddrsplit=SUBSTRING(OwnerAddress,CHARINDEX(' ',OwnerAddress)+1,len(OwnerAddress))


select OwnerAddress,housenosplit,owneraddrsplit
from PortfolioProject..Housing

alter table Housing
add ownerstatesplit nvarchar(255);

update Housing
set ownerstatesplit=SUBSTRING(OwnerAddress,CHARINDEX(' ',OwnerAddress)+1,len(OwnerAddress))


select OwnerAddress,housenosplit,owneraddrsplit
from PortfolioProject..Housing

select
housenosplit,
PARSENAME(replace(owneraddrsplit,',','.'),3) as addr,
PARSENAME(replace(owneraddrsplit,',','.'),2) as city,
PARSENAME(replace(owneraddrsplit,',','.'),1) as state
from PortfolioProject..Housing

alter table Housing
add oaddrsplit nvarchar(255);

update Housing
set oaddrsplit=PARSENAME(replace(owneraddrsplit,',','.'),3) 

alter table Housing
add ocitysplit nvarchar(255);

update Housing
set ocitysplit=PARSENAME(replace(owneraddrsplit,',','.'),2) 

alter table Housing
add ostatesplit nvarchar(255);

update Housing
set ostatesplit=PARSENAME(replace(owneraddrsplit,',','.'),1) 

select OwnerAddress,housenosplit,oaddrsplit,ostatesplit,ocitysplit
from PortfolioProject..Housing

select *
from PortfolioProject..Housing

select SoldAsVacant,count(SoldAsVacant)
from PortfolioProject..Housing
group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE
WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END
from PortfolioProject..Housing


select SoldAsVacant,count(SoldAsVacant)
from PortfolioProject..Housing
group by SoldAsVacant

update Housing
set SoldAsVacant =CASE
WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END
from PortfolioProject..Housing



select SoldAsVacant,count(SoldAsVacant)
from PortfolioProject..Housing
group by SoldAsVacant
;
WITH Row_num_CTE AS (
select *,
ROW_NUMBER() over (
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by 
UniqueID
) as row_num
from PortfolioProject..Housing
)
select *  from Row_num_CTE 
where row_num>1
--order by PropertyAddress


alter table PortfolioProject..Housing
drop column OwnerAddress,TaxDistrict,PropertyAddress

select OwnerAddress,TaxDistrict,PropertyAddress
from PortfolioProject..Housing
