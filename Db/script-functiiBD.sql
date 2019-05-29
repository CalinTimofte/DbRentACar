--Afisare parcari:
CREATE OR REPLACE PROCEDURE afiseaza_parcari
(c_parcari OUT SYS_REFCURSOR)
AS
BEGIN
  open c_parcari for
  SELECT * FROM parcari;
END afiseaza_parcari;

--Inregistrare utilizator:
CREATE OR REPLACE Function register_user
(v_username clienti.username%TYPE, v_nume clienti.nume%TYPE, v_prenume clienti.prenume%TYPE, v_numar_telefon clienti.numar_telefon%TYPE, v_email clienti.email%TYPE, v_parola clienti.parola%TYPE, v_numar_permis clienti.numar_permis%TYPE)
return Integer
AS
v_client_id clienti.id_client%TYPE;
bad_input exception;
  PRAGMA EXCEPTION_INIT( bad_input , -20001);
BEGIN
  SELECT MAX(id_client)+1 INTO v_client_id FROM clienti;
  IF ( (TRIM(v_client_id) = REPLACE(TRIM(v_client_id), ' ', '')) AND (TRIM(v_username) = REPLACE(TRIM(v_username), ' ', '')) AND (TRIM(v_nume)= REPLACE(TRIM(v_nume), ' ', '')) AND (TRIM(v_prenume)= REPLACE(TRIM(v_prenume), ' ', '')) AND (TRIM(v_numar_telefon)= REPLACE(TRIM(v_numar_telefon), ' ', '')) AND (TRIM(v_email)= REPLACE(TRIM(v_email), ' ', '')) AND (TRIM(v_parola)= REPLACE(TRIM(v_parola), ' ', '')) AND (TRIM(v_numar_permis)= REPLACE(TRIM(v_numar_permis), ' ', ''))) THEN
    INSERT INTO clienti
    (id_client, username, nume, prenume, numar_telefon, email, parola, numar_permis)
    VALUES
    (v_client_id, v_username, v_nume, v_prenume, v_numar_telefon, v_email, v_parola, v_numar_permis);
    COMMIT;
    Return 1;
  ELSE
    raise bad_input;
  END IF;
EXCEPTION
WHEN bad_input THEN
REturn 0;
END register_user;


--Acordare nota masina:
CREATE OR REPLACE PROCEDURE notare_masina
(v_id_masina masini.id_masina%TYPE, v_nota masini.nota_clienti%TYPE)
AS
BEGIN
  UPDATE masini
  SET nota_clienti = (nota_clienti*numar_note + v_nota)/(numar_note + 1),
      numar_note = numar_note + 1
  WHERE id_masina=v_id_masina;
END notare_masina;

--Afisare informatii profil utilizator:
CREATE OR REPLACE PROCEDURE profil_utilizator
(v_id_user clienti.id_client%TYPE, v_username OUT clienti.username%TYPE, v_nume OUT clienti.nume%TYPE, v_prenume OUT clienti.prenume%TYPE, v_numar_telefon OUT clienti.numar_telefon%TYPE, v_email OUT clienti.email%TYPE)
AS
v_record_count NUMBER := 0;
BEGIN
  SELECT NVL(COUNT(*), 0) INTO v_record_count FROM clienti WHERE v_id_user = id_client; 
  IF (v_record_count = 1)
    THEN SELECT username, nume, prenume, numar_telefon, email INTO v_username, v_nume, v_prenume, v_numar_telefon, v_email FROM clienti WHERE v_id_user = id_client;
--    ELSE error
  END IF;
END profil_utilizator;

