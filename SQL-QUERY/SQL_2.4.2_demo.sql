-- =========================
-- 1. TEACHER USERS & TEACHER
-- =========================

INSERT INTO Users (
    ID, Username, User_Password, Email, Phone,
    First_Name, Last_Name, Sex, Create_Dated
) VALUES
    (2310037, 'J_Scott',   'Scott123', 'scott.j@gmail.com',    '0901000001', 'John',   'Scott',   'Male', '2000-01-01'),
    (2310038, 'L_Kevin',  'Kevin123', 'kevin.l@gmail.com',    '0901000002', 'Le',  'Kevin',     'Male', '2000-01-02'),
    (2310039, 'P_Peter',   'Peter123', 'peter.p@gmail.com',   '0901000003', 'Parker',  'Peter',   'Male', '2000-01-03'),
    (2310040, 'B_Clinton',   'Clint123', 'clinton.b@gmail.com', '0901000004', 'Bill',   'Clinton', 'Female', '2000-01-04'),
    (2310041, 'M_Johnson',  'John123', 'johnson.m@gmail.com',    '0901000005', 'Mark',  'Johnson',     'Male', '2000-01-05');

INSERT INTO Teacher (ID, Title) VALUES
    (2310037, 'Master'),
    (2310038, 'Phd'),
    (2310039, 'Master'),
    (2310040, 'Bachelor'),
    (2310041, 'Master');

-- =========================
-- 2. COURSES (5–6 KHÓA)
-- =========================

INSERT INTO Course (
    ID, Specialization, Title, Course_Language, Course_Description, Price,
    Course_Level, Duration, Teacher_ID,
    Delete_Date, Delete_By, Course_Status
) VALUES
-- C1: Web Backend
(300011,
 'Web Programming with Node.js',
 'Software Engineering',
 'English',
 'Introduction to building backend REST APIs with Node.js, Express and basic deployment.',
 '49 USD',
 'Beginner',
 '6 weeks',
 2310037,
 NULL, NULL, 'Available'),

-- C2: Database Systems
(300012,
 'CO2013 - Database Systems',
 'Software Engineering',
 'Core concepts of relational databases, SQL, normalization and transaction processing.',
 '65 USD',
 'Intermediate',
 '10 weeks',
 2310038,
 NULL, NULL, 'Available'),

-- C3: Machine Learning căn bản
(300013,
 'Machine Learning Fundamentals',
 'Data Science & AI',
 'Supervised learning, regularization, model evaluation and basic ML workflows.',
 '79 USD',
 'Intermediate',
 '8 weeks',
 2310039,
 NULL, NULL, 'Available'),

-- C4: Operating Systems & Linux
(300014,
 'Operating Systems with Linux',
 'Software Engineering',
 'Processes, threads, scheduling, memory management and intro to Linux commands.',
 '59 USD',
 'Advanced',
 '8 weeks',
 2310040,
 NULL, NULL, 'Available'),

-- C5: Network Fundamentals
(300015,
 'Network Fundamentals (Cisco-style)',
 'Network Computing',
 'English',
 'TCP/IP, switching, routing basics, subnetting and small campus network design.',
 '99 USD',
 'Advanced',
 '6 weeks',
 2310041,
 NULL, NULL, 'Available'),

-- C6: Software Technology
(300016,
 'Software Technology',
 'Software Engineering',
 'Term-long project to design, implement and demo a Tutor Support System for HCMUT.',
 'Free',
 'Advanced',
 '12 weeks',
 2310041,
 NULL, NULL, 'Available');

-- =========================
-- 3. STUDENT USERS & STUDENT
-- =========================

INSERT INTO Users (
    ID, Username, User_Password, Email, Phone,
    First_Name, Last_Name, Sex, Create_Dated
) VALUES
    (2310042, 'A_Anderson', 'Ander123', 'anderson.a@student.hcmut.edu.vn', '0912000001', 'Alex', 'Anderson', 'M', '2004-02-01'),
    (2310043, 'B_Williams', 'Will123', 'williams.b@student.hcmut.edu.vn', '0912000002', 'Brian', 'Williams', 'M', '2004-02-02'),
    (2310044, 'C_Davis', 'Davis123', 'davis.c@student.hcmut.edu.vn', '0912000003', 'Chris', 'Davis', 'M', '2004-02-03'),
    (2310045, 'D_Martinez', 'Mart123', 'martinez.d@student.hcmut.edu.vn', '0912000004', 'Diana', 'Martinez', 'F', '2004-02-04'),
    (2310046, 'E_Robinson', 'Robin123', 'robinson.e@student.hcmut.edu.vn', '0912000005', 'Emma', 'Robinson', 'F', '2004-02-05'),
    (2310047, 'F_Thompson', 'Thom123', 'thompson.f@student.hcmut.edu.vn', '0912000006', 'Frank', 'Thompson', 'M', '2004-02-06'),
    (2310048, 'G_Garcia', 'Garcia123', 'garcia.g@student.hcmut.edu.vn', '0912000007', 'Grace', 'Garcia', 'F', '2004-02-07'),
    (2310049, 'H_Martin', 'Martin123', 'martin.h@student.hcmut.edu.vn', '0912000008', 'Henry', 'Martin', 'M', '2004-02-08'),
    (2310050, 'I_Clark', 'Clark123', 'clark.i@student.hcmut.edu.vn', '0912000009', 'Isabella', 'Clark', 'F', '2004-02-09'),
    (2310051, 'J_Rodriguez', 'Rodri123', 'rodriguez.j@student.hcmut.edu.vn', '0912000010', 'Jack', 'Rodriguez', 'M', '2004-02-10');

