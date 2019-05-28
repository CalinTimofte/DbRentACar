--Afisare parcari:
CREATE OR REPLACE PROCEDURE afiseaza_parcari
(c_parcari OUT SYS_REFCURSOR)
AS
BEGIN
  open c_parcari for
  SELECT * FROM parcari;
END afiseaza_parcari;

--Inregistrare utilizator:
CREATE OR REPLACE PROCEDURE register_user
(v_username clienti.username%TYPE, v_nume clienti.nume%TYPE, v_prenume clienti.prenume%TYPE, v_numar_telefon clienti.numar_telefon%TYPE, v_email clienti.email%TYPE, v_parola clienti.parola%TYPE, v_numar_permis clienti.numar_permis%TYPE)
AS
v_client_id clienti.id_client%TYPE;
BEGIN
  SELECT MAX(id_client)+1 INTO v_client_id FROM clienti;
  INSERT INTO clienti
  (id_client, username, nume, prenume, numar_telefon, email, parola, numar_permis)
  VALUES
  (v_id_client, v_username, v_nume, v_prenume, v_numar_telefon, v_email, v_parola, v_numar_permis);
  COMMIT;
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
(v_id_user client.id_client%TYPE, v_username clienti.username%TYPE, v_nume OUT clienti.nume%TYPE, v_prenume OUT clienti.prenume%TYPE, v_numar_telefon OUT clienti.numar_telefon%TYPE, v_email OUT clienti.email%TYPE)
AS
v_record_count NUMBER := 0;
BEGIN
  SELECT ISNULL(COUNT(*), 0) INTO v_record_count FROM clienti WHERE v_id_user = id_user; 
  IF (v_record_user = 1)
    THEN SELECT username, nume, prenume, numar_telefon, email INTO v_username, v_nume, v_prenume, v_numar_telefon, v_email FROM clienti WHERE v_id_user = id_user;
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
  SELECT ISNULL(COUNT(*), 0) INTO v_record_count_user FROM clienti WHERE (v_username = username) AND (v_parola = parola);
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
CREATE OR REPLACE PROCEDURE logout
(v_id_user clienti.id_client%TYPE)
AS
BEGIN
  UPDATE istoric
  SET data_deconectare = sysdate()
  WHERE v_id_user=id_client AND data_deconectare IS NULL;
END logout;

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
  SELECT ISNULL(COUNT(*), 0) INTO v_record_count_admin FROM admini WHERE (v_username = username) AND (v_parola = parola);
  IF (v_record_count_user = 1)
    THEN  
      SELECT id_admin INTO v_id_admin FROM admini WHERE (v_username = username) AND (v_parola = parola);
    ELSE v_id_admin := -1;
  END IF;
END login_admin;

--Search dupa parcare si perioada:
CREATE OR REPLACE PROCEDURE afiseaza_masini
(c_masini OUT SYS_REFCURSOR, v_id_parcare parcari.id_parcare%TYPE, v_marca masini.marca%TYPE, v_model_masina masini.model_masina%TYPE, v_clasa masini.clasa%TYPE, v_combustibil masini.combustibil%TYPE)
AS
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
END afiseaza_masini;