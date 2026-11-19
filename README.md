# Radiology Hospital Database Management System

![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Relational%20Design-336791)
![PHP](https://img.shields.io/badge/PHP-Backend-777BB4?logo=php&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-Markup-E34F26?logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-Styling-1572B6?logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-Client%20Side-F7DF1E?logo=javascript&logoColor=black)
![XAMPP](https://img.shields.io/badge/XAMPP-Local%20Server-FB7A24?logo=xampp&logoColor=white)
![Status](https://img.shields.io/badge/Project-Academic%20Demo-informational)

An academic database project that models the operations of a hospital **Radiology Department**: from the conceptual Entity-Relationship design, through relational mapping, to a normalized **MySQL** schema, plus a **PHP demonstration website** with role-based dashboards for patients, doctors, nurses, and administrators.

> **Note:** This is an educational demonstration, not a production-ready medical application. See the [Security Notice](#security-notice).

---

## Table of Contents

- [Overview](#overview)
- [Academic Context](#academic-context)
- [Technologies](#technologies)
- [Key Features](#key-features)
- [User Roles and Dashboards](#user-roles-and-dashboards)
- [Database Design](#database-design)
  - [Entity-Relationship Diagram](#entity-relationship-diagram)
  - [Relational Schema](#relational-schema)
  - [Table Reference](#table-reference)
  - [Key Relationships and Constraints](#key-relationships-and-constraints)
  - [Sample Data](#sample-data)
- [Project Structure](#project-structure)
- [Installation and Setup](#installation-and-setup)
- [Demo Accounts](#demo-accounts)
- [Screenshots](#screenshots)
- [Security Notice](#security-notice)
- [Known Limitations](#known-limitations)
- [Author](#author)

---

## Overview

The project has two main parts:

1. **Database design**: a fully documented relational database for a radiology department, including:
   - an ER diagram ([`ERD draw io pic.png`](ERD%20draw%20io%20pic.png))
   - a relational mapping diagram ([`schema draw io.drawio.png`](schema%20draw%20io.drawio.png))
   - a MySQL Workbench model ([`schema sql.mwb`](schema%20sql.mwb))
   - supporting spreadsheets
   - the SQL script ([`schema code.sql`](schema%20code.sql)) that creates the `Radiology_Department` database with **21 tables** and sample records

2. **Demonstration website** (Phase 2): a PHP + MySQL web application in [`radiology_phase2_website/radiology_phase2_website/`](radiology_phase2_website/radiology_phase2_website/). It connects to the same database and provides:
   - login and patient self-registration
   - role-specific dashboards
   - appointment booking and cancellation
   - radiology report writing
   - payments
   - scan file uploads

---

## Academic Context

This repository was developed as an academic database course project. The database design and the website are intended for learning and demonstration purposes only.

---

## Technologies

| Category | Tools |
|---|---|
| Database | MySQL, SQL (DDL and DML) |
| Database Modeling | MySQL Workbench (`.mwb`), diagrams.net / draw.io (`.drawio`) |
| Documentation | Microsoft Excel (`.xlsx`) for entities, attributes, and relational mapping |
| Backend | PHP (MySQLi, prepared statements, sessions, transactions) |
| Frontend | HTML, CSS, JavaScript |
| Local Environment | XAMPP (Apache, PHP, MySQL), phpMyAdmin |

---

## Key Features

### Database

- **21 relational tables** covering hospital, departments, rooms, staff, patients, appointments, radiology tests, reports, medications, treatments, payments, refunds, and file uploads.
- **Primary keys, foreign keys, and `UNIQUE` constraints** that enforce entity integrity, referential integrity, and one-to-one relationships.
- **Multivalued attributes** mapped to separate tables:
  - `DEPARTMENT_LOCATION`
  - `PATIENT_PHONE`
  - `DOCTOR_PHONE`
  - `NURSE_PHONE`
- A **many-to-many relationship** between doctors and departments, resolved through `DOCTOR_DEPARTMENT` (with `Join_Date`).
- A **department chairman** relationship (`DEPARTMENT.Chairman_ID → DOCTOR.Doctor_ID`), added with `ALTER TABLE` to resolve the circular dependency between `DEPARTMENT` and `DOCTOR`.
- A central **`USER_ACCOUNT`** table with a `Role` column, linked one-to-one to `PATIENT`, `DOCTOR`, and `NURSE` records.
- **Sample data** so the database and website can be explored immediately.

### Website

- **Role-based access control.** After login, each user goes to their own dashboard (`patient`, `doctor`, `nurse`, or `admin`). Pages check the session role before showing anything.
- **Patient self-registration.** Creates the user account, patient record, and phone number inside a single **database transaction**, with rollback on error.
- **Appointment booking.** The patient chooses a date, time, doctor, nurse, radiology test, and room.
- **Appointment cancellation**, with a JavaScript confirmation prompt.
- **Radiology reports.** Doctors record findings and a diagnosis, plus an optional medication (name, dose, start/end dates, directions).
- **Payments.** The amount comes automatically from the test price. The patient chooses Cash, Visa, or Online.
- **Scan uploads.** Patients upload a file linked to a specific appointment or as a general upload.
- **Admin statistics and overview.**
  - Counts of patients, doctors, and appointments, plus the total amount paid.
  - A combined view of all appointments that joins patient, doctor, nurse, test, room, and payment status.
- **Prepared statements** for user-submitted form data, and **HTML output escaping** with `htmlspecialchars`.

---

## User Roles and Dashboards

The website has four roles, stored in `USER_ACCOUNT.Role`. When a user logs in, [`login.php`](radiology_phase2_website/radiology_phase2_website/login.php) sends them to the dashboard that matches their role.

| Role | Dashboard | What the user can do |
|---|---|---|
| **Patient** | [`patient_dashboard.php`](radiology_phase2_website/radiology_phase2_website/patient_dashboard.php) | View their appointments (doctor, test, room, date, time, status, payment status); book appointments; pay or cancel an appointment; upload scan files; view their radiology reports |
| **Doctor** | [`doctor_dashboard.php`](radiology_phase2_website/radiology_phase2_website/doctor_dashboard.php) | View appointments assigned to them (patient, test, room, date, status); write or update the radiology report for an appointment, optionally adding a medication |
| **Nurse** | [`nurse_dashboard.php`](radiology_phase2_website/radiology_phase2_website/nurse_dashboard.php) | View appointments assigned to them, including patient, doctor, radiology test, room, date, time, and status (read-only) |
| **Admin** | [`admin_dashboard.php`](radiology_phase2_website/radiology_phase2_website/admin_dashboard.php) | View system statistics; view a joined list of all appointments with payment status; browse records of key tables through [`manage.php`](radiology_phase2_website/radiology_phase2_website/manage.php) (read-only) |

### Patient pages

| Page | Purpose |
|---|---|
| [`register.php`](radiology_phase2_website/radiology_phase2_website/register.php) | Public patient registration: username, password, SSN, name, gender, date of birth, address, medical history, phone |
| [`book_appointment.php`](radiology_phase2_website/radiology_phase2_website/book_appointment.php) | Books an appointment with status `Booked` |
| [`cancel_appointment.php`](radiology_phase2_website/radiology_phase2_website/cancel_appointment.php) | Sets the appointment status to `Cancelled` |
| [`pay.php`](radiology_phase2_website/radiology_phase2_website/pay.php) | Records a payment as `Paid`. Each appointment has at most one payment, and paying again updates the existing record |
| [`upload_scan.php`](radiology_phase2_website/radiology_phase2_website/upload_scan.php) | Uploads a scan file to the `uploads/` folder and records it in `FILE_UPLOAD` |
| [`patient_reports.php`](radiology_phase2_website/radiology_phase2_website/patient_reports.php) | Lists the patient's radiology reports with test name, findings, and diagnosis |

### Doctor pages

| Page | Purpose |
|---|---|
| [`add_report.php`](radiology_phase2_website/radiology_phase2_website/add_report.php) | Creates or updates the radiology report for an appointment (one report per appointment) and can add a linked medication |

### Admin pages

| Page | Purpose |
|---|---|
| [`manage.php`](radiology_phase2_website/radiology_phase2_website/manage.php) | Shows up to 100 rows from one of these tables: `PATIENT`, `DOCTOR`, `NURSE`, `ROOM`, `RADIOLOGY_TEST`, `APPOINTMENT`, `PAYMENT`, `FILE_UPLOAD`, `MEDICAL_STATUS`, `RADIOLOGY_REPORT` |

### Shared files

| File | Purpose |
|---|---|
| [`index.php`](radiology_phase2_website/radiology_phase2_website/index.php) | Public home page with an overview of each role |
| [`login.php`](radiology_phase2_website/radiology_phase2_website/login.php) / [`logout.php`](radiology_phase2_website/radiology_phase2_website/logout.php) | Session login and logout |
| [`db.php`](radiology_phase2_website/radiology_phase2_website/db.php) | Database connection, session start, escaping helper, and `require_login` / `require_role` access checks |
| [`header.php`](radiology_phase2_website/radiology_phase2_website/header.php) / [`footer.php`](radiology_phase2_website/radiology_phase2_website/footer.php) | Shared layout and navigation bar |
| [`assets/style.css`](radiology_phase2_website/radiology_phase2_website/assets/style.css) / [`assets/script.js`](radiology_phase2_website/radiology_phase2_website/assets/script.js) | Styling and the confirmation dialog helper |

---

## Database Design

The design moves through three stages:

1. **Conceptual model:** the ER diagram and the entities/attributes spreadsheet.
2. **Logical model:** the relational mapping diagram and spreadsheet.
3. **Physical model:** the MySQL Workbench model and the SQL script.

### Entity-Relationship Diagram

The ER diagram shows the entities, attributes, and relationships of the radiology department.

- Image: [`ERD draw io pic.png`](ERD%20draw%20io%20pic.png)
- Editable source: [`ERD draw io file.drawio`](ERD%20draw%20io%20file.drawio)
- Entities and attributes: [`Hospital_Entities_and_Attributes.xlsx`](Hospital_Entities_and_Attributes.xlsx)

![Entity-Relationship Diagram](ERD%20draw%20io%20pic.png)

### Relational Schema

The relational mapping turns the ER model into tables with primary and foreign keys.

- Relational mapping diagram: [`schema draw io.drawio.png`](schema%20draw%20io.drawio.png) (editable source: [`schema draw io.drawio`](schema%20draw%20io.drawio))
- Relational mapping spreadsheet: [`Hospital_Schema_Relational_Mapping.xlsx`](Hospital_Schema_Relational_Mapping.xlsx)
- MySQL Workbench model: [`schema sql.mwb`](schema%20sql.mwb)
- Workbench diagram image: [`schema pic SQL.png`](schema%20pic%20SQL.png)
- SQL script: [`schema code.sql`](schema%20code.sql)

![Relational Schema Mapping](schema%20draw%20io.drawio.png)

![MySQL Workbench Schema Diagram](schema%20pic%20SQL.png)

### Table Reference

Primary keys are in **bold**. Foreign keys are marked *(FK → table)*.

| # | Table | Columns |
|---|---|---|
| 1 | `HOSPITAL` | **Hospital_ID**, Hospital_Name, Phone, Email |
| 2 | `USER_ACCOUNT` | **User_ID**, Username (unique), Password, Role |
| 3 | `DEPARTMENT` | **Department_ID**, Department_Code (unique), Department_Name (unique), Hospital_ID *(FK → HOSPITAL)*, Chairman_ID *(FK → DOCTOR)*, Chairman_Start_Date |
| 4 | `DEPARTMENT_LOCATION` | **Department_ID** *(FK → DEPARTMENT)*, **Location** |
| 5 | `ROOM` | **Room_ID**, Room_Name, Room_Type, Status, Department_ID *(FK → DEPARTMENT)* |
| 6 | `PATIENT` | **Patient_ID**, SSN (unique), First_Name, Last_Name, Gender, Date_of_Birth, Street, City, Medical_History, Admission_Date, User_ID *(FK → USER_ACCOUNT, unique)* |
| 7 | `PATIENT_PHONE` | **Patient_ID** *(FK → PATIENT)*, **Phone** |
| 8 | `MEDICAL_STATUS` | **Status_ID**, Blood_Pressure, Heart_Rate, Temperature, Status_Date, Patient_ID *(FK → PATIENT)* |
| 9 | `DOCTOR` | **Doctor_ID**, SSN (unique), First_Name, Last_Name, Gender, Date_of_Birth, Specialization, Major_Area, Degree, Email, User_ID *(FK → USER_ACCOUNT, unique)* |
| 10 | `DOCTOR_PHONE` | **Doctor_ID** *(FK → DOCTOR)*, **Phone** |
| 11 | `DOCTOR_DEPARTMENT` | **Doctor_ID** *(FK → DOCTOR)*, **Department_ID** *(FK → DEPARTMENT)*, Join_Date |
| 12 | `NURSE` | **Nurse_ID**, First_Name, Last_Name, Shift, User_ID *(FK → USER_ACCOUNT, unique)* |
| 13 | `NURSE_PHONE` | **Nurse_ID** *(FK → NURSE)*, **Phone** |
| 14 | `RADIOLOGY_TEST` | **Test_ID**, Test_Name, Test_Type, Price |
| 15 | `APPOINTMENT` | **Appointment_ID**, Appointment_Date, Appointment_Time, Status, Patient_ID *(FK → PATIENT)*, Doctor_ID *(FK → DOCTOR)*, Nurse_ID *(FK → NURSE)*, Test_ID *(FK → RADIOLOGY_TEST)*, Room_ID *(FK → ROOM)* |
| 16 | `TREATMENT` | **Treatment_ID**, Doctor_ID *(FK → DOCTOR)*, Patient_ID *(FK → PATIENT)*, Treatment_Date, Hours_Per_Week, Notes |
| 17 | `RADIOLOGY_REPORT` | **Report_ID**, Report_Date, Findings, Diagnosis, Appointment_ID *(FK → APPOINTMENT, unique)* |
| 18 | `MEDICATION` | **Medication_ID**, Medication_Name, Dose, Start_Date, End_Date, Directions, Report_ID *(FK → RADIOLOGY_REPORT)* |
| 19 | `PAYMENT` | **Payment_ID**, Amount, Payment_Date, Payment_Method, Payment_Status, Appointment_ID *(FK → APPOINTMENT, unique)* |
| 20 | `REFUND` | **Refund_ID**, Refund_Amount, Refund_Date, Refund_Reason, Payment_ID *(FK → PAYMENT, unique)* |
| 21 | `FILE_UPLOAD` | **File_ID**, File_Name, File_Path, Upload_Date, Patient_ID *(FK → PATIENT)*, Appointment_ID *(FK → APPOINTMENT)* |

### Key Relationships and Constraints

| Relationship | Type | How it is enforced |
|---|---|---|
| Hospital → Departments | 1 : N | `DEPARTMENT.Hospital_ID` FK |
| Department → Rooms | 1 : N | `ROOM.Department_ID` FK |
| Department → Locations | Multivalued attribute | Composite PK `(Department_ID, Location)` |
| Doctor ↔ Department | M : N | Junction table `DOCTOR_DEPARTMENT` with composite PK |
| Doctor chairs Department | 1 : 1 (optional) | `DEPARTMENT.Chairman_ID` FK, added with `ALTER TABLE` |
| User Account → Patient / Doctor / Nurse | 1 : 1 | `UNIQUE` FK `User_ID` in each profile table |
| Patient / Doctor / Nurse → Phones | Multivalued attribute | Composite PK `(owner_ID, Phone)` |
| Patient → Medical Status records | 1 : N | `MEDICAL_STATUS.Patient_ID` FK |
| Appointment → Patient, Doctor, Nurse, Test, Room | N : 1 each | Five FKs in `APPOINTMENT` (`Nurse_ID` is optional) |
| Doctor treats Patient | M : N with attributes | `TREATMENT` (date, hours per week, notes) |
| Appointment → Radiology Report | 1 : 1 | `UNIQUE` `RADIOLOGY_REPORT.Appointment_ID` |
| Radiology Report → Medications | 1 : N | `MEDICATION.Report_ID` FK |
| Appointment → Payment | 1 : 1 | `UNIQUE` `PAYMENT.Appointment_ID` |
| Payment → Refund | 1 : 1 | `UNIQUE` `REFUND.Payment_ID` |
| Patient / Appointment → File Uploads | 1 : N | `FILE_UPLOAD` FKs (`Appointment_ID` is optional) |

### Sample Data

The script inserts demonstration records, including:

- **Hospital and department**
  - one hospital
  - a Radiology Department (`RAD01`) with two locations
  - a doctor assigned as its chairman
- **Rooms:** X-Ray Room, MRI Room, and CT Room.
- **Radiology tests:**

  | Test | Type | Price |
  |---|---|---|
  | X-Ray Chest | X-Ray | 500.00 |
  | MRI Brain | MRI | 2500.00 |
  | CT Abdomen | CT Scan | 1800.00 |

- **People and records**
  - one patient, one doctor, and one nurse, each linked to a user account
  - a sample appointment with its report, payment, and file upload record

---

## Project Structure

```text
Radiology-Hospital-Database/
├── README.md
├── schema code.sql                          # SQL script: creates the database, 21 tables, and sample data
├── schema sql.mwb                           # MySQL Workbench model
├── schema pic SQL.png                       # MySQL Workbench schema diagram (image)
├── schema draw io.drawio                    # Relational schema mapping (draw.io source)
├── schema draw io.drawio.png                # Relational schema mapping (image)
├── ERD draw io file.drawio                  # Entity-Relationship Diagram (draw.io source)
├── ERD draw io pic.png                      # Entity-Relationship Diagram (image)
├── Hospital_Entities_and_Attributes.xlsx    # Entities and attributes documentation
├── Hospital_Schema_Relational_Mapping.xlsx  # Relational mapping documentation
└── radiology_phase2_website/
    └── radiology_phase2_website/            # Phase 2 PHP demonstration website
        ├── README.txt                       # Original run instructions
        ├── schema.sql                       # Database script used by the website (schema + sample data)
        ├── db.php                           # DB connection, session, and access-control helpers
        ├── header.php                       # Shared header and navigation
        ├── footer.php                       # Shared footer
        ├── index.php                        # Home page
        ├── login.php                        # Login
        ├── logout.php                       # Logout
        ├── register.php                     # Patient registration
        ├── patient_dashboard.php            # Patient dashboard
        ├── book_appointment.php             # Book an appointment
        ├── cancel_appointment.php           # Cancel an appointment
        ├── pay.php                          # Pay for an appointment
        ├── upload_scan.php                  # Upload a scan file
        ├── patient_reports.php              # Patient's radiology reports
        ├── doctor_dashboard.php             # Doctor dashboard
        ├── add_report.php                   # Write or update a radiology report
        ├── nurse_dashboard.php              # Nurse dashboard
        ├── admin_dashboard.php              # Admin dashboard and statistics
        ├── manage.php                       # Admin table viewer
        └── assets/
            ├── style.css                    # Stylesheet
            └── script.js                    # Confirmation dialog helper
```

---

## Installation and Setup

### Prerequisites

- [XAMPP](https://www.apachefriends.org/) (Apache, PHP, MySQL/MariaDB)
- phpMyAdmin (included with XAMPP) or MySQL Workbench

### Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/abdelrhmanmohamedxx/Radiology-Hospital-Database.git
   ```

2. **Start the services.** Open the XAMPP Control Panel and start **Apache** and **MySQL**.

3. **Create the database.**
   - Open phpMyAdmin at `http://localhost/phpmyadmin`.
   - Import [`radiology_phase2_website/radiology_phase2_website/schema.sql`](radiology_phase2_website/radiology_phase2_website/schema.sql), or run it in MySQL Workbench.
   - This creates the `Radiology_Department` database with its sample data.

   > ⚠️ The script starts with `DROP DATABASE IF EXISTS Radiology_Department;`, so it replaces any existing database with that name.

4. **Deploy the website.** Copy the **inner** `radiology_phase2_website/radiology_phase2_website/` folder to:

   ```text
   C:\xampp\htdocs\radiology_phase2_website\
   ```

5. **Configure the connection (if needed).** If your MySQL `root` user has a password, edit [`db.php`](radiology_phase2_website/radiology_phase2_website/db.php):

   ```php
   $host     = "localhost";
   $user     = "root";
   $password = "";          // put your MySQL password here if you have one
   $database = "Radiology_Department";
   ```

6. **Open the website**

   ```text
   http://localhost/radiology_phase2_website/index.php
   ```

> To explore only the database design, run [`schema code.sql`](schema%20code.sql) in MySQL Workbench or phpMyAdmin. It creates the same tables and sample data.

---

## Demo Accounts

The sample data includes one demonstration account for each role:

| Role | Username |
|---|---|
| Patient | `patient1` |
| Doctor | `doctor1` |
| Nurse | `nurse1` |
| Admin | `admin1` |

The demo password is listed on the login page and in the website's [`README.txt`](radiology_phase2_website/radiology_phase2_website/README.txt). New patient accounts can be created from the **Register** page.

---

## Screenshots

### Entity-Relationship Diagram

![ERD](ERD%20draw%20io%20pic.png)

### Relational Schema Mapping

![Relational Schema](schema%20draw%20io.drawio.png)

### MySQL Workbench Schema

![MySQL Workbench Schema](schema%20pic%20SQL.png)

---

## Security Notice

This project is an **educational demonstration**. It is **not** a production-ready medical system.

- Passwords are stored and compared as **plain text**, and the demo accounts use weak passwords.
- The database connection uses the local `root` user. The credentials are set directly in `db.php`.
- Uploaded files are saved without file type or size validation.
- Some actions do not check that the record belongs to the logged-in user.

Do **not** deploy this application publicly or use real patient information. Production use would first require redesigning authentication (for example, password hashing), configuration, authorization checks, file upload handling, and other security controls.

---

## Known Limitations

- The admin **Manage** page is read-only. It shows up to 100 rows per table and has no create, edit, or delete forms.
- These tables are part of the database design but have no pages in the website:
  - `TREATMENT`
  - `REFUND`
  - `HOSPITAL`
  - `DEPARTMENT`
  - `DEPARTMENT_LOCATION`
  - `DOCTOR_DEPARTMENT`
- Appointment booking does not check for scheduling conflicts (doctor, nurse, or room availability).
- Writing a report does not change the appointment's status.

---

## Author

**Abdelrhman Mohamed**
GitHub: [@abdelrhmanmohamedxx](https://github.com/abdelrhmanmohamedxx)
