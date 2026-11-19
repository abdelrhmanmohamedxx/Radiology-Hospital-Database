-- Abdelrhman Mohamed Abdelaziz
DROP DATABASE IF EXISTS Radiology_Department;
CREATE DATABASE Radiology_Department;
USE Radiology_Department;

CREATE TABLE HOSPITAL (
    Hospital_ID INT PRIMARY KEY,
    Hospital_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE USER_ACCOUNT (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(30) NOT NULL
);

CREATE TABLE DEPARTMENT (
    Department_ID INT PRIMARY KEY AUTO_INCREMENT,
    Department_Code VARCHAR(20) UNIQUE NOT NULL,
    Department_Name VARCHAR(100) UNIQUE NOT NULL,
    Hospital_ID INT NOT NULL,
    Chairman_ID INT,
    Chairman_Start_Date DATE,
    FOREIGN KEY (Hospital_ID) REFERENCES HOSPITAL(Hospital_ID)
);

CREATE TABLE DEPARTMENT_LOCATION (
    Department_ID INT,
    Location VARCHAR(100),
    PRIMARY KEY (Department_ID, Location),
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
);

CREATE TABLE ROOM (
    Room_ID INT PRIMARY KEY AUTO_INCREMENT,
    Room_Name VARCHAR(100) NOT NULL,
    Room_Type VARCHAR(50),
    Status VARCHAR(30),
    Department_ID INT NOT NULL,
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
);

CREATE TABLE PATIENT (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    SSN VARCHAR(20) UNIQUE,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Gender VARCHAR(10),
    Date_of_Birth DATE,
    Street VARCHAR(100),
    City VARCHAR(50),
    Medical_History TEXT,
    Admission_Date DATE,
    User_ID INT UNIQUE,
    FOREIGN KEY (User_ID) REFERENCES USER_ACCOUNT(User_ID)
);

CREATE TABLE PATIENT_PHONE (
    Patient_ID INT,
    Phone VARCHAR(20),
    PRIMARY KEY (Patient_ID, Phone),
    FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
);

CREATE TABLE MEDICAL_STATUS (
    Status_ID INT PRIMARY KEY AUTO_INCREMENT,
    Blood_Pressure VARCHAR(20),
    Heart_Rate INT,
    Temperature DECIMAL(4,1),
    Status_Date DATE,
    Patient_ID INT NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
);

CREATE TABLE DOCTOR (
    Doctor_ID INT PRIMARY KEY AUTO_INCREMENT,
    SSN VARCHAR(20) UNIQUE,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Gender VARCHAR(10),
    Date_of_Birth DATE,
    Specialization VARCHAR(100),
    Major_Area VARCHAR(100),
    Degree VARCHAR(100),
    Email VARCHAR(100),
    User_ID INT UNIQUE,
    FOREIGN KEY (User_ID) REFERENCES USER_ACCOUNT(User_ID)
);

CREATE TABLE DOCTOR_PHONE (
    Doctor_ID INT,
    Phone VARCHAR(20),
    PRIMARY KEY (Doctor_ID, Phone),
    FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID)
);

ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (Chairman_ID) REFERENCES DOCTOR(Doctor_ID);

CREATE TABLE DOCTOR_DEPARTMENT (
    Doctor_ID INT,
    Department_ID INT,
    Join_Date DATE,
    PRIMARY KEY (Doctor_ID, Department_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID),
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
);

CREATE TABLE NURSE (
    Nurse_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Shift VARCHAR(30),
    User_ID INT UNIQUE,
    FOREIGN KEY (User_ID) REFERENCES USER_ACCOUNT(User_ID)
);

CREATE TABLE NURSE_PHONE (
    Nurse_ID INT,
    Phone VARCHAR(20),
    PRIMARY KEY (Nurse_ID, Phone),
    FOREIGN KEY (Nurse_ID) REFERENCES NURSE(Nurse_ID)
);

CREATE TABLE RADIOLOGY_TEST (
    Test_ID INT PRIMARY KEY AUTO_INCREMENT,
    Test_Name VARCHAR(100) NOT NULL,
    Test_Type VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE APPOINTMENT (
    Appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Status VARCHAR(30),
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Nurse_ID INT,
    Test_ID INT NOT NULL,
    Room_ID INT NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID),
    FOREIGN KEY (Nurse_ID) REFERENCES NURSE(Nurse_ID),
    FOREIGN KEY (Test_ID) REFERENCES RADIOLOGY_TEST(Test_ID),
    FOREIGN KEY (Room_ID) REFERENCES ROOM(Room_ID)
);

CREATE TABLE TREATMENT (
    Treatment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_ID INT NOT NULL,
    Patient_ID INT NOT NULL,
    Treatment_Date DATE,
    Hours_Per_Week DECIMAL(4,1),
    Notes TEXT,
    FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID),
    FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
);

CREATE TABLE RADIOLOGY_REPORT (
    Report_ID INT PRIMARY KEY AUTO_INCREMENT,
    Report_Date DATE,
    Findings TEXT,
    Diagnosis TEXT,
    Appointment_ID INT UNIQUE NOT NULL,
    FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID)
);

CREATE TABLE MEDICATION (
    Medication_ID INT PRIMARY KEY AUTO_INCREMENT,
    Medication_Name VARCHAR(100),
    Dose VARCHAR(50),
    Start_Date DATE,
    End_Date DATE,
    Directions VARCHAR(255),
    Report_ID INT NOT NULL,
    FOREIGN KEY (Report_ID) REFERENCES RADIOLOGY_REPORT(Report_ID)
);

CREATE TABLE PAYMENT (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Amount DECIMAL(10,2),
    Payment_Date DATE,
    Payment_Method VARCHAR(50),
    Payment_Status VARCHAR(30),
    Appointment_ID INT UNIQUE NOT NULL,
    FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID)
);

CREATE TABLE REFUND (
    Refund_ID INT PRIMARY KEY AUTO_INCREMENT,
    Refund_Amount DECIMAL(10,2),
    Refund_Date DATE,
    Refund_Reason VARCHAR(255),
    Payment_ID INT UNIQUE NOT NULL,
    FOREIGN KEY (Payment_ID) REFERENCES PAYMENT(Payment_ID)
);

CREATE TABLE FILE_UPLOAD (
    File_ID INT PRIMARY KEY AUTO_INCREMENT,
    File_Name VARCHAR(100),
    File_Path VARCHAR(255),
    Upload_Date DATE,
    Patient_ID INT NOT NULL,
    Appointment_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID)
);

INSERT INTO HOSPITAL VALUES (1, 'Cairo Hospital', '0223456789', 'info@cairohospital.com');
INSERT INTO USER_ACCOUNT (User_ID,Username,Password,Role) VALUES
(1, 'patient1', '12345', 'Patient'),
(2, 'doctor1', '12345', 'Doctor'),
(3, 'nurse1', '12345', 'Nurse'),
(4, 'admin1', '12345', 'Admin');
INSERT INTO DEPARTMENT (Department_ID,Department_Code,Department_Name,Hospital_ID,Chairman_ID,Chairman_Start_Date) VALUES (1, 'RAD01', 'Radiology Department', 1, NULL, NULL);
INSERT INTO DEPARTMENT_LOCATION VALUES (1, 'First Floor - Building A'), (1, 'Second Floor - Imaging Unit');
INSERT INTO ROOM (Room_ID,Room_Name,Room_Type,Status,Department_ID) VALUES
(1, 'X-Ray Room', 'Radiology Room', 'Available', 1),
(2, 'MRI Room', 'Radiology Room', 'Available', 1),
(3, 'CT Room', 'Radiology Room', 'Available', 1);
INSERT INTO PATIENT (Patient_ID,SSN,First_Name,Last_Name,Gender,Date_of_Birth,Street,City,Medical_History,Admission_Date,User_ID)
VALUES (1, 'P123456789', 'Ahmed', 'Ali', 'Male', '2002-05-10', 'Nasr City', 'Cairo', 'No chronic diseases', '2026-05-23', 1);
INSERT INTO PATIENT_PHONE VALUES (1, '01012345678');
INSERT INTO MEDICAL_STATUS VALUES (1, '120/80', 75, 36.7, '2026-05-23', 1);
INSERT INTO DOCTOR (Doctor_ID,SSN,First_Name,Last_Name,Gender,Date_of_Birth,Specialization,Major_Area,Degree,Email,User_ID)
VALUES (1, 'D123456789', 'Mohamed', 'Hassan', 'Male', '1980-03-15', 'Radiologist', 'Diagnostic Radiology', 'Consultant', 'doctor@hospital.com', 2);
INSERT INTO DOCTOR_PHONE VALUES (1, '01123456789');
UPDATE DEPARTMENT SET Chairman_ID=1, Chairman_Start_Date='2024-01-01' WHERE Department_ID=1;
INSERT INTO DOCTOR_DEPARTMENT VALUES (1, 1, '2024-01-01');
INSERT INTO NURSE (Nurse_ID,First_Name,Last_Name,Shift,User_ID) VALUES (1, 'Mona', 'Adel', 'Morning', 3);
INSERT INTO NURSE_PHONE VALUES (1, '01234567890');
INSERT INTO RADIOLOGY_TEST VALUES (1, 'X-Ray Chest', 'X-Ray', 500.00), (2, 'MRI Brain', 'MRI', 2500.00), (3, 'CT Abdomen', 'CT Scan', 1800.00);
INSERT INTO APPOINTMENT VALUES (1, '2026-05-23', '10:30:00', 'Booked', 1, 1, 1, 1, 1);
INSERT INTO RADIOLOGY_REPORT VALUES (1, '2026-05-23', 'Normal chest image', 'No abnormal findings', 1);
INSERT INTO PAYMENT VALUES (1, 500.00, '2026-05-23', 'Cash', 'Paid', 1);
INSERT INTO FILE_UPLOAD VALUES (1, 'chest_xray.png', 'uploads/chest_xray.png', '2026-05-23', 1, 1);