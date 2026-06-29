-- Drop tables if they exist to avoid errors
DROP TABLE IF EXISTS Fuel_Log;
DROP TABLE IF EXISTS Service_History;
DROP TABLE IF EXISTS Insurance;
DROP TABLE IF EXISTS Vehicle_Owners;
DROP TABLE IF EXISTS Owners;
DROP TABLE IF EXISTS Vehicles;

-- Create Vehicles table
CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY AUTO_INCREMENT,
    Brand VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Color VARCHAR(30),
    Status ENUM('Active', 'Inactive', 'Sold') DEFAULT 'Active',
    InsuranceStatus ENUM('Valid', 'Expired', 'Pending') DEFAULT 'Pending'
);

-- Create Owners table
CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT
);

-- Create Vehicle_Owners table
CREATE TABLE Vehicle_Owners (
    VehicleOwnerID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    OwnerID INT,
    PurchaseDate DATE NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID) ON DELETE CASCADE,
    FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID) ON DELETE CASCADE
);

-- Create Insurance table
CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    InsuranceCompany VARCHAR(100),
    PolicyNumber VARCHAR(50) UNIQUE NOT NULL,
    ExpiryDate DATE NOT NULL,
    Status ENUM('Active', 'Expired', 'Pending') DEFAULT 'Active',
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID) ON DELETE CASCADE
);

-- Create Service_History table
CREATE TABLE Service_History (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    ServiceDate DATE NOT NULL,
    ServiceDetails TEXT NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    ServiceCenter VARCHAR(100),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID) ON DELETE CASCADE
);

-- Create Fuel_Log table
CREATE TABLE Fuel_Log (
    FuelLogID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    Date DATE NOT NULL,
    FuelType ENUM('Petrol', 'Diesel', 'Electric', 'Hybrid') NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID) ON DELETE CASCADE
);

-- Insert data into Vehicles
INSERT INTO Vehicles (Brand, Model, Color, Status, InsuranceStatus)
VALUES 
('Toyota', 'Corolla', 'White', 'Active', 'Valid'),
('Honda', 'Civic', 'Black', 'Active', 'Expired'),
('Ford', 'Mustang', 'Red', 'Sold', 'Valid'),
('Tesla', 'Model 3', 'Blue', 'Inactive', 'Pending');

-- Insert data into Owners
INSERT INTO Owners (FullName, ContactNumber, Email, Address)
VALUES 
('John Doe', '1234567890', 'john@example.com', '123 Main Street, NY'),
('Jane Smith', '0987654321', 'jane@example.com', '456 Elm Street, CA');

-- Insert data into Vehicle_Owners
INSERT INTO Vehicle_Owners (VehicleID, OwnerID, PurchaseDate)
VALUES 
(1, 1, '2023-05-10'),
(2, 2, '2022-08-15');

-- Insert data into Insurance
INSERT INTO Insurance (VehicleID, InsuranceCompany, PolicyNumber, ExpiryDate, Status)
VALUES 
(1, 'ABC Insurance', 'POL123456', '2025-12-31', 'Active'),
(2, 'XYZ Insurance', 'POL987654', '2023-07-15', 'Expired');

-- Insert data into Service_History
INSERT INTO Service_History (VehicleID, ServiceDate, ServiceDetails, Cost, ServiceCenter)
VALUES 
(1, '2024-02-20', 'Oil Change and Tire Rotation', 150.00, 'Quick Service Center'),
(2, '2023-11-10', 'Brake Pad Replacement', 250.00, 'Auto Fix Garage');

-- Useful Queries

-- List all vehicles with their owner's name
SELECT V.VehicleID, V.Brand, V.Model, O.FullName AS OwnerName
FROM Vehicles V
JOIN Vehicle_Owners VO ON V.VehicleID = VO.VehicleID
JOIN Owners O ON VO.OwnerID = O.OwnerID;

-- Show service history for a specific vehicle
SELECT V.Brand, V.Model, S.ServiceDate, S.ServiceDetails, S.Cost
FROM Vehicles V
JOIN Service_History S ON V.VehicleID = S.VehicleID
WHERE V.VehicleID = 1;

-- List vehicles with expired insurance
SELECT V.VehicleID, V.Brand, V.Model, I.PolicyNumber, I.ExpiryDate
FROM Vehicles V
JOIN Insurance I ON V.VehicleID = I.VehicleID
WHERE I.Status = 'Expired';

-- Select everything from each table
SELECT * FROM Vehicles;
SELECT * FROM Owners;
SELECT * FROM Vehicle_Owners;
SELECT * FROM Insurance;
SELECT * FROM Service_History;
SELECT * FROM Fuel_Log;
