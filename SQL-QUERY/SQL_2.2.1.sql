DELIMITER $$

CREATE TRIGGER trg_replies_check_time_ins
BEFORE INSERT ON Replies
FOR EACH ROW
BEGIN
    DECLARE v_parent_date DATE;
    DECLARE v_parent_time DATETIME;

    -- Lấy ngày và thời điểm của reply gốc
    SELECT Reply_date, Reply_time
    INTO v_parent_date, v_parent_time
    FROM Reply
    WHERE ID = NEW.Replied_ID;

    IF v_parent_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Parent reply not found for given Replied_ID';
    END IF;

    -- 1) Ngày con < ngày cha  → lỗi
    IF NEW.Reply_date < v_parent_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Replies cannot occur earlier than their parent reply.';
    END IF;

    -- 2) Nếu cùng ngày thì giờ con < giờ cha → lỗi
    IF NEW.Reply_date = v_parent_date
       AND NEW.Reply_time < v_parent_time THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Replies cannot occur earlier than their parent reply.';
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_replies_check_time_upd
BEFORE UPDATE ON Replies
FOR EACH ROW
BEGIN
    DECLARE v_parent_date DATE;
    DECLARE v_parent_time DATETIME;

    -- Chỉ cần check khi có thay đổi Replied_ID hoặc thời gian/ngày
    IF NEW.Replied_ID <> OLD.Replied_ID
       OR NEW.Reply_date <> OLD.Reply_date
       OR NEW.Reply_time <> OLD.Reply_time THEN

        SELECT Reply_date, Reply_time
        INTO v_parent_date, v_parent_time
        FROM Reply
        WHERE ID = NEW.Replied_ID;

        IF v_parent_date IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Parent reply not found for given Replied_ID';
        END IF;

        IF NEW.Reply_date < v_parent_date THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Replies cannot occur earlier than their parent reply.';
        END IF;

        IF NEW.Reply_date = v_parent_date
           AND NEW.Reply_time < v_parent_time THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Replies cannot occur earlier than their parent reply.';
        END IF;

    END IF;
END$$

DELIMITER ;
