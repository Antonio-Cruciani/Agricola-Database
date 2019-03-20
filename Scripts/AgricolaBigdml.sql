USE Agricola;
-- procedura per radomizzare la possibile data inserita come recdord nelle tabelle
DROP PROCEDURE IF EXISTS randoData;
delimiter //
create procedure randoData(in inizio date,out arrivo date) /*usata per generare date casuali */
begin
    set inizio = date_add(inizio,interval rand()*27 day);
    set inizio = date_add(inizio,interval rand()*11 month);
    set inizio = date_add(inizio,interval rand()*52 year);
    set arrivo = inizio;
end; //
delimiter ;




DROP PROCEDURE IF EXISTS datarand;
delimiter //
create procedure datarand(in inizio date,out arrivo date) /*usata per generare date casuali */
begin
    set inizio = date_add(inizio,interval rand()*27 day);
    set inizio = date_add(inizio,interval rand()*11 month);
    set inizio = date_add(inizio,interval rand()*50 year);
    set arrivo = inizio;
end; //
delimiter ;

-- Procedura per randomizzare l'orario 

DROP PROCEDURE IF EXISTS randoHour;
DELIMITER // 
CREATE PROCEDURE randoHour(in inizio timestamp,out arrivo timestamp)
BEGIN
    SET inizio = date_add(inizio,interval rand()*24 hour);

END; // 
DELIMITER ;

-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Tipo_di_Allevamento"
-- ----------------------------------

INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('suinocoltura','maiale',400);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('bovinicoltura','mucche',300);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('caprinicoltura','capre',250);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('coniglicoltura','conigli',50);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('ippicoltura','cavalli',800);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('ovinicoltura','ovini',200);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('pollicoltura','polli',40);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('elicicoltura','lumache',1);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('bachicoltura','bachi da seta',30);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('allevamento dello struzzo','struzzi',1000);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('ostricoltura','ostriche',100);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('allevamento felino','gatti',200);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('allevamento canino','cani',800);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('avicoltura','uccelli',200);
INSERT INTO Tipo_di_Allevamento(nome,descrizione,prezzo) VALUES ('itticoltura','pesci',10);

SELECT "*********Tipi Di Allevamenti inseriti*********";

-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Città"
-- ----------------------------------


drop procedure if exists s_inCitt;
delimiter //
create procedure s_inCitt()
begin
    declare c int; -- contatore
    declare cap varchar(200); -- caprandom
    declare provincia varchar(200); -- provincia    
    declare nome varchar(200); -- nome
    declare prov int; -- numero provincia random 15<=prov>=1
    set c = 1;
    start transaction;
    while c<= 50000 do
        set cap= concat("cap qualunque_",c);
        set prov=rand()*13+1;
        set provincia=concat("provincia qualunque_",prov);
        set nome=concat("nome città qualunque_",c);
        insert into Citta(cap,provincia,nome)values(cap,provincia,nome);
        set c = c + 1;
    end while;
end; //
delimiter ;
call s_inCitt();
SELECT "*********Città Inserite*********";



-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Allevamento"
-- ----------------------------------

DROP PROCEDURE IF EXISTS s_inAllev;
DELIMITER //
CREATE PROCEDURE s_inAllev()
BEGIN
    DECLARE j INT; -- contatore 
  
    DECLARE vi VARCHAR(200); -- via dell' allevamento
    declare c int; -- città random
    declare a int;
    declare qta bigint; -- quantità 
    declare var int;
    SET j = 1;
    set c = 1;
    select count(*) into var from citta ;
    START TRANSACTION;
    while c <= var do

     WHILE j <= 5 DO
                set a= rand()*14+1;
                
                SET vi = CONCAT("Via qualunque_",j);
                set qta= rand()*20000+500;
                INSERT INTO Allevamento(citta,tipo_allevamento,via,qta) VALUES (c,a,vi,qta);
                SET j = j + 1;
            end while;
            set j = 1;
    
          set c= c + 1;
    END WHILE;

END; // 
DELIMITER ;
CALL s_inAllev();
SELECT "*********Allevamenti Inseriti*********";

-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Dipendente"
-- ----------------------------------

DROP PROCEDURE IF EXISTS s_inDip;
DELIMITER //
CREATE PROCEDURE s_inDip()
BEGIN
    DECLARE c INT; -- contatore
    DECLARE ndip VARCHAR(30); -- nome dipendente
    DECLARE cdip VARCHAR(30); -- cognome dipendente
    DECLARE an DATE; -- anno di nascita
    DECLARE tel CHAR(30); -- Numero di telefono
    DECLARE npat CHAR(30); -- numero di patente
    DECLARE cf CHAR(30); -- codice fiscale
    DECLARE stipann FLOAT; -- stipendio annuale
    declare var int; -- variabile per la random
    SET c = 1;
    START TRANSACTION;
    WHILE c <= 3000 DO 
        SET ndip = CONCAT("Nome qualunque_",c);
        SET cdip = CONCAT("Cognome qualunque_",c);
        CALL datarand("1950-1-1",an);
        SET tel = CONCAT("Tel qualunque_",c);
        set var = rand()*1;
        if(var = 1)then
              SET npat = CONCAT("patente qualunque_",c);
        else
            SET npat = null;
         end if;
        SET cf = CONCAT("cf qualunque_",c);
        SET stipann = RAND()*2000+1000;
        INSERT INTO Dipendente(nome,cognome,anno_nascita,n_patente,n_tel,cf,stipendio_annuale) VALUES (ndip,cdip,an,npat,tel,cf,stipann);
        SET c = c + 1;
    END WHILE;
    COMMIT;
END; // 
DELIMITER ;
CALL s_inDip();
SELECT "*********Dipendenti Inseriti*********";


-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nelle tabelle 
-- "Agronomo-Contadino-Enologo"
-- ----------------------------------


DROP PROCEDURE IF EXISTS s_inACE;
DELIMITER  //
CREATE PROCEDURE s_inACE()
BEGIN
    DECLARE c INT; -- contatore 
    SET c = 1;
    START TRANSACTION;
    WHILE c <= 1000 DO
        
            INSERT INTO Agronomo(mat_dip) VALUES (c);
        
        set c= c+1;
    end while;

    WHILE c <= 2000 DO
         
            INSERT INTO Contadino(mat_dip) VALUES (c);

        set c = c + 1;
    end while;

    while (c<= 3000)do
       
            INSERT INTO Enologo(mat_dip) VALUES (c);
        
        SET c = c + 1 ;
    END WHILE;
END; //
DELIMITER ;
CALL s_inACE();
SELECT"*********Agronomi, Contadini ed Enologi Inseriti*********";

-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Lavora In
-- ----------------------------------
DROP PROCEDURE IF EXISTS s_inLain;
DELIMITER //
CREATE PROCEDURE s_inLain()
BEGIN 
    DECLARE c INT; -- contatore
    DECLARE j INT; -- contatore
  
    declare p int;
    declare var int;
    declare dino int;
    declare t int;
    select count(*) into var from contadino;
    set j = 1;
    set t = 1;
    start transaction;
    while j <= var do
        set c = 1;
        while c<=2 do 
         insert into lavora_in (allevamento,contadino) values (t,j);
         set c = c + 1;
         set t = t +1;
        end while;
            set j = j+1;
    end while;
    set j = 1;
    set t = 1;
    select count(*) into var from allevamento;
    while j<=var do
        set c = 1;
        while c <= 3 do 
            select contadino.id_contadino into dino from contadino order by rand() limit 1;
            select count(*) into p from lavora_in,allevamento where lavora_in.contadino = dino and lavora_in.allevamento = allevamento.id_allevamento and allevamento.id_allevamento = j;
            if (p=0)then
                INSERT INTO lavora_in (allevamento,contadino) VALUES (j,dino);
                SET c = c + 1;
            end if;
        end while;
        set j = j +1;
    end while;
end; //
delimiter ;
call s_inLain();
SELECT"*********Lavora In Inseriti*********";
-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Cantina"
-- ----------------------------------


DROP PROCEDURE IF EXISTS s_inCant;
DELIMITER //
CREATE PROCEDURE s_inCant()
BEGIN
    DECLARE j INT; -- contatore cantine
    DECLARE altro VARCHAR(255); -- variabile per la descrizione random
    DECLARE nomec VARCHAR(255); -- nome cantina random
    declare via varchar(200); -- nome via qualunque
    declare c int; 
    declare en int;
    declare p int;
    declare var int; 
    declare b int;
    select count(*) into var from enologo;
    set j = 1;
    set c = 1;
  START TRANSACTION;
    WHILE j <= var DO
        set b = 1;
            while b<= 50 do 
           	 SET altro = CONCAT("Descrizione qualunque_",j);
           	 SET nomec = CONCAT("Nome cantina qualunque_",j);
           	 SET via = concat("Via qualunque_",j);
           	 INSERT INTO Cantina(citta,enologo,nome,altro,via) VALUES (c,j,nomec,altro,via);
             set b = b + 1;
             set c = c + 1;
            end while;
    SET j = j + 1;
    END WHILE;
    select count(*) into var from cantina;
    set j = 1;
    set c = 1;
    WHILE j <= var DO
        set b = 1;
            while b<= 2 do 

            select id_enologo into en from enologo order by rand() limit 1;
            select count(*) into p from cantina,enologo where cantina.id_cantina = j and cantina.enologo = en;
            if p=0 then
                INSERT INTO Cantina(citta,enologo,nome,altro,via) VALUES (j,en,nomec,altro,via);
                set b = b+1;
            end if;
            end while;
            set j= j + 1;
        end while;

END; // 
DELIMITER ;
CALL s_inCant();
SELECT "*********Cantine Inserite*********";

-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Tipo di Vino"
-- ---------------------------------- 


DROP PROCEDURE IF EXISTS s_inTipoVino;
DELIMITER //
CREATE PROCEDURE s_inTipoVino()
BEGIN
    declare c int; -- contatore 
    declare nome varchar(255); -- nome vino 
    declare descrizione varchar(255); -- descrizione vino
    
    set c = 1;
    while c <= 20 DO

            set nome = concat("Nome vino qualunque_",c);
            set descrizione = concat ("Descrizione qualunque_",c);
            insert into Tipo_di_Vino(nome,descrizione) VALUES (nome,descrizione);
            set c = c + 1;
    end while;
    commit;
END; //
DELIMITER ;
CALL s_inTipoVino();
SELECT "*********Tipo di Vino inseriti*********";

-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Venduto"
-- ---------------------------------- 


DROP PROCEDURE IF EXISTS s_inVenduto;
DELIMITER // 
CREATE PROCEDURE s_inVenduto()
BEGIN
    declare c int; -- contatore
    declare v int; -- vino
    declare j int; -- variabile per le volte 
    declare qta bigint; -- quantità
    declare annop DATE; -- data produzione
    declare prezzo float(53); -- prezzo
    declare p int; -- controllo select 
    declare var int;
    declare tv int;
    set j = 1;
    set c = 1;
    select count(*) into var from cantina;
    while (c<=var) do 
           select "ciao venduto";
                set v = 1;
                while (v<= 4) do 
                    
                     set qta= rand()*50+20;
                     CALL randoData("1960-1-1",annop);
                     set prezzo = rand()*400+15;
                     select Tipo_di_Vino.id_vino into tv from Tipo_di_Vino order by rand() limit 1;
                    select count(*) into p from Venduto where venduto.cantina = c and venduto.vino = tv and venduto.data_produzione = annop;
                    if (p=0)then
                        select "vino venduto inserito",c,v;
                        INSERT INTO venduto (vino,cantina,data_produzione,prezzo,qta) VALUES (tv,c,annop,prezzo,qta);
                        SET v = v + 1;
                     end if;
               
            end while;
        set c = c + 1;
    end while;
END; //
DELIMITER ;
CALL s_inVenduto();
SELECT "*********Venduti inseriti*********";



-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Terreno"
-- ---------------------------------- 

