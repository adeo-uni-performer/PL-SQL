-- Task 9
-- Write a function that receives the identifier of a wine and that returns a string containing the characteristics of this wine.

CREATE OR REPLACE FUNCTION get_wine_info (wine_identifier varchar)
  RETURN varchar2 IS
  wine_info varchar2(50);
  vintage varchar(10);
  annee number(4);
  degre number(4,1);
BEGIN
  SELECT vintage, annee, degre INTO vintage, annee, degre
   FROM Wine
    WHERE numwin = wine_identifier;
  ----------------------------------------------------------
  wine_info := vintage || ' ' || annee || ' ' || degre;
  
  return wine_info;
  
END;


-- TEST
/*
SELECT * from wine;

DECLARE
  wine_info varchar2(50);
  wine_identifier varchar(5);
BEGIN
  wine_identifier := 'v1';
  wine_info := get_wine_info (wine_identifier);
 
  dbms_output.put_line (wine_identifier || ': ' || wine_info);
END;

*/