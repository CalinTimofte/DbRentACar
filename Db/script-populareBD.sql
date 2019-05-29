DROP TABLE clienti CASCADE CONSTRAINTS
/
DROP TABLE parcari CASCADE CONSTRAINTS
/
DROP TABLE masini CASCADE CONSTRAINTS 
/
DROP TABLE rezervari CASCADE CONSTRAINTS
/
DROP TABLE istoric CASCADE CONSTRAINTS
/
DROP TABLE drumuri CASCADE CONSTRAINTS
/
DROP TABLE admini CASCADE CONSTRAINTS
/
CREATE TABLE admini
  (
    id_admin    INT NOT NULL PRIMARY KEY,
   username VARCHAR2(100) NOT NULL,
    parola VARCHAR2(100) NOT NULL
   
  )
/
CREATE TABLE parcari
  (
    id_parcare    INT NOT NULL PRIMARY KEY,
    oras          VARCHAR2(50) NOT NULL,
    adresa        VARCHAR2(50) NOT NULL,
    numar_telefon VARCHAR2(50) NOT NULL
  )
/
CREATE TABLE drumuri
  (
    id_drumuri    INT NOT NULL PRIMARY KEY,
   id_parcare1          INTEGER NOT NULL,
    id_parcare2       INTEGER NOT NULL,
    cost_drum     INTEGER NOT NULL,
 CONSTRAINT fk_drumuri_id_parcare_1 FOREIGN KEY (id_parcare1) REFERENCES parcari(id_parcare),
CONSTRAINT fk_drumuri_id_parcare_2 FOREIGN KEY (id_parcare2) REFERENCES parcari(id_parcare)
  )
/
CREATE TABLE masini
  (
    id_masina    INT NOT NULL PRIMARY KEY,
    id_parcare   INT NOT NULL,
    marca        VARCHAR2(30) NOT NULL,
    model_masina VARCHAR2(30) NOT NULL,
    clasa        VARCHAR2(30) NOT NULL,
    pret         INT NOT NULL,
    nota_clienti INT NOT NULL,
    numar_locuri INT NOT NULL,
    optiuni      VARCHAR2(50) NOT NULL,
    combustibil  VARCHAR2(30) NOT NULL,
    numar_note   INT,
    rezervat   INT,
    CONSTRAINT fk_masini_id_parcare FOREIGN KEY (id_parcare) REFERENCES parcari(id_parcare)
  )
/
CREATE TABLE clienti
  (
    id_client     INT NOT NULL PRIMARY KEY,
	username     VARCHAR2(100) NOT NULL UNIQUE,
    nume          VARCHAR2(100) NOT NULL,
    prenume       VARCHAR2(70) NOT NULL,
    numar_telefon VARCHAR2(30) NOT NULL,
    email         VARCHAR2(100) NOT NULL,
    parola        VARCHAR2(40) NOT NULL,
    numar_permis  VARCHAR2(30) NOT NULL
  )
/
CREATE TABLE rezervari
  (
    id_rezervari        INT NOT NULL PRIMARY KEY,
    id_client           INT NOT NULL,
    id_masina           INT NOT NULL,
    first_rent_date     DATE,
    last_rent_date      DATE,
    rezervation_date    DATE,
    Id_parcare_predare  INT NOT NULL,
    Id_parcare_preluare INT NOT NULL,
    CONSTRAINT fk_rezervari_id_client FOREIGN KEY (id_client) REFERENCES clienti(id_client),
    CONSTRAINT fk_rezervari_id_masina FOREIGN KEY (id_masina) REFERENCES masini(id_masina)
  )