--Login user:
CREATE OR REPLACE PROCEDURE login_user
(v_username clienti.username%TYPE, v_parola clienti.parola%TYPE, v_id_client OUT clienti.id_client%TYPE)
AS
v_record_count_user NUMBER := 0;
v_record_count_istoric NUMBER := 0;
v_data_conectare istoric.data_conectare%TYPE := sysdate();
v_data_deconectare istoric.data_deconectare%TYPE := NULL;
BEGIN
  SELECT NVL(COUNT(*), 0) INTO v_record_count_user FROM clienti WHERE (v_username = username) AND (v_parola = parola);
  IF (v_record_count_user = 1)
    THEN  
      SELECT id_client INTO v_id_client FROM clienti WHERE (v_username = username) AND (v_parola = parola);
      SELECT MAX(id_istoric)+1 INTO v_record_count_istoric FROM istoric;
      INSERT INTO istoric
      (id_istoric, id_client, data_conectare, data_deconectare)
      VALUES
      (v_record_count_istoric, v_id_client, v_data_conectare, v_data_deconectare);
      COMMIT;
    ELSE v_id_client := -1;
  END IF;
END login_user;

--Rezervare masina:
CREATE OR REPLACE PROCEDURE rezervare_masina
(v_id_client rezervari.id_client%TYPE, v_id_masina rezervari.id_masina%TYPE, v_last_rent_date rezervari.last_rent_date%TYPE, v_id_parcare_preluare rezervari.id_parcare_preluare%TYPE, v_id_parcare_predare rezervari.id_parcare_predare%TYPE)
AS
v_id_rezervari rezervari.id_rezervari%TYPE;
v_rezervation_date rezervari.rezervation_date%TYPE := sysdate();
v_first_rent_date rezervari.first_rent_date%TYPE := sysdate();
BEGIN
  SELECT MAX(id_rezervari)+1 INTO v_id_rezervari FROM rezervari;
  INSERT INTO rezervari
  (id_rezervari, id_client, id_masina, first_rent_date, last_rent_date, rezervation_date, id_parcare_predare, id_parcare_preluare)
  VALUES
  (v_id_rezervari, v_id_client, v_id_masina, v_first_rent_date, v_last_rent_date, v_rezervation_date, v_id_parcare_predare, v_id_parcare_preluare);
  COMMIT;
  UPDATE masini
  SET rezervat = 1
  WHERE v_id_masina=id_masina;
END rezervare_masina;

--Istoric rezervari, profil:
CREATE OR REPLACE PROCEDURE istoric_rezervari
(v_id_client rezervari.id_client%TYPE, c_istoric_rezervari OUT SYS_REFCURSOR)
AS
BEGIN
  open c_istoric_rezervari for
  SELECT * FROM rezervari WHERE id_client=v_id_client ORDER BY REZERVATION_DATE DESC;
END istoric_rezervari;

--Logout
   create or replace Procedure logoutUser
(mesaj OUT VARCHAR2, v_id_user IN INTEGER)
IS
counter      INTEGER ;
v_count      INTEGER;

BEGIN
 select ID_ISTORIC into v_count from ISTORIC  WHERE (id_client=v_id_user and DATA_DECONECTARE is null)   ;
if(v_count != 0) then
  UPDATE istoric
  SET data_deconectare = sysdate()
  WHERE ID_ISTORIC = v_count;
mesaj := 'Esti deconectat';
end if;

EXCEPTION
WHEN no_data_found THEN
  SELECT COUNT(*) INTO counter FROM istoric WHERE id_client=v_id_user AND data_deconectare IS NULL;
  IF (counter = 0 ) THEN
  mesaj := 'You can*t logout. You have to login first';
    end if;

END logoutUser;

--Stergere rezervare:
--CREATE OR REPLACE PROCEDURE stergere_rezervare
--(v_id_user clienti.id_client%TYPE, v_id_rezervare rezervari.id_rezervari%TYPE)
--AS
--BEGIN
--  DELETE FROM rezervari
--  WHERE v_id_user = id_client AND v_id_rezervare=id_rezervari AND first_rent_date<sysdate();
--END stergere_rezervare;

--Login admin:
CREATE OR REPLACE PROCEDURE login_admin
(v_username admini.username%TYPE, v_parola admini.parola%TYPE, v_id_admin OUT admini.id_admin%TYPE)
AS
v_record_count_admin NUMBER := 0;
BEGIN
  SELECT NVL(COUNT(*), 0) INTO v_record_count_admin FROM admini WHERE (v_username = username) AND (v_parola = parola);
  IF (v_record_count_admin = 1)
    THEN  
      SELECT id_admin INTO v_id_admin FROM admini WHERE (v_username = username) AND (v_parola = parola);
    ELSE v_id_admin := -1;
  END IF;