DROP PROCEDURE IF EXISTS s_inTerr;
DELIMITER //
CREATE PROCEDURE s_inTerr()
BEGIN
    DECLARE J INT; -- contatore 
    declare c int; -- contatore
    DECLARE d FLOAT(53); -- variabile per la dimensione del terreno random
    DECLARE vi VARCHAR(200); -- Variabile per la via
    DECLARe k int ; --  var nome via random 
    declare var int; 
    select count(*) into var from citta;
    set c = 1;
    START TRANSACTION;
    while c <= var do 
    set j = 1;
      WHILE j <= 5 DO 
            SET d = RAND()*4999+1;
            set k = rand()*5000+1;
            SET vi = CONCAT ("Via qualunque_",k);
            INSERT INTO Terreno(dimensione,citta,via) VALUES (d,c,vi);
        SET j = j + 1;
      END WHILE;
        set c = c + 1;
    end while;
END; // 
DELIMITER ;
CALL s_inTerr();
SELECT "*********Terreni Inseriti*********";



-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Prodotto"
-- ----------------------------------       

DROP PROCEDURE IF EXISTS s_inProd;
DELIMITER //
CREATE PROCEDURE s_inProd()
BEGIN
    DECLARE c INT; -- contatore 
    DECLARE nome VARCHAR(50); -- Variabile per il prodotto
    DECLARE descr VARCHAR(200); -- Variabile per la descrizione
    declare prezzo float(53); -- prezzo 
    INSERT INTO Prodotto(nome,descrizione,prezzo) values ("maggese","terreno a riposo",0);
    SET c = 2;
    START TRANSACTION;
    WHILE c <= 20 DO
        SET nome = CONCAT("Prodotto qualunque_",c);
        SET descr = CONCAT("Descrizione prodotto_",c);
        set prezzo = rand()*4+1;
        INSERT INTO Prodotto(nome,descrizione,prezzo) VALUES (nome,descr,prezzo);
        SET c = c + 1;
    END WHILE;
    COMMIT;
END; // 
DELIMITER ;
CALL s_inProd();
SELECT "*********Prodotti Inseriti*********";





-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella "Viene Coltivato"
-- ----------------------------------       


DROP PROCEDURE IF EXISTS s_inVColt;
DELIMITER //
CREATE PROCEDURE s_inVColt()
BEGIN
    DECLARE c INT; -- contatore 
    DECLARE prod INT; -- prodotto
    DECLARE di DATE; -- data inizio coltivazione
    DECLARE df DATE; -- data fine coltivazione
    DECLARE app INT; -- var appoggio
    DECLARE terr INT; -- terreno
    declare j int; -- contatore
    declare var int;
    declare p int;
    declare datai date;
    declare dataf date;
    select count(*) into var from terreno ;
    set j = 1;
    START TRANSACTION;
    while j <= var do
        SET prod = RAND()*19+1;
        CALL randoData("2000-1-1",di);
        SET app = RAND()*9+1;
        SET app = app + 10;
        IF app >12 THEN 
            SET app = app % 12;
            SET df = date_add(di,interval 1 year);
            SET df = date_add(di,interval app month);
        ELSE
            SET df = di;
            SET df = date_add(di,interval app month);
        END IF;
             INSERT INTO Viene_Coltivato(terreno,prodotto,data_inizio,data_fine) VALUES (j,prod,di,df);          
     set j = j + 1;
   end while;
    set j = 1;
    while j<=var do
        select data_fine into di from viene_coltivato where terreno = j;
        SET prod = RAND()*19+1;
        set di=date_add(di,interval 1 month);
        CALL randoData("2000-1-1",di);
         SET app = RAND()*9+1;
        SET app = app + 10;
        IF app >12 THEN 
            SET app = app % 12;
            SET df = date_add(di,interval 1 year);
            SET df = date_add(di,interval app month);
        ELSE
            SET df = di;
            SET df = date_add(di,interval app month);
        END IF;
             INSERT INTO Viene_Coltivato(terreno,prodotto,data_inizio,data_fine) VALUES (j,prod,di,df);          
     set j = j + 1;
     end while;
END; //
DELIMITER ;
CALL s_inVColt();
SELECT "*********Viene Coltivato Inseriti*********";




