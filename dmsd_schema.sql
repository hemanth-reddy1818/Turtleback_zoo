-- Drop tables if they exist
DROP TABLE IF EXISTS cares_for;
DROP TABLE IF EXISTS participates_in;
DROP TABLE IF EXISTS Revenue_Events_tickets;
DROP TABLE IF EXISTS Revenue_Events;

-- Drop tables with foreign key dependencies
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS enclosure;
DROP TABLE IF EXISTS animal_show;

-- Drop remaining tables
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS Species;
DROP TABLE IF EXISTS zoo_admissions;
DROP TABLE IF EXISTS concession;
DROP TABLE IF EXISTS Revenue_types;
DROP TABLE IF EXISTS Building;
DROP TABLE IF EXISTS hourly_rate;

-- Create the hourly_rate table
CREATE TABLE hourly_rate (
  Hourly_ID INT PRIMARY KEY NOT NULL,
  rate INT NULL
);

CREATE TABLE Species (
  Species_name VARCHAR(50) PRIMARY KEY NOT NULL,
  food_cost INT NULL
);

CREATE TABLE Building (
  Building_ID INT PRIMARY KEY NOT NULL,
  building_name VARCHAR(50) NULL,
  b_type VARCHAR(20) NULL
);

CREATE TABLE Revenue_types (
  Revenue_ID INT PRIMARY KEY NOT NULL,
  r_name VARCHAR(50) NULL,
  r_type VARCHAR(20) NULL,
  B_ID INT ,
  FOREIGN KEY (B_ID) REFERENCES Building (Building_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE zoo_admissions(
  Z_ID INT PRIMARY KEY NOT NULL,
  senior_price INT NULL,
  adult_price INT NULL,
  children_price INT NULL,
  FOREIGN KEY (Z_ID) REFERENCES Revenue_types (Revenue_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE concession(
  C_ID INT PRIMARY KEY NOT NULL,
  product VARCHAR(40) NULL,
  FOREIGN KEY (C_ID) REFERENCES Revenue_types (Revenue_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create the EMPLOYEE table with foreign key references
-- Create the EMPLOYEE table with foreign key references
CREATE TABLE EMPLOYEE (
  Employee_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT ,
  SSN INT UNIQUE NOT NULL,
  F_NAME VARCHAR(45) NULL,
  L_NAME VARCHAR(45) NULL,
  M_NAME VARCHAR(45) NULL,
  street VARCHAR(45) NULL,
  CITY VARCHAR(45) NULL,
  STATE VARCHAR(45) NULL,
  ZIP VARCHAR(10) NULL,
  JOB_TYPE VARCHAR(45) NULL,
  SUPERID INT NULL,
  H_ID INT NULL,
  con_id INT NULL,
  Zoo_id INT NUll,
  FOREIGN KEY (Zoo_id) REFERENCES zoo_admissions (Z_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (con_id) REFERENCES concession (C_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, -- Corrected reference to 'concession'
  FOREIGN KEY (SUPERID) REFERENCES EMPLOYEE (Employee_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (H_ID) REFERENCES hourly_rate(Hourly_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE animal_show(
  A_ID INT PRIMARY KEY NOT NULL,
  senior_price INT NULL,
  adult_price INT NULL,
  children_price INT NULL,
  cost_per_show INT NULL,
  FOREIGN KEY (A_ID) REFERENCES Revenue_types (Revenue_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE enclosure (
  Enc_ID INT NOT NULL,
  B_id INT NOT NULL,
  sqr_ft INT NULL,
  PRIMARY KEY (Enc_ID, B_id),
  FOREIGN KEY (B_id) REFERENCES Building (Building_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE Animal(
  Animal_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  a_status VARCHAR(20) NULL,
  birth_year INT NULL,
  animal_name VARCHAR(50) NULL,
  sp_name VARCHAR(50) NULL,
  En_id INT NULL,
  b_id INT NULL,
  FOREIGN KEY (sp_name) REFERENCES Species (Species_name) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (En_id,b_id) REFERENCES enclosure (Enc_ID, B_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE participates_in(
  ani_id INT NOT NULL,
  sp_name VARCHAR(50) NOT NULL,
  required INT NULL,
  PRIMARY KEY (ani_ID, sp_name),
  FOREIGN KEY (ani_id) REFERENCES animal_show(A_ID),
  FOREIGN KEY (sp_name) REFERENCES Species (Species_name) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Revenue_Events(
  Rev_id INT NOT NULL,
  show_Date Date NOT NULL,
  show_time TIME NOT NULL,
  Revenue INT NULL,
  PRIMARY KEY (Rev_id, show_Date,show_time),
  FOREIGN KEY (Rev_id) REFERENCES Revenue_types (Revenue_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Revenue_Events_tickets(
  Rev_id INT NOT NULL,
  show_Date Date NOT NULL,
  show_time TIME NOT NULL,
  adult_tickets_sold INT NULL,
  children_tickets_sold INT NULL,
  sr_citizen_tickets_sold INT NULL,
  PRIMARY KEY (Rev_id, show_Date,show_time),
  FOREIGN KEY (Rev_id) REFERENCES Revenue_types (Revenue_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE cares_for(
  E_id INT NOT NULL,
  spec_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (E_id, spec_name),
  FOREIGN KEY (E_id) REFERENCES EMPLOYEE (Employee_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (spec_name) REFERENCES Species (Species_name) ON DELETE NO ACTION ON UPDATE NO ACTION
);




-- Insert into hourly_rate
-- Insert into hourly_rate
INSERT INTO hourly_rate (Hourly_ID, rate) VALUES
(1, 20),
(2, 22),
(3, 18),
(4, 25),
(5, 19),
(6, 23),
(7, 21),
(8, 24),
(9, 26),
(10, 20);

-- Insert into Species
INSERT INTO Species (Species_name, food_cost) VALUES
('Mammal', 500),
('Reptile', 800),
('Bird', 400),
('Amphibian', 300),
('Fish', 200),
('Insect', 100),
('Arachnid', 150),
('Mollusk', 120),
('Crustacean', 180),
('Rodent', 80);

-- Insert into Building
INSERT INTO Building (Building_ID, building_name, b_type) VALUES
(1, 'Main Entrance', 'Entrance'),
(2, 'Safari Zone', 'Exhibit'),
(3, 'Food Court', 'Service'),
(4, 'Aviary', 'Exhibit'),
(5, 'Aquarium', 'Exhibit'),
(6, 'Gift Shop', 'Service'),
(7, 'Amphitheater', 'Event'),
(8, 'Reptile House', 'Exhibit'),
(9, 'Insectarium', 'Exhibit'),
(10, 'Rodent House', 'Exhibit');

-- Insert into Revenue_types
INSERT INTO Revenue_types (Revenue_ID, r_name, r_type, B_ID) VALUES
(1, 'Entrance Fee', 'Admission', 1),
(2, 'Safari Tour', 'Event', 2),
(3, 'Food Sales', 'Concession', 3),
(4, 'Gift Shop Sales', 'Concession', 6),
(5, 'Amphitheater Show', 'Event', 7),
(6, 'Reptile Encounter', 'Event', 8),
(7, 'Insect Exhibit', 'Exhibit', 9),
(8, 'Aquarium Show', 'Event', 5),
(9, 'Rodent Exhibit', 'Exhibit', 10),
(10, 'Special Event', 'Event', 7);


-- Insert into zoo_admissions
INSERT INTO zoo_admissions (Z_ID, senior_price, adult_price, children_price) VALUES
(1, 10, 20, 5),
(2, 15, 25, 10),
(3, 12, 18, 8),
(4, 18, 30, 12),
(5, 20, 35, 15),
(6, 8, 15, 5),
(7, 25, 40, 18),
(8, 14, 28, 10),
(9, 10, 22, 7),
(10, 30, 50, 20);

-- Insert into concession
INSERT INTO concession (C_ID, product) VALUES
(1, 'Ice Cream'),
(2, 'Soft Drinks'),
(3, 'Popcorn'),
(4, 'Souvenirs'),
(5, 'Plush Toys'),
(6, 'T-Shirts'),
(7, 'Snacks'),
(8, 'Posters'),
(9, 'Jewelry'),
(10, 'Books');

-- Insert into EMPLOYEE
INSERT INTO EMPLOYEE (Employee_ID, SSN, F_NAME, L_NAME, M_NAME, street, CITY, STATE, ZIP, JOB_TYPE, SUPERID, H_ID, con_id, Zoo_id)
VALUES
(1, 111111111, 'John', 'Doe', 'M', '123 Main St', 'Cityville', 'CA', '12345', 'Supervisor', NULL, 1, NULL, NULL),
(2, 222222222, 'Jane', 'Smith', 'L', '456 Oak St', 'Townsville', 'NY', '67890', 'Veterinarian', 1, 2, NULL, NULL),
(3, 333333333, 'Bob', 'Johnson', 'R', '789 Pine St', 'Villagetown', 'TX', '56789', 'Animal Care Specialist', 1, 3, 1, NULL),
(4, 444444444, 'Alice', 'Williams', 'A', '234 Cedar St', 'Hamletville', 'FL', '34567', 'Animal Care Trainer', 1, 3, 4, NULL),
(5, 555555555, 'Charlie', 'Brown', 'C', '567 Birch St', 'Hometown', 'AZ', '45678', 'Maintenance', 1, 4, NULL, NULL),
(6, 666666666, 'Eva', 'Smith', 'E', '890 Oak St', 'Villagetown', 'TX', '12345', 'Maintenance', 1, 4, 2, NULL),
(7, 777777777, 'Michael', 'Jones', 'M', '123 Elm St', 'Cityville', 'CA', '23456', 'Customer Service', 1, 5, NULL, NULL),
(8, 888888888, 'Sara', 'Miller', 'S', '456 Maple St', 'Townsville', 'NY', '78901', 'Ticket Seller', 1, 6, NULL, 3),
(9, 999999999, 'Olivia', 'Smith', 'O', '890 Birch St', 'Townsville', 'NY', '12345', 'Veterinarian', 1, 2, NULL, NULL),
(10, 101101010, 'Mia', 'Brown', 'M', '567 Oak St', 'Hometown', 'AZ', '45678', 'Animal Care Specialist', 1, 3, 2, NULL),
(11, 202202020, 'Jason', 'Taylor', 'J', '678 Walnut St', 'Cityville', 'CA', '45678', 'Supervisor', NULL, 1, 4, NULL),
(12, 303303030, 'Mia', 'Brown', 'M', '567 Oak St', 'Hometown', 'AZ', '45678', 'Veterinarian', 11, 2, 2, NULL),
(13, 404404040, 'Liam', 'Johnson', 'L', '789 Pine St', 'Villagetown', 'TX', '56789', 'Supervisor', NULL, 1, 1, 1),
(14, 505505050, 'Emma', 'Davis', 'E', '234 Cedar St', 'Hamletville', 'FL', '34567', 'Maintenance', 13, 4, NULL, 2),
(15, 606606060, 'Aiden', 'Garcia', 'A', '567 Birch St', 'Hometown', 'AZ', '45678', 'Ticket Seller', 11, 6, NULL, 5),
(16, 707707070, 'Mia', 'Brown', 'M', '890 Oak St', 'Villagetown', 'TX', '12345', 'Customer Service', 13, 5, NULL, NULL),
(17, 808808080, 'Liam', 'Johnson', 'L', '123 Elm St', 'Cityville', 'CA', '23456', 'Animal Care Specialist', 13, 3, 1, NULL),
(18, 909909090, 'Emma', 'Davis', 'E', '456 Maple St', 'Townsville', 'NY', '78901', 'Maintenance', 11, 4, NULL, 3),
(19, 123456789, 'Aiden', 'Garcia', 'A', '567 Oak St', 'Hometown', 'AZ', '45678', 'Veterinarian', 11, 2, NULL, NULL),
(20, 987654321, 'Mia', 'Brown', 'M', '678 Walnut St', 'Cityville', 'CA', '45678', 'Animal Care Specialist', 13, 3, 2, NULL);

-- Insert into animal_show
INSERT INTO animal_show (A_ID, senior_price, adult_price, children_price, cost_per_show) VALUES
(1, 8, 12, 5, 200),
(2, 10, 15, 8, 250),
(3, 7, 10, 4, 180),
(4, 12, 18, 10, 300),
(5, 15, 22, 12, 350),
(6, 10, 12, 6, 250),
(7, 20, 30, 15, 400),
(8, 18, 25, 12, 350),
(9, 8, 10, 5, 200),
(10, 25, 35, 18, 450);


-- Insert into enclosure
INSERT INTO enclosure (Enc_ID, B_id, sqr_ft) VALUES
(1, 2, 1000),
(2, 3, 800),
(3, 1, 1200),
(4, 4, 700),
(5, 5, 1500),
(6, 6, 600),
(7, 7, 2000),
(8, 8, 1000),
(9, 9, 800),
(10, 10, 1200);


-- Insert into Animal
-- Insert into Animal
INSERT INTO Animal (Animal_ID, a_status, birth_year, animal_name, sp_name, En_id, b_id) VALUES
(1, 'Healthy', 2015, 'Lion', 'Mammal', 1, 2),
(2, 'Maternity Leave', 2018, 'Elephant', 'Mammal', 2, 3),
(3, 'Injured', 2017, 'Giraffe', 'Mammal', 3, 1),
(4, 'Healthy', 2016, 'Tiger', 'Mammal', 4, 4),
(5, 'Injured', 2019, 'Shark', 'Fish', 5, 5),
(6, 'Healthy', 2020, 'Eagle', 'Bird', 6, 6),
(7, 'Died', 2014, 'Cobra', 'Reptile', 7, 7),  -- Corrected the b_id for Cobra
(8, 'Healthy', 2013, 'Octopus', 'Mollusk', 8, 8),  -- Corrected the b_id for Octopus
(9, 'Maternity Leave', 2015, 'Crab', 'Crustacean', 9, 9),  -- Corrected the b_id for Crab
(10, 'Died', 2017, 'Panther', 'Mammal', 10, 10);


-- Insert into participates_in
INSERT INTO participates_in (ani_id, sp_name, required) VALUES
(1, 'Mammal', 2),
(2, 'Reptile', 3),
(3, 'Bird', 1),
(4, 'Amphibian', 2),
(5, 'Fish', 3),
(6, 'Insect', 1),
(7, 'Arachnid', 2),
(8, 'Mollusk', 1),
(9, 'Crustacean', 2),
(10, 'Rodent', 3);

-- Insert into Revenue_Events
INSERT INTO Revenue_Events (Rev_id, show_Date, show_time, Revenue) VALUES
(1, '2023-01-01', '12:00:00', 500),
(2, '2023-02-15', '14:30:00', 750),
(3, '2023-03-30', '10:00:00', 400),
(4, '2023-04-10', '15:00:00', 800),
(5, '2023-05-20', '13:30:00', 1000),
(6, '2023-06-05', '11:00:00', 700),
(7, '2023-07-15', '19:00:00', 1200),
(8, '2023-08-25', '17:30:00', 1000),
(9, '2023-09-12', '14:00:00', 500),
(10, '2023-10-05', '16:30:00', 1500);


-- Insert into Revenue_Events_tickets
-- Insert into Revenue_Events_tickets
INSERT INTO Revenue_Events_tickets (Rev_id, show_Date, show_time, adult_tickets_sold, children_tickets_sold, sr_citizen_tickets_sold) VALUES
(1, '2023-01-01', '12:00:00', 50, 30, 20),
(2, '2023-02-15', '14:30:00', 75, 50, 25),
(3, '2023-03-30', '10:00:00', 40, 25, 15),
(4, '2023-04-10', '15:00:00', 100, 70, 30),
(5, '2023-05-20', '13:30:00', 120, 80, 50),
(6, '2023-06-05', '11:00:00', 90, 60, 30),
(7, '2023-07-15', '19:00:00', 150, 100, 50),
(8, '2023-08-25', '17:30:00', 130, 90, 40),
(9, '2023-09-12', '14:00:00', 60, 40, 20),
(10, '2023-10-05', '16:30:00', 180, 120, 70);
-- Add more rows as needed.


-- Insert into cares_for
INSERT INTO cares_for (E_id, spec_name) VALUES
(1, 'Mammal'),
(2, 'Reptile'),
(3, 'Bird'),
(4, 'Amphibian'),
(5, 'Fish'),
(6, 'Insect'),
(7, 'Arachnid'),
(8, 'Mollusk'),
(9, 'Crustacean')


