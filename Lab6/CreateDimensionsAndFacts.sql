CREATE TABLE Dim_Products (
    Product_SK INT IDENTITY(1,1) PRIMARY KEY,
    Product_BK INT, -- Business Key from OLTP
    Product_Name NVARCHAR(100),
    Product_Price DECIMAL(10,2),
    Category_BK INT,
    Category_Name NVARCHAR(100),
    SubCategory_BK INT,
    SubCategory_Name NVARCHAR(100),
    Is_Current BIT,
    SSC TINYINT,
    Start_Date DATETIME,
    End_Date DATETIME
);

CREATE TABLE Dim_Sales_Men (
    Salesman_SK INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key
    Salesman_BK INT,                                 -- Business Key from OLTP
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    
    Address_BK INT,                                  -- Address Business Key
    Street NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(50),
    ZipCode NVARCHAR(20),
    
    Is_Current BIT,                                  -- Handled by SSIS SCD
    SSC TINYINT,
    Start_Date DATETIME,                                 -- Handled by SCD Task
    End_Date DATETIME                                    -- Handled by SCD Task
);

CREATE TABLE Dim_Customers (
    Customer_SK INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key
    Customer_BK INT,                                 -- Business Key from OLTP
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    
    GenderID_BK INT,
    GenderName NVARCHAR(20),
    SSC TINYINT,
    Start_Date DATETIME,                                 -- Handled by SCD Task
    End_Date DATETIME,                                   -- Handled by SCD Task
    Is_Current BIT                                   
);

CREATE TABLE Fact_Sales (
    Sales_SK INT IDENTITY(1,1) PRIMARY KEY,

    Date_FK INT,
    Time_FK INT,

    Product_FK INT,

    Customer_FK INT,

    Salesman_FK INT,
    
    Order_BK INT,   -- << Degenerate Dimension here
    OrderDetails_BK INT,   -- << Degenerate Dimension here
    SSC TINYINT,
    Quantity INT,
    Total_Price DECIMAL(10,2),
    Created_At DATE DEFAULT GETDATE()

);
ALTER TABLE Fact_Sales ADD FOREIGN KEY (Date_FK) REFERENCES DimDate(DateSK);
ALTER TABLE Fact_Sales ADD FOREIGN KEY (Time_FK) REFERENCES DimTime(TimeSK);
ALTER TABLE Fact_Sales ADD FOREIGN KEY (Product_FK) REFERENCES Dim_Products(Product_SK);
ALTER TABLE Fact_Sales ADD FOREIGN KEY (Customer_FK) REFERENCES Dim_Customers(Customer_SK);
ALTER TABLE Fact_Sales ADD FOREIGN KEY (Salesman_FK) REFERENCES Dim_Sales_Men(Salesman_SK);