/
CREATE TABLE istoric
  (
    id_istoric       INT NOT NULL PRIMARY KEY,
    id_client        INT NOT NULL,
    data_conectare   DATE,
    data_deconectare DATE,
    CONSTRAINT fk_istoric_id_client FOREIGN KEY (id_client) REFERENCES clienti(id_client)
  )
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH:MI:SS PM';
SET SERVEROUTPUT ON;
DECLARE
TYPE varr IS VARRAY(10000) OF VARCHAR2(255);
-- Pentru masina
lista_marca varr  := varr('Abarth','Alfa Romeo','Asia Motors','Aston Martin','Audi','Austin','Autobianchi','Bentley','BMW','Bugatti','Buick','Cadillac','Carver','Chevrolet','Chrysler','Citroen','Corvette','Dacia','Daewoo','Daihatsu','Daimler','Datsun','Dodge','Donkervoort','DS','Ferrari','Fiat','Fisker','Ford','FSO','Galloper','Honda','Hummer','Hyundai','Infiniti','Innocenti','Jaguar','Jeep','Josse','Kia','Lada','Lamborghini','Lancia','Land Rover','Landwind','Lexus','Lincoln','Lotus','Marcos','Maserati','Maybach','Mazda','McLaren','Mega','Mercedes','Mercury','MG','Mini','Mitsubishi','Morgan','Morris','Nissan','Noble','Opel','Peugeot','PGO','Pontiac','Porsche','Princess','Renault','Rolls-Royce','Rover','Saab','Seat','Skoda','Smart','Spectre','Ssang','Yong','Subaru','Suzuki','Talbot','Tesla','Think','Toyota','Triumph','TVR','Volkswagen','Volvo','Yugo');
lista_combustibil varr := varr ('benzina','motorina','electric');
lista_clasa varr      := varr ('SUV','Premium','Standard','Mini','Economic','Intermediar','mini-SUV');
--Pentru clienti
  lista_nume varr := varr('Ababei','Acasandrei','Adascalitei','Afanasie','Agafitei','Agape','Aioanei','Alexandrescu','Alexandru','Alexe','Alexii','Amarghioalei','Ambroci','Andonesei','Andrei','Andrian','Andrici','Andronic','Andros','Anghelina','Anita','Antochi','Antonie','Apetrei','Apostol','Arhip','Arhire','Arteni','Arvinte','Asaftei','Asofiei','Aungurenci','Avadanei','Avram','Babei','Baciu','Baetu','Balan','Balica','Banu','Barbieru','Barzu','Bazgan','Bejan','Bejenaru','Belcescu','Belciuganu','Benchea','Bilan','Birsanu','Bivol','Bizu','Boca','Bodnar','Boistean','Borcan','Bordeianu','Botezatu','Bradea','Braescu','Budaca','Bulai','Bulbuc-aioanei','Burlacu','Burloiu','Bursuc','Butacu','Bute','Buza','Calancea','Calinescu','Capusneanu','Caraiman','Carbune','Carp','Catana','Catiru','Catonoiu','Cazacu','Cazamir','Cebere','Cehan','Cernescu','Chelaru','Chelmu','Chelmus','Chibici','Chicos','Chilaboc','Chile','Chiriac','Chirila','Chistol','Chitic','Chmilevski','Cimpoesu','Ciobanu','Ciobotaru','Ciocoiu','Ciofu','Ciornei','Citea','Ciucanu','Clatinici','Clim','Cobuz','Coca','Cojocariu','Cojocaru','Condurache','Corciu','Corduneanu','Corfu','Corneanu','Corodescu','Coseru','Cosnita','Costan','Covatariu','Cozma','Cozmiuc','Craciunas','Crainiceanu','Creanga','Cretu','Cristea','Crucerescu','Cumpata','Curca','Cusmuliuc','Damian','Damoc','Daneliuc','Daniel','Danila','Darie','Dascalescu','Dascalu','Diaconu','Dima','Dimache','Dinu','Dobos','Dochitei','Dochitoiu','Dodan','Dogaru','Domnaru','Dorneanu','Dragan','Dragoman','Dragomir','Dragomirescu','Duceac','Dudau','Durnea','Edu','Eduard','Eusebiu','Fedeles','Ferestraoaru','Filibiu','Filimon','Filip','Florescu','Folvaiter','Frumosu','Frunza','Galatanu','Gavrilita','Gavriliuc','Gavrilovici','Gherase','Gherca','Ghergu','Gherman','Ghibirdic','Giosanu','Gitlan','Giurgila','Glodeanu','Goldan','Gorgan','Grama','Grigore','Grigoriu','Grosu','Grozavu','Gurau','Haba','Harabula','Hardon','Harpa','Herdes','Herscovici','Hociung','Hodoreanu','Hostiuc','Huma','Hutanu','Huzum','Iacob','Iacobuta','Iancu','Ichim','Iftimesei','Ilie','Insuratelu','Ionesei','Ionesi','Ionita','Iordache','Iordache-tiroiu','Iordan','Iosub','Iovu','Irimia','Ivascu','Jecu','Jitariuc','Jitca','Joldescu','Juravle','Larion','Lates','Latu','Lazar','Leleu','Leon','Leonte','Leuciuc','Leustean','Luca','Lucaci','Lucasi','Luncasu','Lungeanu','Lungu','Lupascu','Lupu','Macariu','Macoveschi','Maftei','Maganu','Mangalagiu','Manolache','Manole','Marcu','Marinov','Martinas','Marton','Mataca','Matcovici','Matei','Maties','Matrana','Maxim','Mazareanu','Mazilu','Mazur','Melniciuc-puica','Micu','Mihaela','Mihai','Mihaila','Mihailescu','Mihalachi','Mihalcea','Mihociu','Milut','Minea','Minghel','Minuti','Miron','Mitan','Moisa','Moniry-abyaneh','Morarescu','Morosanu','Moscu','Motrescu','Motroi','Munteanu','Murarasu','Musca','Mutescu','Nastaca','Nechita','Neghina','Negrus','Negruser','Negrutu','Nemtoc','Netedu','Nica','Nicu','Oana','Olanuta','Olarasu','Olariu','Olaru','Onu','Opariuc','Oprea','Ostafe','Otrocol','Palihovici','Pantiru','Pantiruc','Paparuz','Pascaru','Patachi','Patras','Patriche','Perciun','Perju','Petcu','Pila','Pintilie','Piriu','Platon','Plugariu','Podaru','Poenariu','Pojar','Popa','Popescu','Popovici','Poputoaia','Postolache','Predoaia','Prisecaru','Procop','Prodan','Puiu','Purice','Rachieru','Razvan','Reut','Riscanu','Riza','Robu','Roman','Romanescu','Romaniuc','Rosca','Rusu','Samson','Sandu','Sandulache','Sava','Savescu','Schifirnet','Scortanu','Scurtu','Sfarghiu','Silitra','Simiganoschi','Simion','Simionescu','Simionesei','Simon','Sitaru','Sleghel','Sofian','Soficu','Sparhat','Spiridon','Stan','Stavarache','Stefan','Stefanita','Stingaciu','Stiufliuc','Stoian','Stoica','Stoleru','Stolniceanu','Stolnicu','Strainu','Strimtu','Suhani','Tabusca','Talif','Tanasa','Teclici','Teodorescu','Tesu','Tifrea','Timofte','Tincu','Tirpescu','Toader','Tofan','Toma','Toncu','Trifan','Tudosa','Tudose','Tuduri','Tuiu','Turcu','Ulinici','Unghianu','Ungureanu','Ursache','Ursachi','Urse','Ursu','Varlan','Varteniuc','Varvaroi','Vasilache','Vasiliu','Ventaniuc','Vicol','Vidru','Vinatoru','Vlad','Voaides','Vrabie','Vulpescu','Zamosteanu','Zazuleac');
  lista_prenume varr := varr('Adina','Alexandra','Alina','Ana','Anca','Anda','Andra','Andreea','Andreia','Antonia','Bianca','Camelia','Claudia','Codrina','Cristina','Daniela','Daria','Delia','Denisa','Diana','Ecaterina','Elena','Eleonora','Elisa','Ema','Emanuela','Emma','Gabriela','Georgiana','Ileana','Ilona','Ioana','Iolanda','Irina','Iulia','Iuliana','Larisa','Laura','Loredana','Madalina','Malina','Manuela','Maria','Mihaela','Mirela','Monica','Oana','Paula','Petruta','Raluca','Sabina','Sanziana','Simina','Simona','Stefana','Stefania','Tamara','Teodora','Theodora','Vasilica','Xena','Adrian','Alex','Alexandru','Alin','Andreas','Andrei','Aurelian','Beniamin','Bogdan','Camil','Catalin','Cezar','Ciprian','Claudiu','Codrin','Constantin','Corneliu','Cosmin','Costel','Cristian','Damian','Dan','Daniel','Danut','Darius','Denise','Dimitrie','Dorian','Dorin','Dragos','Dumitru','Eduard','Elvis','Emil','Ervin','Eugen','Eusebiu','Fabian','Filip','Florian','Florin','Gabriel','George','Gheorghe','Giani','Giulio','Iaroslav','Ilie','Ioan','Ion','Ionel','Ionut','Iosif','Irinel','Iulian','Iustin','Laurentiu','Liviu','Lucian','Marian','Marius','Matei','Mihai','Mihail','Nicolae','Nicu','Nicusor','Octavian','Ovidiu','Paul','Petru','Petrut','Radu','Rares','Razvan','Richard','Robert','Roland','Rolland','Romanescu','Sabin','Samuel','Sebastian','Sergiu','Silviu','Stefan','Teodor','Teofil','Theodor','Tudor','Vadim','Valentin','Valeriu','Vasile','Victor','Vlad','Vladimir','Vladut');

  --istoric 
   v_data_conectare   DATE;
   v_data_deconectare DATE;
	
  --rezervari 
  v_id_client           INTEGER ;
    v_id_masina           INTEGER ;
    v_first_rent_date     DATE;
    v_last_rent_date      DATE;
    v_rezervation_date    DATE;
    v_id_parcare_predare  INTEGER ;
    v_id_parcare_preluare INTEGER ;
	
  -- CLienti :
  v_username VARCHAR2(255);
    v_nume          VARCHAR2(255);
    v_prenume       VARCHAR2(255);   
    v_email         VARCHAR2(255);
    v_parola        VARCHAR2(255) ;
    v_numar_permis  VARCHAR2(255) ;

