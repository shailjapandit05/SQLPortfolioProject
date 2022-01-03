/*
Cleaning Data in SQL Quries
*/

select * from PortfolioProject..nashvilleHousing

--Standardize Date format
select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject..nashvilleHousing

Update NashvilleHousing SET SaleDate=CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing Add SaleDateConverted Date;

Update NashvilleHousing Set SaleDateConverted =CONVERT(Date, SaleDate);

--Populate Property Address
Select * from PortfolioProject..NashvilleHousing --Where PropertyAddress is null
order by ParcelID

Select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress) 
From PortfolioProject.dbo.NashvilleHousing a 
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null

Update a
SET PropertyAddress= ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN POrtfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null



--Breaking address in Address, Street, city

Select PropertyAddress from PortfolioProject..NashvilleHousing --Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
Set PropertySplitAddress =SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
Set PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select * From PortfolioProject..NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE When SoldAsVacant='Y' THEN 'Yes'
When SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--Removing Duplicate Rows

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num
From PortfolioProject..NashvilleHousing
--order by ParcelID
)
SELECT * From RowNumCTE where row_num>1
--DELETE From RowNumCTE where row_num>1
Order by PropertyAddress

--DELETE Unused Columns
Select * From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress