-- TEST
SET SERVEROUTPUT ON

--===================================-- Task #4 --=========================================--

-- Generate automatically primary key for table Producer (using sequence)
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


-- Generate automatically primary key for table Wine (using sequence)
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


--===================================-- Task #5 --=========================================--
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

--===================================-- Task #6 --=========================================--
-- TEST INSERT
-- Check old total quantity of producer
SELECT qtetot from producer where NUMPROD = 'p2';
-- Insert new row in Crop
INSERT into Crop VALUES ('v2','p2',111);
-- Check new total quantity of producer
SELECT qtetot from producer where NUMPROD = 'p2';

--TEST UPDATE
select quantity from crop where numprod = 'p1' and numwin = 'v1';
select qtetot from producer where numprod = 'p1';
update Crop set quantity = 99 where numprod = 'p1' and numwin = 'v1';
select quantity from crop where numprod = 'p1' and numwin = 'v1';
select qtetot from producer where numprod = 'p1';

--TEST DELETE
-- Check old total quantity of producer
SELECT * from crop;
SELECT qtetot from producer where NUMPROD = 'p1';
-- Delete 1 row
DELETE from crop where NUMPROD = 'p1' and NUMWIN = 'v1';
-- Check new total quantity of producer
SELECT * from crop;
SELECT qtetot from producer where NUMPROD = 'p1';


--===================================-- Task #7 & #8 --=========================================--
BEGIN
  pr_create_producer ('Martin', 'Luter', 'Cuba');  -- new producer
  pr_create_producer ('Bob', 'Marley', 'Cuba');  -- already existing producer
  pr_create_producer (null, 'Marley', 'Cuba');  -- missing name
  pr_create_producer ('Bob', null, 'Cuba');  -- missing surname
  pr_create_producer ('Bob', 'Marley', null);  -- missing region
END;

--===================================-- Task #9 --=========================================--
SELECT * from wine;

DECLARE
  wine_info varchar2(50);
BEGIN
  wine_info := get_wine_info ('v1'); -- exists in DB
  dbms_output.put_line (wine_info);
  
  wine_info := get_wine_info ('blah'); -- does not exist in DB
  dbms_output.put_line (wine_info);
END;

--===================================-- Task #10 --=========================================--
SELECT * from Producer;
SELECT NUMWIN, QUANTITY 
     FROM CROP
      WHERE NUMPROD = (SELECT numprod
                        FROM Producer
                         WHERE NAME = 'Rotchild' 
                         AND SURNAME = 'Skobnikoff'
                       )
      ORDER BY NUMWIN;


BEGIN
 dbms_output.put_line('========================');
 getProdInfo ('Rotchild', 'Skobnikoff');
 getProdInfo ('My', 'Name');
END;