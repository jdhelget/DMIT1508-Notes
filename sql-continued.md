#SQL Continued
-When creating tables, make sure to create the "parent" tables containing the Primary keys before creating the "child" tables containing the foreign keys. When dropping tables make sure to do it in the reverse order.

- In the following example take note of the inclusion of: Composite Primary Keys, Alter Table statements, Dropping and adding constraints, Updating tables, and the creation of indexes

- Inserting data goes by the following format:
	INSERT INTO TableName (ColumnNamList)
		VALUES (ValueList)
- Note Your value list must match your column name list

- Updating data goes by the following format:
	UPDATE TableName 
		SET ColumnName = ValueList
		WHERE WhereCondition

- Deleting date goes by the following format:
	DELETE FROM TableName
		WHERE WhereCondition

- All Of these are DML(Data Manipulation Language)

/* **********************************************
 * Simple Table Creation - Columns and Primary Keys
 *
 * Emergency Service & Product
 * Specification Document 1
 * Version 1.0.0
 *
 * Author: Dan Gilleland
 ********************************************** */

-- Select the CREATE DATABASE stement below to create the demo database.
-- CREATE DATABASE [ESP-A01]

USE [ESP-A01] -- this is a statement that tells us to switch to a particular database
-- Notice in the database name above, it is "wrapped" in square brackets because 
-- the name had a hypen in it. 
-- For all our other objects (tables, columns, etc), we won't use hypens or spaces, so
-- the use of square brackets are optional.
GO  -- this statement helps to "separate" various DDL statements in our script
    -- so that they are executed as "blocks" of code.

/* DROP TABLE statements (to "clean up" the database for re-creation)  */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'OrderDetails')
    DROP TABLE OrderDetails
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'InventoryItems')
    DROP TABLE InventoryItems
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
    DROP TABLE Orders
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Customers')
    DROP TABLE Customers



