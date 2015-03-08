--===================================-- Task #4 --=========================================--
-- For each Producer tables and wine Table write a trigger to generate automatically primary key (using a sequence)

-- Generate automatically primary key for table Wine
DROP SEQUENCE seq_wine;
CREATE SEQUENCE seq_wine START WITH 4;

CREATE OR REPLACE TRIGGER trg_wine_gen_key
BEFORE INSERT ON Wine
FOR EACH ROW
BEGIN
	SELECT seq_wine.nextval INTO :new.numwin FROM dual;
	:new.numwin := 'v' || :new.numwin;
EXCEPTION
	WHEN OTHERS THEN
		null;
END;
/


-- Generate automatically primary key for table Producer
DROP SEQUENCE seq_prod;
CREATE SEQUENCE seq_prod START WITH 5;

CREATE OR REPLACE TRIGGER trg_producer_gen_key
BEFORE INSERT ON Producer
FOR EACH ROW
BEGIN
	SELECT seq_prod.nextval INTO :new.numprod FROM dual;
	:new.numprod := 'p' || :new.numprod;
EXCEPTION
	WHEN OTHERS THEN
		null;
END;
/


--===================================-- Task #5 --=========================================--
-- Write in PL/SQL a trigger (trigger) to update the Total quantity attribute (qtetot) to each inserting a row in the Crops table

CREATE OR REPLACE TRIGGER upd_qtetot_ins_crop
BEFORE INSERT
ON Crop
FOR EACH ROW

BEGIN
  UPDATE Producer SET qtetot = qtetot + :new.quantity WHERE numprod = :new.numprod;
END;
/

--===================================-- Task #6 --=========================================--
-- Write in PL/SQL a trigger (trigger) to update the Total quantity attribute (qtetot) to each updating a row in the harvest table

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
/

--===================================-- Task #7 & #8 --=========================================--
-- Write the procedure for creating a new producer. This new producer will have a couple (name, surtname) different from all existing couples. 
-- This procedure will display a message to indicate whether the operation was successful.
-- Resume the previous question by dealing with errors RAISE_APPLICATION_ERROR function. 

CREATE OR REPLACE PROCEDURE pr_create_producer 
(nameIn varchar, surnameIn varchar, region varchar)
AS
  temp_name Producer.name%TYPE;
  temp_surname Producer.surname%TYPE;
  nameIsNull EXCEPTION;
  surnameIsNull EXCEPTION;
  regionIsNull EXCEPTION;
BEGIN
    -- Define custom exceptions
    IF (nameIn is NULL) THEN
      RAISE nameIsNull;
    ELSIF (surnameIn is NULL) THEN
      RAISE surnameIsNull;
    ELSIF (region is NULL) THEN
      RAISE regionIsNull;
    END IF;
    -------------
    
    SELECT name, surname INTO temp_name, temp_surname
        FROM Producer
          WHERE name = nameIn
          AND surname = surnameIn;
    dbms_output.put_line('Such producer already exists!!!');
    
EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          INSERT INTO Producer (name, surname, region) VALUES (nameIn, surnameIn, region);
          DBMS_OUTPUT.PUT_LINE('New producer is created successfully');
        WHEN nameIsNull THEN
          DBMS_OUTPUT.PUT_LINE('Enter NAME!!!');
        WHEN surnameIsNull THEN
          DBMS_OUTPUT.PUT_LINE('Enter SURNAME!!!');
        WHEN regionIsNull THEN
          DBMS_OUTPUT.PUT_LINE('Enter REGION!!!');
        WHEN OTHERS THEN  -- handles all other errors
          DBMS_OUTPUT.PUT_LINE('Some other kind of error occurred.');
END;
/

--===================================-- Task #9 --=========================================--
-- Write a function that receives the identifier of a wine and that returns a string containing the characteristics of this wine.

CREATE OR REPLACE FUNCTION get_wine_info (wine_id varchar)
  RETURN varchar2 IS
  wine_info varchar2(50);
  vintage varchar(10);
  annee number(4);
  degre number(4,1);
  message varchar2(50);
  myException EXCEPTION;
BEGIN
  SELECT vintage, annee, degre INTO vintage, annee, degre
   FROM Wine
    WHERE numwin = wine_id;
  ----------------------------------------------------------
  wine_info := vintage || ' ' || annee || ' ' || degre;
  
  RETURN wine_info;
	
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		message := 'Wine with id "' || wine_id || '" does not exist';
    RETURN message;
	WHEN OTHERS THEN
    message := 'Oups... there is a problem here';
    RETURN message;
END;
/

--===================================-- Task #10 --=========================================--
/*
Write procedure named reporting_crops that receives the name and surname of a producer call the previous function and display:
- Its production region and the total quantity produced
- An array of crops ordered by type of wine
*/

CREATE OR REPLACE PROCEDURE getProdInfo (nameIn varchar, surnameIn varchar)  IS
  QUANTITY Producer.qtetot%TYPE;
  REGION Producer.region%TYPE;
  prod_name Producer.name%TYPE;
  prod_surname Producer.surname%TYPE;
  -----------------------------------
  NUMWIN CROP.NUMWIN%TYPE;
  QUANTITY_per_wine CROP.QUANTITY%TYPE;
  -----------------------------------
  CURSOR producer_crops IS
    SELECT NUMWIN, QUANTITY 
     FROM CROP
      WHERE NUMPROD = (SELECT numprod
                        FROM Producer
                         WHERE NAME = prod_name
                          AND SURNAME = prod_surname
                       )
      ORDER BY NUMWIN;
--=========================================================
BEGIN
  prod_name := nameIn;
  prod_surname := surnameIn;
  ---------------------------------
  SELECT qtetot, region INTO QUANTITY, REGION
         FROM Producer
          WHERE NAME = prod_name
           AND SURNAME = prod_surname;
      ----------------------------
      dbms_output.put_line('Total quantity produced: '||QUANTITY);
      dbms_output.put_line('Region: '||REGION);
      ------------------------------------
      dbms_output.put_line ('=== Producer''s crops ===');
      dbms_output.put_line ('NUMWIN '|| 'QUANTITY');
      
      OPEN producer_crops;
      LOOP
        FETCH producer_crops INTO NUMWIN, QUANTITY_per_wine;
        EXIT WHEN producer_crops%NOTFOUND;
        dbms_output.put_line ('  '||NUMWIN|| '     '|| QUANTITY_per_wine);
      END LOOP;
      CLOSE producer_crops;
      
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line(nameIn || ' ' || surnameIn || ' does not exist in DB');
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('Oups... there is a problem here');
 
END;  
/