-- Task 7 and Task 8
-- Procedure to create producer is exist

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
        WHEN nameIsNull THEN
          DBMS_OUTPUT.PUT_LINE('Enter NAME!!!');
        WHEN surnameIsNull THEN
          DBMS_OUTPUT.PUT_LINE('Enter SURNAME!!!');
        WHEN regionIsNull THEN
          DBMS_OUTPUT.PUT_LINE('Enter REGION!!!');
        WHEN OTHERS THEN  -- handles all other errors
          DBMS_OUTPUT.PUT_LINE('Some other kind of error occurred.');
END;
