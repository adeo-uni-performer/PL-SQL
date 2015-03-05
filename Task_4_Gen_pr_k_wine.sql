-- Task #4
-- Generate automatically primary key for table Wine (using sequence)

SET SERVEROUTPUT ON;
DROP SEQUENCE num_wine_seq;
CREATE SEQUENCE num_wine_seq START WITH 4;

CREATE OR REPLACE TRIGGER gen_pr_k_wine
  BEFORE INSERT
  ON Wine
  FOR EACH ROW
  
DECLARE
  new_digit NUMBER;
  new_numwin varchar(5);
BEGIN
  new_digit := num_wine_seq.nextval;
  new_numwin := 'v' || TO_CHAR(new_digit);
  :new.numwin := new_numwin;
  DBMS_output.put_line('Insert:  numwin['||TO_CHAR(:new.numwin)|| ']   vintage[' || TO_CHAR(:new.vintage)|| ']   annee[' || TO_CHAR(:new.annee)|| ']');
END;  


/*
--TEST
-- Check last key :
SELECT max(NUMWIN) FROM Wine;

-- Check last row:
SELECT * FROM Wine
WHERE NUMWIN = (SELECT max(NUMWIN) FROM Wine);

-- Insert new row :
INSERT into Wine (VINTAGE,ANNEE,DEGRE) VALUES ('c1',1900,15);

-- Check key of last insertion:
SELECT max(NUMWIN) FROM Wine;

-- Check last insertion:
SELECT * FROM Wine
WHERE NUMWIN = (SELECT max(NUMWIN) FROM Wine);

-- Delete last insertion
DELETE FROM Wine WHERE NUMWIN = (SELECT max(NUMWIN) FROM Wine);

*/