-- To create a database table, we use the CREATE TABLE statement.
-- Note that the order in which we create/drop tables is important
-- because of how the tables are related via Foreign Keys.
CREATE TABLE Customers
(
    -- The body of a CREATE TABLE will identify a comma-separated list of
    -- Column Declarations and Table Constraints.
    CustomerNumber  int
		-- The following is a PRIMARY KEY constraint that has a very specific name 
		-- Primary key constraints ensure a row of data being added to the table
		-- will have to have a unique value for the Primary Key Column(s)
		CONSTRAINT PK_Customers_CustomerNumber
			PRIMARY KEY
		-- IDENTITY means the database will generate a unique whole-number value for this column
		IDENTITY(100,1) -- the first number is the "seed",
						-- and the last number is the "increment"			
									NOT NULL, --NOT NULL means the data is required
    FirstName       varchar(50)		NOT NULL,
    LastName        varchar(60)		NOT NULL,
    [Address]       varchar(40)		NOT NULL,
    City            varchar(35)		NOT NULL,
    Province        char(2)	
		CONSTRAINT DF_Customers_Province
			DEFAULT ('AB')		
		CONSTRAINT CH_Customers_Province
			CHECK (Province = 'AB' OR
				   Province = 'BC' OR
				   Province = 'SK' OR
				   Province = 'MB' OR
				   Province = 'QC' OR
				   Province = 'ON' OR
				   Province = 'NT' OR
				   Province = 'NS' OR
				   Province = 'NB' OR
				   Province = 'NL' OR
				   Province = 'YK' OR
				   Province = 'NU' OR
				   Province = 'PE')
									NOT NULL,
    PostalCode      char(6)		
		CONSTRAINT CK_Customers_PostalCode
			CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
									NOT NULL,
    PhoneNumber     char(13)	
		CONSTRAINT CK_Customers_PhoneNumber
			CHECK (PhoneNumber LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
									NULL  -- Means the data is optional
)

CREATE TABLE Orders
(
    OrderNumber     int
		CONSTRAINT PK_Orders_OrderNumber
			PRIMARY KEY
		IDENTITY(200,1)
									NOT NULL,
    CustomerNumber  int	
		-- Foreign Key constraints ensure that when a row of data is being inserted or updated,
		-- there is a row in the referenced table that has the same value as it's Primary Key
		CONSTRAINT FK_Orders_CustomerNumber_Customers_CustomerNumber
			FOREIGN KEY REFERENCES
			Customers(CustomerNumber)
									NOT NULL,
    [Date]          datetime		NOT NULL,
    Subtotal        money
		CONSTRAINT CK_Orders_Subtotal
			CHECK (Subtotal > 0)	NOT NULL,
    GST             money	
		CONSTRAINT CK_Orders_GST
			CHECK (GST >= 0)		NOT NULL,
    Total           AS Subtotal + GST   -- This is now a Computed Column
)

CREATE TABLE InventoryItems
(
		ItemNumber			varchar(5)
			CONSTRAINT PK_InventoryItems_ItemNumber
				PRIMARY KEY						NOT NULL,
		ItemDescription		varchar(50)				NULL,
		CurrentSalePrice	money
			CONSTRAINT CK_InventoryItems_CurrentSalePrice
				CHECK (CurrentSalePrice > 0)	NOT NULL,
		InStockCount		int					NOT NULL,
		ReorderLevel		int					NOT NULL
)

CREATE TABLE OrderDetails
(
	OrderNumber				int
		CONSTRAINT FK_OrderDetails_OrderNumber_Orders_OrderNumber
			FOREIGN KEY REFERENCES
			Orders(OrderNumber)					NOT NULL,
	ItemNumber				varchar(5)
		CONSTRAINT FK_OrderDetails_ItemNumber_InventoryItems_ItemNumber
			FOREIGN KEY REFERENCES
			InventoryItems(ItemNumber)			NOT NULL,
	Quantity				int
		CONSTRAINT DF_OrderDetails_Quantity
			DEFAULT (1)
		CONSTRAINT CK_OrderDetails_Quantity
			CHECK (Quantity > 0)				NOT NULL,
	SellingPrice			money
		CONSTRAINT CK_OrderDetails_SellingPrice
			CHECK (SellingPrice > 0)			NOT NULL,
	-- The Amount column is a CALCULATED (or "derived") column.
	-- It's value is the result of multiplying Quantity by SellingPrice.
	Amount					AS Quantity * SellingPrice	,
	-- The following is a table constraint
	-- A composite primary key MUST be done as a table constraint
	-- because it involves two or more columns
	CONSTRAINT PK_OrderDetails_OrderNumber_ItemNumber
		PRIMARY KEY (OrderNumber, ItemNumber) -- specify all the columns in the PK
)

-- Let's insert a few rows of data for the tables
PRINT 'Inserting customer data'
INSERT INTO Customers(FirstName, LastName, [Address], City, PostalCode)
	VALUES ('Clark', 'Kent', '344 Clinton Street', 'Metropolis', 'S0S0N0')
INSERT INTO Customers(FirstName, LastName, [Address], City, PostalCode)
	VALUES ('Jimmy', 'Olsen', '242 River Close', 'Bakerline', 'B4K3R1')
PRINT '--end of customer data--'
PRINT ''

PRINT 'Inserting inventory items'
INSERT INTO InventoryItems(ItemNumber, ItemDescription, CurrentSalePrice, InStockCount, ReorderLevel)
	VALUES ('H8726', 'Cleaning Fan Belt', 29.95, 3, 5)
INSERT INTO InventoryItems(ItemNumber, ItemDescription, CurrentSalePrice, InStockCount, ReorderLevel)
	VALUES ('H8621', 'Engine Fan Belt', 17.45, 10, 5)
PRINT '--End of Inventory data--'
PRINT '' 

PRINT 'Inserting an order'
INSERT INTO Orders(CustomerNumber, [Date], Subtotal, GST)
	VALUES (100, GETDATE(), 17.45, 0.87)
INSERT INTO OrderDetails(OrderNumber, ItemNumber, Quantity, SellingPrice)
	VALUES (200, 'H8726', 1, 17.45)
GO


/* *********************************
 * Change Requests for Spec 1
 * Perform table changes through ALTER statements.
 * Syntax for ALTER TABLE can be found at 
	http://msdn.microsoft.com/en-us/library/ms190273.aspx
 * ALTER TABLE statements allow us to change an existing table without
 * having to drop it or lose information in the table
 * *********************************/

 -- A) Allow Address, City, Province, and Postal Code to be NULL
 -- SQL requires each column to be altered SEPERATELY.
 ALTER TABLE Customers
	ALTER COLUMN [Address] varchar(40) NULL
GO -- this statement helps to "seperate" various DDL statements in our script. It's optional.

ALTER TABLE Customers
	ALTER COLUMN city varchar(35) NULL
GO

ALTER TABLE Customers
	ALTER COLUMN Province char(2) NULL
GO

ALTER TABLE Customers
	ALTER COLUMN PostalCode char(6) NULL
GO

-- B) Add a check constraint on the first and last name to require at least two letters.
-- % is a wildcard for zero or more characters (letter, digit, or other character).
-- _ is a wildcard for a single character (letter, digit, or other character).
-- [] are used to represent a range or set of characters that are allowed.

IF OBJECT_ID('CK_Customers_FirstName', 'C') IS NOT NULL -- 'C' specifies that I'm looking for a constraint
	ALTER TABLE Customers DROP CONSTRAINT CK_Customers_FirstName

ALTER TABLE Customers
	ADD CONSTRAINT CK_Customers_FirstName
		CHECK (FirstName LIKE '[A-Z][A-Z]%')

-- By the time that the ALTER TABLE changes are made for A) and B), 
-- we can insert Customer information allowing certain columns to be NULL.
INSERT INTO Customers(FirstName, LastName)
	VALUES ('Fred', 'Flintstones')
INSERT INTO Customers(FirstName, LastName)
	VALUES ('Barney', 'Rubble')
INSERT INTO Customers(FirstName, LastName, PhoneNumber)
	VALUES ('Wilma', 'Slaghoople', '(403)555-1212')
INSERT INTO Customers(FirstName, LastName, [Address], City)
	VALUES ('Betty', 'Mcbricker', '103 Granite Road', 'Bedrock')

