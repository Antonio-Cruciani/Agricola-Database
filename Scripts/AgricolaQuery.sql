--1) Seleziona id agronomo, matricola, nome, allevamento che visita, di che allevamento si  
--  tratta,in quale città si trova e la via dell' allevamento, ordinato crescentemente 
    

SELECT  
        agronomo.id_agronomo as IDAgronomo ,
        dipendente.matricola as MatricolaDipendente,
        dipendente.nome as Nome,
        tipo_di_allevamento.nome as TipodiAllevamento,
        citta.nome as Città,
        allevamento.via as Via 
FROM 
    agronomo,dipendente,visita,allevamento,tipo_di_allevamento,citta 
WHERE 
        agronomo.id_agronomo = visita.agronomo 
        and visita.allevamento = allevamento.id_allevamento 
        and dipendente.matricola=agronomo.mat_dip 
        and allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo 
        and allevamento.citta = citta.id_citta 
order by id_agronomo
;

--  (7.18 sec)


-- 2) Seleziona le cantine che vendono vini risalenti al periodo 1968 - 1986 con una scorta      >= 70


select 
    cantina.id_cantina as IdCantina,
    cantina.via as Via,
    citta.nome as NomeCitta,
    data_produzione as DataProduzione,
    venduto.qta as Qta
FROM
    cantina,venduto,citta
where
    citta.id_citta = cantina.citta and 
    cantina.id_cantina = venduto.cantina and
    YEAR(venduto.data_produzione) between '1968' and '1970'
    group by IdCantina
    having (Qta >= 70);

-- (3.29 sec)

-- 3) Seleziona id,nome,cognome, il numero di allevamenti che visitano,il numero di terreni   
--   che analizzano e lo stipendio annuale degli agronomi guadagnano  più di 1500€



select 
        p.m1 as IDAgronomo,
        p.n1 as Nome,
        p.c1 as Cognome,
        p.sa1 as StipendioAnnuale,
        ifnull(p.t,"Nessuno") as TerreniAnalizzati,
        ifnull(q.r,"Nessuno") as AllevamentiVisitati
from 
       (select  nome as n1,cognome as c1,stipendio_annuale as sa1,count(*) as t,id_agronomo as m1  from dipendente,analizza,terreno,agronomo  where dipendente.matricola =agronomo.mat_dip and agronomo.id_agronomo = analizza.agronomo and analizza.terreno=terreno.id_terreno group by agronomo having sa1 >=1500) as p
       left join
       (select  nome as n2,cognome as c2,stipendio_annuale as sa2,count(*) as r,id_agronomo as m2 from dipendente,visita,allevamento,agronomo where dipendente.matricola =agronomo.mat_dip and agronomo.id_agronomo = visita.agronomo and visita.allevamento=allevamento.id_allevamento group by agronomo having sa2>=1500 ) as q
        on p.m1 = q.m2 
    order by  (StipendioAnnuale)DESC;

-- (4 min 24.49 sec)

-- 4) Seleziona IdContadino, Matricola, Nome, Cognome, Numero di Patente, Data inizio  utilizzo, Data fine utilizzo, IdMacchina, Cavalli
 --   di tutti i contadini con patente che utilizzano una macchina agricola.




SELECT 
        id_contadino as IDContadino,
        matricola as Matricola,
        nome as Nome,
        cognome as Cognome,
        n_patente as NumeroPatente,
        data_inizio as DataInizioUtilizzo,
        data_fine as DataFineUtilizzo,
        id_macchina as IDMacchina,
        cavalli as Cavalli
FROM
        dipendente,contadino,utilizza,macchina_agricola
WHERE   contadino.mat_dip=dipendente.matricola 
        and utilizza.contadino=contadino.id_contadino 
        and utilizza.macchina_agricola=macchina_agricola.id_macchina 
ORDER BY contadino.id_contadino;
--(0.02 sec)


-- 5) Le province che hanno piu superficie di terreni (ed il numero di terreni) della provincia: provincia qualunque_3 con nested query

select c.provincia,sum(t.dimensione) as DimensioneTerreni,count(*) as NumeroDiTerreni
from terreno t,citta c
where t.citta = c.id_citta 
group by c.provincia 
having(sum(t.dimensione))>(select sum(t1.dimensione)
                           from terreno t1,citta c1
                            where t1.citta = c1.id_citta and c1.provincia="provincia qualunque_14");
