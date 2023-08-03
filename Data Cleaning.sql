--Stabdardize Date Format

Select *
from PortfolioProject..[NashvilleHousing]

Select SaleDateConverted, Convert(Date, Saledate)
from PortfolioProject..[NashvilleHousing]

update NashvilleHousing
Set SaleDate= CONVERT(date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date; 

update NashvilleHousing
Set SaleDateConverted= CONVERT(date, SaleDate)

-- Populate Property Address data

Select *
from PortfolioProject..[NashvilleHousing]
--where propertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..[NashvilleHousing] a
JOIN PortfolioProject..[NashvilleHousing] b
 on a. parcelID = b. parcelID
  And a.[UniqueID] <> b.[UniqueID]
  where a.PropertyAddress is null

  Update a
  SET propertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
  from PortfolioProject..[NashvilleHousing] a
JOIN PortfolioProject..[NashvilleHousing] b
 on a. parcelID = b. parcelID
  And a.[UniqueID] <> b.[UniqueID]
  where a.PropertyAddress is null

  --Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProject..[NashvilleHousing]
--where propertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(propertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)as Address
, SUBSTRING(propertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(propertyAddress)) as Address
 from PortfolioProject..[NashvilleHousing]

 
Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255); 

update NashvilleHousing
Set PropertySplitAddress= SUBSTRING(propertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255); 

update NashvilleHousing
Set PropertySplitCity= SUBSTRING(propertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(propertyAddress))


Select *
from PortfolioProject..[NashvilleHousing]

Select OwnerAddress
from PortfolioProject..[NashvilleHousing]

Select
Parsename(Replace(OwnerAddress, ',', '.'), 3)
,Parsename(Replace(OwnerAddress, ',', '.'), 2)
,Parsename(Replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject..[NashvilleHousing]



Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255); 

update NashvilleHousing
Set PropertySplitAddress= Parsename(Replace(OwnerAddress, ',', '.'), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255); 

update NashvilleHousing
Set OwnerSplitCity= Parsename(Replace(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState= Parsename(Replace(OwnerAddress, ',', '.'), 1)



Select *
from PortfolioProject..[NashvilleHousing]


-- Change Y and N to Yes and No in "Sold as Vacant" Field
Select Distinct (SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldASVacant
, Case when SoldAsVacant= 'Y' then 'Yes'
       When SoldAsVacant= 'N' Then 'NO'
	   ELSE SoldAsVacant
	   END
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant=  Case when SoldAsVacant= 'Y' then 'Yes'
       When SoldAsVacant= 'N' Then 'NO'
	   ELSE SoldAsVacant
	   END


--Remove Duplicates

With RowNumCTE AS(
Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDAte,
			   LegalReference
			   ORDER BY
			     UniqueID
				 ) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
from PortfolioProject..NashvilleHousing

--Delete Unused Columns


Select *
from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDAte