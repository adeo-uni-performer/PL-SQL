-- Task 6
-- Trigger that updates the Total quantity in Producer table (qtetot) before each updating in the Crops table

DROP TRIGGER upd_qtetot_ins_crop;
CREATE OR REPLACE TRIGGER upd_qtetot_upd_crop
BEFORE INSERT OR UPDATE OR DELETE ON Crop
FOR EACH ROW

BEGIN
  IF INSERTING THEN
    UPDATE Producer SET qtetot = qtetot + :new.quantity WHERE numprod = :new.numprod;
  ELSIF UPDATING THEN
    UPDATE Producer SET qtetot = (:new.quantity - :old.quantity + qtetot) WHERE numprod = :new.numprod;
  ELSE
    UPDATE Producer SET qtetot = qtetot - :old.quantity WHERE numprod = :old.numprod;
  END IF;
END;




/*
-- TEST INSERT
-- Check old total quantity of producer
SELECT qtetot from producer where NUMPROD = 'p2';

-- Insert new row in Crop
INSERT into Crop VALUES ('v2','p2',111);

-- Check new total quantity of producer
SELECT qtetot from producer where NUMPROD = 'p2';

--=====================================================================

--TEST UPDATE
select quantity from crop where numprod = 'p1' and numwin = 'v1';
select qtetot from producer where numprod = 'p1';

update Crop set quantity = 99 where numprod = 'p1' and numwin = 'v1';


select quantity from crop where numprod = 'p1' and numwin = 'v1';
select qtetot from producer where numprod = 'p1';

--=====================================================================

--TEST DELETE
-- Check old total quantity of producer
SELECT * from crop;
SELECT qtetot from producer where NUMPROD = 'p1';

-- Delete 1 row
DELETE from crop where NUMPROD = 'p1' and NUMWIN = 'v1';

-- Check new total quantity of producer
SELECT * from crop;
SELECT qtetot from producer where NUMPROD = 'p1';

*/