-- parcari
v_oras    VARCHAR2(255);
v_adresa  VARCHAR(255);
v_telefon VARCHAR(255);

--drumuri 
v_id_parcare1 INTEGER;
v_id_parcare2 INTEGER;
cost_drum INTEGER;

v_temp INTEGER ;
v_temp1 INTEGER ;

--pentru masina
v_id_parcare  INTEGER ;
v_marca       VARCHAR2(255);
v_model       VARCHAR2(255);
v_clasa       VARCHAR2(255);
v_pret        INTEGER;
v_nota        NUMBER ;
v_locuri      INTEGER ;
v_combustibil VARCHAR2(100);
v_optiuni     VARCHAR2(20); --da/nu
v_nr_note     INTEGER;
v_rezervat INTEGER;

BEGIN
------------Admini-------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('Inserarea a adminilor...');
  FOR v_i IN 1..5 LOOP
  
      v_username := 'Admin'||v_i ;
      v_parola := 'parola'||v_i ;
 
    INSERT INTO admini VALUES
      (v_i, v_username, v_parola);
      
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Inserarea adminilor reusita !');
  

------------PARCARI-------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('Inserarea a parcarilor...');
  FOR v_i IN 1..100 LOOP
    -- oras + adresa sa nu se repete impreuna, separat se pot repeta
    LOOP
      v_oras := 'Oras ' || TRUNC(DBMS_RANDOM.VALUE(0,10000)) ;
      v_adresa := 'Strada ' || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || ', nr' || TRUNC(DBMS_RANDOM.VALUE(0,10000)) ;
      SELECT COUNT(*) INTO v_temp FROM parcari WHERE oras = v_oras AND adresa = v_adresa ;
      EXIT WHEN v_temp=0;
    END LOOP;
    
    --numere de telefon unice
    LOOP
      v_telefon := 0 || 7 || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10)) ;
      SELECT COUNT(*) INTO v_temp FROM parcari WHERE numar_telefon=v_telefon ;
      EXIT
    WHEN v_temp=0;
    END LOOP;
  
    INSERT INTO parcari VALUES
      (v_i, v_oras, v_adresa, v_telefon);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Inserarea parcarilor reusita !');
  
