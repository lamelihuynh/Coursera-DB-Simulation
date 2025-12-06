-- ============================
-- 1. THREAD MẪU (HỢP LỆ)
-- ============================

INSERT INTO Thread (ID, Title, Content)
VALUES 
    (25005, 'Setup OPNSense', 'Thread about setting up OPNSense'),
    (25006, 'Web blocking', 'Thread about blocking websites'),
    (25007, 'Deep learning model', 'Thread about building DL model'),
    (25008, 'Component design', 'Thread about components'),
    (25009, 'Data import', 'Thread about importing data');


-- ============================
-- 2. REPLY GỐC (CHA) – HỢP LỆ
-- ============================

INSERT INTO Reply (ID, Content, Reply_date, Reply_time, Thread_ID)
VALUES 
    (250005, 'Answer for setup OPNSense', 
        '2023-02-01', '2023-02-01 09:00:00', 25005),

    (250006, 'Answer for web-block', 
        '2023-05-12', '2023-05-12 09:01:00', 25006),

    (250007, 'Answer for building a deep learning model', 
        '2023-12-23', '2023-12-23 09:02:00', 25007),

    (250008, 'Answer for component', 
        '2023-11-14', '2023-11-14 09:03:00', 25008),

    (250009, 'Answer for data importation', 
        '2023-09-19', '2023-09-19 09:04:00', 25009);


-- ============================
-- 3. REPLIES (CON) – HỢP LỆ
-- ============================

INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260005, 'Check Network Adapter, check IP, check HTTPS method', 
        '2023-02-03', '2023-02-03 09:30:00', 25005, 250005),

    (260006, 'Check SSL, check Transparent mode', 
        '2023-05-14', '2023-05-14 09:31:00', 25006, 250006),

    (260007, 'Learn math (linear algebra, probability, statistic)...', 
        '2023-12-27', '2023-12-27 09:32:00', 25007, 250007),

    (260008, 'Group classes/interfaces (API, fetch, ...) into components', 
        '2023-11-15', '2023-11-15 09:33:00', 25008, 250008),

    (260009, 'For CSV/Excel, use bulk load commands...', 
        '2023-09-20', '2023-09-20 09:34:00', 25009, 250009);



-- =====================================================================
-- ❌ TESTCASE VI PHẠM TRIGGER (PHẢI BỊ CHẶN)
-- =====================================================================


-- 1) CHILD DATE < PARENT DATE
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260015, 'INVALID: child date < parent date', 
        '2023-01-30', '2023-01-30 10:00:00', 25005, 250005);
-- EXPECT ERROR


-- 2) SAME DATE BUT EARLIER TIME
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260016, 'INVALID: same date but earlier time', 
        '2023-05-12', '2023-05-12 09:00:00', 25006, 250006);
-- EXPECT ERROR


-- 3) INSERT HỢP LỆ → UPDATE THÀNH VI PHẠM

-- 3.1 – INSERT HỢP LỆ
INSERT INTO Replies (ID, Content, Reply_date, Reply_time, Thread_ID, Replied_ID)
VALUES 
    (260017, 'Valid child first, then we break it by UPDATE', 
        '2023-05-13', '2023-05-13 10:00:00', 25006, 250006);
-- EXPECT OK

-- 3.2 – UPDATE VI PHẠM (TIME < PARENT)
UPDATE Replies
SET Reply_date = '2023-05-12',
    Reply_time = '2023-05-12 08:00:00'
WHERE ID = 260017;
-- EXPECT ERROR



-- =====================================================================
-- 🟦 TESTCASE UPDATE REPLY (CHA)
-- =====================================================================

-- ✔ HỢP LỆ (cha vẫn trước con)
UPDATE Reply
SET Reply_date = '2023-02-02',
    Reply_time = '2023-02-02 10:00:00'
WHERE ID = 250005;
-- EXPECT OK


-- ❌ VI PHẠM (cha trễ hơn con)
UPDATE Reply
SET Reply_date = '2023-11-16',
    Reply_time = '2023-11-16 08:00:00'
WHERE ID = 250008;
-- EXPECT ERROR