# 🎓 Student Course Management System (SQL Project)

A complete relational database project implemented using **MySQL**.  
This project demonstrates strong SQL fundamentals including:

- Relational database design  
- Primary & foreign key constraints  
- CHECK, UNIQUE, DEFAULT constraints  
- One-to-many & many-to-many relationships  
- Normalized table structure  
- Views for reporting  
- Joins, subqueries, and aggregate queries  

This project is ideal for academic submission, portfolio building, and showcasing SQL skills to recruiters.

---

## 🧩 Project Overview

The **Student Course Management System** models a real-world academic database with five main entities:

1. **Departments**
2. **Teachers**
3. **Students**
4. **Courses**
5. **Enrollments** (junction table)

Each table contains meaningful constraints to ensure data integrity and demonstrate relational modeling principles.

---

## 🎯 Purpose of the Project

The purpose of this database project is to:

- Learn SQL through a complete end-to-end database mini-application.
- Demonstrate correct database normalization and entity relationships.
- Practice SQL DDL, DML, and DQL operations.
- Explore advanced SQL features like **views**, **subqueries**, and **aggregate functions**.
- Build a project suitable for **GitHub**, **portfolio**, **resume**, and **interviews**.

---

## 🛠️ Technologies Used

| Component | Technology |
|----------|------------|
| Database | MySQL 8.x |
| Language | SQL (DDL, DML, DQL) |
| Tools | MySQL Workbench / Git / GitHub |

---

## 🗂️ Database Schema (5 Tables)

- **Departments**  
  Contains unique department names.

- **Teachers**  
  Linked to Departments via `dept_id`.

- **Students**  
  Includes CHECK constraints on age and enrollment year.

- **Courses**  
  Contains course details with credit constraints.

- **Enrollments**  
  Junction table with PK + 3 FKs.  
  Demonstrates `ON DELETE CASCADE`, `ON DELETE SET NULL`, and unique composite constraints.

---

## 📐 ER Diagram

The ER diagram illustrates all relationships between tables.

Add your diagram file and embed it here:

```markdown
![ER Diagram](er-diagram.png)
