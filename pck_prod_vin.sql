CREATE OR REPLACE PACKAGE pck_prod_vin IS
  -- Task 7 and 8 :
  PROCEDURE pr_create_producer (nameIn varchar, surnameIn varchar, region varchar);
  -- Task 9: 
  FUNCTION get_wine_info (wine_id varchar) RETURN varchar2;
  -- task 10:
  PROCEDURE getProdInfo (nameIn varchar, surnameIn varchar); 
END pck_prod_vin;
/


CREATE OR REPLACE PACKAGE BODY pck_prod_vin AS
  --=================== task 7 and 8: ===============================================
  PROCEDURE pr_create_producer 
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

  --=================== task 9: ===============================================
  FUNCTION get_wine_info (wine_id varchar)
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
  
  --=================== task 10: ===============================================
  PROCEDURE getProdInfo (nameIn varchar, surnameIn varchar)  IS
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
END pck_prod_vin;
