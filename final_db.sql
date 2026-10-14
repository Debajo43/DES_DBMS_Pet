-- Pet Care Management System - MySQL Schema (Final ERD)
-- ============================================================

CREATE DATABASE IF NOT EXISTS pet_care_db;
USE pet_care_db;

-- ------------------------------------------------------------
-- 1. USERS  (login superclass)
-- ------------------------------------------------------------
CREATE TABLE Users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    email       VARCHAR(150)  NOT NULL UNIQUE,
    phone       VARCHAR(20),
    password    VARCHAR(255)  NOT NULL
);

-- ------------------------------------------------------------
-- 2. PET OWNER  (1:1 subtype of User)
-- ------------------------------------------------------------
CREATE TABLE Pet_owners (
    owner_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL UNIQUE,
    o_name        VARCHAR(100),
    phone       VARCHAR(20),
    email       VARCHAR(150),
    address     VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 3. STAFF  (1:1 subtype of User)
-- ------------------------------------------------------------
CREATE TABLE Staff (
    staff_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL UNIQUE,
    s_name            VARCHAR(100),
    phone           VARCHAR(20),
    email           VARCHAR(150),
    role            VARCHAR(50),
    specialization  VARCHAR(150),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 4. PET  (owns: Pet Owner 1---M Pet)
-- ------------------------------------------------------------
CREATE TABLE Pet (
    pet_id         INT AUTO_INCREMENT PRIMARY KEY,
    owner_id       INT NOT NULL,
    pet_name       VARCHAR(100) NOT NULL,
    species        VARCHAR(50),
    breed          VARCHAR(100),
    gender         ENUM('male', 'female', 'unknown') DEFAULT 'unknown',
    age				INT,
    weight         DECIMAL(6,2),
    FOREIGN KEY (owner_id) REFERENCES Pet_owners(owner_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 5. APPOINTMENT
--    Pet 1---M Appointment (has), Staff 1---M Appointment (conducts)
-- ------------------------------------------------------------
CREATE TABLE Appointments (
    appointment_id    INT AUTO_INCREMENT PRIMARY KEY,
    pet_id            INT NOT NULL,
    staff_id          INT NOT NULL,
    service_ID		  INT NOT NULL,
    appointment_date  DATE NOT NULL,
    appointment_time  TIME NOT NULL,
    reason            VARCHAR(255),
    status            ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    FOREIGN KEY (pet_id)   REFERENCES Pet(pet_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- ------------------------------------------------------------
-- 6. MEDICAL RECORD
--    Appointment 1---M Medical Record (generates)
--    Staff 1---M Medical Record (creates) -> staff_id added
--    for referential integrity (not explicitly drawn as an attribute)
-- ------------------------------------------------------------
CREATE TABLE Medical_records (
    record_id       INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT NOT NULL,
    pet_id          INT NOT NULL,
    staff_id        INT NOT NULL,
    diagnosis       TEXT,
    treatment       TEXT,
    prescription    TEXT,
    visit_date     DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id)         REFERENCES Pet(pet_id),
    FOREIGN KEY (staff_id)       REFERENCES Staff(staff_id)
);

-- ------------------------------------------------------------
-- 7. MEDICAL SERVICES  (catalog)general checkup,vaccination,dental checkup,grooming,surgery consultation
-- ------------------------------------------------------------
CREATE TABLE Services (
    service_id  INT AUTO_INCREMENT PRIMARY KEY,
    service_name        VARCHAR(100) NOT NULL,
    description          VARCHAR(255),
    cost                 DECIMAL(10,2) NOT NULL
);




-- ------------------------------------------------------------
-- 8. BILL  (Appointment 1---1 Bill)
-- ------------------------------------------------------------
CREATE TABLE Bills (
    bill_id         INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT NOT NULL UNIQUE,
    bill_date       DATE NOT NULL,
    total_amount    DECIMAL(10,2) NOT NULL,
    bill_status     ENUM('unpaid', 'paid', 'cancelled') DEFAULT 'unpaid',
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 9. PAYMENT  (Bill 1---1 Payment)
-- ------------------------------------------------------------
CREATE TABLE Payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    bill_id         INT NOT NULL UNIQUE,
    payment_date	DATE,
    amount          DECIMAL(10,2) NOT NULL,
    payment_status  ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_method  ENUM('cash', 'card', 'upi') DEFAULT 'cash',
    FOREIGN KEY (bill_id) REFERENCES Bills(bill_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Helpful indexes
-- ------------------------------------------------------------
-- CREATE INDEX idx_pets_owner         ON pets(owner_id);
-- CREATE INDEX idx_appointments_pet   ON appointments(pet_id);
-- CREATE INDEX idx_appointments_staff ON appointments(staff_id);
-- CREATE INDEX idx_appointments_date  ON appointments(appointment_date);
-- CREATE INDEX idx_medrec_pet         ON medical_records(pet_id);
-- CREATE INDEX idx_medrec_staff       ON medical_records(staff_id);
-- CREATE INDEX idx_vacc_pet           ON vaccinations(pet_id);
-- CREATE INDEX idx_vacc_appointment   ON vaccinations(appointment_id);
-- CREATE INDEX idx_bills_appointment  ON bills(appointment_id);
-- CREATE INDEX idx_payments_bill      ON payments(bill_id);

select * from Users;
select * from Pet_owners;
select * from Staff;
select * from Pet;
select * from Appointments;
select * from Medical_records;
select * from Services;
select * from Bills;
select * from Payments;

insert into Users(user_id,email,phone,password) values(101,'rahul@gmail.com','89077354622','pass123');
insert into Users(user_id,email,phone,password) values(102,'priya@gmail.com','9876543211', 'pass456');
insert into Users(user_id,email,phone,password) values(103,'raj@gmail.com', '9876543212', 'pass789');
insert into Users(user_id,email,phone,password) values(104,'amit@gmail.com','8998077056','pass111');
insert into Users(user_id,email,phone,password) values(105,'riya@gmail.com','9807795946','pass125');
insert into Users(user_id,email,phone,password) values(106,'sneha@gmail.com','1200321186','pass183');
insert into Users(user_id,email,phone,password) values(107,'arjun@gmail.com','4563339087','pass903');
insert into Users(user_id,email,phone,password) values(108,'kavya@gmail.com','7806540092','pass786');
insert into Users(user_id,email,phone,password) values(109,'rohan@gmail.com','9934022399','pass487');
insert into Users(user_id,email,phone,password) values(110,'shravani@gmail.com','8904455653','pass532');

INSERT INTO Pet_owners (user_id,owner_id, o_name, phone, email, address) VALUES
(101, 10,'Rahul Sharma', '89077354622', 'rahul@gmail.com', 'Andheri, Mumbai'),
(102, 11,'Priya Patel', '9876543211', 'priya@gmail.com', 'Bandra, Mumbai'),
(103, 12,'Raj Verma', '9876543212', 'raj@gmail.com', 'Powai, Mumbai'),
(104, 13,'Amit Singh', '8998077056', 'amit@gmail.com', 'Thane, Mumbai'),
(105, 14,'Riya Mehta', '9807795946', 'riya@gmail.com', 'Dadar, Mumbai'),
(106, 15,'Sneha Teli', '1200321186', 'rahul@gmail.com', 'Powai, Mumbai'),
(107, 16,'Arjun Patil', '4563339087', 'arjun@gmail.com', 'Shanipar, Pune'),
(108, 17,'Kavya Shah', '7806540092', 'kavya@gmail.com', 'Dadar, Satara'),
(109, 18,'Rohan Singh', '9934022399', 'rohan@gmail.com', 'Thane, Nagpur'),
(110, 19,'Shravani Amnekar', '8904455653', 'shravani@gmail.com', 'JM Road, Pune');

INSERT INTO Staff
(user_id,staff_id, s_name, phone, email, role, specialization) VALUES
(101,201, 'Dr. Sneha Rao', '9876543215', 'sneharao@gmail.com',
 'Veterinarian', 'General Medicine'),
(102,202, 'Dr. Abhay Shah', '9876543216', 'abhay@gmail.com',
 'Veterinarian', 'Surgery'),
(103,203, 'Dr. Shreya Iyer', '9876543217', 'shreya@gmail.com',
 'Veterinarian', 'Dental Care'),
(104,204, 'Dr. Shirisha Shetty', '9876543218', 'shetty@gmail.com',
 'Veterinarian', 'Vaccination'),
(105,205, 'Dr. Simar Kaur', '9876543219', 'simar@gmail.com',
 'Veterinarian', 'Cosmetology'),
(106,206, 'Dr. Tanvi Patel', '9876543212', 'tanvi@gmail.com',
 'Veterinarian', 'Dental Care'),
 (107,207, 'Dr. Pooja Verma', '9876543213', 'pooja@gmail.com',
 'Veterinarian', 'General Checkup'),
(108,208, 'Dr. Mahesh Joshi', '9876543290', 'mahesh@gmail.com',
 'Veterinarian', 'Dental Care'),
 (109,209, 'Dr. Jain', '9876543210', 'jain@gmail.com',
 'Veterinarian', 'Dermatology'),
(110,210, 'Dr. Patil', '9876543211', 'patil@gmail.com',
 'Veterinarian', 'Dental Care');
 
 INSERT INTO Pet
(pet_id, owner_id, pet_name, species, breed, weight, age, gender)
VALUES
(1, 10, 'Bruno', 'Dog', 'Golden Retriever', 28.5, '2', 'Male'),
(2,11, 'Luna', 'Cat', 'Persian', 4.2, '3', 'Female'),
(3,12, 'Max', 'Dog', 'Labrador', 25.0, '1', 'Male'),
(4, 13, 'Bella', 'Dog', 'Beagle', 12.5, '4', 'Female'),
(5, 14, 'Coco', 'Cat', 'Siamese', 3.8, '2', 'Female'),
(6, 15, 'Rocky', 'Dog', 'German Shepherd', 32.0, '12', 'Male'),
(7, 16, 'Milo', 'Rabbit', 'Holland Lop', 2.1, '13', 'Male'),
(8, 17, 'Daisy', 'Dog', 'Pug', 8.4, '20', 'Female'),
(9, 18, 'Leo', 'Cat', 'Maine Coon', 6.5, '6', 'Male'),
(10, 19, 'Oreo', 'Dog', 'Shih Tzu', 7.2, '5', 'Male');

INSERT INTO Services
(service_ID, service_Name, description, cost)
VALUES
(1, 'General Checkup', 'Complete health examination', 500.00),
(2, 'Vaccination', 'Routine pet vaccination', 800.00),
(3, 'Dental Checkup', 'Dental examination and cleaning', 600.00),
(4, 'Blood Test', 'Complete blood examination', 700.00),
(5, 'X-Ray', 'Pet X-Ray examination', 1200.00),
(6, 'Surgery Consultation', 'Consultation before surgery', 1000.00),
(7, 'Grooming', 'Basic pet grooming service', 450.00),
(8, 'Deworming', 'Deworming treatment', 350.00),
(9, 'Skin Treatment', 'Treatment for skin problems', 900.00),
(10, 'Emergency Care', 'Emergency medical treatment', 1500.00);

INSERT INTO Appointments
(appointment_id, pet_id, staff_id, service_ID, reason,
 appointment_date, appointment_time, status)
VALUES
(1001, 1, 201, 1, 'Regular health checkup', '2026-10-01', '10:00:00', 'completed'),
(1002, 2, 202, 9, 'Skin allergy', '2026-10-02', '11:00:00', 'completed'),
(1003, 3, 203, 6, 'Surgery consultation', '2026-10-03', '12:00:00', 'completed'),
(1004, 4, 204, 3, 'Dental problem', '2026-10-04', '09:30:00', 'completed'),
(1005, 5, 206, 2, 'Annual vaccination', '2026-10-05', '10:30:00', 'completed'),
(1006, 6, 205, 5, 'Leg injury', '2026-10-06', '14:00:00', 'completed'),
(1007, 7, 207, 8, 'Routine deworming', '2026-10-07', '11:30:00', 'completed'),
(1008, 8, 208, 7, 'Grooming appointment', '2026-10-08', '13:00:00', 'scheduled'),
(1009, 9, 210, 4, 'Blood test', '2026-10-09', '10:00:00', 'scheduled'),
(1010, 10, 209, 10, 'Emergency treatment', '2026-10-10', '15:00:00', 'cancelled');

INSERT INTO Medical_Record
(record_ID, appointment_id, pet_id, staff_id, visit_date,
 symptoms, diagnosis, treatment, prescription)
VALUES
(1, 1, 1, 1, '2026-10-01',
 'Mild fever', 'Minor infection', 'Medication and rest', 'Antibiotic twice daily'),
(2, 2, 2, 3, '2026-10-02',
 'Skin itching', 'Skin allergy', 'Anti-allergy treatment', 'Antihistamine once daily'),
(3, 3, 3, 2, '2026-10-03',
 'Joint pain', 'Ligament problem', 'Surgery recommended', 'Painkiller as required'),
(4, 4, 4, 4, '2026-10-04',
 'Bad breath', 'Dental infection', 'Dental cleaning', 'Dental medicine'),
(5, 5, 5, 5, '2026-10-05',
 'No symptoms', 'Healthy', 'Vaccination given', 'No prescription'),
(6, 6, 6, 9, '2026-10-06',
 'Difficulty walking', 'Leg injury', 'Rest and medication', 'Painkiller twice daily'),
(7, 7, 7, 1, '2026-10-07',
 'Loss of appetite', 'Worm infection', 'Deworming treatment', 'Deworming tablet'),
(8, 8, 8, 8, '2026-10-08',
 'Dirty coat', 'No medical issue', 'Grooming performed', 'No prescription'),
(9, 9, 9, 3, '2026-10-09',
 'Weakness', 'Low hemoglobin', 'Dietary treatment', 'Iron supplement'),
(10, 10, 10, 2, '2026-10-10',
 'Vomiting', 'Stomach infection', 'Emergency treatment', 'Antibiotic and fluids');