-- (1.45 sec)
-- variante con sub query nel from

select c.provincia,sum(t.dimensione) as DimensioneTerreni,count(*) as NumeroDiTerreni,pq3.somma as supterreniprovinciaqual3
from citta c,terreno t,(select sum(t1.dimensione)as somma
                         from citta c1,terreno t1
                        where t1.citta = c1.id_citta and c1.provincia ="provincia qualunque_14") as     pq3
where t.citta = c.id_citta
group by c.provincia
having (sum(t.dimensione))>pq3.somma;


-- 6) per ogni provincia seleziona il numero di attività totali presenti ( allevamenti,terreni coltivati e cantine) 

        select 
            citta.provincia as Provincia,
            ifnull(a.c,0)+ifnull(c.c,0)+ifnull(t.c,0) as NumeroDiAttività,
            ifnull(a.c,0) as Allevamenti,
            ifnull(c.c,0) as Cantine,
            ifnull(t.c,0) as Terreni
        from 
            citta
            left join
            (select provincia as pc, count(*) as c from citta left join cantina on citta.id_citta = cantina.citta   group by pc ) as c
            on citta.provincia = c.pc
            left join
            (select provincia as pa, count(*) as c from citta left join allevamento on citta.id_citta = allevamento.citta group by pa) as a
            on c.pc=a.pa
            left join 
            (select provincia as pt, count(*) as c from terreno left join citta on citta.id_citta = terreno.citta group by pt ) as t
            on c.pc = t.pt
          group by provincia;

-- (2.62 sec)


-- 7) Seleziona il terreno più grande con più di un dipendente che lavora ad esso,la città,la via in cui si trova ed il numero totale di dipendenti (agronomi e contadini) che lavorano a quel terreno 
 
select 
    terreno.id_terreno as IdTerreno,
    terreno.dimensione as Dimensione,
    ifnull(ag.a,0)+ifnull(con.c,0) as DipendentiCheSeNeOccupano,
    ifnull(ag.a,0) as AgronomiCheAnalzzano,
    ifnull(con.c,0) as ContadiniCheColtivano
from 
    (select id_terreno as ita ,dimensione as dimta,count(*) as a from agronomo,analizza,terreno where agronomo.id_agronomo = analizza.agronomo and analizza.terreno=terreno.id_terreno group by ita ) as ag
    left join 
    (select id_terreno as itc,dimensione as dimtc, count(*) as c from contadino,coltiva,terreno where contadino.id_contadino = coltiva.contadino and coltiva.terreno = terreno.id_terreno group by itc ) as con
    on ag.ita = con.itc
    left join
    terreno
    on terreno.id_terreno = ag.ita
    having DipendentiCheSeNeOccupano >=1
    order by Dimensione DESC limit 1;

 -- (12 min 13.00 sec)


-- 8) visualizzare l'allevamento con il prezzo totale degli esemplari maggiore 

select
    id_allevamento as Id,
    qta as Quantità,
    prezzo*qta as CostoTotale,
    tipo_allevamento as TipodiAllevamento,
    nome as NomeTipo,
    citta as Città,
    via as Via
from 
    allevamento as a
    left join 
    tipo_di_allevamento as t
    on a.tipo_allevamento = t.id_tipo
    order by CostoTotale desc limit 1;

 --(1.48 sec)


-- 9) Calcolare la spesa totale dell'azienda ovvero, la somma degli stipendi annuali più il costo totale degli 
--    animali allevati in ogni allevamento più i prodotti coltivati (considerando che 1kg di prodotto per ogni ettaro di terreno) e 
--    la spesa di produzione dei vini considerando che il prezzo di produzione del vino = prezzo del vino in vendita - 20% - 5 

select 
    s1.sa as SpesaStipendi,
    s2.pa as SpesaAllevamenti,
    s3.pt as SpesaTerreni,
    s4.pv as SpesaVini,
    s1.sa + s2.pa + s3.pt + s4.pv as Spesatotale
from 
    (select sum(stipendio_annuale) as sa from dipendente) as s1,
    (select sum(qta*prezzo) as pa from allevamento  as a,tipo_di_allevamento as ta where a.tipo_allevamento = ta.id_tipo ) as s2,
    (select sum(prezzo*dimensione) as pt from terreno as t,viene_coltivato as vc,prodotto as p where t.id_terreno = vc.terreno and vc.prodotto = p.id_prodotto ) as s3,
    (select sum((prezzo*qta)-(0.02)*(prezzo*qta)-5) as pv from tipo_di_vino as v, venduto as ve, cantina as ca where v.id_vino = ve.vino and ca.id_cantina = ve.cantina ) as s4