INSERT INTO Student (
    ID, Date_of_birth, Number_course_enrolled, Number_course_completed
) VALUES
    (2310042, '2004-01-01', 0, 0),
    (2310043, '2004-02-02', 0, 0),
    (2310044, '2004-03-03', 0, 0),
    (2310045, '2004-04-04', 0, 0),
    (2310046, '2004-05-05', 0, 0),
    (2310047, '2004-06-06', 0, 0),
    (2310048, '2004-07-07', 0, 0),
    (2310049, '2004-08-08', 0, 0),
    (2310050, '2004-09-09', 0, 0),
    (2310051, '2004-10-10', 0, 0);

-- =========================
-- 4. ENROLLMENT
-- =========================

INSERT INTO Enrollment (
    Enroll_ID, Enroll_date, Complete_Percentage,
    Student_ID, Course_ID
) VALUES
-- ===== COURSE 300011: Web Node.js =====
    (400166, '2024-03-01', 100, 2310042, 300011),
    (400167, '2024-03-02',  80, 2310043, 300011),
    (400168, '2024-03-05', 100, 2310044, 300011),
    (400169, '2024-03-06',  20, 2310045, 300011),

-- ===== COURSE 300012: DB Systems =====
    (400170, '2024-04-01', 100, 2310046, 300012),
    (400171, '2024-04-02', 100, 2310047, 300012),
    (400172, '2024-04-03', 100, 2310048, 300012),

-- ===== COURSE 300013: Machine Learning =====
    (400173, '2024-05-01',  60, 2310049, 300013),
    (400174, '2024-05-02',  10, 2310050, 300013),
    (400175, '2024-05-03',   0, 2310051, 300013),

-- ===== COURSE 300014: OS & Linux (Free/Sponsored) =====
    (400176, '2024-06-01', 100, 2310049, 300014),
    (400177, '2024-06-02', 100, 2310050, 300014),

-- ===== COURSE 300015: Network Fundamentals =====
    (400178, '2024-07-01', 100, 2310050, 300015),
    (400179, '2024-07-02',  90, 2310051, 300015),
    (400180, '2024-07-03', 100, 2310049, 300015),

-- ===== COURSE 300016: SE Project (Capstone) =====
    (400181, '2024-08-01', 100, 2310051, 300016);

-- =========================
-- 5. PAYMENT
-- =========================

INSERT INTO Payment (
    ID, Payment_date, Method, Payment_Status, Ammount, Enroll_ID
) VALUES
-- ----- COURSE 300011: Web Node.js -----

(500166, '2024-03-10', 'Card',     'Finish',   '49 USD',     400166),

(500167, '2024-03-11', 'Card',     'Unfinish', '49 USD',     400167),

(500168, '2024-03-12', 'Bank',     'Finish',   '49 USD',     400168),


-- EXPECTED REVENUE 300011 = 49 + 49 = 98.00

-- ----- COURSE 300012: DB Systems -----

(500170, '2024-04-10', 'Card',     'Finish',   '65 USD',     400170),

(500171, '2024-04-11', 'Bank',     'Finish',   '65 USD',     400171),

-- EXPECTED REVENUE 300012 = 65 + 65 = 130.00

-- ----- COURSE 300013: Machine Learning -----

(500173, '2024-05-10', 'Card',     'Unfinish', '79 USD',     400173),
(500174, '2024-05-11', 'Momo',     'Unfinish', '79 USD',     400174),

-- EXPECTED REVENUE 300013 = 0.00

-- ----- COURSE 300016: SE Project (Capstone) -----
(500181, '2024-08-10', 'Bank',     'Finish',   'Free',    400181);

-- EXPECTED REVENUE 300016 = 0.00

-- =========================
-- 6. TEST GỌI HÀM REVENUE
-- =========================

SET @rev := 0;
CALL Calc_Course_Revenue(300011, @rev);
SELECT @rev AS revenue_course_300011_expected_98_00;

SET @rev := 0;
CALL Calc_Course_Revenue(300012, @rev);
SELECT @rev AS revenue_course_300012_expected_130_00;

SET @rev := 0;
CALL Calc_Course_Revenue(300013, @rev);
SELECT @rev AS revenue_course_300013_expected_0_00;

SET @rev := 0;
CALL Calc_Course_Revenue(300016, @rev);
SELECT @rev AS revenue_course_300016_expected_0_00;