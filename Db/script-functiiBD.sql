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
v_record_count NUMBER := 0;
BEGIN
  SELECT ISNULL(COUNT(*), 0) INTO v_record_count FROM clienti WHERE (v_username = username) AND (v_parola = parola);
  IF (v_record_user = 1)
    THEN  SELECT id_client INTO v_id_client FROM clienti WHERE (v_username = username) AND (v_parola = parola);
    ELSE v_id_client := -1;
  END IF;
END login_user;