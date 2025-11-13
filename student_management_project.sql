-- STUDENT COURSE MANAGEMENT SYSTEM --

-- STEP 1 : "CREATING DATA BASE"
CREATE DATABASE student_management;
USE student_management;

-- STEP 2 : Creating tables (DDL)  : (Departments → Teachers → Students → Courses → Enrollments)
-- 2.1 Departments : 
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2.2 Teachers : 
-- (FK → Departments)
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    email VARCHAR(150) UNIQUE,
    hired_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_teacher_dept FOREIGN KEY (dept_id)
        REFERENCES Departments(dept_id)
        ON DELETE RESTRICT
);

-- 2.3 Students :
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    age INT NOT NULL CHECK (age BETWEEN 18 AND 40),
    email VARCHAR(150) UNIQUE,
    enrollment_year INT NOT NULL CHECK (enrollment_year >= 2000)
);
 
 -- 2.4 Courses :
 CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    credit INT NOT NULL CHECK (credit BETWEEN 1 AND 6),
    UNIQUE (course_name)
);

-- 2.5 Enrollments :
-- (junction table with PK + FKs)
CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    teacher_id INT NULL,
    grade CHAR(2),
    enrolled_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id)
        REFERENCES Students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id)
        REFERENCES Courses(course_id) ON DELETE RESTRICT,
    CONSTRAINT fk_enroll_teacher FOREIGN KEY (teacher_id)
        REFERENCES Teachers(teacher_id) ON DELETE SET NULL
);


-- Step 3 : "Data Insertion"

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics');

INSERT INTO Teachers (teacher_id, teacher_name, dept_id, email) VALUES
(101, 'Dr. Sharma', 1, 'sharma@uni.edu'),
(102, 'Prof. Mehta', 2, 'mehta@uni.edu'),
(103, 'Dr. Das', 3, 'das@uni.edu');

INSERT INTO Students (student_id, student_name, age, email, enrollment_year) VALUES
(1, 'Amit Roy', 22, 'amit@gmail.com', 2022),
(2, 'Sneha Paul', 20, 'sneha@gmail.com', 2023),
(3, 'Rahul Sen', 23, 'rahul@gmail.com', 2021);

INSERT INTO Courses VALUES
(501, 'Database Systems', 4),
(502, 'Calculus', 3),
(503, 'Physics I', 4);

INSERT INTO Enrollments (enroll_id, student_id, course_id, teacher_id, grade) VALUES
(1, 1, 501, 101, 'A'),
(2, 2, 502, 102, 'B'),
(3, 3, 503, 103, 'B+'),
(4, 1, 502, 102, 'A-');


-- Step 4 — "Creating needful views"
-- 4.1 View: student_enrollments —> student with course & teacher
CREATE VIEW student_enrollments AS
SELECT e.enroll_id, s.student_id, s.student_name, c.course_id, c.course_name,
       t.teacher_id, t.teacher_name, e.grade, e.enrolled_on
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
LEFT JOIN Teachers t ON e.teacher_id = t.teacher_id;

-- 4.2 View: teacher_workload —> teachers and number of students they teach
CREATE VIEW teacher_workload AS
SELECT t.teacher_id, t.teacher_name, d.dept_name,
       COUNT(e.enroll_id) AS student_count
FROM Teachers t
LEFT JOIN Enrollments e ON t.teacher_id = e.teacher_id
LEFT JOIN Departments d ON t.dept_id = d.dept_id
GROUP BY t.teacher_id, t.teacher_name, d.dept_name;

-- 4.3 View: dept_overview —> department summary
CREATE VIEW dept_overview AS
SELECT d.dept_id, d.dept_name,
       COUNT(DISTINCT t.teacher_id) AS teacher_count,
       COUNT(DISTINCT s.student_id) AS students_linked -- this is approximate if students linked by enrollments
FROM Departments d
LEFT JOIN Teachers t ON d.dept_id = t.dept_id
LEFT JOIN Enrollments e ON t.teacher_id = e.teacher_id
LEFT JOIN Students s ON e.student_id = s.student_id
GROUP BY d.dept_id, d.dept_name;


-- Step 5 : Exploring queries-"constraints, joins, subqueries, and views"
-- 5.1 Simple join
SELECT s.student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 5.2 Using view
SELECT * FROM student_enrollments WHERE student_name = 'Amit Roy';

-- 5.3 Aggregation + join
SELECT c.course_name, COUNT(e.enroll_id) AS total_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- 5.4 Subquery —> students with more than one course
SELECT student_name
FROM Students
WHERE student_id IN (
    SELECT student_id FROM Enrollments GROUP BY student_id HAVING COUNT(*) > 1
);

-- 5.5 Constraint test —> try to insert a student with age 16 (should fail)
INSERT INTO Students (student_id, student_name, age, email, enrollment_year)
VALUES (10, 'Test Kid', 16, 'test@x.com', 2024);
-- This violates CHECK (age BETWEEN 18 AND 40)

-- 5.6 Constraint test —> duplicate email[failed due to UNIQUE]
INSERT INTO Students (student_id, student_name, age, email, enrollment_year)
VALUES (11, 'Same Email', 21, 'amit@gmail.com', 2024);
-- "Unique email violation" --

-- 5.7 Foreign key test — delete a student and see cascade effect
DELETE FROM Students WHERE student_id = 1;
-- Enrollments for student_id=1 will be deleted due to ON DELETE CASCADE --