--------------Drumuri------------
DBMS_OUTPUT.PUT_LINE('Inserarea a drumurilor...');
  FOR v_i IN 1..100 LOOP
       SELECT COUNT(*) INTO v_temp1 FROM parcari;
    LOOP
      v_id_parcare1 := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1;
      v_id_parcare2 := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1;
      v_temp := 1;
      if( v_id_parcare1 <> v_id_parcare2) then
       SELECT COUNT(*) INTO v_temp FROM drumuri WHERE (id_parcare1 = v_id_parcare1 AND id_parcare2 = v_id_parcare2) OR (id_parcare2 = v_id_parcare1 AND id_parcare1 = v_id_parcare2) ;
      end if;
      EXIT WHEN v_temp=0;      
    END LOOP;
    
    cost_drum := TRUNC(DBMS_RANDOM.VALUE(10,10000))+1;
    INSERT INTO drumuri VALUES
      (v_i, v_id_parcare1,  v_id_parcare2, cost_drum);
    
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Inserarea drumurilor reusita !');
  
  -----------------------MASINI -----------------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('Inserarea masinilor...');
  FOR v_i IN 1..10000 LOOP
  
    --Intr-o parcare incap doar 1000 de masini
    SELECT COUNT(*) INTO v_temp1 FROM parcari;
    LOOP
      v_id_parcare := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1;
      SELECT COUNT(*) INTO v_temp FROM masini WHERE id_parcare = v_id_parcare ;
      EXIT WHEN v_temp <= 10000;
    END LOOP;
    
    -- un rand poate fi diferit doar printr-un atribut
    LOOP
      v_marca                         := lista_marca(TRUNC(DBMS_RANDOM.VALUE(0,lista_marca.count))            +1);
      v_model                         := 'Model-' || TRUNC(DBMS_RANDOM.VALUE(1,40))       ;
      v_clasa                         := lista_clasa(TRUNC(DBMS_RANDOM.VALUE(0,lista_clasa.count))            +1);
      v_combustibil                   := lista_combustibil(TRUNC(DBMS_RANDOM.VALUE(0,lista_combustibil.count))+1);
      v_locuri                        := TRUNC(DBMS_RANDOM.VALUE(1,7))                                        +1 ;
   
      IF(TRUNC(DBMS_RANDOM.VALUE(0,10))< 5) THEN
        v_optiuni                     := 'DA' ;
      ELSE
        v_optiuni := 'NU' ;
      END IF;
      SELECT COUNT(*)
      INTO v_temp
      FROM masini
      WHERE marca      =v_marca
      AND model_masina = v_model
      AND clasa        =v_clasa
      AND combustibil  = v_combustibil
      AND numar_locuri =v_locuri
      AND optiuni      =v_optiuni ;
      EXIT
    WHEN v_temp =0;
    END LOOP;
    v_nota    := DBMS_RANDOM.VALUE(0,5) ;
    v_nr_note := TRUNC(DBMS_RANDOM.VALUE(0,1000))+1 ;
    v_pret := DBMS_RANDOM.VALUE(30,10000) ;
    v_rezervat :=DBMS_RANDOM.VALUE(0,1);
    INSERT
    INTO masini VALUES
      (
        v_i,
        v_id_parcare,
        v_marca,
        v_model,
        v_clasa,
        v_pret,
        v_nota,
        v_locuri,
        v_optiuni,
        v_combustibil,
        v_nr_note,
        v_rezervat
      );
  END LOOP ;
  DBMS_OUTPUT.PUT_LINE('Inserarea a masinilor reusita !');  
  
  ----------------------CLIENTI -------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('Inserarea clientilor...');
