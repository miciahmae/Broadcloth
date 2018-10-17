-- BroadclothDM developed and written by Broadcloth Team
-- Originally written: October 2018 | Updated: --
-----------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'BroadclothDM')
	CREATE DATABASE BroadclothDM
GO  

USE BroadclothDM
GO

--
--Drop Existing Tables
--

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'FactSales'
	)
	DROP TABLE FactSales;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimCustomer'
	)
	DROP TABLE DimCustomer;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimFactory'
	)
	DROP TABLE DimFactory;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimModel'
	)
	DROP TABLE DimModel;
-- 
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDate'
	)
	DROP TABLE DimDate;

--
--Build Tables
--

CREATE TABLE DimDate --Build script for DimDate taken from BuildAdventureWorksDM2017 created by Amy Phillips
	(
	Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);

--
CREATE TABLE DimCustomer
	(
	Customer_SK			INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Customer_AK			INT NOT NULL,
	City			    NVARCHAR(20) NOT NULL,
	CustomerState	    NVARCHAR(20) NOT NULL,
	Nation		        NVARCHAR(50) NOT NULL,
	PersonCategory		NVARCHAR(20) NOT NULL
	);
--
CREATE TABLE DimFactory
	(
	Factory_SK			INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Factory_AK			INT NOT NULL,
	City				NVARCHAR(30) NOT NULL,
	Nation				NVARCHAR(50) NOT NULL,
	MaxWorkers			INT NOT NULL,
	ContactFirstName	NVARCHAR(20) NOT NULL,
	ContactLastName     NVARCHAR(25) NOT NULL
	);
--
CREATE TABLE DimModel
	(
	Model_SK			INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Model_AK			INT NOT NULL,
	BasePrice			MONEY NOT NULL,
	SizeLow				DECIMAL NOT NULL,
	SizeHigh			DECIMAL NOT NULL,
	Color				NVARCHAR(50) NOT NULL
	);
--
CREATE TABLE FactSales
	(
	Customer_SK			INT NOT NULL,
	Factory_SK			INT NOT NULL,
	Model_SK			INT NOT NULL,
	OrderDateKey		INT NOT NULL,
	ShipDateKey			INT NOT NULL,
	OrderPrice			MONEY,
	OrderQuantity		INT,
	CONSTRAINT fk_order_dim_date FOREIGN KEY (OrderDateKey) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_ship_dim_date FOREIGN KEY (ShipDateKey) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_dim_customer FOREIGN KEY (Customer_SK) REFERENCES DimCustomer(Customer_SK),
	CONSTRAINT fk_dim_factory FOREIGN KEY (Factory_SK) REFERENCES DimFactory(Factory_SK),
	CONSTRAINT fk_dim_model FOREIGN KEY (Model_SK) REFERENCES DimModel(Model_SK)
	);

