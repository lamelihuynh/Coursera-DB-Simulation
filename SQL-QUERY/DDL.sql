DROP DATABASE IF EXISTS mydb;
CREATE DATABASE mydb;
USE mydb;
Create table Users (
	ID int primary key not null,
    Username varchar(100) not null,
    User_Password varchar(100) not null,
    Email varchar(200) not null,
    Phone varchar(20),
    First_Name varchar(100),
    Last_Name varchar(100),
    Sex varchar(10) not null,
    Create_Dated date not null
);

Create table Student (
	ID int primary key not null,
    Date_of_birth date not null,
    Number_course_enrolled int not null default 0 ,
    Number_course_completed int not null default 0 ,
    foreign key(ID) references Users(ID)
);

Create table Teacher (
	ID int primary key not null,
    Title varchar(100),
    foreign key(ID) references Users(ID)
);

Create table Teacher_Spec (
	Teacher_ID int not null,
    Specialization varchar(100),
    Primary key(Teacher_ID, Specialization),
    foreign key(Teacher_ID) references Teacher(ID)
);

Create table Partner (
	ID int primary key not null,
    Partner_name varchar(100) not null,
    Partner_type varchar(100) not null,
    Website varchar(500)
);

Create table Collaborate (
	Teacher_ID int primary key not null,
    Partner_ID int not null,
    foreign key(Teacher_ID) references Teacher(ID),
    foreign key(Partner_ID) references Partner(ID)
);

Create table Course (
	ID int primary key not null AUTO_INCREMENT,
    Specialization VARCHAR(100),
    Title varchar(100) not null,
    Course_Language varchar(50) not null,
    Course_Description text,
    Price varchar(20) not null default "Free",
    Course_Level varchar(15) not null, 
    Duration varchar(15) not null, 
    Teacher_ID int not null,
    -- v2 added
    Delete_Date DATETIME DEFAULT NULL,
    Delete_By INT DEFAULT NULL,
    Course_Status enum("Discarded", "Available") not null default "Available",
    -- v2 ended
	FOREIGN KEY (Delete_By) REFERENCES Teacher(ID) ON DELETE SET NULL, 
    foreign key(Teacher_ID) references Teacher(ID)
) ENGINE=InnoDB;

Create table Enrollment (
	Enroll_ID int primary key not null,
    Enroll_date date not null,
    Complete_Percentage INT default 0 not null,
    Student_ID int not null,
    Course_ID int not null,
    -- v3 added
    Access_Level ENUM('Limited', 'Full') DEFAULT 'Limited',
    -- v3 added
    foreign key(Student_ID) references Student(ID),
    foreign key(Course_ID) references Course(ID)
);

Create table Payment (
	ID int primary key not null,
    Payment_date date not null,
    Method varchar(30) default "Free",
    Payment_Status varchar(10) not null,
    Ammount varchar(20) default "Free",
    Enroll_ID int not null,
    foreign key(Enroll_ID) references Enrollment(Enroll_ID)
);

Create table Certificate (
	ID int primary key not null,
    Issue_date date not null,
    Expire_date date not null,
    Certificate_name text not null,
    Enroll_ID int not null,
    foreign key(Enroll_ID) references Enrollment(Enroll_ID)
);

Create table Thread (
	ID int primary key not null,
    Title text not null,
    Content text
);

Create table Reply (
	ID int primary key not null,
    Content text not null,
    Reply_date date not null,
    Reply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Thread_ID int not null,
    foreign key(Thread_ID) references Thread(ID)
);

Create table Post (
	Thread_ID int primary key not null,
    Student_ID int not null,
    Course_ID int not null,
    foreign key(Student_ID) references Student(ID),
    foreign key(Course_ID) references Course(ID),
    foreign key(Thread_ID) references Thread(ID)
); 

CREATE TABLE Replies (
    ID INT PRIMARY KEY NOT NULL,
    Content TEXT NOT NULL,
    Reply_date DATE NOT NULL,
    Reply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Thread_ID INT NOT NULL,
    Replied_ID INT NOT NULL,
    FOREIGN KEY (Thread_ID) REFERENCES Thread(ID),
    FOREIGN KEY (Replied_ID) REFERENCES Reply(ID)
 );

Create table Module (
	Title varchar(100) not null,
    Course_ID int not null,
    Duration varchar(20) not null,
    primary key(Title, Course_ID),
    foreign key(Course_ID) references Course(ID)
); 

Create table Learning_Item (
	ID int not null,
	Module_Title varchar(100) not null,
    Course_ID int not null,
    Item_Order int default 0,
    Content_Type varchar(20) not null,
    Title varchar(100) not null,
    primary key(ID, Module_Title, Course_ID),
    
    foreign key(Module_Title, Course_ID) references Module(Title, Course_ID)
);

Create table Video (
	ID int not null,
	Module_Title varchar(100) not null,
    Course_ID int not null,
    URL text not null,
    Duration time not null,
    primary key(ID, Module_Title, Course_ID),
    foreign key(ID, Module_Title, Course_ID) references Learning_Item(ID, Module_Title,Course_ID)
);

Create table Reading (
	ID int not null,
	Module_Title varchar(100) not null,
    Course_ID int not null,
    URL text not null,
    Content text not null,
    primary key(ID, Module_Title, Course_ID),
	foreign key(ID, Module_Title, Course_ID) references Learning_Item(ID, Module_Title,Course_ID)

);

Create table Quiz (
	ID int not null,
	Module_Title varchar(100) not null,
    Course_ID int not null,
    Passing_Score int not null,
    Time_Limit time,
    Max_Attempt int not null default 3,
    primary key(ID, Module_Title, Course_ID),
    foreign key(ID, Module_Title, Course_ID) references Learning_Item(ID, Module_Title,Course_ID)

);

Create table Question (
	Quiz_ID int not null,
	Q_Module_Title varchar(100) not null,
    Q_Course_ID int not null,
    Question_ID int not null,
    Question_Text text not null,
    Question_Point float default 0.0,
--     Q_Option_ID int not null,
    Q_Answer varchar(1) not null,
    primary key(Quiz_ID, Q_Module_Title, Q_Course_ID, Question_ID),

    foreign key(Quiz_ID,Q_Module_Title , Q_Course_ID) references Quiz (ID,Module_Title,Course_ID) 
);


CREATE TABLE Question_Option (
    Option_ID INT AUTO_INCREMENT PRIMARY KEY,
    Quiz_ID INT NOT NULL,
    Q_Module_Title VARCHAR(100) NOT NULL,
    Q_Course_ID INT NOT NULL,
    Question_ID INT NOT NULL,
    Option_Label CHAR(1) NOT NULL, -- 'A', 'B', 'C', 'D', 'E'
    Option_Text TEXT NOT NULL,
    
    FOREIGN KEY (Quiz_ID, Q_Module_Title, Q_Course_ID, Question_ID)
        REFERENCES Question (Quiz_ID, Q_Module_Title, Q_Course_ID, Question_ID)
);



Create table Make_Progress (
	Attempt_ID int AUTO_INCREMENT,
	Enroll_ID int not null,
	Learning_Item_ID int not null,
    Learning_Item_Module_Title varchar(100) not null,
    Learning_Item_Course_ID int not null,
    Completion_Time time default "00:00:00",
    Score float default 0.0,
    Total_Time_Limit time default "00:00:00",
    primary key(Attempt_ID, Enroll_ID, Learning_Item_ID, Learning_Item_Module_Title, Learning_Item_Course_ID),
    
    foreign key(Enroll_ID) references Enrollment(Enroll_ID),
    foreign key(Learning_Item_ID, Learning_Item_Module_Title, Learning_Item_Course_ID) references Learning_Item(ID, Module_Title,Course_ID)
);



DELIMITER $$

CREATE TRIGGER trg_CheckQuizAttempts
BEFORE INSERT ON Make_Progress
FOR EACH ROW
BEGIN
    DECLARE v_max_attempts INT;
    DECLARE v_current_attempts INT;
    DECLARE v_is_quiz INT;
    
    SELECT 
        COUNT(*), 
        MAX(Max_Attempt) 
    INTO 
        v_is_quiz, 
        v_max_attempts
    FROM 
        Quiz
    WHERE 
        ID = NEW.Learning_Item_ID 
        AND Module_Title = NEW.Learning_Item_Module_Title 
        AND Course_ID = NEW.Learning_Item_Course_ID;

    IF v_is_quiz > 0 THEN
        SELECT COUNT(*) 
        INTO v_current_attempts
        FROM Make_Progress
        WHERE 
            Enroll_ID = NEW.Enroll_ID
            AND Learning_Item_ID = NEW.Learning_Item_ID
            AND Learning_Item_Module_Title = NEW.Learning_Item_Module_Title
            AND Learning_Item_Course_ID = NEW.Learning_Item_Course_ID;
            
        IF v_current_attempts >= v_max_attempts THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Đã vượt quá số lần làm bài kiểm tra tối đa.';
        END IF;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_CheckEnrollmentBeforePost
BEFORE INSERT ON Post
FOR EACH ROW
BEGIN
    DECLARE v_enrollment_count INT DEFAULT 0;
    
    SELECT COUNT(*)
    INTO v_enrollment_count
    FROM Enrollment
    WHERE 
        Student_ID = NEW.Student_ID    
        AND Course_ID = NEW.Course_ID  
        AND Complete_Percentage <= 100; 

    IF v_enrollment_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Học viên chưa ghi danh vào khóa học này. Không thể tạo thảo luận.';
        
    END IF;
END$$

DELIMITER ;

ALTER TABLE Certificate
ADD CONSTRAINT uc_Enrollment_Unique 
UNIQUE (Enroll_ID);


DELIMITER $$

CREATE TRIGGER trg_CheckCertificateConditions
BEFORE INSERT ON Certificate
FOR EACH ROW
BEGIN
    DECLARE v_completion_percentage INT;
    DECLARE v_enroll_date DATE;
    DECLARE v_enrollment_exists INT DEFAULT 0;

    SELECT COUNT(*), MAX(Complete_Percentage), MAX(Enroll_date)
    INTO v_enrollment_exists, v_completion_percentage, v_enroll_date
    FROM Enrollment
    WHERE Enroll_ID = NEW.Enroll_ID;

    
    IF v_enrollment_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lượt ghi danh (Enroll_ID) không tồn tại.';
        
    ELSEIF v_completion_percentage < 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể cấp chứng chỉ: Khóa học chưa hoàn thành 100%.';
        
    ELSEIF NEW.Issue_date <= v_enroll_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày cấp chứng chỉ phải sau ngày ghi danh.';
        
    ELSEIF NEW.Expire_date <= NEW.Issue_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày hết hạn phải sau ngày cấp.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_CheckQuizTimeLimit
BEFORE INSERT ON Make_Progress
FOR EACH ROW
BEGIN
    DECLARE v_time_limit TIME;
    DECLARE v_is_quiz INT DEFAULT 0;

    SELECT COUNT(*), MAX(Time_Limit) 
    INTO v_is_quiz, v_time_limit
    FROM Quiz
    WHERE ID = NEW.Learning_Item_ID AND Module_Title = NEW.Learning_Item_Module_Title AND Course_ID = NEW.Learning_Item_Course_ID;

    IF v_is_quiz > 0 THEN
        SET NEW.Total_Time_Limit = v_time_limit;
        
        IF v_time_limit IS NOT NULL THEN
            IF NEW.Completion_Time > v_time_limit THEN
                SET NEW.Score = 0.0;
            END IF;
        END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_CheckPaymentDate
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE v_enroll_date DATE;
    
    SELECT Enroll_date 
    INTO v_enroll_date
    FROM Enrollment
    WHERE Enroll_ID = NEW.Enroll_ID
    LIMIT 1;

    IF NEW.Payment_date < v_enroll_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Ngày thanh toán phải sau hoặc bằng ngày ghi danh.';
        
    ELSEIF NEW.Payment_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Ngày thanh toán không được là một ngày trong tương lai.';
        
    END IF;
END$$

DELIMITER ;


-- v2 Added
DELIMITER $$

CREATE TRIGGER trg_CheckMaxScore_Insert
BEFORE INSERT ON Question
FOR EACH ROW
BEGIN
    DECLARE v_current_total FLOAT DEFAULT 0;

    -- Tính tổng điểm hiện tại của Quiz đó trong database
    SELECT IFNULL(SUM(Question_Point), 0)
    INTO v_current_total
    FROM Question
    WHERE Quiz_ID = NEW.Quiz_ID 
      AND Q_Module_Title = NEW.Q_Module_Title 
      AND Q_Course_ID = NEW.Q_Course_ID;

    -- Kiểm tra: Nếu (Tổng cũ + Điểm mới) > 10 thì báo lỗi
    IF (v_current_total + NEW.Question_Point) > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Tổng điểm các câu hỏi trong một Quiz không được vượt quá 10 điểm.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_CheckMaxScore_Update
BEFORE UPDATE ON Question
FOR EACH ROW
BEGIN
    DECLARE v_current_total FLOAT DEFAULT 0;

    -- Tính tổng điểm của các câu hỏi KHÁC câu đang sửa
    SELECT IFNULL(SUM(Question_Point), 0)
    INTO v_current_total
    FROM Question
    WHERE Quiz_ID = NEW.Quiz_ID 
      AND Q_Module_Title = NEW.Q_Module_Title 
      AND Q_Course_ID = NEW.Q_Course_ID
      AND Question_ID != OLD.Question_ID; -- Trừ câu đang sửa ra

    -- Kiểm tra: Nếu (Tổng các câu khác + Điểm mới sửa) > 10 thì báo lỗi
    IF (v_current_total + NEW.Question_Point) > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi cập nhật: Tổng điểm sau khi sửa sẽ vượt quá 10 điểm.';
    END IF;
END$$

DELIMITER ;
-- v2 Ended

-- v3 add
DELIMITER //

CREATE TRIGGER check_PaymentToCourse
BEFORE UPDATE ON Payment
FOR EACH ROW
BEGIN
    -- Khai báo biến
    DECLARE v_course_price_str VARCHAR(20);
    DECLARE v_course_price_dec DECIMAL(15, 2);
    DECLARE v_payment_dec DECIMAL(15, 2);
    

    SELECT c.Price INTO v_course_price_str
    FROM Course c 
    JOIN Enrollment e ON e.Course_ID = c.ID
    WHERE e.Enroll_ID = NEW.Enroll_ID;
    
    -- 2. Xử lý giá gốc (Course Price)
    IF v_course_price_str = 'Free' THEN
        SET v_course_price_dec = 0;
    ELSE 
        SET v_course_price_dec = CAST(SUBSTRING(v_course_price_str, " ", 1) AS DECIMAL(15, 2));
    END IF;
    
    IF NEW.Ammount = 'Free' THEN
        SET v_payment_dec = 0;
    ELSE
        SET v_payment_dec = CAST(SUBSTRING(NEW.Ammount, " ", 1) AS DECIMAL(15, 2));
    END IF;
    
    IF v_payment_dec > v_course_price_dec THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi dữ liệu: Số tiền thanh toán (Payment) không được lớn hơn giá gốc của khóa học.';
    END IF;