FOR v_i IN 1..500 LOOP
v_nume := lista_nume(TRUNC(DBMS_RANDOM.VALUE(0,lista_nume.count))+1);
v_prenume := lista_prenume(TRUNC(DBMS_RANDOM.VALUE(0,lista_prenume.count))+1);

      v_telefon := 0 || 7 || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10)) ;
 	
	--username unic
	 v_temp1 :=TRUNC(DBMS_RANDOM.VALUE(0,100000));
	 LOOP         
         select count(*) into v_temp from clienti where username = v_nume||v_temp1;
         exit when v_temp=0;
         v_temp1 :=  TRUNC(DBMS_RANDOM.VALUE(0,100));
      END LOOP;  
	  
	  v_username := v_nume||v_temp1;
	
	
	--email unic
	v_temp:='';
      v_email := lower(v_nume ||'.'|| v_prenume);
      LOOP         
         select count(*) into v_temp from clienti where email = v_email||v_temp;
         exit when v_temp=0;
         v_temp :=  TRUNC(DBMS_RANDOM.VALUE(0,100));
      END LOOP;    
      
      if (TRUNC(DBMS_RANDOM.VALUE(0,2))=0) then v_email := v_email ||'@gmail.com';
         else v_email := v_email ||'@info.ro';
      end if;
	  
	  --parola = prenumele  + ultimele 3 cifre de la numarul de telefon , daca deja exista, cifre random
	  
	  v_temp1 := SUBSTR(v_telefon,8,3);
	 LOOP         
         select count(*) into v_temp from clienti where parola = v_prenume||v_temp1;
         exit when v_temp=0;
         v_temp1 :=  TRUNC(DBMS_RANDOM.VALUE(0,100));
      END LOOP;  
	  
	  v_parola := v_prenume||v_temp1;
	  
	  -- numar permis : unic
	   LOOP
      v_numar_permis := TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10)) || TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10))|| TRUNC(DBMS_RANDOM.VALUE(0,10)) ;
      SELECT COUNT(*) INTO v_temp FROM clienti WHERE numar_permis=v_numar_permis ;
      EXIT
    WHEN v_temp=0;
    END LOOP;

