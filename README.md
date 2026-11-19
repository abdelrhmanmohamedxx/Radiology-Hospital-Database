# Radiology Hospital Database Management System

An academic database project for a radiology department, including a relational MySQL schema, entity-relationship diagrams, and a PHP-based demonstration website with role-specific pages.

## Project contents

- **Database design:** `schema code.sql`, ERD and relational mapping diagrams, and supporting spreadsheets.
- **Demonstration website:** PHP pages for patient, doctor, nurse, and administrator roles, along with appointments, reports, payments, and scan uploads.
- **Website database setup:** `radiology_phase2_website/radiology_phase2_website/schema.sql` contains the schema and sample records for the demonstration website.

## Technologies

MySQL, SQL, PHP, HTML, CSS, JavaScript, MySQL Workbench, and diagrams.net (draw.io).

## Run locally (demo only)

1. Install XAMPP (Apache, PHP, and MySQL).
2. Start Apache and MySQL.
3. Import `radiology_phase2_website/radiology_phase2_website/schema.sql` into MySQL, for example using phpMyAdmin.
4. Copy the **inner** `radiology_phase2_website/radiology_phase2_website/` directory to `C:\xampp\htdocs\radiology_phase2_website\`.
5. If necessary, update the local MySQL connection settings in `db.php`.
6. Open `http://localhost/radiology_phase2_website/index.php`.

The sample database includes demonstration accounts named `patient1`, `doctor1`, `nurse1`, and `admin1`; see the website's `README.txt` for the demo credentials.

> **Security note:** This is an educational demonstration, **not a production-ready medical application**. The sample application uses weak demo passwords and compares passwords as plain text. Do not deploy it publicly or use actual patient information without redesigning authentication, configuration, and security controls.

## Repository structure

```text
.
├── schema code.sql                       # Database design SQL
├── schema draw io.drawio                 # Schema diagram source
├── schema draw io.drawio.png             # Schema diagram image
├── schema pic SQL.png                    # SQL schema image
├── schema sql.mwb                        # MySQL Workbench model
├── ERD draw io file.drawio               # ERD diagram source
├── ERD draw io pic.png                   # ERD image
├── Hospital_Entities_and_Attributes.xlsx
├── Hospital_Schema_Relational_Mapping.xlsx
└── radiology_phase2_website/
    └── radiology_phase2_website/          # PHP demo website + SQL sample data
```

## Author

**Abdelrhman Mohamed**  
GitHub: [@abdelrhmanmohamedxx](https://github.com/abdelrhmanmohamedxx)