END; //

DELIMITER ;


DELIMITER //

-- 1. Trigger cập nhật quyền khi CẬP NHẬT thanh toán (Ví dụ: Pending -> Success)
CREATE TRIGGER trg_UpdateAccessOnPayment_Update
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    -- Nếu thanh toán chuyển sang trạng thái success
    IF NEW.Payment_Status = 'Finish' AND OLD.Payment_Status != 'Finish' THEN
        UPDATE Enrollment
        SET Access_Level = 'Full'
        WHERE Enroll_ID = NEW.Enroll_ID;
    END IF;
END; //

-- 2. [MỚI] Trigger cập nhật quyền khi TẠO MỚI thanh toán (Ví dụ: Thanh toán ngay lập tức)
-- Đây là phần sửa lỗi logic cho trường hợp bạn vừa test
CREATE TRIGGER trg_UpdateAccessOnPayment_Insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    -- Nếu thanh toán mới tạo mà đã success ngay
    IF NEW.Payment_Status = 'Finish' THEN
        UPDATE Enrollment
        SET Access_Level = 'Full'
        WHERE Enroll_ID = NEW.Enroll_ID;
    END IF;
END; //

-- 3. Trigger set quyền khi mới đăng ký (xử lý khóa học Free)
CREATE TRIGGER trg_SetAccessOnEnroll
BEFORE INSERT ON Enrollment
FOR EACH ROW
BEGIN
    DECLARE v_price VARCHAR(20);
    
    -- Lấy giá khóa học
    SELECT Price INTO v_price FROM Course WHERE ID = NEW.Course_ID;
    
    -- Nếu miễn phí -> Cấp quyền Full ngay lập tức
    IF v_price = 'Free' OR v_price = '0' THEN
        SET NEW.Access_Level = 'Full';
    ELSE
        SET NEW.Access_Level = 'Limited';
    END IF;
END; //

-- 4. Trigger chặn truy cập khi học (Make_Progress)
CREATE TRIGGER trg_CheckAccess_MakeProgress
BEFORE INSERT ON Make_Progress
FOR EACH ROW
BEGIN
    -- Khai báo biến
    DECLARE v_content_type VARCHAR(20);
    DECLARE v_access_level VARCHAR(20); 

    -- Lấy loại nội dung
    SELECT Content_Type INTO v_content_type
    FROM Learning_Item
    WHERE ID = NEW.Learning_Item_ID 
      AND Module_Title = NEW.Learning_Item_Module_Title 
      AND Course_ID = NEW.Learning_Item_Course_ID;
    
    -- Kiểm tra: Nếu nội dung KHÔNG PHẢI là đọc (Reading) thì mới xét quyền hạn
    IF (v_content_type != 'Reading') THEN
    
        -- Lấy cấp độ truy cập hiện tại trong bảng Enrollment
        SELECT Access_Level INTO v_access_level 
        FROM Enrollment 
        WHERE Enroll_ID = NEW.Enroll_ID;

        -- Nếu quyền hạn là Limited -> Chặn
        IF v_access_level = 'Limited' THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Quyền truy cập bị hạn chế: Vui lòng thanh toán khóa học để xem Video và làm Quiz.';
        END IF;
        
    END IF;

END; //

DELIMITER ;

-- v3 end

INSERT INTO Users
VALUES 
    (2310001, "A_Hill", "Hill123", "HillA@gmail.com", "0123456789", "Allison", "Hill", "Male", "2000-01-01"),
    (2310002, "B_Hall", "Hall123", "HallB@gmail.com", "0123456790", "Brandon", "Hall", "Male", "2000-01-02"),
    (2310003, "R_Smith", "Smith123", "SmithR@gmail.com", "0123456791", "Rhonda", "Smith", "Male", "2000-01-03"),
    (2310004, "G_Davis", "Davis123", "DavisG@gmail.com", "0123456792", "Gabrielle", "Davis", "Male", "2000-01-04"),
    (2310005, "V_Gray", "Gray123", "GrayV@gmail.com", "0123456793", "Valerie", "Gray", "Male", "2000-01-05"),
    (2310006, "D_Roberts", "Roberts123", "RobertsD@gmail.com", "0123456794", "Darren", "Roberts", "Male", "2000-01-06"),
    (2310007, "H_Wood", "Wood123", "WoodH@gmail.com", "0123456795", "Holly", "Wood", "Female", "2000-01-07"),
    (2310008, "N_Martin", "Martin123", "MartinN@gmail.com", "0123456796", "Nicholas", "Martin", "Male", "2000-01-08"),
    (2310009, "P_Perez", "Perez123", "PerezP@gmail.com", "0123456797", "Patty", "Perez", "Female", "2000-01-09"),
    (2310010, "E_Rios", "Rios123", "RiosE@gmail.com", "0123456798", "Emily", "Rios", "Female", "2000-01-10"),
    (2310011, "J_Baker", "Baker123", "BakerJ@gmail.com", "0123456799", "Justin", "Baker", "Male", "2000-01-11"),
    (2310012, "A_Williams", "Williams123", "WilliamsA@gmail.com", "0123456800", "Ann", "Williams", "Female", "2000-01-12"),
    (2310013, "J_King", "King123", "KingJ@gmail.com", "0123456801", "Julie", "King", "Female", "2000-01-13"),
    (2310014, "J_Chavez", "Chavez123", "ChavezJ@gmail.com", "0123456802", "Jeffrey", "Chavez", "Male", "2000-01-14"),
    (2310015, "M_Lynch", "Lynch123", "LynchM@gmail.com", "0123456803", "Mark", "Lynch", "Male", "2000-01-15"),
    (2310016, "A_Hickman", "Hickman123", "HickmanA@gmail.com", "0123456804", "Alec", "Hickman", "Male", "2000-01-16"),
    (2310017, "V_Patel", "Patel123", "PatelV@gmail.com", "0123456805", "Vanessa", "Patel", "Female", "2000-01-17"),
    (2310018, "J_Lewis", "Lewis123", "LewisJ@gmail.com", "0123456806", "Jenny", "Lewis", "Female", "2000-01-18"),
    (2310019, "D_Brown", "Brown123", "BrownD@gmail.com", "0123456807", "David", "Brown", "Male", "2000-01-19"),
    (2310020, "A_Jones", "Jones123", "JonesA@gmail.com", "0123456808", "Amy", "Jones", "Female", "2000-01-20"),
    (2310021, "C_Walls", "Walls123", "WallsC@gmail.com", "0123456809", "Carlos", "Walls", "Male", "2000-01-21"),
    (2310022, "J_Henderson", "Henderson123", "HendersonJ@gmail.com", "0123456810", "Jeffrey", "Henderson", "Male", "2000-01-22"),
    (2310023, "R_Rodriguez", "Rodriguez123", "RodriguezR@gmail.com", "0123456811", "Rebecca", "Rodriguez", "Female", "2000-01-23"),
    (2310024, "D_Leblanc", "Leblanc123", "LeblancD@gmail.com", "0123456812", "David", "Leblanc", "Male", "2000-01-24"),
    (2310025, "T_House", "House123", "HouseT@gmail.com", "0123456813", "Tracy", "House", "Female", "2000-01-25"),
    (2310026, "C_Smith", "Smith123", "SmithC@gmail.com", "0123456814", "Carmen", "Smith", "Female", "2000-01-26"),
    (2310027, "K_Lee", "Lee123", "LeeK@gmail.com", "0123456815", "Katelyn", "Lee", "Female", "2000-01-27"),
    (2310028, "J_Calhoun", "Calhoun123", "CalhounJ@gmail.com", "0123456816", "John", "Calhoun", "Male", "2000-01-28"),
    (2310029, "M_Young", "Young123", "YoungM@gmail.com", "0123456817", "Megan", "Young", "Female", "2000-01-29"),
    (2310030, "E_Green", "Green123", "GreenE@gmail.com", "0123456818", "Emily", "Green", "Female", "2000-01-30"),
    (2310031, "T_Walls", "Walls123", "WallsT@gmail.com", "0123456819", "Timothy", "Walls", "Male", "2000-01-31"),
    (2310032, "D_Mahoney", "Mahoney123", "MahoneyD@gmail.com", "0123456820", "Derek", "Mahoney", "Male", "2000-02-01"),
    (2310033, "V_Valdez", "Valdez123", "ValdezV@gmail.com", "0123456821", "Victoria", "Valdez", "Female", "2000-02-02"),
    (2310034, "B_Tran", "Tran123", "TranB@gmail.com", "0123456822", "Brian", "Tran", "Male", "2000-02-03"),
    (2310035, "K_King", "King123", "KingK@gmail.com", "0123456823", "Kathy", "King", "Female", "2000-02-04"),
    (2310036, "R_Miller", "Miller123", "MillerR@gmail.com", "0123456824", "Roudigues", "Miller", "Male", "2000-02-05"); -- dummy user

INSERT INTO Student
VALUES 
    (2310016, "1980-05-12", 10, 8),
    (2310017, "1979-08-23", 5, 2),
    (2310018, "1981-11-02", 11, 9),
    (2310019, "1981-03-15", 6, 3),
    (2310020, "1978-12-30", 11, 11),
    (2310021, "1980-07-14", 4, 1),
    (2310022, "1981-09-09", 9, 5),
    (2310023, "1979-04-25", 11, 1),
    (2310024, "1980-01-18", 7, 4),
    (2310025, "1981-06-20", 10, 6),
    (2310026, "1978-02-14", 3, 0),
    (2310027, "1981-10-10", 8, 7),
    (2310028, "1980-11-28", 9, 5),
    (2310029, "1979-05-05", 11, 8),
    (2310030, "1981-08-19", 6, 2),
    (2310031, "1980-03-22", 9, 4),
    (2310032, "1979-12-05", 10, 6),
    (2310033, "1981-04-01", 5, 3),
    (2310034, "1980-09-16", 10, 9),
    (2310035, "1979-07-07", 11, 2);

INSERT INTO Teacher
VALUES 
    (2310001, "PhD"),
    (2310002, "Master"),
    (2310003, "Bachelor"),
    (2310004, "Master"),
    (2310005, "PhD"),
    (2310006, "Bachelor"),
    (2310007, "PhD"),
    (2310008, "Master"),
    (2310009, "Bachelor"),
    (2310010, "Master"),
    (2310011, "PhD"),
    (2310012, "Master"),
    (2310013, "PhD"),
    (2310014, "Bachelor"),
    (2310015, "Master"),
    (2310036, "Master"); -- dummy teacher
    
INSERT INTO Teacher_Spec 
VALUES 
    (2310001, "Computer Science"),
    (2310001, "Applied Artificial Intelligence"),
    (2310001, "Image Processing and Computer Vision"),
    (2310002, "Cybersecurity"),
    (2310003, "Advanced Software Engineering"),
    (2310003, "Computer Science"),
    (2310004, "Data, Security Engineering and Business Intelligence Data Engineering"),
    (2310005, "Applied Artificial Intelligence"),
    (2310005, "Data, Security Engineering and Business Intelligence Data Engineering"),
    (2310006, "Advanced Software Engineering"),
    (2310007, "Cybersecurity"),
    (2310007, "Computer Science"),
    (2310007, "Advanced Software Engineering"),
    (2310008, "Image Processing and Computer Vision"),
    (2310009, "Computer Science"),
    (2310010, "Cybersecurity"),
    (2310010, "Data, Security Engineering and Business Intelligence Data Engineering"),
    (2310011, "Applied Artificial Intelligence"),
    (2310012, "Advanced Software Engineering"),
    (2310013, "Image Processing and Computer Vision"),
    (2310013, "Applied Artificial Intelligence"),
    (2310014, "Computer Science"),
    (2310015, "Data, Security Engineering and Business Intelligence Data Engineering");
    
INSERT INTO Partner 
VALUES 
    (100000, "FPT Software Ho Chi Minh", "Company", "https://career.fpt-software.com/employer/fpt-software-ho-chi-minh"),
    (100001, "IVS JSC", "Company", "https://indivisys.vn"),
    (100002, "KMS Technology", "Company", "https://kms-technology.com"),
    (100003, "VNG JSC", "Company", "https://vng.com.vn"),
    (100004, "Ban Vien Corporation", "Corporation", "https://banvien.com"),
    (100005, "Bosch Global Software Technologies Company Limited", "Company", "https://www.bosch.com.vn/our-company/bosch-in-vietnam/ho-chi-minh-city-rbvh");

INSERT INTO Collaborate
VALUES 
    (2310001, 100000), 
    (2310002, 100001), 
    (2310004, 100003), 
    (2310005, 100004), 
    (2310006, 100005), 
    (2310008, 100000), 
    (2310009, 100002), 
    (2310010, 100002), 
    (2310011, 100005), 
    (2310013, 100005), 
    (2310014, 100001), 
    (2310015, 100004); 
    
-- ALTER TABLE Course
-- MODIFY COLUMN Price varchar(20) not null default "Free";
    
