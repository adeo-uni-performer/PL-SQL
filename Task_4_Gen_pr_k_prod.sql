-- Task #4
-- Generate automatically primary key for table Producer (using sequence)


CREATE SEQUENCE seq_prod START WITH 6;
CREATE OR REPLACE TRIGGER trg_producer_gen_key
BEFORE INSERT ON Producer
FOR EACH ROW
BEGIN
	SELECT seq_prod.nextval INTO :new.numprod FROM dual;
	:new.numprod := 'v' || :new.numprod;
EXCEPTION
	WHEN OTHERS THEN
		null;
END;



/*
--TEST
-- Check last key :
SELECT max(NUMPROD) FROM Producer;

-- Check last row:
SELECT * FROM Producer
WHERE NUMPROD = (SELECT max(NUMPROD) FROM Producer);

-- Insert new row :
INSERT into Producer (NAME, SURNAME, region, qtetot) VALUES ('Arthur','Skobnikoff','Cergy',100500);

-- Check key of last insertion:
SELECT max(NUMPROD) FROM Producer;

-- Check last insertion:
SELECT * FROM Producer
WHERE NUMPROD = (SELECT max(NUMPROD) FROM Producer);

-- Delete last insertion
DELETE FROM Producer WHERE NUMPROD = (SELECT max(NUMPROD) FROM Producer);

*/