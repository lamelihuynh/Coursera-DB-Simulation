-- TESTCASE HỢP LỆ

-- 1. Thread mẫu
INSERT INTO Thread (ID, Title, Content)
VALUES 
    (25000, 'Setup OPNSense', 'Thread about setting up OPNSense'),
    (25001, 'Web blocking', 'Thread about blocking websites'),
    (25002, 'Deep learning model', 'Thread about building DL model'),
    (25003, 'Component design', 'Thread about components'),
    (25004, 'Data import', 'Thread about importing data');

-- 2. Reply gốc (cha) – TẤT CẢ HỢP LỆ
INSERT INTO Reply (ID, Content, Reply_date, Reply_time, Thread_ID)
VALUES 
    (250000, 'Answer for setup OPNSense', 
        '2023-02-01', '2023-02-01 09:00:00', 25000),
    (250001, 'Answer for web-block', 
        '2023-05-12', '2023-05-12 09:01:00', 25001),
    (250002, 'Answer for building a deep learning model', 
        '2023-12-23', '2023-12-23 09:02:00', 25002),
    (250003, 'Answer for component', 
        '2023-11-14', '2023-11-14 09:03:00', 25003),
    (250004, 'Answer for data importation', 
        '2023-09-19', '2023-09-19 09:04:00', 25004);

-- 3. Replies (con) – TẤT CẢ HỢP LỆ, dùng để demo trigger PASS
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260000, 'Check Network Adapter, check IP, check HTTPS method', 
        '2023-02-03', '2023-02-03 09:30:00', 25000, 250000),

    (260001, 'Check SSL, check Transparent mode', 
        '2023-05-14', '2023-05-14 09:31:00', 25001, 250001),

    (260002, 'Learn math (linear algebra, probability, statistic) then work on conv layers, activations,...', 
        '2023-12-27', '2023-12-27 09:32:00', 25002, 250002),

    (260003, 'Group classes/interfaces (API, fetch, ...) into components. Good luck!', 
        '2023-11-15', '2023-11-15 09:33:00', 25003, 250003),

    (260004, 'For CSV/Excel, use bulk load commands instead of inserting each row.', 
        '2023-09-20', '2023-09-20 09:34:00', 25004, 250004);
        
-- TESTCASE VI PHẠM TRIGGER

-- Cha 250000: 2023-02-01 09:00:00
-- Con cố tình ghi lùi ngày 2023-01-30 -> phải bị trigger chặn
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260010, 'INVALID: child date < parent date', 
        '2023-01-30', '2023-01-30 10:00:00', 25000, 250000);
-- EXPECT: ERROR từ trigger (Replies cannot occur earlier than their parent reply.)

-- Cha 250001: 2023-05-12 09:01:00
-- Con cùng ngày nhưng giờ 09:00:00 < 09:01:00 -> phải FAIL
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260011, 'INVALID: same date but earlier time', 
        '2023-05-12', '2023-05-12 09:00:00', 25001, 250001);
-- EXPECT: ERROR từ trigger (Replies cannot occur earlier than their parent reply.)

-- Bước 1: tạo 1 reply con hợp lệ
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260012, 'Valid child first, then we break it by UPDATE', 
        '2023-05-13', '2023-05-13 10:00:00', 25001, 250001);
-- EXPECT: OK

-- Bước 2: cố tình UPDATE cho nó quay ngược về trước cha
UPDATE Replies
SET Reply_date = '2023-05-12',
    Reply_time = '2023-05-12 08:00:00'
WHERE ID = 260012;
-- EXPECT: ERROR từ trigger BEFORE UPDATE