INSERT INTO Course
VALUES 
    (300000, "Data Science & AI","Neural Networks and Deep Learning", "English", "In this course, you will study the foundational concept of neural networks and deep learning. By the end, you will be familiar with the significant technological trends driving the rise of deep learning; build, train, and apply fully connected deep neural networks; implement efficient (vectorized) neural networks; identify key parameters in a neural network’s architecture; and apply deep learning to your own applications.", "50 USD", "Beginner", "2 Weeks", 2310001, null, null, "Available"), 
    (300001, "Data Science & AI" , "Improving Deep Neural Networks: Hyperparameter Tuning, Regularization and Optimization", "English", "In this course, you will open the deep learning black box to understand the processes that drive performance and generate good results systematically. By the end, you will learn the best practices to train and develop test sets and analyze bias/variance for building deep learning applications; be able to use standard neural network techniques such as initialization, L2 and dropout regularization, hyperparameter tuning, batch normalization, and gradient checking; implement and apply a variety of optimization algorithms, such as mini-batch gradient descent, Momentum, RMSprop and Adam, and check for their convergence; and implement a neural network in TensorFlow.", "60 USD", "Intermediate", "3 Weeks", 2310011, null, null, "Available"), 
    (300002, "Data Science & AI" ,"Structuring Machine Learning Projects", "English", "In this course, you will learn how to build a successful machine learning project and get to practice decision-making as a machine learning project leader. By the end, you will be able to diagnose errors in a machine learning system; prioritize strategies for reducing errors; understand complex ML settings, such as mismatched training/test sets, and comparing to and/or surpassing human-level performance; and apply end-to-end learning, transfer learning, and multi-task learning.", "70 USD", "Intermediate", "1 Month", 2310013, null, null, "Available"), 
    (300003, "Data Science & AI","Convolutional Neural Networks", "English", "In this course, you will understand how computer vision has evolved and become familiar with its exciting applications such as autonomous driving, face recognition, reading radiology images, and more. By the end, you will be able to build a convolutional neural network, including recent variations such as residual networks; apply convolutional networks to visual detection and recognition tasks; and use neural style transfer to generate art and apply these algorithms to a variety of image, video, and other 2D or 3D data.", "70 USD", "Advanced", "3 Weeks", 2310008, null, null, "Available"), 
    (300004, "Data Science & AI","Sequence Models", "English", "In this course, you will become familiar with sequence models and their exciting applications such as speech recognition, music synthesis, chatbots, machine translation, natural language processing (NLP), and more. By the end, you will be able to build and train Recurrent Neural Networks (RNNs) and commonly-used variants such as GRUs and LSTMs; apply RNNs to Character-level Language Modeling; gain experience with natural language processing and Word Embeddings; and use HuggingFace tokenizers and transformer models to solve different NLP tasks such as NER and Question Answering.", "80 USD", "Advanced", "3 Weeks", 2310005, null, null, "Available"), 
    (300005, "Cybersecurity", "Foundations of Cybersecurity", "English", "In this course, learners will be introduced to  the cybersecurity profession, including the primary job responsibilities and core skills of entry-level analysts; significant events that led to the development of the cybersecurity field; and security’s continued importance to organizational operations. Learners will also explore the Certified Information Systems Security Professional (CISSP) eight security domains, common security frameworks and controls, as well as the confidentiality, integrity, and availability (CIA) triad. This course covers a wide variety of cybersecurity topics to provide an overview of what’s to come in this certificate program. Learners who complete the eight courses in the Google Cybersecurity Certificate will be equipped to apply for entry-level cybersecurity roles. No previous experience is necessary.", "80 USD", "Beginner", "3 Weeks", 2310002, null, null, "Available"), 
    (300006, "Cybersecurity","Play It Safe: Manage Security Risks", "English", "This course takes a deeper dive into concepts introduced in the first course, with an emphasis on recognizing the focus of the CISSP eight security domains, steps of risk management, security frameworks and controls (e.g., NIST, CIA triad, OWASP), as well as common security threats, risks, and vulnerabilities. Additionally, learners are provided with an opportunity to explore and analyze SIEM data, use a playbook to respond to identified threats, risks, and vulnerabilities, and conduct a security audit.", "80 USD", "Intermediate", "3 Weeks", 2310007, null, null, "Available"), 
    (300007, "Software Engineering", "Introduction to Software Engineering", "English", "In this course, you will gain foundational knowledge of software development, programming, and the many exciting job roles and career paths that the IT industry offers. Learn about the power of the Software Development Lifecycle (SDLC), and modern software development frameworks methodologies like Agile and Scrum. Explore fundamental programming principles and foundations of design, architecture, and deployment.", "75 USD", "Beginner", "3 Weeks", 2310003, null, null, "Available"), 
    (300008, "Software Engineering","Software Design and Architecture Specialization", "English", "In the Software Design and Architecture Specialization, you will learn how to apply design principles, patterns, and architectures to create reusable and flexible software applications and systems. You will learn how to express and document the design and architecture of a software system using a visual notation.", "80 USD", "Beginner", "3 Weeks", 2310012, null, null, "Available"), 
    (300009, "Data Engineering","Introduction to Data Engineering", "English", "Start your journey in one of the fastest growing professions today with this beginner-friendly Data Engineering course! You will be introduced to the core concepts, processes, and tools you need to know in order to get a foundational knowledge of data engineering. as well as the roles that Data Engineers, Data Scientists, and Data Analysts play in the ecosystem. ", "90 USD", "Beginner", "1 Month", 2310010, null, null, "Available"), 
    (300010, "Data Science & AI","Python for Data Science, AI & Development", "English", "As you progress, you will gain practical experience reading from and writing to files and working with common file formats. You’ll also use powerful Python libraries like NumPy and Pandas for data manipulation and analysis. The course also covers APIs and web scraping, teaching you how to interact with REST APIs using libraries like requests and extract data from websites using BeautifulSoup. ", "90 USD", "Intermediate", "3 Weeks", 2310015, null, null, "Available"); 
    
INSERT INTO Enrollment
VALUES 
-- Student 2310016 (Enrolled 10, Completed 8) -> 8 dòng 100%, 2 dòng <100%
    (400000, "2023-01-10", 100, 2310016, 300001),
    (400001, "2023-01-15", 100, 2310016, 300002),
    (400002, "2023-02-01", 100, 2310016, 300003),
    (400003, "2023-02-20", 100, 2310016, 300004),
    (400004, "2023-03-10", 100, 2310016, 300005),
    (400005, "2023-03-15", 100, 2310016, 300006),
    (400006, "2023-04-01", 100, 2310016, 300007),
    (400007, "2023-04-20", 100, 2310016, 300008),
    (400008, "2023-05-05", 0,  2310016, 300009),
    (400009, "2023-05-10", 0,  2310016, 300010),

-- Student 2310017 (Enrolled 5, Completed 2)
    (400010, "2023-06-01", 100, 2310017, 300001),
    (400011, "2023-06-05", 100, 2310017, 300002),
    (400012, "2023-06-10", 0,  2310017, 300003),
    (400013, "2023-06-15", 0,  2310017, 300004),
    (400014, "2023-06-20", 0,  2310017, 300005),

-- Student 2310018 (Enrolled 11, Completed 9)
    (400015, "2023-01-11", 100, 2310018, 300000),
    (400016, "2023-01-12", 100, 2310018, 300001),
    (400017, "2023-01-13", 100, 2310018, 300002),
    (400018, "2023-02-14", 100, 2310018, 300003),
    (400019, "2023-02-15", 100, 2310018, 300004),
    (400020, "2023-02-16", 100, 2310018, 300005),
    (400021, "2023-03-17", 100, 2310018, 300006),
    (400022, "2023-03-18", 100, 2310018, 300007),
    (400023, "2023-03-19", 100, 2310018, 300008),
    (400024, "2023-04-20", 0,  2310018, 300009),
    (400025, "2023-04-21", 0,  2310018, 300010),

-- Student 2310019 (Enrolled 6, Completed 3)
    (400026, "2023-05-01", 100, 2310019, 300002),
    (400027, "2023-05-02", 100, 2310019, 300004),
    (400028, "2023-05-03", 100, 2310019, 300006),
    (400029, "2023-05-04", 0,  2310019, 300008),
    (400030, "2023-05-05", 0,  2310019, 300010),
    (400031, "2023-05-06", 0,  2310019, 300000),

-- Student 2310020 (Enrolled 11, Completed 11) -> Tất cả đều 100%
    (400032, "2023-01-01", 100, 2310020, 300000),
    (400033, "2023-01-02", 100, 2310020, 300001),
    (400034, "2023-01-03", 100, 2310020, 300002),
    (400035, "2023-02-04", 100, 2310020, 300003),
    (400036, "2023-02-05", 100, 2310020, 300004),
    (400037, "2023-02-06", 100, 2310020, 300005),
    (400038, "2023-03-07", 100, 2310020, 300006),
    (400039, "2023-03-08", 100, 2310020, 300007),
    (400040, "2023-03-09", 100, 2310020, 300008),
    (400041, "2023-04-10", 100, 2310020, 300009),
    (400042, "2023-04-11", 100, 2310020, 300010),

-- Student 2310021 (Enrolled 4, Completed 1)
    (400043, "2023-07-01", 100, 2310021, 300005),
    (400044, "2023-07-02", 0,  2310021, 300007),
    (400045, "2023-07-03", 0,  2310021, 300009),
    (400046, "2023-07-04", 0,  2310021, 300001),

-- Student 2310022 (Enrolled 9, Completed 5)
    (400047, "2023-02-01", 100, 2310022, 300001),
    (400048, "2023-02-02", 100, 2310022, 300002),
    (400049, "2023-02-03", 100, 2310022, 300003),
    (400050, "2023-02-04", 100, 2310022, 300004),
    (400051, "2023-02-05", 100, 2310022, 300005),
    (400052, "2023-03-06", 0,  2310022, 300006),
    (400053, "2023-03-07", 0,  2310022, 300007),
    (400054, "2023-03-08", 0,  2310022, 300008),
    (400055, "2023-03-09", 0,  2310022, 300009),

-- Student 2310023 (Enrolled 11, Completed 1)
    (400056, "2023-01-20", 100, 2310023, 300000),
    (400057, "2023-01-21", 0,   2310023, 300001),
    (400058, "2023-01-22", 0,  2310023, 300002),
    (400059, "2023-01-23", 0,  2310023, 300003),
    (400060, "2023-01-24", 0,  2310023, 300004),
    (400061, "2023-02-25", 0,  2310023, 300005),
    (400062, "2023-02-26", 0,  2310023, 300006),
    (400063, "2023-02-27", 0,  2310023, 300007),
    (400064, "2023-03-28", 0,  2310023, 300008),
    (400065, "2023-03-29", 0,  2310023, 300009),
    (400066, "2023-03-30", 0,  2310023, 300010),

-- Student 2310024 (Enrolled 7, Completed 4)
    (400067, "2023-04-01", 100, 2310024, 300002),
    (400068, "2023-04-02", 100, 2310024, 300004),
    (400069, "2023-04-03", 100, 2310024, 300006),
    (400070, "2023-04-04", 100, 2310024, 300008),
    (400071, "2023-04-05", 0,  2310024, 300010),
    (400072, "2023-04-06", 0,  2310024, 300001),
    (400073, "2023-04-07", 0,  2310024, 300003),

-- Student 2310025 (Enrolled 10, Completed 6)
    (400074, "2023-05-10", 100, 2310025, 300000),
    (400075, "2023-05-11", 100, 2310025, 300001),
    (400076, "2023-05-12", 100, 2310025, 300002),
    (400077, "2023-05-13", 100, 2310025, 300003),
    (400078, "2023-05-14", 100, 2310025, 300004),
    (400079, "2023-05-15", 100, 2310025, 300005),
    (400080, "2023-06-16", 0,  2310025, 300006),
    (400081, "2023-06-17", 0,  2310025, 300007),
    (400082, "2023-06-18", 0,  2310025, 300008),
    (400083, "2023-06-19", 0,  2310025, 300009),

-- Student 2310026 (Enrolled 3, Completed 0) -> Không có dòng nào 100%
    (400084, "2023-08-01", 0,  2310026, 300005),
    (400085, "2023-08-02", 0,  2310026, 300006),
    (400086, "2023-08-03", 0,  2310026, 300007),

-- Student 2310027 (Enrolled 8, Completed 7)
    (400087, "2023-01-15", 100, 2310027, 300001),
    (400088, "2023-01-16", 100, 2310027, 300002),
    (400089, "2023-01-17", 100, 2310027, 300003),
    (400090, "2023-02-18", 100, 2310027, 300004),
    (400091, "2023-02-19", 100, 2310027, 300005),
    (400092, "2023-02-20", 100, 2310027, 300006),
    (400093, "2023-03-21", 100, 2310027, 300007),
    (400094, "2023-03-22", 0,  2310027, 300008),

-- Student 2310028 (Enrolled 9, Completed 5)
    (400095, "2023-04-05", 100, 2310028, 300000),
    (400096, "2023-04-06", 100, 2310028, 300002),
    (400097, "2023-04-07", 100, 2310028, 300004),
    (400098, "2023-04-08", 100, 2310028, 300006),
    (400099, "2023-04-09", 100, 2310028, 300008),
    (400100, "2023-05-10", 0,  2310028, 300001),
    (400101, "2023-05-11", 0,  2310028, 300003),
    (400102, "2023-05-12", 0,  2310028, 300005),
    (400103, "2023-05-13", 0,  2310028, 300007),

-- Student 2310029 (Enrolled 11, Completed 8)
    (400104, "2023-02-01", 100, 2310029, 300000),
    (400105, "2023-02-02", 100, 2310029, 300001),
    (400106, "2023-02-03", 100, 2310029, 300002),
    (400107, "2023-03-04", 100, 2310029, 300003),
    (400108, "2023-03-05", 100, 2310029, 300004),
    (400109, "2023-03-06", 100, 2310029, 300005),
    (400110, "2023-04-07", 100, 2310029, 300006),
    (400111, "2023-04-08", 100, 2310029, 300007),
    (400112, "2023-04-09", 0,  2310029, 300008),
    (400113, "2023-05-10", 0,  2310029, 300009),
    (400114, "2023-05-11", 0,  2310029, 300010),

-- Student 2310030 (Enrolled 6, Completed 2)
    (400115, "2023-06-01", 100, 2310030, 300001),
    (400116, "2023-06-02", 100, 2310030, 300003),
    (400117, "2023-06-03", 0,  2310030, 300005),
    (400118, "2023-06-04", 0,  2310030, 300007),
    (400119, "2023-06-05", 0,  2310030, 300009),
    (400120, "2023-06-06", 0,  2310030, 300000),

-- Student 2310031 (Enrolled 9, Completed 4)
    (400121, "2023-07-10", 100, 2310031, 300002),
    (400122, "2023-07-11", 100, 2310031, 300004),
    (400123, "2023-07-12", 100, 2310031, 300006),
    (400124, "2023-07-13", 100, 2310031, 300008),
    (400125, "2023-07-14", 0,  2310031, 300010),
    (400126, "2023-07-15", 0,  2310031, 300001),
    (400127, "2023-07-16", 0,  2310031, 300003),
    (400128, "2023-07-17", 0,  2310031, 300005),
    (400129, "2023-07-18", 0,  2310031, 300007),

-- Student 2310032 (Enrolled 10, Completed 6)
    (400130, "2023-01-20", 100, 2310032, 300000),
    (400131, "2023-01-21", 100, 2310032, 300001),
    (400132, "2023-01-22", 100, 2310032, 300002),
    (400133, "2023-02-23", 100, 2310032, 300003),
    (400134, "2023-02-24", 100, 2310032, 300004),
    (400135, "2023-02-25", 100, 2310032, 300005),
    (400136, "2023-03-26", 0,  2310032, 300006),
    (400137, "2023-03-27", 0,  2310032, 300007),
    (400138, "2023-03-28", 0,  2310032, 300008),
    (400139, "2023-03-29", 0,  2310032, 300009),

-- Student 2310033 (Enrolled 5, Completed 3)
    (400140, "2023-08-01", 100, 2310033, 300005),
    (400141, "2023-08-02", 100, 2310033, 300006),
    (400142, "2023-08-03", 100, 2310033, 300007),
    (400143, "2023-08-04", 0,  2310033, 300008),
    (400144, "2023-08-05", 0,  2310033, 300009),

