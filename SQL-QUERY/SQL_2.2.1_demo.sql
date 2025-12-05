-- Active: 1764906751390@@127.0.0.1@3306@mydb

-- 1. Teacher (User + Teacher)

INSERT INTO Users (
    ID, Username, User_Password, Email, Phone,
    First_Name, Last_Name, Sex, Create_Dated
) VALUES
(10001, 'teacher1', 'pw', 'teacher1@test.com', '0123',
 'T', 'One', 'M', '2024-01-01');

INSERT INTO Teacher (ID, Title)
VALUES (10001, 'Professor');

-----------------------------------------
-- 2. Student (User + Student)
-----------------------------------------
INSERT INTO Users (
    ID, Username, User_Password, Email, Phone,
    First_Name, Last_Name, Sex, Create_Dated
) VALUES
(20001, 'student1', 'pw', 'student1@test.com', '0456',
 'S', 'One', 'F', '2024-01-02');

INSERT INTO Student (
    ID, Date_of_birth, Number_course_enrolled, Number_course_completed
) VALUES
(20001, '2004-01-01', 0, 0);

-----------------------------------------
-- 3. Course + Module
-----------------------------------------
INSERT INTO Course (
    ID, Title, Course_Language, Course_Description,
    Price, Course_Level, Duration,
    Teacher_ID, Delete_Date, Delete_By, Course_Status
) VALUES
(30001, 'Quiz Test Course', 'English', 'Course for testing quiz attempts',
 'Free', 'Beginner', '1h',
 10001, NULL, NULL, 'Available');

INSERT INTO Module (Title, Course_ID, Duration)
VALUES ('Quiz Module', 30001, '30m');

-----------------------------------------
-- 4. Learning_Item:
--   - 1 QUIZ (ID=40001)
--   - 1 VIDEO (ID=40002) để test non-quiz
-----------------------------------------
INSERT INTO Learning_Item (
    ID, Module_Title, Course_ID, Item_Order, Content_Type, Title
) VALUES
(40001, 'Quiz Module', 30001, 1, 'QUIZ',  'Quiz 1'),
(40002, 'Quiz Module', 30001, 2, 'VIDEO', 'Video 1');

-----------------------------------------
-- 5. Quiz cho Learning_Item 40001
-- Max_Attempt = 3
-----------------------------------------
INSERT INTO Quiz (
    ID, Module_Title, Course_ID,
    Passing_Score, Time_Limit, Max_Attempt
) VALUES
(40001, 'Quiz Module', 30001,
 5, '00:10:00', 3);

-----------------------------------------
-- 6. Enrollment cho Student 20001 vào Course 30001
-----------------------------------------
INSERT INTO Enrollment (
    Enroll_ID, Enroll_date, Complete_Percentage, Student_ID, Course_ID
) VALUES
(50001, '2024-02-01', 0, 20001, 30001);

-- 3 lần làm Video 40002 → tất cả đều OK
INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50001, 40002, 'Quiz Module', 30001, '00:05:00', 0, '00:00:00'),
(50001, 40002, 'Quiz Module', 30001, '00:06:00', 0, '00:00:00'),
(50001, 40002, 'Quiz Module', 30001, '00:07:00', 0, '00:00:00');

SELECT *
FROM Make_Progress
WHERE Enroll_ID = 50001
  AND Learning_Item_ID = 40002;
-- Kỳ vọng: 3 dòng, trigger không báo lỗi

-- Attempt 1: OK
INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50001, 40001, 'Quiz Module', 30001, '00:03:00', 6, '00:10:00');

-- Attempt 2: OK
INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50001, 40001, 'Quiz Module', 30001, '00:04:00', 7, '00:10:00');

-- Attempt 3: OK
INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50001, 40001, 'Quiz Module', 30001, '00:05:00', 8, '00:10:00');

-- Attempt 4: PHẢI BỊ CHẶN
-- Kỳ vọng: Error 45000 với message
-- 'Đã vượt quá số lần làm bài kiểm tra tối đa.'
INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50001, 40001, 'Quiz Module', 30001, '00:06:00', 9, '00:10:00');


-- Tạo Enrollment mới cho cùng Student 20001
INSERT INTO Enrollment (
    Enroll_ID, Enroll_date, Complete_Percentage, Student_ID, Course_ID
) VALUES
(50002, '2024-02-02', 0, 20001, 30001);

-- Với Enroll_ID = 50002, lại được làm 3 lần từ đầu

INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50002, 40001, 'Quiz Module', 30001, '00:03:00', 6, '00:10:00'),
(50002, 40001, 'Quiz Module', 30001, '00:04:00', 7, '00:10:00'),
(50002, 40001, 'Quiz Module', 30001, '00:05:00', 8, '00:10:00');

-- Lần thứ 4 với Enroll_ID=50002 cũng phải bị chặn
INSERT INTO Make_Progress (
    Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title,
    Learning_Item_Course_ID, Completion_Time, Score, Total_Time_Limit
) VALUES
(50002, 40001, 'Quiz Module', 30001, '00:06:00', 9, '00:10:00');
