--Cleaning Data in SQL Queries

Select *
from NashvilleHousing

--standardize date format

select SaleDate
From NashvilleHousing

select SaleDate, CONVERT(Date, SaleDate)
from NashvilleHousing


update NashvilleHousing
SET SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


update NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)


select SaleDateConverted, CONVERT(Date, SaleDate)
from NashvilleHousing


--Populate Propert Address

Select PropertyAddress
from NashvilleHousing
where PropertyAddress is null


Select *
from NashvilleHousing
where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a
Join NashvilleHousing b 
 on a.ParcelID= b.ParcelID
  AND a.[UniqueID ]<> b.[UniqueID ]
  where a.PropertyAddress is null


  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b 
 on a.ParcelID= b.ParcelID
  AND a.[UniqueID ]<> b.[UniqueID ]
  where a.PropertyAddress is null


  Update a
  SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
  from NashvilleHousing a
Join NashvilleHousing b 
 on a.ParcelID= b.ParcelID
  AND a.[UniqueID ]<> b.[UniqueID ]
   where a.PropertyAddress is null

   --Breaking out Address into Indiviual columns

   select PropertyAddress
   from NashvilleHousing


Select 
SUBSTRING( PropertyAddress, 1, CHARINDEX( ',' , PropertyAddress)) as Address
from NashvilleHousing


Select 
SUBSTRING( PropertyAddress, 1, CHARINDEX( ',' , PropertyAddress) -1) as Address
from NashvilleHousing


Select 
SUBSTRING( PropertyAddress, 1, CHARINDEX( ',' , PropertyAddress) -1) as Address
, SUBSTRING( PropertyAddress, CHARINDEX( ',' , PropertyAddress) +1, LEN(
PropertyAddress)) as Address
from NashvilleHousing


--separate two new columns from other

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX( ',' , PropertyAddress) +1, LEN (PropertyAddress))


select *
from NashvilleHousing


--owner Address Split

Select OwnerAddress
from NashvilleHousing

Select
PARSENAME(OwnerAddress,1)
from NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress,',','.'),1),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
from NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing










ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select *
from NashvilleHousing






-- Change Y and N to Yes and No in "sold as vacant"


select Distinct(SoldAsVacant)
from NashvilleHousing

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant,

CASE
when SoldAsVacant = 'Y' THEN 'Yes'
when SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
END
from NashvilleHousing



Update NashvilleHousing
SET   SoldAsVacant = CASE
when SoldAsVacant = 'Y' THEN 'Yes'
when SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
END


--Remove Duplicates
--CTE

Select *,
ROW_NUMBER() OVER ( 
 PARTITION BY ParcelID, 
               PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID
				) row_num
				from NashvilleHousing
				order by parcelID

WITH RowNumCTE AS (				
Select *,
ROW_NUMBER() OVER ( 
 PARTITION BY ParcelID, 
               PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID
				) row_num

				from NashvilleHousing
				
				)
				

select * from RowNumCTE
where row_num >1
Order By PropertyAddress


--Delete unused columns
select *
from NashvilleHousing

ALTER Table NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

--