-- Student 2310034 (Enrolled 10, Completed 9)
    (400145, "2023-02-10", 100, 2310034, 300001),
    (400146, "2023-02-11", 100, 2310034, 300002),
    (400147, "2023-02-12", 100, 2310034, 300003),
    (400148, "2023-02-13", 100, 2310034, 300004),
    (400149, "2023-03-14", 100, 2310034, 300005),
    (400150, "2023-03-15", 100, 2310034, 300006),
    (400151, "2023-03-16", 100, 2310034, 300007),
    (400152, "2023-04-17", 100, 2310034, 300008),
    (400153, "2023-04-18", 100, 2310034, 300009),
    (400154, "2023-04-19", 36,  2310034, 300010),

-- Student 2310035 (Enrolled 11, Completed 2)
    (400155, "2023-05-01", 100, 2310035, 300000),
    (400156, "2023-05-02", 100, 2310035, 300002),
    (400157, "2023-05-03", 0,  2310035, 300004),
    (400158, "2023-05-04", 0,  2310035, 300006),
    (400159, "2023-06-05", 0,  2310035, 300008),
    (400160, "2023-06-06", 0,  2310035, 300010),
    (400161, "2023-06-07", 0,  2310035, 300001),
    (400162, "2023-07-08", 0,  2310035, 300003),
    (400163, "2023-07-09", 0,  2310035, 300005),
    (400164, "2023-07-10", 0,  2310035, 300007),
    (400165, "2023-07-11", 0,  2310035, 300009);
    
-- ALTER TABLE Payment
-- MODIFY COLUMN Ammount varchar(20) default "Free";

INSERT INTO Payment
VALUES 
-- Sinh viên 2310016 (Courses: 01-10)
    (500000, "2023-01-11", "Cash", "Finish", "60 USD", 400000, "Full"),
    (500001, "2023-01-16", "Transaction", "Finish", "70 USD", 400001, "Full"),
    (500002, "2023-02-01", "Cash", "Finish", "70 USD", 400002, "Full"),
    (500003, "2023-02-21", "Transaction", "Unfinish", "80 USD", 400003, "Limited"),
    (500004, "2023-03-12", "Cash", "Finish", "80 USD", 400004, "Full"),
    (500005, "2023-03-15", "Transaction", "Finish", "80 USD", 400005, "Full"),
    (500006, "2023-04-03", "Cash", "Finish", "75 USD", 400006, "Full"),
    (500007, "2023-04-21", "Transaction", "Finish", "80 USD", 400007, "Full"),
    (500008, "2023-05-06", "Cash", "Unfinish", "90 USD", 400008, "Limited"),
    (500009, "2023-05-10", "Transaction", "Finish", "90 USD", 400009, "Full"),

-- Sinh viên 2310017 (Courses: 01-05)
    (500010, "2023-06-01", "Transaction", "Finish", "60 USD", 400010, "Full"),
    (500011, "2023-06-06", "Cash", "Finish", "70 USD", 400011, "Full"),
    (500012, "2023-06-12", "Transaction", "Unfinish", "70 USD", 400012, "Limited"),
    (500013, "2023-06-16", "Cash", "Finish", "80 USD", 400013, "Full"),
    (500014, "2023-06-21", "Transaction", "Unfinish", "80 USD", 400014, "Limited"),

-- Sinh viên 2310018 (Courses: 00-10)
    (500015, "2023-01-12", "Cash", "Finish", "50 USD", 400015, "Full"),
    (500016, "2023-01-14", "Transaction", "Finish", "60 USD", 400016, "Full"),
    (500017, "2023-01-13", "Cash", "Finish", "70 USD", 400017, "Full"),
    (500018, "2023-02-15", "Transaction", "Finish", "70 USD", 400018, "Full"),
    (500019, "2023-02-16", "Cash", "Finish", "80 USD", 400019, "Full"),
    (500020, "2023-02-18", "Transaction", "Finish", "80 USD", 400020, "Full"),
    (500021, "2023-03-19", "Cash", "Finish", "80 USD", 400021, "Full"),
    (500022, "2023-03-19", "Transaction", "Finish", "75 USD", 400022, "Full"),
    (500023, "2023-03-20", "Cash", "Finish", "80 USD", 400023, "Full"),
    (500024, "2023-04-22", "Transaction", "Unfinish", "90 USD", 400024, "Limited"),
    (500025, "2023-04-22", "Cash", "Finish", "90 USD", 400025, "Full"),

-- Sinh viên 2310019 (Courses: 02,04,06,08,10,00)
    (500026, "2023-05-02", "Transaction", "Finish", "70 USD", 400026, "Full"),
    (500027, "2023-05-03", "Cash", "Finish", "80 USD", 400027, "Full"),
    (500028, "2023-05-05", "Transaction", "Finish", "80 USD", 400028, "Full"),
    (500029, "2023-05-06", "Cash", "Unfinish", "80 USD", 400029, "Limited"),
    (500030, "2023-05-05", "Transaction", "Unfinish", "90 USD", 400030, "Limited"),
    (500031, "2023-05-07", "Cash", "Finish", "50 USD", 400031, "Full"),

-- Sinh viên 2310020 (Courses: 00-10)
    (500032, "2023-01-02", "Transaction", "Finish", "50 USD", 400032, "Full"),
    (500033, "2023-01-02", "Cash", "Finish", "60 USD", 400033, "Full"),
    (500034, "2023-01-05", "Transaction", "Finish", "70 USD", 400034, "Full"),
    (500035, "2023-02-04", "Cash", "Finish", "70 USD", 400035, "Full"),
    (500036, "2023-02-07", "Transaction", "Finish", "80 USD", 400036, "Full"),
    (500037, "2023-02-06", "Cash", "Finish", "80 USD", 400037, "Full"),
    (500038, "2023-03-08", "Transaction", "Finish", "80 USD", 400038, "Full"),
    (500039, "2023-03-09", "Cash", "Finish", "75 USD", 400039, "Full"),
    (500040, "2023-03-10", "Transaction", "Finish", "80 USD", 400040, "Full"),
    (500041, "2023-04-10", "Cash", "Finish", "90 USD", 400041, "Full"),
    (500042, "2023-04-13", "Transaction", "Finish", "90 USD", 400042, "Full"),

-- Sinh viên 2310021 (Courses: 05,07,09,01)
    (500043, "2023-07-02", "Cash", "Finish", "80 USD", 400043, "Full"),
    (500044, "2023-07-03", "Transaction", "Unfinish", "75 USD", 400044, "Limited"),
    (500045, "2023-07-05", "Cash", "Unfinish", "90 USD", 400045, "Limited"),
    (500046, "2023-07-05", "Transaction", "Unfinish", "60 USD", 400046, "Limited"),

-- Sinh viên 2310022 (Courses: 01-09)
    (500047, "2023-02-01", "Cash", "Finish", "60 USD", 400047, "Full"),
    (500048, "2023-02-03", "Transaction", "Finish", "70 USD", 400048, "Full"),
    (500049, "2023-02-05", "Cash", "Finish", "70 USD", 400049, "Full"),
    (500050, "2023-02-05", "Transaction", "Finish", "80 USD", 400050, "Full"),
    (500051, "2023-02-07", "Cash", "Finish", "80 USD", 400051, "Full"),
    (500052, "2023-03-08", "Transaction", "Unfinish", "80 USD", 400052, "Limited"),
    (500053, "2023-03-09", "Cash", "Unfinish", "75 USD", 400053, "Limited"),
    (500054, "2023-03-09", "Transaction", "Unfinish", "80 USD", 400054, "Limited"),
    (500055, "2023-03-11", "Cash", "Unfinish", "90 USD", 400055, "Limited"),

-- Sinh viên 2310023 (Courses: 00-10)
    (500056, "2023-01-22", "Transaction", "Finish", "50 USD", 400056, "Full"),
    (500057, "2023-01-22", "Cash", "Unfinish", "60 USD", 400057, "Limited"),
    (500058, "2023-01-24", "Transaction", "Unfinish", "70 USD", 400058, "Limited"),
    (500059, "2023-01-26", "Cash", "Unfinish", "70 USD", 400059, "Limited"),
    (500060, "2023-01-25", "Transaction", "Unfinish", "80 USD", 400060, "Limited"),
    (500061, "2023-02-26", "Cash", "Unfinish", "80 USD", 400061, "Limited"),
    (500062, "2023-02-28", "Transaction", "Unfinish", "80 USD", 400062, "Limited"),
    (500063, "2023-02-28", "Cash", "Unfinish", "75 USD", 400063, "Limited"),
    (500064, "2023-03-30", "Transaction", "Unfinish", "80 USD", 400064, "Limited"),
    (500065, "2023-04-01", "Cash", "Unfinish", "90 USD", 400065, "Limited"),
    (500066, "2023-04-02", "Transaction", "Unfinish", "90 USD", 400066, "Limited"),

-- Sinh viên 2310024 (Courses: 02,04,06,08,10,01,03)
    (500067, "2023-04-02", "Cash", "Finish", "70 USD", 400067, "Full"),
    (500068, "2023-04-04", "Transaction", "Finish", "80 USD", 400068, "Full"),
    (500069, "2023-04-04", "Cash", "Finish", "80 USD", 400069, "Full"),
    (500070, "2023-04-06", "Transaction", "Finish", "80 USD", 400070, "Full"),
    (500071, "2023-04-07", "Cash", "Unfinish", "90 USD", 400071, "Limited"),
    (500072, "2023-04-08", "Transaction", "Unfinish", "60 USD", 400072, "Limited"),
    (500073, "2023-04-09", "Cash", "Unfinish", "70 USD", 400073, "Limited"),

-- Sinh viên 2310025 (Courses: 00-09)
    (500074, "2023-05-10", "Transaction", "Finish", "50 USD", 400074, "Full"),
    (500075, "2023-05-12", "Cash", "Finish", "60 USD", 400075, "Full"),
    (500076, "2023-05-13", "Transaction", "Finish", "70 USD", 400076, "Full"),
    (500077, "2023-05-15", "Cash", "Finish", "70 USD", 400077, "Full"),
    (500078, "2023-05-15", "Transaction", "Finish", "80 USD", 400078, "Full"),
    (500079, "2023-05-16", "Cash", "Finish", "80 USD", 400079, "Full"),
    (500080, "2023-06-18", "Transaction", "Finish", "80 USD", 400080, "Full"),
    (500081, "2023-06-19", "Cash", "Finish", "75 USD", 400081, "Full"),
    (500082, "2023-06-20", "Transaction", "Finish", "80 USD", 400082, "Full"),
    (500083, "2023-06-21", "Cash", "Unfinish", "90 USD", 400083, "Limited"),

-- Sinh viên 2310026 (Courses: 05,06,07)
    (500084, "2023-08-02", "Transaction", "Unfinish", "80 USD", 400084, "Limited"),
    (500085, "2023-08-04", "Cash", "Unfinish", "80 USD", 400085, "Limited"),
    (500086, "2023-08-05", "Transaction", "Unfinish", "75 USD", 400086, "Limited"),

-- Sinh viên 2310027 (Courses: 01-08)
    (500087, "2023-01-16", "Cash", "Finish", "60 USD", 400087, "Full"),
    (500088, "2023-01-16", "Transaction", "Finish", "70 USD", 400088, "Full"),
    (500089, "2023-01-19", "Cash", "Finish", "70 USD", 400089, "Full"),
    (500090, "2023-02-20", "Transaction", "Finish", "80 USD", 400090, "Full"),
    (500091, "2023-02-21", "Cash", "Finish", "80 USD", 400091, "Full"),
    (500092, "2023-02-22", "Transaction", "Finish", "80 USD", 400092, "Full"),
    (500093, "2023-03-21", "Cash", "Finish", "75 USD", 400093, "Full"),
    (500094, "2023-03-23", "Transaction", "Unfinish", "80 USD", 400094, "Limited"),

-- Sinh viên 2310028 (Courses: 00,02,04,06,08,01,03,05,07)
    (500095, "2023-04-05", "Cash", "Finish", "50 USD", 400095, "Full"),
    (500096, "2023-04-07", "Transaction", "Finish", "70 USD", 400096, "Full"),
    (500097, "2023-04-08", "Cash", "Finish", "80 USD", 400097, "Full"),
    (500098, "2023-04-10", "Transaction", "Finish", "80 USD", 400098, "Full"),
    (500099, "2023-04-10", "Cash", "Finish", "80 USD", 400099, "Full"),
    (500100, "2023-05-12", "Transaction", "Unfinish", "60 USD", 400100, "Limited"),
    (500101, "2023-05-12", "Cash", "Unfinish", "70 USD", 400101, "Limited"),
    (500102, "2023-05-14", "Transaction", "Unfinish", "80 USD", 400102, "Limited"),
    (500103, "2023-05-15", "Cash", "Unfinish", "75 USD", 400103, "Limited"),

-- Sinh viên 2310029 (Courses: 00-10)
    (500104, "2023-02-02", "Transaction", "Finish", "50 USD", 400104, "Full"),
    (500105, "2023-02-03", "Cash", "Finish", "60 USD", 400105, "Full"),
    (500106, "2023-02-05", "Transaction", "Finish", "70 USD", 400106, "Full"),
    (500107, "2023-03-05", "Cash", "Finish", "70 USD", 400107, "Full"),
    (500108, "2023-03-06", "Transaction", "Finish", "80 USD", 400108, "Full"),
    (500109, "2023-03-08", "Cash", "Finish", "80 USD", 400109, "Full"),
    (500110, "2023-04-08", "Transaction", "Finish", "80 USD", 400110, "Full"),
    (500111, "2023-04-09", "Cash", "Finish", "75 USD", 400111, "Full"),
    (500112, "2023-04-11", "Transaction", "Finish", "80 USD", 400112, "Full"),
    (500113, "2023-05-12", "Cash", "Finish", "90 USD", 400113, "Full"),
    (500114, "2023-05-13", "Transaction", "Finish", "90 USD", 400114, "Full"),

-- Sinh viên 2310030 (Courses: 01,03,05,07,09,00)
    (500115, "2023-06-01", "Cash", "Finish", "60 USD", 400115, "Full"),
    (500116, "2023-06-04", "Transaction", "Finish", "70 USD", 400116, "Full"),
    (500117, "2023-06-05", "Cash", "Unfinish", "80 USD", 400117, "Limited"),
    (500118, "2023-06-05", "Transaction", "Unfinish", "75 USD", 400118, "Limited"),
    (500119, "2023-06-07", "Cash", "Unfinish", "90 USD", 400119, "Limited"),
    (500120, "2023-06-08", "Transaction", "Unfinish", "50 USD", 400120, "Limited"),

-- Sinh viên 2310031 (Courses: 02,04,06,08,10,01,03,05,07)
    (500121, "2023-07-10", "Cash", "Finish", "70 USD", 400121, "Full"),
    (500122, "2023-07-12", "Transaction", "Finish", "80 USD", 400122, "Full"),
    (500123, "2023-07-13", "Cash", "Finish", "80 USD", 400123, "Full"),
    (500124, "2023-07-15", "Transaction", "Finish", "80 USD", 400124, "Full"),
    (500125, "2023-07-16", "Cash", "Unfinish", "90 USD", 400125, "Limited"),
    (500126, "2023-07-17", "Transaction", "Unfinish", "60 USD", 400126, "Limited"),
    (500127, "2023-07-18", "Cash", "Unfinish", "70 USD", 400127, "Limited"),
    (500128, "2023-07-18", "Transaction", "Unfinish", "80 USD", 400128, "Limited"),
    (500129, "2023-07-20", "Cash", "Unfinish", "75 USD", 400129, "Limited"),

-- Sinh viên 2310032 (Courses: 00-09)
    (500130, "2023-01-21", "Transaction", "Finish", "50 USD", 400130, "Full"),
    (500131, "2023-01-23", "Cash", "Finish", "60 USD", 400131, "Full"),
    (500132, "2023-01-25", "Transaction", "Finish", "70 USD", 400132, "Full"),
    (500133, "2023-02-25", "Cash", "Finish", "70 USD", 400133, "Full"),
    (500134, "2023-02-26", "Transaction", "Finish", "80 USD", 400134, "Full"),
    (500135, "2023-02-28", "Cash", "Finish", "80 USD", 400135, "Full"),
    (500136, "2023-03-28", "Transaction", "Finish", "80 USD", 400136, "Full"),
    (500137, "2023-03-29", "Cash", "Finish", "75 USD", 400137, "Full"),
    (500138, "2023-03-30", "Transaction", "Finish", "80 USD", 400138, "Full"),
    (500139, "2023-03-31", "Cash", "Finish", "90 USD", 400139, "Full"),

-- Sinh viên 2310033 (Courses: 05-09)
    (500140, "2023-08-02", "Transaction", "Finish", "80 USD", 400140, "Full"),
    (500141, "2023-08-03", "Cash", "Finish", "80 USD", 400141, "Full"),
    (500142, "2023-08-05", "Transaction", "Finish", "75 USD", 400142, "Full"),
    (500143, "2023-08-06", "Cash", "Unfinish", "80 USD", 400143, "Limited"),
    (500144, "2023-08-06", "Transaction", "Unfinish", "90 USD", 400144, "Limited"),

-- Sinh viên 2310034 (Courses: 01-10)
    (500145, "2023-02-11", "Cash", "Finish", "60 USD", 400145, "Full"),
    (500146, "2023-02-13", "Transaction", "Finish", "70 USD", 400146, "Full"),
    (500147, "2023-02-14", "Cash", "Finish", "70 USD", 400147, "Full"),
    (500148, "2023-02-15", "Transaction", "Finish", "80 USD", 400148, "Full"),
    (500149, "2023-03-16", "Cash", "Finish", "80 USD", 400149, "Full"),
    (500150, "2023-03-17", "Transaction", "Finish", "80 USD", 400150, "Full"),
    (500151, "2023-03-18", "Cash", "Finish", "75 USD", 400151, "Full"),
    (500152, "2023-04-18", "Transaction", "Finish", "80 USD", 400152, "Full"),
    (500153, "2023-04-20", "Cash", "Finish", "90 USD", 400153, "Full"),
    (500154, "2023-04-21", "Transaction", "Finish", "90 USD", 400154, "Full"),

-- Sinh viên 2310035 (Courses: 00,02,04,06,08,10,01,03,05,07,09)
    (500155, "2023-05-02", "Cash", "Finish", "50 USD", 400155, "Full"),
    (500156, "2023-05-04", "Transaction", "Finish", "70 USD", 400156, "Full"),
    (500157, "2023-05-05", "Cash", "Unfinish", "80 USD", 400157, "Limited"),
    (500158, "2023-05-07", "Transaction", "Unfinish", "80 USD", 400158, "Limited"),
    (500159, "2023-06-06", "Cash", "Unfinish", "80 USD", 400159, "Limited"),
    (500160, "2023-06-08", "Transaction", "Unfinish", "90 USD", 400160, "Limited"),
    (500161, "2023-06-08", "Cash", "Unfinish", "60 USD", 400161, "Limited"),
    (500162, "2023-07-10", "Transaction", "Unfinish", "70 USD", 400162, "Limited"),
    (500163, "2023-07-11", "Cash", "Unfinish", "80 USD", 400163, "Limited"),
    (500164, "2023-07-13", "Transaction", "Unfinish", "75 USD", 400164, "Limited"),
    (500165, "2023-07-13", "Cash", "Unfinish", "90 USD", 400165, "Limited");
    
INSERT INTO Certificate (ID, Issue_date, Expire_date, Certificate_name, Enroll_ID)
VALUES 
-- Student 2310016
    (36000, "2023-01-31", "2025-01-31", "Improving Deep Neural Networks Certificate", 400000), -- Course 01
    (36001, "2023-02-15", "2025-02-15", "Structuring Machine Learning Projects Certificate", 400001), -- Course 02
    (36002, "2023-02-22", "2025-02-22", "Convolutional Neural Networks Certificate", 400002), -- Course 03
    (36003, "2023-03-13", "2025-03-13", "Sequence Models Certificate", 400003), -- Course 04
    (36004, "2023-03-31", "2025-03-31", "Foundations of Cybersecurity Certificate", 400004), -- Course 05
    (36005, "2023-04-05", "2025-04-05", "Play It Safe: Manage Security Risks Certificate", 400005), -- Course 06
    (36006, "2023-04-22", "2025-04-22", "Introduction to Software Engineering Certificate", 400006), -- Course 07
    (36007, "2023-05-11", "2025-05-11", "Software Design and Architecture Specialization Certificate", 400007), -- Course 08

-- Student 2310017
    (36008, "2023-06-22", "2025-06-22", "Improving Deep Neural Networks Certificate", 400010), -- Course 01
    (36009, "2023-07-05", "2025-07-05", "Structuring Machine Learning Projects Certificate", 400011), -- Course 02

-- Student 2310018
    (36010, "2023-01-25", "2025-01-25", "Neural Networks and Deep Learning Certificate", 400015), -- Course 00
    (36011, "2023-02-02", "2025-02-02", "Improving Deep Neural Networks Certificate", 400016), -- Course 01
    (36012, "2023-02-13", "2025-02-13", "Structuring Machine Learning Projects Certificate", 400017), -- Course 02
    (36013, "2023-03-07", "2025-03-07", "Convolutional Neural Networks Certificate", 400018), -- Course 03
    (36014, "2023-03-08", "2025-03-08", "Sequence Models Certificate", 400019), -- Course 04
    (36015, "2023-03-09", "2025-03-09", "Foundations of Cybersecurity Certificate", 400020), -- Course 05
    (36016, "2023-04-07", "2025-04-07", "Play It Safe: Manage Security Risks Certificate", 400021), -- Course 06
    (36017, "2023-04-08", "2025-04-08", "Introduction to Software Engineering Certificate", 400022), -- Course 07
    (36018, "2023-04-09", "2025-04-09", "Software Design and Architecture Specialization Certificate", 400023), -- Course 08

-- Student 2310019
    (36019, "2023-06-01", "2025-06-01", "Structuring Machine Learning Projects Certificate", 400026), -- Course 02
    (36020, "2023-05-23", "2025-05-23", "Sequence Models Certificate", 400027), -- Course 04
    (36021, "2023-05-24", "2025-05-24", "Play It Safe: Manage Security Risks Certificate", 400028), -- Course 06

-- Student 2310020
    (36022, "2023-01-15", "2025-01-15", "Neural Networks and Deep Learning Certificate", 400032), -- Course 00
    (36023, "2023-01-23", "2025-01-23", "Improving Deep Neural Networks Certificate", 400033), -- Course 01
    (36024, "2023-02-03", "2025-02-03", "Structuring Machine Learning Projects Certificate", 400034), -- Course 02
    (36025, "2023-02-25", "2025-02-25", "Convolutional Neural Networks Certificate", 400035), -- Course 03
    (36026, "2023-02-26", "2025-02-26", "Sequence Models Certificate", 400036), -- Course 04
    (36027, "2023-02-27", "2025-02-27", "Foundations of Cybersecurity Certificate", 400037), -- Course 05
    (36028, "2023-03-28", "2025-03-28", "Play It Safe: Manage Security Risks Certificate", 400038), -- Course 06
    (36029, "2023-03-29", "2025-03-29", "Introduction to Software Engineering Certificate", 400039), -- Course 07
    (36030, "2023-03-30", "2025-03-30", "Software Design and Architecture Specialization Certificate", 400040), -- Course 08
    (36031, "2023-05-10", "2025-05-10", "Introduction to Data Engineering Certificate", 400041), -- Course 09
    (36032, "2023-05-02", "2025-05-02", "Python for Data Science, AI & Development Certificate", 400042), -- Course 10

-- Student 2310021
    (36033, "2023-07-22", "2025-07-22", "Foundations of Cybersecurity Certificate", 400043), -- Course 05

-- Student 2310022
    (36034, "2023-02-22", "2025-02-22", "Improving Deep Neural Networks Certificate", 400047), -- Course 01
    (36035, "2023-03-02", "2025-03-02", "Structuring Machine Learning Projects Certificate", 400048), -- Course 02
    (36036, "2023-02-24", "2025-02-24", "Convolutional Neural Networks Certificate", 400049), -- Course 03
    (36037, "2023-02-25", "2025-02-25", "Sequence Models Certificate", 400050), -- Course 04
    (36038, "2023-02-26", "2025-02-26", "Foundations of Cybersecurity Certificate", 400051), -- Course 05

-- Student 2310023
    (36039, "2023-02-03", "2025-02-03", "Neural Networks and Deep Learning Certificate", 400056), -- Course 00

-- Student 2310024
    (36040, "2023-05-01", "2025-05-01", "Structuring Machine Learning Projects Certificate", 400067), -- Course 02
    (36041, "2023-04-23", "2025-04-23", "Sequence Models Certificate", 400068), -- Course 04
    (36042, "2023-04-24", "2025-04-24", "Play It Safe: Manage Security Risks Certificate", 400069), -- Course 06
    (36043, "2023-04-25", "2025-04-25", "Software Design and Architecture Specialization Certificate", 400070), -- Course 08

-- Student 2310025
    (36044, "2023-05-24", "2025-05-24", "Neural Networks and Deep Learning Certificate", 400074), -- Course 00
    (36045, "2023-06-01", "2025-06-01", "Improving Deep Neural Networks Certificate", 400075), -- Course 01
    (36046, "2023-06-12", "2025-06-12", "Structuring Machine Learning Projects Certificate", 400076), -- Course 02
    (36047, "2023-06-03", "2025-06-03", "Convolutional Neural Networks Certificate", 400077), -- Course 03
    (36048, "2023-06-04", "2025-06-04", "Sequence Models Certificate", 400078), -- Course 04
    (36049, "2023-06-05", "2025-06-05", "Foundations of Cybersecurity Certificate", 400079), -- Course 05

-- Student 2310027
    (36050, "2023-02-05", "2025-02-05", "Improving Deep Neural Networks Certificate", 400087), -- Course 01
    (36051, "2023-02-16", "2025-02-16", "Structuring Machine Learning Projects Certificate", 400088), -- Course 02
    (36052, "2023-02-07", "2025-02-07", "Convolutional Neural Networks Certificate", 400089), -- Course 03
    (36053, "2023-03-11", "2025-03-11", "Sequence Models Certificate", 400090), -- Course 04
    (36054, "2023-03-12", "2025-03-12", "Foundations of Cybersecurity Certificate", 400091), -- Course 05
    (36055, "2023-03-13", "2025-03-13", "Play It Safe: Manage Security Risks Certificate", 400092), -- Course 06
    (36056, "2023-04-11", "2025-04-11", "Introduction to Software Engineering Certificate", 400093), -- Course 07

-- Student 2310028
    (36057, "2023-04-19", "2025-04-19", "Neural Networks and Deep Learning Certificate", 400095), -- Course 00
    (36058, "2023-05-06", "2025-05-06", "Structuring Machine Learning Projects Certificate", 400096), -- Course 02
    (36059, "2023-04-28", "2025-04-28", "Sequence Models Certificate", 400097), -- Course 04
    (36060, "2023-04-29", "2025-04-29", "Play It Safe: Manage Security Risks Certificate", 400098), -- Course 06
    (36061, "2023-04-30", "2025-04-30", "Software Design and Architecture Specialization Certificate", 400099), -- Course 08

-- Student 2310029
    (36062, "2023-02-15", "2025-02-15", "Neural Networks and Deep Learning Certificate", 400104), -- Course 00
    (36063, "2023-02-23", "2025-02-23", "Improving Deep Neural Networks Certificate", 400105), -- Course 01
    (36064, "2023-03-03", "2025-03-03", "Structuring Machine Learning Projects Certificate", 400106), -- Course 02
    (36065, "2023-03-25", "2025-03-25", "Convolutional Neural Networks Certificate", 400107), -- Course 03
    (36066, "2023-03-26", "2025-03-26", "Sequence Models Certificate", 400108), -- Course 04
    (36067, "2023-03-27", "2025-03-27", "Foundations of Cybersecurity Certificate", 400109), -- Course 05
    (36068, "2023-04-28", "2025-04-28", "Play It Safe: Manage Security Risks Certificate", 400110), -- Course 06
    (36069, "2023-04-29", "2025-04-29", "Introduction to Software Engineering Certificate", 400111), -- Course 07

-- Student 2310030
    (36070, "2023-06-22", "2025-06-22", "Improving Deep Neural Networks Certificate", 400115), -- Course 01
    (36071, "2023-06-23", "2025-06-23", "Convolutional Neural Networks Certificate", 400116), -- Course 03

-- Student 2310031
    (36072, "2023-08-10", "2025-08-10", "Structuring Machine Learning Projects Certificate", 400121), -- Course 02
    (36073, "2023-08-01", "2025-08-01", "Sequence Models Certificate", 400122), -- Course 04
    (36074, "2023-08-02", "2025-08-02", "Play It Safe: Manage Security Risks Certificate", 400123), -- Course 06
    (36075, "2023-08-03", "2025-08-03", "Software Design and Architecture Specialization Certificate", 400124), -- Course 08

-- Student 2310032
    (36076, "2023-02-03", "2025-02-03", "Neural Networks and Deep Learning Certificate", 400130), -- Course 00
    (36077, "2023-02-11", "2025-02-11", "Improving Deep Neural Networks Certificate", 400131), -- Course 01
    (36078, "2023-02-22", "2025-02-22", "Structuring Machine Learning Projects Certificate", 400132), -- Course 02
    (36079, "2023-03-16", "2025-03-16", "Convolutional Neural Networks Certificate", 400133), -- Course 03
    (36080, "2023-03-17", "2025-03-17", "Sequence Models Certificate", 400134), -- Course 04
    (36081, "2023-03-18", "2025-03-18", "Foundations of Cybersecurity Certificate", 400135), -- Course 05

-- Student 2310033
    (36082, "2023-08-22", "2025-08-22", "Foundations of Cybersecurity Certificate", 400140), -- Course 05
    (36083, "2023-08-23", "2025-08-23", "Play It Safe: Manage Security Risks Certificate", 400141), -- Course 06
    (36084, "2023-08-24", "2025-08-24", "Introduction to Software Engineering Certificate", 400142), -- Course 07

-- Student 2310034
    (36085, "2023-03-03", "2025-03-03", "Improving Deep Neural Networks Certificate", 400145), -- Course 01
    (36086, "2023-03-11", "2025-03-11", "Structuring Machine Learning Projects Certificate", 400146), -- Course 02
    (36087, "2023-03-05", "2025-03-05", "Convolutional Neural Networks Certificate", 400147), -- Course 03
    (36088, "2023-03-06", "2025-03-06", "Sequence Models Certificate", 400148), -- Course 04
    (36089, "2023-04-04", "2025-04-04", "Foundations of Cybersecurity Certificate", 400149), -- Course 05
    (36090, "2023-04-05", "2025-04-05", "Play It Safe: Manage Security Risks Certificate", 400150), -- Course 06
    (36091, "2023-04-06", "2025-04-06", "Introduction to Software Engineering Certificate", 400151), -- Course 07
    (36092, "2023-05-08", "2025-05-08", "Software Design and Architecture Specialization Certificate", 400152), -- Course 08
    (36093, "2023-05-18", "2025-05-18", "Introduction to Data Engineering Certificate", 400153), -- Course 09

-- Student 2310035
    (36094, "2023-05-15", "2025-05-15", "Neural Networks and Deep Learning Certificate", 400155), -- Course 00
    (36095, "2023-06-02", "2025-06-02", "Structuring Machine Learning Projects Certificate", 400156); -- Course 02
    
INSERT INTO Thread
VALUES (25000, "How to setup OPNSense?", "I have been setup OPNSense for firewall on Mac but I couldn't access to the web page. Any debuging guidance?"),
	   (25001, "How to configure web-block?", "I've install a Access Control List on my OPNSense firewall but it seems useless when I tested it. Any idea why?"),
       (25002, "How to build a deep learning model?", "I've been curious about AI and how it works, can you give me a guidance about what i should learn about in general and any course that I should attend?"),
       (25003, "How to determine an component opbject?", "I have an assignment on software developing and I am asked to draw an component diagram, but identifing components for me is a tedious task. Any guidance on how to choose it easily?"),
       (25004, "How to import data fast?", "I had an assignment on Database System using My SQL, can anyone have ways to import data faster since I have a lot of tables to deal with, like a script or something like that?");
       
INSERT INTO Reply
VALUES 
    (250000, "Answer for setup OPNSense", "2023-02-01", "2023-02-01 09:00:00", 25000),
    (250001, "Answer for web-block", "2023-05-12", "2023-05-12 09:01:00", 25001),
    (250002, "Answer for building a deep learning model", "2023-12-23", "2023-12-23 09:02:00", 25002),
    (250003, "Answer for componemt", "2023-11-14", "2023-11-14 09:03:00", 25003),
    (250004, "Answer for data importation", "2023-09-19", "2023-09-19 09:04:00", 25004);
       
INSERT INTO Post
VALUES 
    (25000, 2310016, 300005), 
    (25001, 2310020, 300006), 
    (25002, 2310025, 300000), 
    (25003, 2310032, 300008), 
    (25004, 2310035, 300009); 
       
INSERT INTO Replies
VALUES 
    (260000, "Check Network Adaper, check IP, check HTTPS method", 
        "2023-02-03", "2023-02-03 09:30:00", 25000, 250000),

    (260001, "Check SSL, check Transparent mode", 
        "2023-05-14", "2023-05-14 09:31:00", 25001, 250001),

    (260002, "Learn math like linear algebra, probability and statistic and work on things like convonent layer, functions,... before attending into courses and projects", 
        "2023-12-27", "2023-12-27 09:32:00", 25002, 250002),

    (260003, "Group up classes/interfaces that represent the system's work like API, fetch,... and turn them into component - Good Luck, I'm a shitass in this field", 
        "2023-11-15", "2023-11-15 09:33:00", 25003, 250003),

    (260004, "If you are dealing with data from csv, excel,...you can use load command rather than insert each row from it", 
         "2023-09-20", "2023-09-20 09:34:00", 25004, 250004);
    
INSERT INTO Module
VALUES 
    -- Course 300000: Neural Networks and Deep Learning (Total: 2 Weeks)
    ("Introduction to Deep Learning", 300000, "1 Week"),
    ("Neural Network Basics", 300000, "1 Week"),

    -- Course 300001: Improving Deep Neural Networks (Total: 3 Weeks)
    ("Practical Aspects of Deep Learning", 300001, "1 Week"),
    ("Optimization Algorithms", 300001, "1 Week"),
    ("Hyperparameter Tuning and Batch Normalization", 300001, "1 Week"),

    -- Course 300002: Structuring Machine Learning Projects (Total: 1 Month ~ 4 Weeks)
    ("ML Strategy Introduction", 300002, "1 Week"),
    ("Setting up your Goal", 300002, "1 Week"),
    ("Mismatched Training and Dev sets", 300002, "1 Week"),
    ("End-to-end Deep Learning", 300002, "1 Week"),

    -- Course 300003: Convolutional Neural Networks (Total: 3 Weeks)
    ("Foundations of Convolutional Neural Networks", 300003, "1 Week"),
    ("Deep Convolutional Models: Case Studies", 300003, "1 Week"),
    ("Object Detection and Face Recognition", 300003, "1 Week"),

    -- Course 300004: Sequence Models (Total: 3 Weeks)
    ("Recurrent Neural Networks", 300004, "1 Week"),
    ("Natural Language Processing and Word Embeddings", 300004, "1 Week"),
    ("Sequence Models and Attention Mechanism", 300004, "1 Week"),

    -- Course 300005: Foundations of Cybersecurity (Total: 3 Weeks)
    ("The Evolution of Cybersecurity", 300005, "1 Week"),
    ("The CISSP Eight Security Domains", 300005, "1 Week"),
    ("Security Frameworks and Controls", 300005, "1 Week"),

    -- Course 300006: Play It Safe: Manage Security Risks (Total: 3 Weeks)
    ("Security Risks and Vulnerabilities", 300006, "1 Week"),
    ("Analyzing SIEM Data", 300006, "1 Week"),
    ("Incident Response Playbooks", 300006, "1 Week"),

    -- Course 300007: Introduction to Software Engineering (Total: 3 Weeks)
    ("Software Development Lifecycle (SDLC)", 300007, "1 Week"),
    ("Agile and Scrum Methodologies", 300007, "1 Week"),
    ("Fundamental Programming Principles", 300007, "1 Week"),

    -- Course 300008: Software Design and Architecture Specialization (Total: 3 Weeks)
    ("Object-Oriented Design Principles", 300008, "1 Week"),
    ("Design Patterns", 300008, "1 Week"),
    ("Software Architecture Patterns", 300008, "1 Week"),

    -- Course 300009: Introduction to Data Engineering (Total: 1 Month ~ 4 Weeks)
    ("Data Engineering Ecosystem", 300009, "1 Week"),
    ("Data Lifecycle and ETL Processes", 300009, "1 Week"),
    ("Introduction to Big Data and Hadoop", 300009, "1 Week"),
    ("Data Platforms and Pipelines", 300009, "1 Week"),

    -- Course 300010: Python for Data Science, AI & Development (Total: 3 Weeks)
    ("Python Basics and Data Types", 300010, "1 Week"),
    ("Python Data Structures", 300010, "1 Week"),
    ("Working with Libraries and APIs", 300010, "1 Week");
    
INSERT INTO Learning_Item
VALUES 
-- Course 300000: Neural Networks and Deep Learning
    (27000, "Introduction to Deep Learning", 300000, 1, "Video", "What is a Neural Network?"),
    (27001, "Introduction to Deep Learning", 300000, 2, "Quiz", "Deep Learning Intro Quiz"),
    (27002, "Neural Network Basics", 300000, 1, "Reading", "Binary Classification"),
    (27003, "Neural Network Basics", 300000, 2, "Video", "Logistic Regression as a Neural Network"),

-- Course 300001: Improving Deep Neural Networks
    (27004, "Practical Aspects of Deep Learning", 300001, 1, "Video", "Train/Dev/Test sets"),
    (27005, "Practical Aspects of Deep Learning", 300001, 2, "Reading", "Bias and Variance"),
    (27006, "Optimization Algorithms", 300001, 1, "Video", "Mini-batch Gradient Descent"),
    (27007, "Hyperparameter Tuning and Batch Normalization", 300001, 1, "Video", "Tuning Process"),
    (27008, "Hyperparameter Tuning and Batch Normalization", 300001, 2, "Quiz", "Optimization Quiz"),

-- Course 300002: Structuring Machine Learning Projects
    (27009, "ML Strategy Introduction", 300002, 1, "Video", "Why ML Strategy?"),
    (27010, "Setting up your Goal", 300002, 1, "Reading", "Satisficing and Optimizing Metrics"),
    (27011, "Mismatched Training and Dev sets", 300002, 1, "Video", "Training and Testing on Different Distributions"),
    (27012, "End-to-end Deep Learning", 300002, 1, "Quiz", "Strategy Quiz"),

-- Course 300003: Convolutional Neural Networks
    (27013, "Foundations of Convolutional Neural Networks", 300003, 1, "Video", "Edge Detection Example"),
    (27014, "Foundations of Convolutional Neural Networks", 300003, 2, "Reading", "Padding and Stride"),
    (27015, "Foundations of Convolutional Neural Networks", 300003, 3, "Quiz", "CNN Basics Quiz"),
    (27016, "Deep Convolutional Models: Case Studies", 300003, 1, "Video", "ResNets"),
    (27017, "Object Detection and Face Recognition", 300003, 1, "Video", "YOLO Algorithm"),

-- Course 300004: Sequence Models
    (27018, "Recurrent Neural Networks", 300004, 1, "Video", "Why Sequence Models?"),
    (27019, "Recurrent Neural Networks", 300004, 2, "Reading", "RNN Model"),
    (27020, "Natural Language Processing and Word Embeddings", 300004, 1, "Video", "Word Representation"),
    (27021, "Sequence Models and Attention Mechanism", 300004, 1, "Video", "Attention Model Intuition"),
    (27022, "Sequence Models and Attention Mechanism", 300004, 2, "Quiz", "NLP Quiz"),

-- Course 300005: Foundations of Cybersecurity
    (27023, "The Evolution of Cybersecurity", 300005, 1, "Video", "History of Cyber Attacks"),
    (27024, "The CISSP Eight Security Domains", 300005, 1, "Reading", "Understanding the Domains"),
    (27025, "The CISSP Eight Security Domains", 300005, 2, "Quiz", "Domains Check"),
    (27026, "Security Frameworks and Controls", 300005, 1, "Video", "NIST Framework"),

-- Course 300006: Play It Safe: Manage Security Risks
    (27027, "Security Risks and Vulnerabilities", 300006, 1, "Reading", "Common Threats"),
    (27028, "Analyzing SIEM Data", 300006, 1, "Video", "Intro to SIEM Tools"),
    (27029, "Analyzing SIEM Data", 300006, 2, "Quiz", "Log Analysis Quiz"),
    (27030, "Incident Response Playbooks", 300006, 1, "Reading", "Creating a Playbook"),

-- Course 300007: Introduction to Software Engineering
    (27031, "Software Development Lifecycle (SDLC)", 300007, 1, "Video", "Stages of SDLC"),
    (27032, "Software Development Lifecycle (SDLC)", 300007, 2, "Quiz", "SDLC Quiz"),
    (27033, "Agile and Scrum Methodologies", 300007, 1, "Video", "Scrum Artifacts"),
    (27034, "Fundamental Programming Principles", 300007, 1, "Reading", "Clean Code Practices"),

-- Course 300008: Software Design and Architecture Specialization
    (27035, "Object-Oriented Design Principles", 300008, 1, "Video", "SOLID Principles"),
    (27036, "Object-Oriented Design Principles", 300008, 2, "Quiz", "OOD Quiz"),
    (27037, "Design Patterns", 300008, 1, "Video", "Singleton & Factory Patterns"),
    (27038, "Software Architecture Patterns", 300008, 1, "Reading", "MVC Architecture"),

-- Course 300009: Introduction to Data Engineering
    (27039, "Data Engineering Ecosystem", 300009, 1, "Video", "Who is a Data Engineer?"),
    (27040, "Data Lifecycle and ETL Processes", 300009, 1, "Video", "Extract Transform Load"),
    (27041, "Data Lifecycle and ETL Processes", 300009, 2, "Reading", "Data Cleaning Techniques"),
    (27042, "Introduction to Big Data and Hadoop", 300009, 1, "Video", "HDFS Basics"),
    (27043, "Data Platforms and Pipelines", 300009, 1, "Quiz", "Data Engineering Quiz"),

-- Course 300010: Python for Data Science, AI & Development
    (27044, "Python Basics and Data Types", 300010, 1, "Video", "Variables and Strings"),
    (27045, "Python Basics and Data Types", 300010, 2, "Quiz", "Basics Quiz"),
    (27046, "Python Data Structures", 300010, 1, "Reading", "Lists and Dictionaries"),
    (27047, "Working with Libraries and APIs", 300010, 1, "Video", "Pandas Introduction"),
    (27048, "Working with Libraries and APIs", 300010, 2, "Video", "Requests Library"),
    (27049, "Working with Libraries and APIs", 300010, 3, "Quiz", "Python Final Quiz");
    
INSERT INTO Video (ID, Module_Title, Course_ID, URL, Duration)
VALUES 
-- Course 300000
    (27000, "Introduction to Deep Learning", 300000, "https://www.youtube.com/watch?v=alfdI7S6wCY&list=PLtBw6njQRU-rwp5__7C0oIVt26ZgjG9NI&index=1", "01:09:25"),
    (27003, "Neural Network Basics", 300000, "https://www.youtube.com/watch?v=aircAruvnKk&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi", "03:09:00"),

-- Course 300001
    (27004, "Practical Aspects of Deep Learning", 300001, "https://www.youtube.com/watch?v=oScPlBsCCbw", "00:17:45"),
    (27006, "Optimization Algorithms", 300001, "https://www.youtube.com/playlist?list=PLXsmhnDvpjORzPelSDs0LSDrfJcqyLlZc", "01:24:43"),
    (27007, "Hyperparameter Tuning and Batch Normalization", 300001, "https://www.youtube.com/watch?v=CdTqHbFMePM", "00:47:00"),

-- Course 300002
    (27009, "ML Strategy Introduction", 300002, "https://www.youtube.com/watch?v=l3_pTkVyYGA", "00:22:44"),
    (27011, "Mismatched Training and Dev sets", 300002, "https://www.youtube.com/watch?v=1GKxaAyrUKg", "01:33:30"),

-- Course 300003 (Convolutional Neural Networks)
    (27013, "Foundations of Convolutional Neural Networks", 300003, "https://www.youtube.com/watch?v=2fq9wYslV0A", "01:10:00"), -- Stanford CS231n Lecture 1
    (27016, "Deep Convolutional Models: Case Studies", 300003, "https://www.youtube.com/watch?v=aVJy4O5TOk8", "01:20:00"), -- Stanford CS231n Lecture 6 (Architectures)
    (27017, "Object Detection and Face Recognition", 300003, "https://www.youtube.com/watch?v=N3adGK66myE", "02:00:00"), -- Full YOLO & Object Detection Tutorial

-- Course 300004 (Sequence Models)
    (27018, "Recurrent Neural Networks", 300004, "https://www.youtube.com/watch?v=4wuIOcD1LLI", "00:39:43"), -- RNN from Scratch
    (27020, "Natural Language Processing and Word Embeddings", 300004, "https://www.youtube.com/watch?v=DzpHeXVSC5I", "01:20:00"), -- Stanford CS224n Lecture 1
    (27021, "Sequence Models and Attention Mechanism", 300004, "https://www.youtube.com/watch?v=VM2c-E1YGiw", "00:45:00"), -- RNNs to Transformers

-- Course 300005 (Foundations of Cybersecurity)
    (27023, "The Evolution of Cybersecurity", 300005, "https://www.youtube.com/watch?v=q3R6ZFNW_oY", "01:29:00"), -- Code 2600 Documentary
    (27026, "Security Frameworks and Controls", 300005, "https://www.youtube.com/watch?v=UwujuV9K-OE", "00:35:00"), -- NIST Framework Full Tutorial

-- Course 300006 (Manage Security Risks)
    (27028, "Analyzing SIEM Data", 300006, "https://www.youtube.com/watch?v=6VuwUrx_m50", "00:50:00"), -- TryHackMe Log Analysis

-- Course 300007 (Software Engineering)
    (27031, "Software Development Lifecycle (SDLC)", 300007, "https://www.youtube.com/watch?v=cgWzYMaDncI", "00:40:00"), -- SDLC Explained
    (27033, "Agile and Scrum Methodologies", 300007, "https://www.youtube.com/watch?v=J-psYRsMZ1A", "04:40:30"), -- Agile Scrum Full Course

-- Course 300008 (Software Design and Architecture)
    (27035, "Object-Oriented Design Principles", 300008, "https://www.youtube.com/watch?v=UsNl8kcU4UA", "01:05:00"), -- SOLID Principles Full Guide
    (27037, "Design Patterns", 300008, "https://www.youtube.com/watch?v=GwQnoaUoiOM", "01:36:38"), -- Modern Design Patterns Full Course

-- Course 300009 (Data Engineering)
    (27039, "Data Engineering Ecosystem", 300009, "https://www.youtube.com/watch?v=PHsC_t0j1dU", "03:00:00"), -- Data Engineering Course for Beginners
    (27040, "Data Lifecycle and ETL Processes", 300009, "https://www.youtube.com/watch?v=4_Cv0rKVLhU", "00:45:00"), -- Understanding ETL Process
    (27042, "Introduction to Big Data and Hadoop", 300009, "https://www.youtube.com/watch?v=9QxZhapbo0o", "12:00:00"), -- Big Data & Hadoop Full Course

-- Course 300010 (Python for Data Science)
    (27044, "Python Basics and Data Types", 300010, "https://www.youtube.com/watch?v=INGJh9DEaBM", "00:40:00"), -- Python Data Types
    (27047, "Working with Libraries and APIs", 300010, "https://www.youtube.com/watch?v=CMEWVn1uZpQ", "14:43:00"), -- Python for Data Science Full Course
    (27048, "Working with Libraries and APIs", 300010, "https://www.youtube.com/watch?v=CMEWVn1uZpQ", "14:43:00"); -- (Same course, different section reference)

INSERT INTO Reading 
VALUES 
-- Course 300000: Neural Networks and Deep Learning
    (27002, "Neural Network Basics", 300000, 
    "https://www.deeplearningbook.org/", 
    "Chapter 1 introduces the concept of binary classification using logistic regression as the fundamental building block for neural networks. It explains how to map inputs to a probability output between 0 and 1."),

-- Course 300001: Improving Deep Neural Networks
    (27005, "Practical Aspects of Deep Learning", 300001, 
    "https://www.microsoft.com/en-us/research/uploads/prod/2006/01/Bishop-Pattern-Recognition-and-Machine-Learning-2006.pdf", 
    "This section covers the bias-variance tradeoff, a central problem in supervised learning. It explains how to diagnose high bias (underfitting) versus high variance (overfitting) to improve model performance."),

-- Course 300002: Structuring Machine Learning Projects
    (27010, "Setting up your Goal", 300002, 
    "https://www.deeplearning.ai/the-batch/a-roadmap-for-building-machine-learning-systems/", 
    "A guide on selecting a single number evaluation metric to track progress efficiently. It also distinguishes between satisficing metrics (constraints) and optimizing metrics (goals)."),

-- Course 300003: Convolutional Neural Networks
    (27014, "Foundations of Convolutional Neural Networks", 300003, 
    "https://www.oreilly.com/library/view/hands-on-machine-learning/9781492032632/", 
    "Explains the mechanics of convolution operations, specifically how padding preserves output dimensions and stride controls the downsampling rate. Essential for designing valid CNN architectures."),

-- Course 300004: Sequence Models
    (27019, "Recurrent Neural Networks", 300004, 
    "https://www.deeplearningbook.org/contents/rnn.html", 
    "Details the unfolding of computational graphs in Recurrent Neural Networks to process sequential data. It explains how information persists across time steps in the network."),

-- Course 300005: Foundations of Cybersecurity
    (27024, "The CISSP Eight Security Domains", 300005, 
    "https://www.wiley.com/en-us/(ISC)2+CISSP+Certified+Information+Systems+Security+Professional+Official+Study+Guide,+9th+Edition-p-9781119786238", 
    "A comprehensive overview of the eight domains of the (ISC)² Common Body of Knowledge (CBK). This reading outlines the core pillars of information security required for certification."),

-- Course 300006: Play It Safe: Manage Security Risks
    (27027, "Security Risks and Vulnerabilities", 300006, 
    "https://www.pearson.com/en-us/subject-catalog/p/computer-security-principles-and-practice/P200000003287", 
    "Categorizes common cyber threats including malware, phishing, and social engineering attacks. It provides a framework for assessing the potential impact and likelihood of these vulnerabilities."),

    (27030, "Incident Response Playbooks", 300006, 
    "https://csrc.nist.gov/pubs/sp/800/61/r2/final", 
    "The NIST Computer Security Incident Handling Guide which defines the incident response life cycle. It instructs on how to create actionable playbooks for detecting, analyzing, and containing security incidents."),

-- Course 300007: Introduction to Software Engineering
    (27034, "Fundamental Programming Principles", 300007, 
    "https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882", 
    "Excerpt from 'Clean Code' by Robert C. Martin focused on meaningful naming and function composition. It argues that code is read far more often than it is written, so clarity is paramount."),

-- Course 300008: Software Design and Architecture Specialization
    (27038, "Software Architecture Patterns", 300008, 
    "https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/", 
    "An analysis of the Model-View-Controller (MVC) pattern and its role in separating internal representations of information from the user interface. It compares MVC with other layered architectures."),

-- Course 300009: Introduction to Data Engineering
    (27041, "Data Lifecycle and ETL Processes", 300009, 
    "https://wesmckinney.com/book/", 
    "Techniques for handling missing data, filtering outliers, and transforming data using the Pandas library. It covers the 'Transform' phase of ETL where raw data is converted into a usable format."),

-- Course 300010: Python for Data Science, AI & Development
    (27046, "Python Data Structures", 300010, 
    "https://docs.python.org/3/tutorial/datastructures.html", 
    "Official Python documentation on using built-in list, dictionary, and set data structures. It explains time complexity considerations and best practices for storing collections of data.");
    
-- 2. CHÈN DỮ LIỆU VÀO BẢNG QUIZ
INSERT INTO Quiz (ID, Module_Title, Course_ID, Passing_Score, Time_Limit, Max_Attempt)
VALUES
-- Course 300000: Neural Networks and Deep Learning
(27001, 'Introduction to Deep Learning', 300000, 7, '00:30:00', 3),

-- Course 300001: Improving Deep Neural Networks
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 8, '00:45:00', 3),

-- Course 300002: Structuring Machine Learning Projects (Không có câu hỏi trong dữ liệu gốc)
(27012, 'End-to-end Deep Learning', 300002, 6, '00:20:00', 5),

-- Course 300003: Convolutional Neural Networks
(27015, 'Foundations of Convolutional Neural Networks', 300003, 8, '01:00:00', 3),

-- Course 300004: Sequence Models (Không có câu hỏi trong dữ liệu gốc)
(27022, 'Sequence Models and Attention Mechanism', 300004, 7, '00:40:00', 4),

-- Course 300005: Foundations of Cybersecurity
(27025, 'The CISSP Eight Security Domains', 300005, 9, '01:30:00', 3),

-- Course 300006: Play It Safe: Manage Security Risks (Không có câu hỏi trong dữ liệu gốc)
(27029, 'Analyzing SIEM Data', 300006, 7, '00:50:00', 5),

-- Course 300007: Introduction to Software Engineering
(27032, 'Software Development Lifecycle (SDLC)', 300007, 5, '00:15:00', 5),

-- Course 300008: Software Design and Architecture Specialization (Không có câu hỏi trong dữ liệu gốc)
(27036, 'Object-Oriented Design Principles', 300008, 8, '01:15:00', 3),

-- Course 300009: Introduction to Data Engineering (Không có câu hỏi trong dữ liệu gốc)
(27043, 'Data Platforms and Pipelines', 300009, 7, '02:00:00', 4),

-- Course 300010: Python for Data Science, AI & Development
(27045, 'Python Basics and Data Types', 300010, 6, '00:25:00', 5),
(27049, 'Working with Libraries and APIs', 300010, 9, '03:00:00', 3); -- Final Exam


-- 3. CHÈN DỮ LIỆU VÀO BẢNG QUESTION
INSERT INTO Question (Quiz_ID, Q_Module_Title, Q_Course_ID, Question_ID, Question_Text, Question_Point, Q_Answer)
VALUES
-- Quiz 27001 (Introduction to Deep Learning) - 5 câu, mỗi câu 2 điểm = 10
(27001, 'Introduction to Deep Learning', 300000, 28000, 'What is the primary purpose of an activation function in a neural network?', 2.0, 'C'),
(27001, 'Introduction to Deep Learning', 300000, 28001, 'Which of the following is an example of a supervised learning problem?', 2.0,  'B'),
(27001, 'Introduction to Deep Learning', 300000, 28002, 'What happens if you initialize all weights to zero?', 2.0,  'A'),
(27001, 'Introduction to Deep Learning', 300000, 28003, 'Which activation function outputs a value between 0 and 1?', 2.0,  'E'),
(27001, 'Introduction to Deep Learning', 300000, 28004, 'What is the role of the loss function?', 2.0,  'D'),

-- Quiz 27008 (Hyperparameter Tuning...) - 5 câu, mỗi câu 2 điểm = 10
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28005, 'Why do we normalize inputs in a neural network?', 2.0,  'A'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28006, 'What is the main benefit of Batch Normalization?', 2.0,  'B'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28007, 'Which hyperparameter is usually tuned first?', 2.0,  'C'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28008, 'What is the purpose of Softmax regression?', 2.0,  'E'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28009, 'How does L2 regularization prevent overfitting?', 2.0,  'D'),

-- Quiz 27015 (Foundations of CNN) - 5 câu, mỗi câu 2 điểm = 10
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28010, 'What operation does a Convolutional layer perform?', 2.0,  'B'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28011, 'What is the purpose of ''Padding'' in CNN?', 2.0,  'C'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28012, 'What does ''Stride'' control?', 2.0,  'A'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28013, 'Which layer is typically used to reduce the spatial dimensions?', 2.0,  'D'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28014, 'Why are CNNs better for images than standard NN?', 2.0, 'B'),

-- Quiz 27025 (CISSP Domains) - 5 câu, mỗi câu 2 điểm = 10
(27025, 'The CISSP Eight Security Domains', 300005, 28015, 'What does the ''C'' in the CIA Triad stand for?', 2.0, 'A'),
(27025, 'The CISSP Eight Security Domains', 300005, 28016, 'Which domain covers the physical safety of assets?', 2.0,  'C'),
(27025, 'The CISSP Eight Security Domains', 300005, 28017, 'What is the principle of Least Privilege?', 2.0,  'B'),
(27025, 'The CISSP Eight Security Domains', 300005, 28018, 'Hashing is primarily used to ensure what?', 2.0,  'E'),
(27025, 'The CISSP Eight Security Domains', 300005, 28019, 'What is the main goal of a Disaster Recovery Plan?', 2.0,  'D'),

-- Quiz 27032 (SDLC) - 6 câu
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28020, 'Which comes first in the SDLC process?', 1.0,  'B'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28021, 'What is a key feature of the Agile methodology?', 2.0, 'C'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28022, 'What is the purpose of the Testing phase?', 2.0,  'D'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28023, 'Waterfall model is best described as...', 2.0,  'A'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28024, 'What happens during Deployment?', 1.0,  'E'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28025, 'What is ''Maintenance'' in SDLC?', 2.0,  'C'),

-- Quiz 27045 (Python Basics) - 5 câu, mỗi câu 2 điểm = 10
(27045, 'Python Basics and Data Types', 300010, 28026, 'Which of the following data types is immutable?', 2.0,  'B'),
(27045, 'Python Basics and Data Types', 300010, 28027, 'How do you define a function in Python?', 2.0,  'A'),
(27045, 'Python Basics and Data Types', 300010, 28028, 'What is the output of 3 ** 2?', 2.0,  'C'),
(27045, 'Python Basics and Data Types', 300010, 28029, 'How do you access a value in a dictionary?', 2.0,  'D'),
(27045, 'Python Basics and Data Types', 300010, 28030, 'Which keyword is used to import a library?', 2.0,  'A');


-- 4. CHÈN DỮ LIỆU VÀO BẢNG QUESTION_OPTION (Tạo các tùy chọn cho các câu hỏi)
INSERT INTO Question_Option (Quiz_ID, Q_Module_Title, Q_Course_ID, Question_ID, Option_Label, Option_Text)
VALUES
-- Question 28000 (Activation function purpose) - Answer: C
(27001, 'Introduction to Deep Learning', 300000, 28000, 'A', 'To introduce bias into the model.'),
(27001, 'Introduction to Deep Learning', 300000, 28000, 'B', 'To normalize the input data.'),
(27001, 'Introduction to Deep Learning', 300000, 28000, 'C', 'To introduce non-linearity, allowing the network to learn complex functions.'),
(27001, 'Introduction to Deep Learning', 300000, 28000, 'D', 'To calculate the gradients during backpropagation.'),
-- Question 28001 (Supervised learning) - Answer: B
(27001, 'Introduction to Deep Learning', 300000, 28001, 'A', 'Clustering customer segments.'),
(27001, 'Introduction to Deep Learning', 300000, 28001, 'B', 'Image Classification (predicting a label from an image).'),
(27001, 'Introduction to Deep Learning', 300000, 28001, 'C', 'Training an agent to play a game.'),
(27001, 'Introduction to Deep Learning', 300000, 28001, 'D', 'Dimensionality reduction using PCA.'),
-- Question 28002 (Initialize weights to zero) - Answer: A
(27001, 'Introduction to Deep Learning', 300000, 28002, 'A', 'All neurons in each layer will learn the same features (symmetry breaking issue).'),
(27001, 'Introduction to Deep Learning', 300000, 28002, 'B', 'Training will converge instantly.'),
(27001, 'Introduction to Deep Learning', 300000, 28002, 'C', 'The gradients will vanish to zero immediately.'),
(27001, 'Introduction to Deep Learning', 300000, 28002, 'D', 'It only affects the first iteration of training.'),
-- Question 28003 (Activation 0 to 1) - Answer: E
(27001, 'Introduction to Deep Learning', 300000, 28003, 'A', 'ReLU'),
(27001, 'Introduction to Deep Learning', 300000, 28003, 'B', 'Leaky ReLU'),
(27001, 'Introduction to Deep Learning', 300000, 28003, 'C', 'Tanh'),
(27001, 'Introduction to Deep Learning', 300000, 28003, 'D', 'GELU'),
(27001, 'Introduction to Deep Learning', 300000, 28003, 'E', 'Sigmoid'),
-- Question 28004 (Role of loss function) - Answer: D
(27001, 'Introduction to Deep Learning', 300000, 28004, 'A', 'To calculate the overall accuracy of the model.'),
(27001, 'Introduction to Deep Learning', 300000, 28004, 'B', 'To determine the best learning rate.'),
(27001, 'Introduction to Deep Learning', 300000, 28004, 'C', 'To perform regularization.'),
(27001, 'Introduction to Deep Learning', 300000, 28004, 'D', 'To quantify the error or difference between predicted and true values.'),

-- Question 28005 (Normalize inputs) - Answer: A
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28005, 'A', 'To speed up the convergence of gradient descent.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28005, 'B', 'To ensure all weights are positive.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28005, 'C', 'To reduce the number of features.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28005, 'D', 'To prevent overfitting.'),
-- Question 28006 (Batch Normalization benefit) - Answer: B
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28006, 'A', 'It replaces the need for any activation function.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28006, 'B', 'It allows the use of higher learning rates and makes weight initialization less critical.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28006, 'C', 'It acts as a primary form of data augmentation.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28006, 'D', 'It eliminates the need for a separate validation set.'),
-- Question 28007 (First hyperparameter tuned) - Answer: C
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28007, 'A', 'Number of hidden layers.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28007, 'B', 'Mini-batch size.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28007, 'C', 'Learning Rate.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28007, 'D', 'Activation function choice.'),
-- Question 28008 (Softmax purpose) - Answer: E
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28008, 'A', 'To convert outputs into a binary class prediction.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28008, 'B', 'To apply regularization to the last layer.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28008, 'C', 'To speed up model inference.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28008, 'D', 'To handle regression problems.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28008, 'E', 'To output probabilities for more than two classes (multi-class classification).'),
-- Question 28009 (L2 regularization) - Answer: D
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28009, 'A', 'By randomly dropping out neurons during training.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28009, 'B', 'By increasing the size of the training dataset.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28009, 'C', 'By making the model more complex.'),
(27008, 'Hyperparameter Tuning and Batch Normalization', 300001, 28009, 'D', 'By penalizing large weights, leading to smoother decision boundaries.'),

-- Question 28010 (Convolutional layer) - Answer: B
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28010, 'A', 'Fully-connected transformation of all inputs.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28010, 'B', 'Feature extraction via sliding a filter (kernel) over the input.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28010, 'C', 'Down-sampling the spatial dimensions.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28010, 'D', 'Normalizing the activations.'),
-- Question 28011 (Padding in CNN) - Answer: C
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28011, 'A', 'To discard irrelevant information from the input image.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28011, 'B', 'To increase the speed of the convolution operation.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28011, 'C', 'To preserve the spatial size of the input and ensure border pixels are used effectively.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28011, 'D', 'To increase the number of output channels.'),
-- Question 28012 (Stride control) - Answer: A
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28012, 'A', 'The number of pixels the filter moves at each step.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28012, 'B', 'The size (width and height) of the convolutional filter.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28012, 'C', 'The amount of zero-padding applied.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28012, 'D', 'The number of filters used.'),
-- Question 28013 (Reduce spatial dimensions) - Answer: D
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28013, 'A', 'Input Layer.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28013, 'B', 'Fully Connected Layer.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28013, 'C', 'Convolutional Layer.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28013, 'D', 'Pooling Layer (Max or Average Pooling).'),
-- Question 28014 (CNN vs Standard NN for images) - Answer: B
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28014, 'A', 'Standard NNs cannot handle high-dimensional data.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28014, 'B', 'CNNs exploit spatial locality and use parameter sharing (reduced number of parameters).'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28014, 'C', 'Standard NNs are only for sequential data.'),
(27015, 'Foundations of Convolutional Neural Networks', 300003, 28014, 'D', 'CNNs do not use activation functions.'),

-- Question 28015 (CIA Triad 'C') - Answer: A
(27025, 'The CISSP Eight Security Domains', 300005, 28015, 'A', 'Confidentiality.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28015, 'B', 'Compliance.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28015, 'C', 'Controls.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28015, 'D', 'Communication.'),
-- Question 28016 (Physical safety domain) - Answer: C
(27025, 'The CISSP Eight Security Domains', 300005, 28016, 'A', 'Security Operations.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28016, 'B', 'Asset Security.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28016, 'C', 'Security Architecture and Engineering (Physical Security).'),
(27025, 'The CISSP Eight Security Domains', 300005, 28016, 'D', 'Communication and Network Security.'),
-- Question 28017 (Least Privilege) - Answer: B
(27025, 'The CISSP Eight Security Domains', 300005, 28017, 'A', 'Every user should have administrator access.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28017, 'B', 'Users should only be granted the minimum permissions necessary to perform their job role.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28017, 'C', 'Granting access based on the time of day.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28017, 'D', 'The principle of granting access to everyone by default.'),
-- Question 28018 (Hashing purpose) - Answer: E
(27025, 'The CISSP Eight Security Domains', 300005, 28018, 'A', 'Confidentiality (hiding data).'),
(27025, 'The CISSP Eight Security Domains', 300005, 28018, 'B', 'Availability (ensuring data access).'),
(27025, 'The CISSP Eight Security Domains', 300005, 28018, 'C', 'Non-repudiation.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28018, 'D', 'Authentication.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28018, 'E', 'Integrity (detecting unauthorized modification).'),
-- Question 28019 (Disaster Recovery Plan goal) - Answer: D
(27025, 'The CISSP Eight Security Domains', 300005, 28019, 'A', 'Eliminating all security risks.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28019, 'B', 'Reducing the annual budget for security.'),
(27025, 'The CISSP Eight Security Domains', 300005, 28019, 'C', 'Maximizing the RTO (Recovery Time Objective).'),
(27025, 'The CISSP Eight Security Domains', 300005, 28019, 'D', 'Resuming critical business operations quickly after an event.'),

-- Question 28020 (First in SDLC) - Answer: B
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28020, 'A', 'Design.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28020, 'B', 'Planning (or Requirements Gathering).'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28020, 'C', 'Coding.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28020, 'D', 'Deployment.'),
-- Question 28021 (Agile key feature) - Answer: C
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28021, 'A', 'Strict, sequential phases (like Waterfall).'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28021, 'B', 'No customer collaboration is needed.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28021, 'C', 'Iterative, incremental development and responsiveness to change.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28021, 'D', 'Focus on comprehensive documentation over working software.'),
-- Question 28022 (Testing phase purpose) - Answer: D
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28022, 'A', 'Writing the user manual.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28022, 'B', 'Training the end-users.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28022, 'C', 'Defining the system architecture.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28022, 'D', 'Verifying the software meets requirements and identifying defects.'),
-- Question 28023 (Waterfall model description) - Answer: A
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28023, 'A', 'A linear, sequential flow where each phase must be completed before the next begins.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28023, 'B', 'A process focused on continuous feedback and rapid prototypes.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28023, 'C', 'A methodology where the entire system is built in one large release.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28023, 'D', 'A model best suited for projects with frequently changing requirements.'),
-- Question 28024 (Deployment phase) - Answer: E
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28024, 'A', 'Refining the design specifications.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28024, 'B', 'Identifying the necessary hardware.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28024, 'C', 'Unit testing the code modules.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28024, 'D', 'Fixing bugs found in integration testing.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28024, 'E', 'Making the finished software product available for users.'),
-- Question 28025 (Maintenance in SDLC) - Answer: C
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28025, 'A', 'The phase of gathering initial user requirements.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28025, 'B', 'Only fixing fatal bugs discovered within the first week of launch.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28025, 'C', 'Ongoing support, enhancements, corrections, and adaptations to the software post-release.'),
(27032, 'Software Development Lifecycle (SDLC)', 300007, 28025, 'D', 'Creating the database schema.'),

-- Question 28026 (Immutable data type Python) - Answer: B
(27045, 'Python Basics and Data Types', 300010, 28026, 'A', 'List.'),
(27045, 'Python Basics and Data Types', 300010, 28026, 'B', 'Tuple.'),
(27045, 'Python Basics and Data Types', 300010, 28026, 'C', 'Dictionary.'),
(27045, 'Python Basics and Data Types', 300010, 28026, 'D', 'Set.'),
-- Question 28027 (Define function Python) - Answer: A
(27045, 'Python Basics and Data Types', 300010, 28027, 'A', 'def.'),
(27045, 'Python Basics and Data Types', 300010, 28027, 'B', 'function.'),
(27045, 'Python Basics and Data Types', 300010, 28027, 'C', 'fn.'),
(27045, 'Python Basics and Data Types', 300010, 28027, 'D', 'define.'),
-- Question 28028 (3 ** 2) - Answer: C
(27045, 'Python Basics and Data Types', 300010, 28028, 'A', '6 (Multiplication).'),
(27045, 'Python Basics and Data Types', 300010, 28028, 'B', '8 (3 * 3 - 1).'),
(27045, 'Python Basics and Data Types', 300010, 28028, 'C', '9 (Exponentiation).'),
(27045, 'Python Basics and Data Types', 300010, 28028, 'D', '27 (3 ** 3).'),
-- Question 28029 (Access dictionary value) - Answer: D
(27045, 'Python Basics and Data Types', 300010, 28029, 'A', 'Using dot notation (e.g., dict.key).'),
(27045, 'Python Basics and Data Types', 300010, 28029, 'B', 'Using index slicing (e.g., dict[0]).'),
(27045, 'Python Basics and Data Types', 300010, 28029, 'C', 'Using the get_value() method.'),
(27045, 'Python Basics and Data Types', 300010, 28029, 'D', 'Using square brackets with the key (e.g., dict["key"]).'),
-- Question 28030 (Import keyword) - Answer: A
(27045, 'Python Basics and Data Types', 300010, 28030, 'A', 'import.'),
(27045, 'Python Basics and Data Types', 300010, 28030, 'B', 'include.'),
(27045, 'Python Basics and Data Types', 300010, 28030, 'C', 'using.'),
(27045, 'Python Basics and Data Types', 300010, 28030, 'D', 'require.');





INSERT INTO Make_Progress 
VALUES 
    -- Quiz 27001: Giới hạn 30 phút (00:30:00) -> Điền 28 phút
    (1, 400000, 27001, "Introduction to Deep Learning", 300000, "00:28:15", 9.0, "00:30:00"),

    -- Quiz 27001: Giới hạn 30 phút (00:30:00) -> Điền 25 phút
    (2, 400015, 27001, "Introduction to Deep Learning", 300000, "00:25:10", 8.5, "00:30:00"),

    -- Quiz 27008: Giới hạn 45 phút (00:45:00) -> Điền 40 phút
    (3, 400001, 27008, "Hyperparameter Tuning and Batch Normalization", 300001, "00:40:05", 8.0, "00:45:00"),

    -- Quiz 27008: Giới hạn 45 phút (00:45:00) -> Điền 42 phút
    (4, 400047, 27008, "Hyperparameter Tuning and Batch Normalization", 300001, "00:42:00", 9.5, "00:45:00"),

    -- Quiz 27025: Giới hạn 1 tiếng 30 phút (01:30:00) -> Điền 1 tiếng 15 phút
    (5, 400037, 27025, "The CISSP Eight Security Domains", 300005, "01:15:00", 10.0, "01:30:00"),

    -- Quiz 27015: Giới hạn 1 tiếng (01:00:00) -> Điền 55 phút
    (6, 400073, 27015, "Foundations of Convolutional Neural Networks", 300003, "00:55:30", 7.5, "01:00:00"),

    -- Quiz 27029: Giới hạn 50 phút (00:50:00) -> Điền 48 phút
    (7, 400098, 27029, "Analyzing SIEM Data", 300006, "00:48:00", 8.0, "00:50:00"),

    -- Quiz 27049: Giới hạn 3 tiếng (03:00:00) -> Điền 2 tiếng 45 phút
    (8, 400154, 27049, "Working with Libraries and APIs", 300010, "02:45:45", 9.0, "03:00:00"),

    -- Quiz 27043: Giới hạn 2 tiếng (02:00:00) -> Điền 1 tiếng 50 phút
    (9, 400165, 27043, "Data Platforms and Pipelines", 300009, "01:50:05", 6.0, "02:00:00"),

    -- Quiz 27036: Giới hạn 1 tiếng 15 phút (01:15:00) -> Điền 1 tiếng 10 phút
    (10, 400007, 27036, "Object-Oriented Design Principles", 300008, "01:10:30", 9.0, "01:15:00");
    