;

-- (30.13 sec)

-- 10) Selezionare la citta con l'allevamento di maiali più grande ed il terreno più grande presente in quella città

    select
    citta.nome as NomeCitta, 
    a.qm as NumeroMaiali,
    t.dm as DimensioneTerreno

from
    (select allevamento.qta as qm, id_allevamento as ida, citta as ca from allevamento,tipo_di_allevamento where allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo and tipo_di_allevamento.descrizione="maiale"   ) as a,
    (select dimensione as dm, id_terreno as idt, citta as ct from terreno ) as t,
     citta
where 
    citta.id_citta = a.ca and a.ca = t.ct
    order by NumeroMaiali,DimensioneTerreno desc limit 1;

-- (0.81 sec)

-- 11) Seleziona qual è la città con la cantina che vende più vini

select
        s.nvini as Numero,
        s.c as Città
    from 
        (select sum(qta) as nvini, citta.nome as c from cantina,citta,venduto where citta.id_citta = cantina.citta and cantina.id_cantina = venduto.cantina group by citta.nome) as s
        order by Numero desc limit 1;
--  (12.24 sec)

-- 12) elencare tutte le città con più di 1000 allevamenti di cani

select 
     count(*) as NumeroAllevamenti, 
     allevamento.via as Via,
     citta.provincia as Provincia,
     tipo_di_allevamento.descrizione as Descrizione 
from 
     allevamento,tipo_di_allevamento,citta
where 
    allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo and tipo_di_allevamento.descrizione = "cani" and allevamento.citta = citta.id_citta 
group by provincia
having (NumeroAllevamenti>=1000) ;
-- (0.47 sec)

-- 13) Seleziona tutti gli agronomi che analizzano il prodotto:" Prodotto qualunque_2" e che sono specializzati in gatti e pesci o in una soltanto delle due tipologie di animali
select 
    dipendente.nome as NomeAgronomo,
    cognome as Cognome,
    matricola as Matricola,
    anno_nascita as DataNascita
FROM
    dipendente,agronomo,terreno,viene_coltivato,prodotto,analizza,
    (select agronomo as ida from specializzato,tipo_di_allevamento 
     where specializzato.tipo_allevamento = tipo_di_allevamento.id_tipo and (tipo_di_allevamento.descrizione ="gatti" or tipo_di_allevamento.descrizione ="pesci" or tipo_di_allevamento.descrizione ="gatti" and tipo_di_allevamento.descrizione="pesci") group by ida) as sa
where
    dipendente.matricola = agronomo.mat_dip and
    agronomo.id_agronomo = sa.ida and
    agronomo.id_agronomo = analizza.terreno and
    analizza.terreno = terreno.id_terreno and
    terreno.id_terreno = viene_coltivato.terreno and
    viene_coltivato.prodotto= prodotto.id_prodotto and
    prodotto.nome = "Prodotto qualunque_2"    group by Matricola;

--  (0.08 sec)

-- 14) Seleziona i contadini che hanno patente e lavorano i terreni con una macchina agricola

select
    nome as Nome,
    cognome as Cognome,
    n_patente as NumeroPatente,
    sc.dai as DataInizioMa,
    sc.daf as DataFineMA,
    sc1.daic as DataInizioColt,
    sc1.dfc as DataFineColt,
    sc1.idt as IdTerreno,
    sc1.dpc as ProdColtivato
from
    dipendente,
    (select mat_dip as m, id_contadino as idc, data_inizio as dai,data_fine as daf from contadino,utilizza where contadino.id_contadino =utilizza.contadino ) as sc,
    (select coltiva.terreno as idt,prodotto.descrizione as dpc, id_contadino as idc1,data_inizio as daic,data_fine as dfc from prodotto, contadino,coltiva,terreno,viene_coltivato where contadino.id_contadino = coltiva.contadino and coltiva.terreno = terreno.id_terreno and viene_coltivato.terreno = terreno.id_terreno and viene_coltivato.prodotto = prodotto.id_prodotto) as sc1
