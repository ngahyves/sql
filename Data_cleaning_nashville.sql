SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolio].[dbo].[Sheet1$];

--I)Data cleaning with SQL
--1-Standardize 'saledate' format
SELECT [SaleDate]
FROM [portfolio].[dbo].[Sheet1$];

ALTER TABLE [portfolio].[dbo].[Sheet1$]
ADD date_formated DATE;

UPDATE [portfolio].[dbo].[Sheet1$]
SET date_formated= CAST(SaleDate as date)

SELECT [date_formated], [SaleDate]
FROM [portfolio].[dbo].[Sheet1$]




----------------------------------------------------------------------------------------------------

--2-Populate property address data

SELECT a.[ParcelID], a.[PropertyAddress], b.[PropertyAddress], b.[ParcelID], ISNULL(a.[PropertyAddress],b.[PropertyAddress])
	FROM [portfolio].[dbo].[Sheet1$] a
	JOIN [portfolio].[dbo].[Sheet1$] b
	ON a.[ParcelID]=b.[ParcelID]
	AND a.[UniqueID]<>b.[UniqueID]
WHERE a.[PropertyAddress] IS NULL

UPDATE a
SET [PropertyAddress]=ISNULL(a.[PropertyAddress],b.[PropertyAddress])
FROM [portfolio].[dbo].[Sheet1$] a
	JOIN [portfolio].[dbo].[Sheet1$] b
	ON a.[ParcelID]=b.[ParcelID]
	AND a.[UniqueID]<>b.[UniqueID]
WHERE a.[PropertyAddress] IS NULL

SELECT [PropertyAddress]
FROM [portfolio].[dbo].[Sheet1$]



---------------------------------------------------------------

--3-Breaking Address in 3 columns (address, city and state)
--Find the index of the separators

SELECT [PropertyAddress], CHARINDEX(' ', [PropertyAddress])
FROM [portfolio].[dbo].[Sheet1$]


SELECT [PropertyAddress], CHARINDEX(',', [PropertyAddress])
FROM [portfolio].[dbo].[Sheet1$]

--Find the address number

SELECT  [PropertyAddress],
SUBSTRING(PropertyAddress,1, CHARINDEX(' ' , PropertyAddress)-1) as address
FROM [portfolio].[dbo].[Sheet1$]

ALTER TABLE [portfolio].[dbo].[Sheet1$]
ADD address nvarchar (255)

UPDATE [portfolio].[dbo].[Sheet1$]
SET address=SUBSTRING(PropertyAddress,1, CHARINDEX(' ' , PropertyAddress)-1)

--Find the city
ALTER TABLE [portfolio].[dbo].[Sheet1$]
ADD city nvarchar (255)

UPDATE [portfolio].[dbo].[Sheet1$]
SET city=SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)-CHARINDEX(',' , PropertyAddress))


SELECT address, city
FROM [portfolio].[dbo].[Sheet1$]

--Create an city&address column

SELECT [PropertyAddress],
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',' , PropertyAddress)-1) as address_city
FROM [portfolio].[dbo].[Sheet1$]


ALTER TABLE [portfolio].[dbo].[Sheet1$]
ADD address_city nvarchar (255)

UPDATE [portfolio].[dbo].[Sheet1$]
SET address_city= SUBSTRING(PropertyAddress, 1 , CHARINDEX(',' , PropertyAddress)-1)

---Find the state

SELECT address_city, 
SUBSTRING (address_city,CHARINDEX (' ', address_city)+1, LEN(address_city)-CHARINDEX(',' , address_city)) as state
FROM [portfolio].[dbo].[Sheet1$]

ALTER TABLE [portfolio].[dbo].[Sheet1$]
ADD state nvarchar (255)

update [portfolio].[dbo].[Sheet1$]
SET state= SUBSTRING (address_city,CHARINDEX (' ', address_city)+1, LEN(address_city)-CHARINDEX(',' , address_city))

ALTER TABLE [portfolio].[dbo].[Sheet1$]
DROP COLUMN address_city

---View the result
 
 SELECT address, city, state
 FROM [portfolio].[dbo].[Sheet1$]



SET [address]=SUBSTRING([PropertyAddress], 1, CHARINDEX(' ', [PropertyAddress]))
FROM [portfolio].[dbo].[Sheet1$]

SELECT address
FROM [portfolio].[dbo].[Sheet1$]





------------------------------------------------------------------------------------

--4-Change Y and N into YES or NO in SOLDASVACANT column
SELECT [SOLDASVACANT],
CASE WHEN [SOLDASVACANT] ='Y' then 'YES'
	WHEN [SOLDASVACANT] = 'N' then  'NO'
	ELSE [SOLDASVACANT]
	END
FROM [portfolio].[dbo].[Sheet1$]

UPDATE [portfolio].[dbo].[Sheet1$]
SET [SOLDASVACANT]=CASE WHEN [SOLDASVACANT] ='Y' then 'YES'
	WHEN [SOLDASVACANT] = 'N' then  'NO'
	ELSE [SOLDASVACANT]
	END
SELECT [SOLDASVACANT]
FROM [portfolio].[dbo].[Sheet1$]




----------------------------------------------------------
--5-Remove duplicate

SELECT *
FROM [portfolio].[dbo].[Sheet1$]

WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID
            ORDER BY Uniqueid) rownum
    FROM 
      [portfolio].[dbo].[Sheet1$]
)

DELETE
FROM cte
where rownum>1

-----------------------------------------------------------------------------------
--6-Remove unwanted columns
SELECT *
FROM [portfolio].[dbo].[Sheet1$]


ALTER TABLE [portfolio].[dbo].[Sheet1$]
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict 