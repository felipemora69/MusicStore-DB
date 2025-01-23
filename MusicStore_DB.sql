-- Query 1

-- Stored Procedure
--CREATE PROCEDURE spInsertCategory 
--    @CategoryName NVARCHAR(50)
--AS
--BEGIN
--    INSERT INTO Categories (CategoryName)
--    VALUES (@CategoryName);
--END;

-- Declaration variables
--DECLARE @NewCategoryName1 NVARCHAR(50) = 'Acoustic Guitars';
--DECLARE @NewCategoryName2 NVARCHAR(50) = 'Electric Guitars';

-- Execution statements to test the stored procedures and add the variables into the CategoryName
--EXEC spInsertCategory @NewCategoryName1;
--EXEC spInsertCategory @NewCategoryName2;

--SELECT * FROM Categories;

--Query 2

-- Function creation
--CREATE FUNCTION fnDiscountPrice (@ItemID INT)
--RETURNS DECIMAL(10, 2)
--AS
--BEGIN
---- Declaration of variables to use it
--    DECLARE @ItemPrice DECIMAL(10, 2);  
--    DECLARE @DiscountAmount DECIMAL(10, 2);
--    DECLARE @DiscountPrice DECIMAL(10, 2);

---- Retrieve the ItemPrice and DiscountAmount from OrderItems for the given ItemID
--    SELECT @ItemPrice = ItemPrice, @DiscountAmount = DiscountAmount
--    FROM OrderItems
--    WHERE ItemID = @ItemID;

---- Calculation of the discount price
--    SET @DiscountPrice = @ItemPrice - @DiscountAmount;

---- Return the discount price
--    RETURN @DiscountPrice;
--END;

--SELECT 
--    oi.ItemID,
--    oi.ItemPrice,
--    oi.DiscountAmount,
--    dbo.fnDiscountPrice(oi.ItemID) AS DiscountPrice
--FROM 
--    OrderItems oi;

--Query 3

-- Function creation
--CREATE FUNCTION fnItemTotal (@ItemID INT)
--RETURNS DECIMAL(10, 2)
--AS
--BEGIN
---- Declaration of the variables to use them
--    DECLARE @DiscountPrice DECIMAL(10, 2);
--    DECLARE @Quantity INT;
--    DECLARE @TotalAmount DECIMAL(10, 2);

---- Retrieve the discount price by calling the previous fnDiscountPrice function
--    SELECT @DiscountPrice = dbo.fnDiscountPrice(@ItemID), 
--           @Quantity = Quantity
--    FROM OrderItems
--    WHERE ItemID = @ItemID;

---- Calculation of the total amount
--    SET @TotalAmount = @DiscountPrice * @Quantity;

--    RETURN @TotalAmount;
--END;

--SELECT 
--    oi.ItemID,
--    dbo.fnDiscountPrice(oi.ItemID) AS DiscountPrice,
--    oi.Quantity,
--    dbo.fnItemTotal(oi.ItemID) AS ItemTotal
--FROM 
--    OrderItems oi;

-- Query 4

-- Stored Procedure
--CREATE PROCEDURE spUpdateProductDiscount
--    @ProductID INT,
--    @DiscountPercent DECIMAL(5, 2)
--AS
--BEGIN
---- Check if the discount percentage is negative
--    IF @DiscountPercent < 0
--    BEGIN
---- Error handling if the discount percentage is negative
--        RAISERROR ('DiscountPercent must be a positive number.', 16, 1);
--        RETURN;
--    END
    
---- Update the DiscountPercent in the Products table
--    UPDATE Products
--    SET DiscountPercent = @DiscountPercent
--    WHERE ProductID = @ProductID;
--END;

-- Valid discount percentage
--EXEC spUpdateProductDiscount @ProductID = 1, @DiscountPercent = 19.00;
-- Invalid discount percentage (negative value)
--EXEC spUpdateProductDiscount @ProductID = 2, @DiscountPercent = -8.00;

--SELECT ProductID, ProductName, DiscountPercent
--FROM Products
--WHERE ProductID IN (1, 2);

-- Query 5

-- Stored Procedure
--CREATE PROCEDURE spInsertProduct
--    @CategoryID INT,
--    @ProductCode NVARCHAR(50),
--    @ProductName NVARCHAR(100),
--    @ListPrice DECIMAL(10, 2),
--    @DiscountPercent DECIMAL(5, 2)
--AS
--BEGIN
---- Check if ListPrice is negative
--    IF @ListPrice < 0
--    BEGIN
---- Error handling if ListPrice is negative
--        RAISERROR ('ListPrice cannot be negative.', 16, 1);
--        RETURN;
--    END
    
---- Check if DiscountPercent is negative
--    IF @DiscountPercent < 0
--    BEGIN
---- Error handling if DiscountPercent is negative
--        RAISERROR ('DiscountPercent cannot be negative.', 16, 1);
--        RETURN;
--    END
    
---- Insert a new product into the table
--    INSERT INTO Products (CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, Description, DateAdded)
--    VALUES (@CategoryID, @ProductCode, @ProductName, @ListPrice, @DiscountPercent, '', GETDATE());
--END;

-- Valid input values
--EXEC spInsertProduct 
--    @CategoryID = 1, 
--    @ProductCode = '123', 
--    @ProductName = 'Electric Guitar', 
--    @ListPrice = 800.00, 
--    @DiscountPercent = 15.00;

-- Invalid ListPrice (negative value)
--EXEC spInsertProduct 
--    @CategoryID = 2, 
--    @ProductCode = '456', 
--    @ProductName = 'Acoustic Guitar', 
--    @ListPrice = -300.00, 
--    @DiscountPercent = 8.00;

-- Invalid DiscountPercent (negative value)
--EXEC spInsertProduct 
--    @CategoryID = 3, 
--    @ProductCode = '789', 
--    @ProductName = 'Drum Kit', 
--    @ListPrice = 799.99, 
--    @DiscountPercent = -10.00;

--SELECT ProductID, CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, Description, DateAdded
--FROM Products
--WHERE ProductCode IN ('123', '456', '789');

-- Query 6

-- Trigger Creation
-- Create the trigger Products_UPDATE
--CREATE TRIGGER Products_UPDATE
--ON Products
--FOR UPDATE
--AS
--BEGIN
---- Declaration of the variable
--    DECLARE @NewDiscountPercent DECIMAL(5, 2);

---- Retrieve the new value of DiscountPercent
--    SELECT @NewDiscountPercent = DiscountPercent FROM inserted;

---- Check if the new DiscountPercent is greater than 100 or less than 0
--    IF @NewDiscountPercent > 100 OR @NewDiscountPercent < 0
--    BEGIN
---- Raise an error if the DiscountPercent is out of the allowed range (0 to 100)
--        RAISERROR ('DiscountPercent must be between 0 and 100.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END

---- Check if the new DiscountPercent is between 0 and 1 (inclusive)
--    IF @NewDiscountPercent > 0 AND @NewDiscountPercent < 1
--    BEGIN
---- Multiply the DiscountPercent by 100 if it is between 0 and 1
--        UPDATE Products
--        SET DiscountPercent = @NewDiscountPercent * 100
--        WHERE ProductID IN (SELECT ProductID FROM inserted);
--    END
--END;

-- Valid discount percentage greater than 1 but less than 100
--UPDATE Products
--SET DiscountPercent = 50
--WHERE ProductID = 1;

-- DiscountPercent value between 0 and 1 (e.g., 0.2)
--UPDATE Products
--SET DiscountPercent = 0.2
--WHERE ProductID = 2;

-- Invalid DiscountPercent greater than 100
--UPDATE Products
--SET DiscountPercent = 120
--WHERE ProductID = 3;

-- Invalid DiscountPercent less than 0
--UPDATE Products
--SET DiscountPercent = -5
--WHERE ProductID = 4;

--SELECT ProductID, ProductName, DiscountPercent
--FROM Products;

-- Query 7

-- Trigger Creation
--CREATE TRIGGER Products_INSERT
--ON Products
--FOR INSERT
--AS
--BEGIN
---- Update the DateAdded column to the current date if it is NULL
--    UPDATE Products
--    SET DateAdded = GETDATE()
--    WHERE ProductID IN (SELECT ProductID FROM inserted) AND DateAdded IS NULL;
--END;

-- Insertion of a product without specifying DateAdded (Set current date)
--INSERT INTO Products (CategoryID, ProductCode, ProductName,  Description, ListPrice, DiscountPercent)
--VALUES (2, 'Spect', 'Spector NS', 'The Spector NS Dimension 4 multi-scale bass offers players the look, playability and tone that modern bassists demand. Each model features neck-thru construction, premium tonewoods and active electronics from EMG and Darkglass.',  2099.99, 10);

-- Insert a new product with a specified DateAdded value (this should not trigger the upda--te)
--INSERT INTO Products (CategoryID, ProductCode, ProductName,  Description, ListPrice, DiscountPercent, DateAdded)
--VALUES (3, 'Ludwig-P', 'Ludwig Pocket Kit Black Sparkle', 'Co-developed with Ahmir "Questlove" Thompson to meet the needs of drummers ranging from ages 4-10 years old, the Ludwig Pocket Kit is an all-inclusive setup designed for the early player. These drums are tunable and include all needed hardware and cymbals. Even a pair of drumsticks!', 349.00, 12, '2024-11-08');

--SELECT ProductID, ProductName, DateAdded
--FROM Products;

--Query 8

-- Creation of the new table
--CREATE TABLE ProductsAudit (
--    AuditID INT IDENTITY(1,1) PRIMARY KEY,
--    ProductID INT,
--    CategoryID INT,
--    ProductCode NVARCHAR(50),
--    ProductName NVARCHAR(255),
--    ListPrice DECIMAL(18, 2),
--    DiscountPercent DECIMAL(5, 2),
--    DateUpdated DATETIME
--);

-- Trigger Creation
--CREATE TRIGGER ProductsAudit_UPDATE
--ON Products
--FOR UPDATE
--AS
--BEGIN
---- Insert the old data into the ProductsAudit table
--    INSERT INTO ProductsAudit (ProductID, CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, DateUpdated)
--    SELECT 
--        ProductID, 
--        CategoryID, 
--        ProductCode, 
--        ProductName, 
--        ListPrice, 
--        DiscountPercent, 
--        GETDATE()
--    FROM deleted;
--END;

-- Update a product in the Products table
--UPDATE Products
--SET 
--    ProductCode = 'lesPaul',
--    ProductName = 'Gibson LesPaul', 
--    ListPrice = 1499.00, 
--    DiscountPercent = 40.00
--WHERE ProductID = 2;  -- Update the product with ProductID = 2 (Les Paul)

--SELECT * FROM ProductsAudit;

-- Query 9

--CREATE INDEX idx_ProductCode
--ON Products (ProductCode);

--CREATE INDEX idx_ItemID
--ON OrderItems (ItemID);