END login_admin;

--Search dupa parcare si perioada:
CREATE OR REPLACE PROCEDURE afiseaza_masini
(v_id_parcare parcari.id_parcare%TYPE, v_marca masini.marca%TYPE, v_model_masina masini.model_masina%TYPE, v_clasa masini.clasa%TYPE, v_combustibil masini.combustibil%TYPE)
AS
c_masini SYS_REFCURSOR;
v_fisier UTL_FILE.FILE_TYPE;
output_marca masini.marca%TYPE;
output_model_masina masini.model_masina%TYPE;
output_clasa masini.clasa%TYPE;
output_pret masini.pret%TYPE;
output_nota_clienti masini.nota_clienti%TYPE; 
output_numar_locuri masini.numar_locuri%TYPE;
output_optiuni masini.optiuni%TYPE; 
output_combustibil masini.combustibil%TYPE;
output_numar_note masini.combustibil%TYPE;
v_message CLOB;
BEGIN
  IF (v_marca IS NOT NULL) THEN
    IF (v_model_masina IS NOT NULL) THEN
      IF (v_clasa IS NOT NULL) THEN
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND model_masina = v_model_masina AND clasa = v_clasa AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND model_masina = v_model_masina AND clasa = v_clasa;
        END IF;
      ELSE
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND model_masina = v_model_masina AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND model_masina = v_model_masina;
        END IF;
      END IF;
    ELSE
      IF (v_clasa IS NOT NULL) THEN
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND clasa = v_clasa AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND clasa = v_clasa;
        END IF;
      ELSE
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND marca = v_marca;
        END IF;
      END IF;
    END IF;
  ELSE
    IF (v_model_masina IS NOT NULL) THEN
      IF (v_clasa IS NOT NULL) THEN
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND model_masina = v_model_masina AND clasa = v_clasa AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND model_masina = v_model_masina AND clasa = v_clasa;
        END IF;
      ELSE
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND model_masina = v_model_masina AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND model_masina = v_model_masina;
        END IF;
      END IF;
    ELSE
      IF (v_clasa IS NOT NULL) THEN
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND clasa = v_clasa AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND clasa = v_clasa;
        END IF;
      ELSE
        IF (v_combustibil IS NOT NULL) THEN
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0 AND combustibil = v_combustibil;
        ELSE
          open c_masini for
          SELECT marca, model_masina, clasa, pret, nota_clienti, numar_locuri, optiuni, combustibil, numar_note FROM masini WHERE id_parcare = v_id_parcare AND rezervat = 0;
        END IF;
      END IF;
    END IF;
  END IF;
  v_fisier := UTL_FILE.FOPEN('MYDIR','tempdoc.txt','R');
  LOOP
    FETCH c_masini INTO output_marca, output_model_masina, output_clasa, output_pret, output_nota_clienti, output_numar_locuri, output_optiuni, output_combustibil, output_numar_note;
    EXIT WHEN c_masini%NOTFOUND;
    v_message := output_marca ||' ' || output_model_masina ||' ' || output_clasa ||' ' || output_pret ||' ' || output_nota_clienti ||' ' || output_numar_locuri ||' ' || output_optiuni ||' ' || output_combustibil ||' ' || output_numar_note || chr(10);
    UTL_FILE.PUTF(v_fisier, v_message);
  END LOOP;
  UTL_FILE.FCLOSE(v_fisier);
END afiseaza_masini;

--Numar drumuri
--CREATE OR REPLACE FUNCTION nr_drumuri
--RETURN NUMBER
--AS
--v_nr NUMBER;
--BEGIN
--  SELECT COUNT(*)+1 INTO v_nr FROM drumuri;
--  return v_nr;
--END nr_drumuri;