-- Select the customer information
SELECT	CustomerNumber, FirstName, LastName,
		[Address] + ' ' + City + ' ' + Province AS 'Customer Address', 
		PhoneNumber
FROM	Customers

-- C) add a default constraint on the Orders.Date column to use the current cate.
-- GETDATE() is a global function in the SQL Server Database
-- GETDATE() will obtain the current date/time on the database server
IF OBJECT_ID('DF_Orders_Date', 'C') IS NOT NULL
	ALTER TABLE Orders DROP CONSTRAINT DF_Orders_Date

ALTER TABLE Orders
	ADD CONSTRAINT DF_Orders_Date
		DEFAULT GETDATE() FOR [Date]
--		use		\ this /  for \this column/ if no value was supplied when INSERTING data 
GO

--To illustrate the default value, consider this sample row for the Orders table
INSERT INTO Orders(CustomerNumber, Subtotal, GST)
	VALUES (101, 150.00, 7,50)
-- Select the current Orders
SELECT OrderNumber, CustomerNumber, Total, [date]
FROM Orders
GO

-- Prep-data for change request D)....
-- Some inventory data without a ItemDescription
INSERT INTO InventoryItems(ItemNumber, ItemDescription, CurrentSalePrice, InStockCount, ReorderLevel)
	VALUES ('GR35A', NULL, 45.95, 8, 5)
INSERT INTO InventoryItems(ItemNumber, CurrentSalePrice, InStockCount, ReorderLevel)
	VALUES ('KD5-Q', 1.45, 10, 7)
GO
SELECT ItemNumber, ItemDescription, CurrentSalePrice
FROM InventoryItems
GO

-- D) Change the InventoryItems.ItemDescription column to be NOT NULL
--		WAIT!!	We have described the ItemDescription as allowing NULL values.
--				That means we might have dta in the table where the ItemDescription doesn't exist.
--				If we try to make the column NOT NULL, what will we do about the existing data in
--				the database where it is "empty"??
--				we can fix that by updating the data in the database where that description is missing
UPDATE		InventoryItems
	SET		ItemDescription = '-missing-'
	WHERE	ItemDescription IS NULL

-- Also Note:	We might be asked to put a default value for the column 
--				that will become required. In this case, let's use a default 
--				value of '-no description-'
ALTER TABLE InventoryItems
	ADD CONSTRAINT DF_InventoryItems_Description
		DEFAULT '-no description-' FOR ItemDescription
GO
-- Here's some sample data where ItemDescription is not entered and the default value comes into play
INSERT INTO InventoryItems(ItemNumber, CurrentSalePrice, InStockCount, ReorderLevel)
	VALUES	('B-95R', 45.95, 8, 5),
			('GR47D', 92.45, 3, 3)
GO

-- Now we can change the ItemDescription to be required (NOT NULL)
ALTER TABLE InventoryItems
	ALTER COLUMN ItemDescription varchar(50) NOT NULL
GO

-- Let's enter a bit more information in our database
INSERT INTO InventoryItems(ItemNumber, ItemDescription, CurrentSalePrice, InStockCount, ReorderLevel)
	VALUES ('BL-92', '92mm Bolt', 3.95, 18, 6)

-- Let's see the data in the inventory table
SELECT ItemNumber, ItemDescription, CurrentSalePrice
FROM InventoryItems
GO

-- E) Add indexes to the customer's First and Last Name columns as well to the Item's Description column.
-- Indexes improve the performance of the database when retrieving information.
CREATE NONCLUSTERED INDEX IX_Customers_FirstName
	ON Customers (FirstName)
CREATE NONCLUSTERED INDEX IX_Customers_LastName
	ON Customers (LastName)
CREATE NONCLUSTERED INDEX IX_InventoryItems_ItemDescription
	ON InventoryItems (ItemDescription)
GO -- End of a batch of instructions

-- F) Data change requests: All inventory items that are less the $5.00 have to have their prices increased by 10%.

UPDATE InventoryItems
	SET CurrentSalePrice = CurrentSalePrice * 0.10
	WHERE CurrentSalePrice < 5.00

-- Somebody got married....
UPDATE Customers
	SET LastName = 'Flintstone'
	WHERE FirstName = 'Wilma' AND LastName = 'Slaghoople'

UPDATE Customers 
	SET LastName = 'Rubble'
	WHERE FirstName = 'Betty' AND LastName = 'Mcbricker'

UPDATE Customers
	SET [Address] = '103 Granite Road',
		City = 'Bedrock'
	WHERE LastName = 'Rubble'

UPDATE Customers
	SET [Address] = '105 Granite Road',
	City = 'Bedrock'
	WHERE LastName = 'Flintstone'

-- Increase the current sale price for products between $10 and $30 by 2%.
UPDATE InventoryItems 
	SET CurrentSalePrice = CurrentSalePrice * 0.02
	WHERE CurrentSalePrice BETWEEN 10 AND 30

-- And, we want to get rid of some inventory
DELETE FROM InventoryItems
WHERE ItemNumber IN ('GR47D', 'KD5-Q')
GO