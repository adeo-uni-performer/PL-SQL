-- Task 5
-- Trigger that updates the Total quantity in Producer table (qtetot) before each inserting in the Crops table

DROP TRIGGER upd_qtetot_upd_crop;
CREATE OR REPLACE TRIGGER upd_qtetot_ins_crop
BEFORE INSERT
ON Crop
FOR EACH ROW

BEGIN
  UPDATE Producer SET qtetot = qtetot + :new.quantity WHERE numprod = :new.numprod;
END;

/*
-- TEST
-- Check old total quantity of producer
SELECT qtetot from producer where NUMPROD = 'p2';

-- Insert new row in Crop
INSERT into Crop VALUES ('v2','p2',111);

-- Check new total quantity of producer
SELECT qtetot from producer where NUMPROD = 'p2';

-- Delete last insertion
DELETE from crop where NUMPROD = 'p2' and NUMWIN = 'v2';

-- Update producer's total quantity to old value 
UPDATE Producer SET qtetot = 100 WHERE numprod = 'p2';
*/