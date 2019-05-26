--CREATE OR REPLACE PROCEDURE afiseaza_parcari
--(c_parcari OUT SYS_REFCURSOR)
--AS
--BEGIN
--  open c_parcari for
--  SELECT * FROM parcari;
--END afiseaza_parcari;
SET SERVEROUTPUT ON;
DECLARE
  c_parcari SYS_REFCURSOR;
  v_std_linie c_parcari%ROWTYPE;
BEGIN
  afiseaza_parcari(c_parcari);
  FOR v_std_linie IN c_parcari LOOP
    DBMS_OUTPUT.PUT_LINE(v_std_linie.oras||' '||v_std_linie.adresa||' '||v_std_linie.numar_telefon);
  END LOOP;
  CLOSE c_parcari;
END;