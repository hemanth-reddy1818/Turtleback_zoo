Use Turtleback_zoo;
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
DROP TABLE IF EXISTS Species;
DROP TABLE IF EXISTS EMPLOYEE;

DROP TABLE IF EXISTS zoo_admissions;
DROP TABLE IF EXISTS concession;
DROP TABLE IF EXISTS Revenue_types;
DROP TABLE IF EXISTS Building;
DROP TABLE IF EXISTS hourly_rate;

-- Create the hourly_rate table
CREATE TABLE hourly_rate (
  Hourly_ID INT PRIMARY KEY NOT NULL ,
  rate INT NULL
);



CREATE TABLE Building (
  Building_ID INT PRIMARY KEY NOT NULL auto_increment,
  building_name VARCHAR(50) NULL,
  b_type VARCHAR(20) NULL
);

CREATE TABLE Revenue_types (
  Revenue_ID INT PRIMARY KEY NOT NULL auto_increment,

  r_type VARCHAR(20) NULL,
  B_ID INT ,
  FOREIGN KEY (B_ID) REFERENCES Building (Building_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE zoo_admissions  (
  Z_ID INT PRIMARY KEY NOT NULL,
  show_name Varchar(50) NULL,
  senior_price INT NULL,
  adult_price INT NULL,
  children_price INT NULL,
  FOREIGN KEY (Z_ID) REFERENCES Revenue_types (Revenue_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE concession(
  C_ID INT PRIMARY KEY NOT NULL,
  product VARCHAR(40) NULL,
  price INT NULL,
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
  start_date date NOT NULL,
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
CREATE TABLE Species (
  Species_name VARCHAR(50) PRIMARY KEY NOT NULL,
  food_cost INT NULL,
  emp_id INT NULL,
  FOREIGN KEY (emp_id) REFERENCES EMPLOYEE (Employee_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
  
  
);
CREATE TABLE animal_show(
  A_ID INT PRIMARY KEY NOT NULL ,
  show_name varchar(50) NULL,
  senior_price INT NULL,
  adult_price INT NULL,
  children_price INT NULL,

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


CREATE TABLE Revenue_Events_tickets(
  Rev_id INT NOT NULL ,
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


-- Insert into Building
-- Insert into Building
INSERT INTO Building (Building_ID, building_name, b_type) VALUES
(1, 'Main Entrance', 'Attraction'),
(2, 'Safari Zone', 'Attraction'),
(3, 'Food Court', 'Concession Stand'),
(4, 'Aviary', 'Attraction'),
(5, 'Aquarium', 'Attraction'),
(6, 'Gift Shop', 'Concession Stand'),
(7, 'Amphitheater', 'Attraction'),
(8, 'Reptile House', 'Animal Shelter'),
(9, 'Insectarium', 'Animal Shelter'),
(10, 'Rodent House', 'Animal Shelter'),
(11, 'Playground Area', 'Attraction'),
(12, 'Botanical Garden', 'Attraction'),
(13, 'Cafeteria', 'Concession Stand'),
(14, 'Butterfly House', 'Attraction'),
(15, 'Observation Deck', 'Attraction'),
(16, 'Penguin Enclosure', 'Animal Shelter'),
(17, 'Interactive Zone', 'Concession Stand'),
(18, 'Mammal Nursery', 'Animal Shelter'),
(19, 'Education Center', 'Concession Stand'),
(20, 'Picnic Area', 'Attraction');

-- Insert into Revenue_types
-- Insert into Revenue_types
INSERT INTO Revenue_types (Revenue_ID, r_type, B_ID) VALUES
-- Rows for 'zoo_admissions'
(1, 'zoo_admissions', 1),
(2, 'zoo_admissions', 2),
(3, 'zoo_admissions', 4),
(4, 'zoo_admissions', 5),
(5, 'zoo_admissions', 7),
(6, 'zoo_admissions', 11),
(7, 'zoo_admissions', 12),
(8, 'zoo_admissions', 14),
(9, 'zoo_admissions', 15),
(10, 'zoo_admissions', 3),
(31, 'zoo_admissions', 17),

-- Rows for 'animal_show'
(11, 'animal_show', 1),
(12, 'animal_show', 2),
(13, 'animal_show', 4),
(14, 'animal_show', 5),
(15, 'animal_show', 7),
(16, 'animal_show', 11),
(17, 'animal_show', 12),
(18, 'animal_show', 14),
(19, 'animal_show', 15),
(20, 'animal_show', 3),
(32, 'animal_show', 17),

-- Rows for 'concession'
(21, 'concession', 3),
(22, 'concession', 6),
(23, 'concession', 13),
(24, 'concession', 17),
(25, 'concession', 3),
(26, 'concession', 6),
(27, 'concession', 13),
(28, 'concession', 17),
(29, 'concession', 3),
(30, 'concession', 6),
-- Additional rows for each type and B_ID
(33, 'zoo_admissions', 1),
(34, 'zoo_admissions', 2),
(35, 'zoo_admissions', 4),
(36, 'zoo_admissions', 5),
(37, 'zoo_admissions', 7),
(38, 'zoo_admissions', 11),
(39, 'zoo_admissions', 12),
(40, 'zoo_admissions', 14),
(41, 'zoo_admissions', 15),
(42, 'zoo_admissions', 3),
(43, 'animal_show', 1),
(44, 'animal_show', 2),
(45, 'animal_show', 4),
(46, 'animal_show', 5),
(47, 'animal_show', 7),
(48, 'animal_show', 11),
(49, 'animal_show', 12),
(50, 'animal_show', 14),
(51, 'animal_show', 15),
(52, 'animal_show', 3),
(53, 'concession', 13),
(54, 'concession', 17),
(55, 'concession', 3),
(56, 'concession', 6),
(57, 'concession', 13),
(58, 'concession', 17),
(59, 'concession', 3),
(60, 'concession', 6),
(61, 'concession', 13),
(62, 'concession', 17);



-- Insert into zoo_admissions
-- Insert into zoo_admissions
INSERT INTO zoo_admissions (Z_ID, show_name, senior_price, adult_price, children_price)
VALUES
(1, 'Lion Encounter', 15, 25, 10),
(2, 'Monkey Madness', 16, 26, 11),
(3, 'Tropical Adventure', 17, 27, 12),
(4, 'Penguin Paradise', 18, 28, 13),
(5, 'Safari Spectacle', 19, 29, 14),
(6, 'Aquatic Wonders', 20, 30, 15),
(7, 'Birds of Prey Showcase', 21, 31, 16),
(8, 'Butterfly Bliss', 22, 32, 17),
(9, 'Reptile Rendezvous', 23, 33, 18),
(10, 'Elephant Extravaganza', 24, 34, 19),
(31, 'Kangaroo Kingdom', 25, 35, 20),
(33, 'Giraffe Gala', 26, 36, 21),
(34, 'Zebra Zenith', 27, 37, 22),
(35, 'Hippopotamus Happening', 28, 38, 23),
(36, 'Cheetah Celebration', 29, 39, 24),
(37, 'Gorilla Gathering', 30, 40, 25),
(38, 'Panda Parade', 31, 41, 26),
(39, 'Koala Komotion', 32, 42, 27),
(40, 'Seal Soiree', 33, 43, 28),
(41, 'Dolphin Delight', 34, 44, 29),
(42, 'Polar Bear Party', 35, 45, 30);


-- Insert into concession
-- Insert data into concession table for 'concession' rows
-- Insert into concession
INSERT INTO concession (C_ID, product, price)
VALUES
(21, 'Popcorn', 20),
(22, 'Soda', 15),
(23, 'Hot Dog', 12),
(24, 'Candy', 5),
(25, 'Nachos', 7),
(26, 'Pretzel', 15),
(27, 'Ice Cream', 30),
(28, 'Chips', 10),
(29, 'Pizza', 40),
(30, 'Cotton Candy', 8),
(53, 'Burger', 25),
(54, 'Fries', 18),
(55, 'Soft Drink', 12),
(56, 'Caramel Apple', 6),
(57, 'Cheese Nachos', 9),
(58, 'Brownie Sundae', 28),
(59, 'Fruit Cup', 10),
(60, 'Chicken Tenders', 35),
(61, 'Slushie', 14),
(62, 'Chocolate Bar', 4);



--- Insert into EMPLOYEE
INSERT INTO EMPLOYEE (Employee_ID, SSN, F_NAME, L_NAME, M_NAME, street, CITY, STATE, ZIP, JOB_TYPE, SUPERID, H_ID, con_id, Zoo_id, start_date)
VALUES
-- 10 rows with various job types
(1, 111111111, 'John', 'Doe', 'M', '123 Main St', 'Cityville', 'CA', '12345', 'Supervisor', NULL, 1, NULL, NULL, '2022-01-15'),
(2, 222222222, 'Jane', 'Smith', 'L', '456 Oak St', 'Townsville', 'NY', '67890', 'Veterinarian', 1, 2, NULL, NULL, '2022-02-01'),
(3, 333333333, 'Bob', 'Johnson', 'R', '789 Pine St', 'Villagetown', 'TX', '56789', 'Animal Care Specialist', 1, 2, NULL, NULL, '2022-03-10'),
(4, 444444444, 'Alice', 'Williams', 'A', '234 Cedar St', 'Hamletville', 'FL', '34567', 'Animal Care Trainer', 1, 2, NULL, NULL, '2022-04-05'),
(5, 555555555, 'Charlie', 'Brown', 'C', '567 Birch St', 'Hometown', 'AZ', '45678', 'Maintenance', 1, 3, NULL, NULL, '2022-05-20'),
(6, 666666666, 'Eva', 'Smith', 'E', '890 Oak St', 'Villagetown', 'TX', '12345', 'Maintenance', 1, 3, NULL, NULL, '2022-06-12'),
(7, 777777777, 'Michael', 'Jones', 'M', '123 Elm St', 'Cityville', 'CA', '23456', 'Customer Service', 1, 4, NULL, NULL, '2022-07-08'),
(8, 888888888, 'Sara', 'Miller', 'S', '456 Maple St', 'Townsville', 'NY', '78901', 'Ticket Seller', 1, 5, NULL, 3, '2022-08-03'),
(9, 999999999, 'Olivia', 'Smith', 'O', '890 Birch St', 'Townsville', 'NY', '12345', 'Veterinarian', 1, 2, NULL, NULL, '2022-09-18'),
(10, 101101010, 'Mia', 'Brown', 'M', '567 Oak St', 'Hometown', 'AZ', '45678', 'Animal Care Specialist', 1, 2, NULL, NULL, '2022-10-22'),

-- 15 rows with 'Sales' job type and con_id between 21 and 35
(11, 111111110, 'Jason', 'Taylor', 'J', '678 Walnut St', 'Cityville', 'CA', '45678', 'Sales', NULL, 1, 21, 4, '2022-11-07'),
(12, 999999998, 'Mia', 'Brown', 'M', '567 Oak St', 'Hometown', 'AZ', '45678', 'Veterinarian', 11, 2, NULL, NULL, '2022-12-15'),
(13, 999999997, 'Liam', 'Johnson', 'L', '789 Pine St', 'Villagetown', 'TX', '56789', 'Supervisor', NULL, 1, NULL, NULL, '2023-01-10'),
(14, 999999996, 'Emma', 'Davis', 'E', '234 Cedar St', 'Hamletville', 'FL', '34567', 'Maintenance', 13, 3, NULL, 2, '2023-02-25'),
(15, 999999995, 'Aiden', 'Garcia', 'A', '567 Birch St', 'Hometown', 'AZ', '45678', 'Ticket Seller', 13, 5, NULL, 5, '2023-03-18'),
(16, 999999994, 'Mia', 'Brown', 'M', '890 Oak St', 'Villagetown', 'TX', '12345', 'Customer Service', 13, 4, NULL, NULL, '2023-04-12'),
(17, 999999993, 'Liam', 'Johnson', 'L', '123 Elm St', 'Cityville', 'CA', '23456', 'Animal Care Specialist', 13, 2, NULL, NULL, '2023-05-03'),
(18, 999999992, 'Emma', 'Davis', 'E', '456 Maple St', 'Townsville', 'NY', '78901', 'Maintenance', 13, 3, NULL, 2, '2023-06-22'),
(19, 999999991, 'Aiden', 'Garcia', 'A', '567 Oak St', 'Hometown', 'AZ', '45678', 'Veterinarian', 13, 2, NULL, NULL, '2023-07-15'),
(20, 999999990, 'Mia', 'Brown', 'M', '678 Walnut St', 'Cityville', 'CA', '45678', 'Animal Care Specialist', 13, 2, NULL, NULL, '2023-08-09'),
(21, 999999989, 'Sophia', 'Thomas', 'S', '123 Main St', 'Cityville', 'CA', '12345', 'Veterinarian', 13, 2, NULL, NULL, '2023-09-01'),
(22, 999999988, 'James', 'Roberts', 'J', '456 Oak St', 'Townsville', 'NY', '67890', 'Ticket Seller', 13, 5, NULL, 3, '2023-10-15'),
(23, 999999987, 'Ava', 'Martin', 'A', '789 Pine St', 'Villagetown', 'TX', '56789', 'Maintenance', 13, 3, NULL, 2, '2023-11-08'),
(24, 999999986, 'Jackson', 'Hill', 'J', '234 Cedar St', 'Hamletville', 'FL', '34567', 'Sales', 13, 8, 30, 4, '2023-12-25'),
(25, 999999985, 'Emma', 'Gordon', 'E', '567 Birch St', 'Hometown', 'AZ', '45678', 'Animal Care Specialist', 13, 2, NULL, NULL, '2024-01-18'),
(26, 999999984, 'Oliver', 'Myers', 'O', '890 Oak St', 'Villagetown', 'TX', '12345', 'Customer Service', 13, 4, NULL, NULL, '2024-02-12'),
(27, 999999983, 'Ava', 'Thomas', 'A', '123 Elm St', 'Cityville', 'CA', '23456', 'Veterinarian', 13, 2, NULL, NULL, '2024-03-03'),
(28, 999999982, 'Liam', 'Johnson', 'L', '456 Maple St', 'Townsville', 'NY', '78901', 'Animal Care Specialist', 13, 2, NULL, NULL, '2024-04-22'),
(29, 999999981, 'Sophia', 'Roberts', 'S', '890 Birch St', 'Townsville', 'NY', '12345', 'Maintenance', 13, 3, NULL, 3, '2024-05-15'),
(30, 999999980, 'James', 'Garcia', 'J', '567 Oak St', 'Hometown', 'AZ', '45678', 'Sales', 13, 8, 26, 5, '2024-06-09');



-- Insert into Species
INSERT INTO Species (Species_name, food_cost,emp_id) VALUES
('Mammal', 500,2),
('Reptile', 800,3),
('Bird', 400,4),
('Amphibian', 300,9),
('Fish', 200,10),
('Insect', 100,12),
('Arachnid', 150,17),
('Mollusk', 120,19),
('Crustacean', 180,20),
('Rodent', 80,21);

-- Insert data into animal_show table for 'animal_show' rows
-- Insert data into animal_show table for 'animal_show' rows
-- Insert data into animal_show table for 'animal_show' rows with show_name
-- Insert into animal_show
INSERT INTO animal_show (A_ID, show_name, senior_price, adult_price, children_price)
VALUES
(11, 'Lion Show', 30, 15, 50),
(12, 'Monkey Show', 31, 16, 51),
(13, 'Elephant Show', 32, 17, 52),
(14, 'Tiger Show', 33, 18, 53),
(15, 'Giraffe Show', 34, 19, 54),
(16, 'Penguin Show', 35, 20, 55),
(17, 'Seal Show', 36, 21, 56),
(18, 'Kangaroo Show', 37, 22, 57),
(19, 'Panda Show', 38, 23, 58),
(20, 'Bear Show', 39, 24, 59),
(32, 'Dolphin Show', 40, 25, 60),
(43, 'Zebra Show', 41, 26, 61),
(44, 'Hippopotamus Show', 42, 27, 62),
(45, 'Cheetah Show', 43, 28, 63),
(46, 'Gorilla Show', 44, 29, 64),
(47, 'Penguin Encounter', 45, 30, 65),
(48, 'Parrot Show', 46, 31, 66),
(49, 'Koala Show', 47, 32, 67),
(50, 'Snake Show', 48, 33, 68),
(51, 'Crocodile Show', 49, 34, 69),
(52, 'Jungle Adventure', 50, 35, 70);



-- Insert into enclosure
INSERT INTO enclosure (Enc_ID, B_id, sqr_ft) VALUES
(1, 2, 1000),
(2, 4, 800),
(3, 5, 1200),
(4, 8, 700),
(5, 9, 1500),
(6, 10, 600),
(7, 2, 2000),
(8, 4, 1000),
(9, 5, 800),
(10, 8, 1200);


-- Insert into Animal
INSERT INTO Animal (Animal_ID, a_status, birth_year, animal_name, sp_name, En_id, b_id) VALUES
(1, 'Healthy', 2015, 'Lion', 'Mammal', 1, 2),
(2, 'Maternity Leave', 2018, 'Elephant', 'Mammal', 2, 4),
(3, 'Injured', 2017, 'Giraffe', 'Mammal', 3, 5),
(4, 'Healthy', 2016, 'Tiger', 'Mammal', 4, 8),
(5, 'Injured', 2019, 'Shark', 'Fish', 5, 9),
(6, 'Healthy', 2020, 'Eagle', 'Bird', 6, 10),
(7, 'Died', 2014, 'Cobra', 'Reptile', 7, 2),
(8, 'Healthy', 2013, 'Octopus', 'Mollusk', 8, 4),
(9, 'Maternity Leave', 2015, 'Crab', 'Crustacean', 9, 5),
(10, 'Died', 2017, 'Panther', 'Mammal', 10, 8),
(11, 'Healthy', 2015, 'Lion', 'Mammal', 1, 2),
(12, 'Maternity Leave', 2018, 'Elephant', 'Mammal', 2, 4),
(13, 'Injured', 2017, 'Giraffe', 'Mammal', 3, 5),
(14, 'Healthy', 2016, 'Tiger', 'Mammal', 4, 8),
(15, 'Injured', 2019, 'Shark', 'Fish', 5, 9),
(16, 'Healthy', 2020, 'Eagle', 'Bird', 6, 10),
(17, 'Died', 2014, 'Cobra', 'Reptile', 7, 2),
(18, 'Healthy', 2013, 'Octopus', 'Mollusk', 8, 4),
(19, 'Maternity Leave', 2015, 'Crab', 'Crustacean', 9, 5),
(20, 'Died', 2017, 'Panther', 'Mammal', 10, 8),
(21, 'Healthy', 2015, 'Lion', 'Mammal', 1, 2),
(22, 'Maternity Leave', 2018, 'Elephant', 'Mammal', 2, 4),
(23, 'Injured', 2017, 'Giraffe', 'Mammal', 3, 5),
(24, 'Healthy', 2016, 'Tiger', 'Mammal', 4, 8),
(25, 'Injured', 2019, 'Shark', 'Fish', 5, 9),
(26, 'Healthy', 2020, 'Eagle', 'Bird', 6, 10),
(27, 'Died', 2014, 'Cobra', 'Reptile', 7, 2),
(28, 'Healthy', 2013, 'Octopus', 'Mollusk', 8, 4),
(29, 'Maternity Leave', 2015, 'Crab', 'Crustacean', 9, 5),
(30, 'Died', 2017, 'Panther', 'Mammal', 10, 8);


-- Insert into participates_in
INSERT INTO participates_in (ani_id, sp_name, required) VALUES
(11, 'Mammal', 2),
(12, 'Reptile', 3),
(13, 'Bird', 1),
(14, 'Amphibian', 2),
(15, 'Fish', 3),
(16, 'Insect', 1),
(17, 'Arachnid', 2),
(18, 'Mollusk', 1),
(19, 'Crustacean', 2),
(20, 'Rodent', 3);

-- Insert into Revenue_Events



-- Insert into Revenue_Events_tickets
-- Insert into Revenue_Events_tickets
-- Insert into Revenue_Events_tickets
-- Insert into Revenue_Events_tickets
INSERT INTO Revenue_Events_tickets (Rev_id, show_Date, show_time, adult_tickets_sold, children_tickets_sold, sr_citizen_tickets_sold)
VALUES
-- Rows for 'zoo_admissions'
(1, '2023-01-01', '12:00:00', 50, 30, 20),
(2, '2023-01-01', '14:30:00', 75, 50, 25),
(3, '2023-03-30', '10:00:00', 40, 25, 15),
(4, '2023-04-10', '15:00:00', 100, 70, 30),
(5, '2023-01-20', '13:30:00', 120, 80, 50),
(6, '2023-06-05', '11:00:00', 90, 60, 30),
(7, '2023-07-15', '19:00:00', 150, 100, 50),
(8, '2023-01-25', '17:30:00', 130, 90, 40),
(9, '2023-09-12', '14:00:00', 60, 40, 20),
(10, '2023-10-05', '16:30:00', 180, 120, 70),
(31, '2023-01-01', '12:00:00', 50, 30, 20),
(33, '2023-02-15', '16:00:00', 80, 50, 30),
(34, '2023-03-01', '18:30:00', 120, 80, 40),
(35, '2023-04-15', '14:00:00', 90, 60, 30),
(36, '2023-05-05', '12:30:00', 110, 70, 35),
(37, '2023-06-20', '20:00:00', 160, 110, 60),
(38, '2023-07-10', '17:30:00', 140, 95, 45),
(39, '2023-08-01', '13:00:00', 70, 45, 25),
(40, '2023-09-25', '15:30:00', 200, 140, 80),
(41, '2023-10-15', '18:00:00', 130, 85, 40),
(42, '2023-11-05', '16:30:00', 170, 110, 60),

-- Rows for 'animal_show'
-- Insert into Revenue_Events_tickets
(11, '2023-01-01', '12:00:00', 30, 20, 10),
(12, '2023-02-15', '14:30:00', 40, 30, 15),
(13, '2023-03-30', '10:00:00', 25, 15, 10),
(14, '2023-04-10', '15:00:00', 50, 40, 20),
(15, '2023-05-20', '13:30:00', 60, 50, 30),
(16, '2023-06-05', '11:00:00', 45, 35, 15),
(17, '2023-07-15', '19:00:00', 70, 60, 40),
(18, '2023-08-25', '17:30:00', 65, 50, 25),
(19, '2023-09-12', '14:00:00', 30, 20, 10),
(20, '2023-10-05', '16:30:00', 90, 70, 40),
(32, '2023-10-01', '16:30:00', 90, 70, 40),
(43, '2023-01-15', '13:00:00', 35, 25, 15),
(44, '2023-12-01', '15:30:00', 55, 45, 20),
(45, '2023-12-15', '12:00:00', 40, 30, 15),
(46, '2023-01-10', '17:00:00', 70, 60, 30),
(47, '2023-02-05', '14:30:00', 80, 70, 40),
(48, '2023-03-20', '18:00:00', 55, 45, 20),
(49, '2023-04-10', '16:30:00', 75, 60, 30),
(50, '2023-05-01', '12:00:00', 60, 50, 25),
(51, '2023-06-15', '19:30:00', 100, 80, 40),
(52, '2023-01-05', '17:00:00', 85, 70, 35),

-- Rows for 'concession'
-- Insert into Revenue_Events_tickets
(21, '2023-01-01', '12:00:00', 100, 50, 30),
(22, '2023-01-01', '14:30:00', 120, 60, 40),
(23, '2023-03-30', '10:00:00', 80, 40, 20),
(24, '2023-04-10', '15:00:00', 150, 80, 50),
(25, '2023-05-20', '13:30:00', 180, 100, 70),
(26, '2023-06-05', '11:00:00', 130, 70, 40),
(27, '2023-07-15', '19:00:00', 200, 120, 80),
(28, '2023-08-25', '17:30:00', 170, 90, 60),
(29, '2023-09-12', '14:00:00', 90, 50, 30),
(30, '2023-10-05', '16:30:00', 220, 150, 100),
(53, '2023-11-15', '13:00:00', 110, 80, 50),
(54, '2023-12-01', '15:30:00', 130, 90, 60),
(55, '2023-12-15', '12:00:00', 100, 60, 40),
(56, '2024-01-10', '17:00:00', 150, 100, 70),
(57, '2024-02-05', '14:30:00', 170, 120, 80),
(58, '2024-03-20', '18:00:00', 130, 80, 50),
(59, '2024-04-10', '16:30:00', 160, 110, 70),
(60, '2024-01-01', '12:00:00', 140, 90, 60),
(61, '2024-06-15', '19:30:00', 180, 130, 90),
(62, '2024-07-05', '17:00:00', 160, 110, 70);


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

-- Trigger for validating SSN
DELIMITER //

CREATE TRIGGER check_SSN_range
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
  IF NEW.SSN < 100000000 OR NEW.SSN > 999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Employee ID must be between 100000000 and 999999999';
  END IF;
END //

DELIMITER ;

