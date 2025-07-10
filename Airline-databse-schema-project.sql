
CREATE DATABASE IF NOT EXISTS newAirline;

USE newAirline;

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS InternationalBookingInfo;
DROP TABLE IF EXISTS DomesticBookingInfo;
DROP TABLE IF EXISTS InternationalFlights;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS Login; 
DROP TABLE IF EXISTS Users;


CREATE TABLE Users (
    userId BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,    
    passwordHash VARCHAR(255) NOT NULL,      
    email VARCHAR(100) UNIQUE NOT NULL,      
    fullName VARCHAR(100),                 
    registrationDate DATETIME DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE Login (
    username VARCHAR(30) PRIMARY KEY, 
    password VARCHAR(30) NOT NULL,    
    FOREIGN KEY (username) REFERENCES Users(username) 
);


CREATE TABLE flights (
    flightNo VARCHAR(10) PRIMARY KEY,     
    destination VARCHAR(30) NOT NULL,
    source VARCHAR(30) NOT NULL,
    flightDate DATE NOT NULL,              
    ticketPrice DECIMAL(10, 2) NOT NULL,    
    totalSeats INT NOT NULL,
    availableSeats INT NOT NULL,
    CONSTRAINT chk_flights_total_seats CHECK (totalSeats >= 0),
    CONSTRAINT chk_flights_available_seats CHECK (availableSeats >= 0 AND availableSeats <= totalSeats)
);

CREATE TABLE InternationalFlights (
    flightNo VARCHAR(10) PRIMARY KEY,      
    destination VARCHAR(50) NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    flightDate DATE NOT NULL,              
    ticketPrice DECIMAL(10, 2) NOT NULL,   
    totalSeats INT NOT NULL,
    availableSeats INT NOT NULL,
    CONSTRAINT chk_intl_flights_total_seats CHECK (totalSeats >= 0),
    CONSTRAINT chk_intl_flights_available_seats CHECK (availableSeats >= 0 AND availableSeats <= totalSeats)
);

CREATE TABLE DomesticBookingInfo (
    bookingID BIGINT PRIMARY KEY AUTO_INCREMENT, 
    userId BIGINT NOT NULL,                      
    flightNo VARCHAR(10) NOT NULL,               
    name VARCHAR(20) NOT NULL,                   
    age INT NOT NULL CHECK (age > 0),          
    source VARCHAR(30) NOT NULL,
    destination VARCHAR(30) NOT NULL,
    nationality VARCHAR(60) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    ticketClass VARCHAR(20) NOT NULL,
    TicketNo BIGINT UNIQUE NOT NULL,             
    FOREIGN KEY (userId) REFERENCES Users(userId), 
    FOREIGN KEY (flightNo) REFERENCES flights(flightNo) 
);

CREATE TABLE InternationalBookingInfo (
    bookingID BIGINT PRIMARY KEY AUTO_INCREMENT, 
    userId BIGINT NOT NULL,                      
    flightNo VARCHAR(10) NOT NULL,               
    name VARCHAR(20) NOT NULL,                  
    age INT NOT NULL CHECK (age > 0),            
    Origin VARCHAR(30) NOT NULL,
    destination VARCHAR(30) NOT NULL,
    nationality VARCHAR(60) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    ticketClass VARCHAR(20) NOT NULL,
    VisaNum VARCHAR(10) NOT NULL,                
    TicketNo BIGINT UNIQUE NOT NULL,             
    FOREIGN KEY (userId) REFERENCES Users(userId), 
    FOREIGN KEY (flightNo) REFERENCES InternationalFlights(flightNo) 
);

INSERT INTO Users (username, passwordHash, email, fullName) VALUES
('admin', 'hashed_admin_password_123', 'admin@airline.com', 'Administrator'),
('hamid.abdullah', 'hashed_password_hamid', 'hamid.abdullah@example.com', 'Hamid Abdullah'),
('zeeshan.khan', 'hashed_password_zeeshan', 'zeeshan.khan@example.com', 'Zeeshan khan');

INSERT INTO Login (username, password) VALUES ('admin', 'admin');

INSERT INTO InternationalFlights (flightNo, destination, Origin, flightDate, ticketPrice, totalSeats, availableSeats)
VALUES
('PIA001', 'Dubai', 'Karachi', '2024-12-20', 50000.00, 100, 100),
('EMR002', 'New York', 'Dubai', '2024-12-21', 120000.00, 100, 100),
('BA003', 'Toronto', 'London', '2024-12-22', 80000.00, 100, 100),
('QA004', 'Sydney', 'Doha', '2024-12-23', 140000.00, 100, 100),
('SIA005', 'San Francisco', 'Singapore', '2024-12-24', 110000.00, 100, 100),
('TA006', 'Berlin', 'Istanbul', '2024-12-25', 70000.00, 100, 100),
('AI007', 'Bangkok', 'Delhi', '2024-12-26', 60000.00, 100, 100),
('LHA008', 'Tokyo', 'Frankfurt', '2024-12-27', 130000.00, 100, 100),
('AF009', 'Mexico City', 'Paris', '2024-12-28', 90000.00, 100, 100),
('MAS010', 'Beijing', 'Kuala Lumpur', '2024-12-29', 100000.00, 100, 100);

INSERT INTO flights (flightNo, destination, source, flightDate, ticketPrice, totalSeats, availableSeats)
VALUES
('PK101', 'Karachi', 'Lahore', '2024-12-20', 15000.00, 100, 100),
('PK102', 'Islamabad', 'Karachi', '2024-12-21', 17000.00, 100, 100),
('PK103', 'Lahore', 'Islamabad', '2024-12-22', 12000.00, 100, 100),
('PK104', 'Peshawar', 'Lahore', '2024-12-23', 18000.00, 100, 100),
('PK105', 'Quetta', 'Karachi', '2024-12-24', 20000.00, 100, 100),
('PK106', 'Abbottabad', 'Karachi', '2024-12-17', 10000.00, 100, 100);

DELETE FROM InternationalBookingInfo;
DELETE FROM DomesticBookingInfo;

INSERT INTO DomesticBookingInfo (userId, flightNo, name, age, source, destination, nationality, gender, ticketClass, TicketNo) VALUES
(2, 'PK101', 'John Doe', 30, 'Lahore', 'Karachi', 'Pakistani', 'Male', 'Economy', 1000000001),
(3, 'PK102', 'Jane Smith', 25, 'Karachi', 'Islamabad', 'American', 'Female', 'Business', 1000000002);

INSERT INTO InternationalBookingInfo (userId, flightNo, name, age, Origin, destination, nationality, gender, ticketClass, VisaNum, TicketNo) VALUES
(2, 'PIA001', 'John Doe', 30, 'Karachi', 'Dubai', 'Pakistani', 'Male', 'Economy', 'VISA1234', 2000000001),
(3, 'EMR002', 'Jane Smith', 25, 'Dubai', 'New York', 'American', 'Female', 'First Class', 'VISA5678', 2000000002);


SET SQL_SAFE_UPDATES = 1;

DROP USER IF EXISTS 'hamid'@'%';
DROP USER IF EXISTS 'zeeshan'@'%';

-- Create users and grant permissions
CREATE USER 'hamid'@'%' IDENTIFIED BY 'hamid123';
CREATE USER 'zeeshan'@'%' IDENTIFIED BY 'zeeshan123';

GRANT ALL PRIVILEGES ON newAirline.* TO 'hamid'@'%';
GRANT SELECT ON newAirline.flights TO 'zeeshan'@'%';

SELECT 'Login Table' AS TableName, l.* FROM Login l;
SELECT 'Users Table' AS TableName, u.* FROM Users u;
SELECT 'Domestic Flights Table' AS TableName, f.* FROM flights f;
SELECT 'International Flights Table' AS TableName, i.* FROM InternationalFlights i;
SELECT 'Domestic Booking Info Table' AS TableName, dbi.* FROM DomesticBookingInfo dbi;
SELECT 'International Booking Info Table' AS TableName, ibi.* FROM InternationalBookingInfo ibi;
SELECT fullName, flightNo, ticketClass
FROM Users u
JOIN DomesticBookingInfo db ON u.userId = db.userId
WHERE u.username = 'hamid.abdullah';