-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Coltiva
-- ----------------------------------

DROP PROCEDURE IF EXISTS s_inColt;
DELIMITER //
CREATE PROCEDURE s_inColt()
BEGIN 
    DECLARE c INT; -- contatore
    DECLARE j INT; -- contatore
    DECLARE terr INT; -- terreno
    declare p int;
    declare var int;
    declare dino int;
    declare t int;
    select count(*) into var from contadino;
    set j = 1;
    set t = 1;
    start transaction;
    while j <= var do
        set c = 1;
        while c<=2 do 
         insert into coltiva (terreno,contadino) values (t,j);
         set c = c + 1;
         set t = t +1;
        end while;
            set j = j+1;
    end while;
    set j = 1;
    set t = 1;
    select count(*) into var from terreno;
    while j<=var do
        set c = 1;
        while c <= 2 do 
            select contadino.id_contadino into dino from contadino order by rand() limit 1;
            select count(*) into p from Coltiva,Terreno where coltiva.contadino = dino and coltiva.terreno = terreno.id_terreno and terreno.id_terreno = j;
            if (p=0)then
            
                INSERT INTO Coltiva (terreno,contadino) VALUES (j,dino);
                SET c = c + 1;
            end if;
        end while;
        set j = j +1;
    end while;
END; //
DELIMITER ;
CALL s_inColt();
SELECT"*********Coltiva Inseriti*********";


-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Analizza
-- ----------------------------------

DROP PROCEDURE IF EXISTS s_inAna;
DELIMITER //
CREATE PROCEDURE s_inAna()
BEGIN 
    declare c int; -- contatore
    declare j int; -- contatore
    declare b int;
    declare p int;
    declare t int;
    declare var int;
    declare agro int;
    select count(*) into var from agronomo ;
    set j = 1;
    set t = 1;
    start transaction;
    while j<=var do
        set c = 1;
        while c<=5 do 
         insert into Analizza (terreno,agronomo) values (t,j);
         set c = c + 1;
         set t = t +1;
        end while;
            set j = j+1;
    end while;
    set j = 1;
    set t = 1;
    select count(*) into var from terreno;
    while j<=var do
        set c = 1;
        while c <= 3 do 
            select agronomo.id_agronomo into agro from agronomo order by rand() limit 1;
            select count(*) into p from analizza,Terreno where analizza.agronomo = agro and analizza.terreno = terreno.id_terreno and terreno.id_terreno = j; 
            if (p=0)then
                INSERT INTO Analizza (terreno,agronomo) VALUES (j,agro);
                SET c = c + 1;
            end if;
        end while;
        set j = j +1;
    end while;
end; //
delimiter ;
call s_inAna();
SELECT"*********Analizza inseriti*********";



-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Macchina Agricola
-- ----------------------------------


DROP PROCEDURE IF EXISTS s_inMA;
DELIMITER //
CREATE PROCEDURE s_inMA()
BEGIN 
    DECLARE c INT; -- contatore
    DECLARE cav INT; -- cavalli
    DECLARE km INT; -- km effettuati
    SET c = 1;
    START TRANSACTION;
    WHILE c <= 20 DO
        SET cav = RAND()*90+40;
        SET km = RAND()*100+100;
        INSERT INTO Macchina_Agricola (cavalli,km_effettuati) VALUES (cav,km);
        SET c = c + 1;
    END WHILE;
END; //
DELIMITER ;
CALL s_inMA();
SELECT"*********Macchine Agricole Inserite*********";





-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Utilizza
-- ----------------------------------