INSERT INTO clienti VALUES(v_i,v_username,v_nume,v_prenume,v_telefon,v_email,v_parola,v_numar_permis);
  END LOOP ;
  DBMS_OUTPUT.PUT_LINE('Inserarea clientilor reusita !');  
  
  ------------------------REZERVARI -----------------------------------------------------
  
 DBMS_OUTPUT.PUT_LINE('Inserarea rezervarilor...');
  FOR v_i IN 1..1000 LOOP  
  
      SELECT COUNT(*) INTO v_temp1 FROM clienti;
      v_id_client := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1;
	  
	  SELECT COUNT(*) INTO v_temp1 FROM masini;
      v_id_masina := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1;
  
   v_first_rent_date := TO_DATE('01-01-2019','MM-DD-YYYY')+TRUNC(DBMS_RANDOM.VALUE(0,700));    
   v_last_rent_date :=  v_first_rent_date + TRUNC(DBMS_RANDOM.VALUE(1,100));
   v_rezervation_date := CURRENT_DATE ;
   
    SELECT COUNT(*) INTO v_temp1 FROM parcari;
	v_id_parcare_preluare := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1 ;
	v_id_parcare_predare :=TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1 ;
         
  INSERT INTO rezervari VALUES(v_i, v_id_client, v_id_masina, v_first_rent_date, v_last_rent_date,v_rezervation_date,v_id_parcare_predare,v_id_parcare_preluare);
  END LOOP ;
  DBMS_OUTPUT.PUT_LINE('Inserarea rezervarilor reusita !');  

  
  ------------------ ISTORIC -------------------------------------------------------------

  DBMS_OUTPUT.PUT_LINE('Inserarea istoricului...');
  FOR v_i IN 1..500 LOOP  
  
   SELECT COUNT(*) INTO v_temp1 FROM clienti;
      v_id_client := TRUNC(DBMS_RANDOM.VALUE(0,v_temp1))+1;
      
	  v_data_conectare := TO_DATE('01-01-2019 12:00:00','MM-DD-YYYY HH:MI:SS')+ TRUNC(DBMS_RANDOM.VALUE(0,700)) + DBMS_RANDOM.VALUE(0,0.5);    
    v_data_deconectare := v_data_conectare +DBMS_RANDOM.VALUE(0,0.5);
  
  INSERT INTO istoric VALUES(v_i, v_id_client, v_data_conectare, v_data_deconectare);
   END LOOP ;
  DBMS_OUTPUT.PUT_LINE('Inserarea istoricului reusita !');  
  -- end-ul de la begin
END ; 
/
CREATE INDEX masini_libere ON masini(id_parcare,rezervat);