--Drumuri intre parcari:
CREATE OR REPLACE PROCEDURE drumuri_parcari
(v_id_parcare_1 drumuri.id_parcare1%TYPE, v_id_parcare_2 drumuri.id_parcare2%TYPE, v_path OUT VARCHAR2)
AS
TYPE vc_array IS TABLE OF VARCHAR2(101) index by pls_integer;
TYPE vc_array_array IS TABLE OF vc_array index by pls_integer;
v_matrice_adiacenta vc_array_array;
v_matrice_cost vc_array_array;
v_distance vc_array;
v_pred vc_array;
v_visited vc_array;
v_count NUMBER;
v_mindistance NUMBER;
v_nextnode NUMBER;
v_i NUMBER := 0;
v_j NUMBER := 0;
v_infinity NUMBER := 999999;
BEGIN
  FOR v_i IN 0..100 LOOP
    FOR v_j IN 0..100 LOOP
      v_matrice_adiacenta (v_i)(v_j) := 0;
      v_matrice_cost (v_i)(v_j) := v_infinity;
    END LOOP;
  END LOOP;
  
  FOR v_iterator IN (SELECT id_parcare1, id_parcare2,cost_drum FROM drumuri) LOOP
    v_matrice_adiacenta(v_iterator.id_parcare1)(v_iterator.id_parcare2) := 1;
    v_matrice_cost(v_iterator.id_parcare1)(v_iterator.id_parcare2) := v_iterator.cost_drum;
  END LOOP;
  
  FOR v_i IN 0..100 LOOP
    v_distance(v_i) := v_matrice_cost(v_id_parcare_1)(v_i);
    v_pred(v_i) := v_id_parcare_1;
    v_visited(v_i) := 0;
  END LOOP;
  
  v_distance(v_id_parcare_1) := 0;
  v_visited(v_id_parcare_1) := 1;
  v_count := 1;
  
  WHILE(v_count < 101) LOOP
    v_mindistance := v_infinity;
    FOR v_i IN 0..100 LOOP
      IF((v_distance(v_i) < v_mindistance) AND (v_visited(v_i) = 0)) THEN
        v_mindistance := v_distance(v_i);
        v_nextnode := v_i;
      END IF;
    END LOOP;
    
    v_visited(v_nextnode) := 1;
    FOR v_i IN 0..100 LOOP
      IF (v_visited(v_i) = 0) THEN
        IF (v_mindistance + v_matrice_cost(v_nextnode)(v_i) < v_distance(v_i)) THEN
          v_distance(v_i) := v_mindistance + v_matrice_cost(v_nextnode)(v_i);
          v_pred(v_i) := v_nextnode;
        END IF;
      END IF;
    END LOOP;
    
    v_count := v_count + 1;
    
  END LOOP;
  
  v_path := 'Distance of node ' || v_id_parcare_2 || ' from ' || v_id_parcare_1 || ' is ' || v_distance(v_id_parcare_2) || '. ';
  v_j := v_id_parcare_2;
  v_path := v_path || 'Path:' || v_id_parcare_2;
  LOOP
    v_j := v_pred(v_j);
    v_path := v_path || '<-' || v_j;
    EXIT WHEN v_j = v_id_parcare_1;
  END LOOP;
END drumuri_parcari;

--logout user, Bianca:
create or replace PROCEDURE logoutUser
(v_id_user clienti.id_client%TYPE)
AS
counter INTEGER;
v_count INTEGER;
BEGIN
select ID_CLIENT into v_count from ISTORIC  WHERE v_id_user=id_client AND (data_deconectare IS NULL);
UPDATE istoric
 SET data_deconectare = sysdate()
WHERE v_id_user=id_client AND data_deconectare IS NULL;
 
EXCEPTION
WHEN no_data_found THEN
  SELECT COUNT(*) INTO counter FROM istoric WHERE v_id_user=id_client AND data_deconectare IS NULL;
IF counter = 0 THEN
 raise_application_error (-20001,'You can*t logout. You have to login first');
end if;
END logoutUser;