DROP PROCEDURE IF EXISTS s_inUt;
DELIMITER //
CREATE PROCEDURE s_inUt()
BEGIN 
    DECLARE c INT; -- contatore
    DECLARE j INT; -- contatore
    DECLARE ma INT; -- macchina agricola
    DECLARE din DATE; -- data inizio
    DECLARE df DATE; -- data fine
    DECLARE app INT; -- variabile d'appoggio
    declare q int; -- flag
    declare p int;
    declare var int;
    SET df = null;
    SET j = 1;
    select count(*) into var from Macchina_Agricola ;
    START TRANSACTION;
    WHILE j <= var DO
        select id_contadino into p from contadino,dipendente where (contadino.mat_dip = dipendente.matricola) and (dipendente.n_patente is not null) order by rand() limit 1;
                CALL randoData("2000-1-1",din);
                SET app = RAND()*2+1;
                SET app = app + 10;
                IF app >12 THEN 
                    SET app = app % 12;
                    SET df = date_add(din,interval 1 year);
                    SET df = date_add(din,interval app month);
                ELSE
                    SET df = din;
                    SET df = date_add(din,interval app month);
                END IF;
                select count(*) into q from utilizza where utilizza.contadino = p and utilizza.macchina_agricola = j;
                if (q=0) then
                
                INSERT INTO Utilizza (macchina_agricola,contadino,data_inizio,data_fine) VALUES (j,p,din,df);
                SET j = j + 1;
                end if;
    END WHILE;
END; //
DELIMITER ;
CALL s_inUt();
SELECT"*********Utilizza Inseriti*********";




-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Specializzato
-- ----------------------------------


DROP PROCEDURE IF EXISTS s_inSpec;
DELIMITER //
CREATE PROCEDURE s_inSpec()
BEGIN 
    declare c int; -- contatore
    declare j int; -- contatore
    declare a int; -- animale random
    declare b int;
    declare p int;
    declare var int;
    set j=1;
   select count(*) into var from agronomo ;
   while j <= var do
    set b=1;
       while ( b<= 5)do
            select tipo_di_allevamento.id_tipo into a from Tipo_di_Allevamento order by rand() limit 1;
            select count(*) into p from specializzato,tipo_di_allevamento where specializzato.agronomo=j and specializzato.tipo_allevamento = Tipo_di_Allevamento.id_tipo and tipo_di_allevamento.id_tipo = a;
        if p = 0 then
        select j;
            insert into specializzato (agronomo,tipo_allevamento) values(j,a);
                
                      set b = b+1;
        end if;
        end while;
      set j = j+1;
    end while;
end; // 
delimiter ;
call s_inSpec();
SELECT"*********Specializzato Inseriti*********";








-- ----------------------------------
-- Procedura per l'inserimento dei dati 
-- nella tabella Visita
-- ----------------------------------


DROP PROCEDURE IF EXISTS s_inVis;
DELIMITER //
CREATE PROCEDURE s_inVis()
BEGIN 
    declare c int; -- contatore
    declare j int; -- contatore
    declare a int; 
    declare b int;
    declare p int;
    declare var int;
    declare al int;
    declare q int;
    declare agro int;
   set j= 1;
    select count(*) into var from allevamento;
    while j<= var do 
           select agronomo.id_agronomo into agro from agronomo order by rand() limit 1;
         select count(*) into q from agronomo,specializzato,tipo_di_allevamento,allevamento where agro = specializzato.agronomo and specializzato.tipo_allevamento = Tipo_di_Allevamento.id_tipo and allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo and allevamento.id_allevamento = j ;
        select count(*) into p from visita where visita.agronomo=agro and visita.allevamento = j;
       if p = 0 and q > 0 then
        select "visita",j;
            insert into Visita (agronomo,allevamento) values(agro,j);

            set j = j+1;
        end if;

      end while;

    set j = 1;
    select count(*) into var from agronomo;
    start transaction;
     while j <= var do
     set b = 1;
       while b<= 2 do
       
        select allevamento.id_allevamento into al from allevamento order by rand() limit 1;
        select count(*) into q from agronomo,specializzato,tipo_di_allevamento,allevamento where j = specializzato.agronomo and specializzato.tipo_allevamento = Tipo_di_Allevamento.id_tipo and allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo and allevamento.id_allevamento = al;
        select count(*) into p from visita where visita.agronomo=j and visita.allevamento = al;

        if p = 0 and q > 0 then
        select "visita",j;
            insert into Visita (agronomo,allevamento) values(j,al);

            set b = b+1;
        end if;

      end while;
    set j = j+1;
    end while;
end; // 
delimiter ;
call s_inVis();
SELECT"*********Visita Inseriti*********";
