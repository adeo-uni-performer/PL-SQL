-- Task 10
/*
 * Write procedure named reporting_crops that receives the name and surname of a producer call the previous function and display:
 * - Its production region and the total quantity produced
 * - An array of crops ordered by type of wine
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
                       );
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
 
END;  
  
  