where 
    matricola = sc.m and 
    sc.idc = sc1.idc1 and 
     sc1.daic between sc.dai and sc.daf
     order by Nome;
--  (10.42 sec)


-- 15) Seleziona i contadini che lavorano in un terreno e non hanno la patente

select distinct 
    nome as Nome,
    cognome as Cognome,
    stipendio_annuale as Stipendio
from dipendente,contadino,coltiva
where dipendente.matricola = contadino.mat_dip and contadino.id_contadino = coltiva.contadino and dipendente.n_patente is null; 
group by nome;

-- (0.12 sec)


-- 16) Selezionare tutti i prodotti che richiedono 3 mesi esatti di tempo per poter essere raccolti

select nome as NomerProdotto,descrizione,data_inizio as DataInizio, data_fine as DataFine
from prodotto p,viene_coltivato vc
where p.id_prodotto = vc.prodotto and ((MONTH(data_fine)-MONTH(data_inizio))=3)
group by p.id_prodotto;

--(4.22 sec)

 -- 17) Seleziona gli agronomi che visitano l’allevamento di struzzi più costoso

select 
    id_agronomo as Agronomo,
    d.nome as Nome,
    d.cognome as Cognome,
     s1.ida as IdAllevamento,
     s1.pa as PrezzoTotaleStruzzi
from 
    agronomo as a,visita as v,dipendente as d, (select id_allevamento as ida, qta*prezzo as pa from allevamento,tipo_di_allevamento where allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo and tipo_di_allevamento.descrizione ="struzzi" order by pa DESC limit 1) as s1
where 
    v.allevamento = s1.ida and v.agronomo = a.id_agronomo and a.mat_dip = d.matricola;

--  (0.51 sec)

-- 18)  seleziona tutti i dipendenti (Matricola,Nome,Cognome,Numero di Telefono) che lavorano nella città con cap :" cap qualunque_272"

(select matricola, dipendente.nome, cognome, n_tel from dipendente,agronomo,visita,allevamento,citta  where dipendente.matricola = agronomo.mat_dip and agronomo.id_agronomo = visita.agronomo and visita.allevamento = allevamento.id_allevamento and allevamento.citta = citta.id_citta and citta.cap = "cap qualunque_272" ) 
UNION 
(select matricola, dipendente.nome, cognome, n_tel from dipendente,agronomo,analizza,terreno,citta  where dipendente.matricola = agronomo.mat_dip and agronomo.id_agronomo = analizza.agronomo and analizza.terreno = terreno.id_terreno and terreno.citta = citta.id_citta and citta.cap = "cap qualunque_272" )
UNION 
(select matricola,dipendente.nome,cognome,n_tel from dipendente,contadino,coltiva,terreno,citta where dipendente.matricola = contadino.mat_dip and contadino.id_contadino = coltiva.contadino and coltiva.terreno = terreno.id_terreno and terreno.citta = citta.id_citta  and citta.cap = "cap qualunque_272"  )  
UNION 
(select matricola,dipendente.nome,cognome,n_tel from dipendente,contadino,lavora_in,allevamento,citta where dipendente.matricola = contadino.mat_dip and contadino.id_contadino = lavora_in.contadino and lavora_in.allevamento = allevamento.id_allevamento and allevamento.citta = citta.id_citta  and citta.cap = "cap qualunque_272"  ) order by matricola;

-- (0.25 sec)

-- 19) Selezionare i dipendenti che hanno tra i 30 anni ed i 40 anni che lavorano per l'azienda

select 
    d.nome as Nome,
    d.cognome as Cognome,
     d.anno_nascita as DataNascita,
    YEAR(CURDATE()) - YEAR (d.anno_nascita) as Età
from 
    dipendente d
where 
    (YEAR(CURDATE()) - YEAR (d.anno_nascita) >= '30') and (YEAR(CURDATE()) - YEAR (d.anno_nascita) <= '40') order by Età;
-- (0.02 sec)


-- 20 ) seleziona per ogni prodotto il numero di terreni che coltivano il prodotto tranne maggese

    select 
        prodotto as Prodotto,
        nome as NomeProdotto,
        descrizione as DescProdotto,
        count(*) as NumeroTerreni
    from
        viene_coltivato,prodotto
    where 
        viene_coltivato.prodotto = prodotto.id_prodotto and prodotto.nome <> "maggese" group by prodotto;

-- (0.60 sec)