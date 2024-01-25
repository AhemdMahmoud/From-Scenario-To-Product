CREATE DATABASE predictor;
GO
USE predictor;
GO
-- User table
CREATE TABLE [User] (
    UserID INT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    UserType VARCHAR(50) NOT NULL
);

-- Property table
CREATE TABLE Property (
    PropertyID INT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    Area DECIMAL(10, 2) NOT NULL,
    Bedrooms INT NOT NULL,
    Bathrooms INT NOT NULL,
    YearBuilt INT,
    ListingPrice DECIMAL(12, 2) NOT NULL
);

-- Transaction table
CREATE TABLE [Transaction] (
    TransactionID INT PRIMARY KEY,
    PropertyID INT,
    BuyerID INT,
    SellerID INT,
    TransactionDate DATE,
    TransactionPrice DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (BuyerID) REFERENCES [User](UserID),
    FOREIGN KEY (SellerID) REFERENCES [User](UserID)
);

-- Prediction table
CREATE TABLE Prediction (
    PredictionID INT PRIMARY KEY,
    PropertyID INT,
    PredictedPrice DECIMAL(12, 2) NOT NULL,
    PredictionDate DATE,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

-- SearchHistory table
CREATE TABLE SearchHistory (
    SearchID INT PRIMARY KEY,
    UserID INT,
    PropertyID INT,
    SearchDate DATE,
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

-- SellingProperty table
CREATE TABLE SellingProperty (
    SellingID INT PRIMARY KEY,
    UserID INT,
    PropertyID INT,
    SellingPrice DECIMAL(12, 2) NOT NULL,
    SellingDate DATE,
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

-- UserSession table
CREATE TABLE UserSession (
    SessionID INT PRIMARY KEY,
    UserID INT,
    LoginTime DATETIME,
    LogoutTime DATETIME,
    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- PropertyFeature table
CREATE TABLE PropertyFeature (
    FeatureID INT PRIMARY KEY,
    FeatureName VARCHAR(255) NOT NULL
);

-- PropertyType table
CREATE TABLE PropertyType (
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR(255) NOT NULL
);

-- Property-PropertyFeature relationship table
CREATE TABLE PropertyPropertyFeature (
    PropertyID INT,
    FeatureID INT,
    PRIMARY KEY (PropertyID, FeatureID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (FeatureID) REFERENCES PropertyFeature(FeatureID)
);

-- Property-PropertyType relationship table
CREATE TABLE PropertyPropertyType (
    PropertyID INT,
    TypeID INT,
    PRIMARY KEY (PropertyID, TypeID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (TypeID) REFERENCES PropertyType(TypeID)
);
-- Insert sample data into [User] table
INSERT INTO [User] (UserID, Username, Password, Email, UserType)
VALUES
    (1, 'john_doe', 'password123', 'john.doe@email.com', 'Buyer'),
    (2, 'jane_smith', 'pass456', 'jane.smith@email.com', 'Seller'),
    (3, 'agent007', 'secret', 'agent@email.com', 'Agent');

-- Insert sample data into Property table
INSERT INTO Property (PropertyID, Address, Area, Bedrooms, Bathrooms, YearBuilt, ListingPrice)
VALUES
    (1, '123 Main St', 1200, 3, 2, 2000, 250000),
    (2, '456 Oak Ave', 1800, 4, 3, 2015, 350000),
    (3, '789 Pine Ln', 1500, 2, 2, 1990, 200000);

-- Insert sample data into [Transaction] table
INSERT INTO [Transaction] (TransactionID, PropertyID, BuyerID, SellerID, TransactionDate, TransactionPrice)
VALUES
    (1, 1, 1, 2, '2023-01-15', 245000),
    (2, 2, 3, 1, '2023-02-20', 340000);

-- Insert sample data into Prediction table
INSERT INTO Prediction (PredictionID, PropertyID, PredictedPrice, PredictionDate)
VALUES
    (1, 1, 255000, '2023-01-10'),
    (2, 2, 360000, '2023-02-15');

-- Insert sample data into SearchHistory table
INSERT INTO SearchHistory (SearchID, UserID, PropertyID, SearchDate)
VALUES
    (1, 1, 2, '2023-01-05'),
    (2, 2, 3, '2023-02-10');

-- Insert sample data into SellingProperty table
INSERT INTO SellingProperty (SellingID, UserID, PropertyID, SellingPrice, SellingDate)
VALUES
    (1, 2, 1, 245000, '2023-01-20'),
    (2, 1, 3, 195000, '2023-02-25');

-- Insert sample data into UserSession table
INSERT INTO UserSession (SessionID, UserID, LoginTime, LogoutTime)
VALUES
    (1, 1, '2023-01-01 10:00:00', '2023-01-01 12:30:00'),
    (2, 2, '2023-02-01 09:30:00', '2023-02-01 11:45:00');

-- Insert sample data into PropertyFeature table
INSERT INTO PropertyFeature (FeatureID, FeatureName)
VALUES
    (1, 'Swimming Pool'),
    (2, 'Garden'),
    (3, 'Garage');

-- Insert sample data into PropertyType table
INSERT INTO PropertyType (TypeID, TypeName)
VALUES
    (1, 'Apartment'),
    (2, 'House');







--DQL
SELECT * FROM [User];



SELECT * FROM Property;




SELECT
    t.TransactionID,
    t.TransactionDate,
    t.TransactionPrice,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt
FROM
    [Transaction] t
JOIN
    Property p ON t.PropertyID = p.PropertyID;
SELECT
    pr.PredictionID,
    pr.PredictionDate,
    pr.PredictedPrice,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt
FROM
    Prediction pr
JOIN
    Property p ON pr.PropertyID = p.PropertyID;
SELECT
    sh.SearchID,
    sh.SearchDate,
    u.Username AS UserName,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt
FROM
    SearchHistory sh
JOIN
    [User] u ON sh.UserID = u.UserID
JOIN
    Property p ON sh.PropertyID = p.PropertyID;

SELECT
    sp.SellingID,
    sp.SellingDate,
    u.Username AS SellerName,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt,
    sp.SellingPrice
FROM
    SellingProperty sp
JOIN
    [User] u ON sp.UserID = u.UserID
JOIN
    Property p ON sp.PropertyID = p.PropertyID;

SELECT
    us.SessionID,
    us.LoginTime,
    us.LogoutTime,
    u.Username
FROM
    UserSession us
JOIN
    [User] u ON us.UserID = u.UserID;

SELECT * FROM PropertyFeature;
SELECT * FROM PropertyType;


--views 
--View to Display Property Details with Transaction Information:
CREATE VIEW PropertyTransactionView AS
SELECT
    t.TransactionID,
    t.TransactionDate,
    t.TransactionPrice,
    p.PropertyID,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt
FROM
    [Transaction] t
JOIN
    Property p ON t.PropertyID = p.PropertyID;

--View to Display Property Details with Prediction Information:
CREATE VIEW PropertyPredictionView AS
SELECT
    pr.PredictionID,
    pr.PredictionDate,
    pr.PredictedPrice,
    p.PropertyID,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt
FROM
    Prediction pr
JOIN
    Property p ON pr.PropertyID = p.PropertyID;

--View to Display Search History with User and Property Details:
CREATE VIEW SearchHistoryView AS
SELECT
    sh.SearchID,
    sh.SearchDate,
    u.Username AS UserName,
    p.PropertyID,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt
FROM
    SearchHistory sh
JOIN
    [User] u ON sh.UserID = u.UserID
JOIN
    Property p ON sh.PropertyID = p.PropertyID;
--View to Display Selling Properties with User and Property Details:
CREATE VIEW SellingPropertyView AS
SELECT
    sp.SellingID,
    sp.SellingDate,
    u.Username AS SellerName,
    p.PropertyID,
    p.Address,
    p.Area,
    p.Bedrooms,
    p.Bathrooms,
    p.YearBuilt,
    sp.SellingPrice
FROM
    SellingProperty sp
JOIN
    [User] u ON sp.UserID = u.UserID
JOIN
    Property p ON sp.PropertyID = p.PropertyID;

--View to Display User Sessions with User Details:
CREATE VIEW UserSessionView AS
SELECT
    us.SessionID,
    us.LoginTime,
    us.LogoutTime,
    u.Username
FROM
    UserSession us
JOIN
    [User] u ON us.UserID = u.UserID;

