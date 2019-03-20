--7) Seleziona il terreno più grande con più di un dipendente che lavora ad esso,la città,la via in cui si trova ed il numero totale di dipendenti (agronomi e contadini) che lavorano a quel terreno 



    select 
    terreno.id_terreno as IdTerreno,
    terreno.dimensione as Dimensione,
    ifnull(AgronomiCheAnalizzano.a,0)+ifnull(ContadiniCheColtivano.c,0) as DipendentiCheSeNeOccupano,
    ifnull(AgronomiCheAnalizzano.a,0) as AgronomiCheAnalzzano,
    ifnull(ContadiniCheColtivano.c,0) as ContadiniCheColtivano
from 
    AgronomiCheAnalizzano
    left join
    ContadiniCheColtivano
    on
    AgronomiCheAnalizzano.ita = ContadiniCheColtivano.itc
    left join
    terreno
    on 
    terreno.id_terreno = AgronomiCheAnalizzano.ita
    having DipendentiCheSeNeOccupano >=1
    order by Dimensione DESC limit 1;



CREATE OR REPLACE VIEW AgronomiCheAnalizzano as
select 
    id_terreno as ita ,
    dimensione as dimta,
    count(*) as a 
from agronomo,analizza,terreno 
where agronomo.id_agronomo = analizza.agronomo and analizza.terreno=terreno.id_terreno 
    group by ita ;

CREATE OR REPLACE VIEW ContadiniCheColtivano as
select
     id_terreno as itc,
     dimensione as dimtc,
      count(*) as c 
from contadino,coltiva,terreno 
where contadino.id_contadino = coltiva.contadino and coltiva.terreno = terreno.id_terreno 
group by itc;




--14) Seleziona i contadini che  hanno patente e lavorano i terreni con una macchina agricola 



select
    nome as Nome,
    cognome as Cognome,
    n_patente as NumeroPatente,
    SelectContadinoUtilizzaMacchinaAgricola.dai as DataInizioMa,
    SelectContadinoUtilizzaMacchinaAgricola.daf as DataFineMA,
    SelectContadinoLavoraTerreno.daic as DataInizioColt,
    SelectContadinoLavoraTerreno.dfc as DataFineColt,
    SelectContadinoLavoraTerreno.idt as IdTerreno,
    SelectContadinoLavoraTerreno.dpc as ProdColtivato
from
    dipendente,
    SelectContadinoLavoraTerreno,
    SelectContadinoUtilizzaMacchinaAgricola
where 
    matricola = SelectContadinoUtilizzaMacchinaAgricola.m and 
    SelectContadinoUtilizzaMacchinaAgricola.idc = SelectContadinoLavoraTerreno.idc1 and 
     SelectContadinoLavoraTerreno.daic between SelectContadinoUtilizzaMacchinaAgricola.dai and SelectContadinoUtilizzaMacchinaAgricola.daf
     order by Nome;


CREATE OR REPLACE VIEW SelectContadinoLavoraTerreno as
select 
    coltiva.terreno as idt,
    prodotto.descrizione as dpc, 
    id_contadino as idc1,
    data_inizio as daic,
    data_fine as dfc 
from 
prodotto, contadino,coltiva,terreno,viene_coltivato 
where 
contadino.id_contadino = coltiva.contadino and 
coltiva.terreno = terreno.id_terreno and 
viene_coltivato.terreno = terreno.id_terreno and 
viene_coltivato.prodotto = prodotto.id_prodotto ;


CREATE OR REPLACE VIEW SelectContadinoUtilizzaMacchinaAgricola as
select 
    mat_dip as m, 
    id_contadino as idc,
    data_inizio as dai,
    data_fine as daf 
from 
contadino,utilizza 
where contadino.id_contadino =utilizza.contadino;


-- 13) Seleziona tutti gli agronomi che analizzano il prodotto:" Prodotto qualunque_2" e che sono specializzati in gatti e pesci o in una soltanto delle due tipologie di animali

select 
    dipendente.nome as NomeAgronomo,
    cognome as Cognome,
    matricola as Matricola,
    anno_nascita as DataNascita
FROM
    dipendente,agronomo,terreno,viene_coltivato,prodotto,analizza,
    SelectAgronomoGattiPesci
where
    dipendente.matricola = agronomo.mat_dip and
    agronomo.id_agronomo = SelectAgronomoGattiPesci.ida and
    agronomo.id_agronomo = analizza.terreno and
    analizza.terreno = terreno.id_terreno and
    terreno.id_terreno = viene_coltivato.terreno and
    viene_coltivato.prodotto= prodotto.id_prodotto and
    prodotto.nome = "Prodotto qualunque_2" 
    group by Matricola;


    CREATE OR REPLACE VIEW SelectAgronomoGattiPesci as
    select 
        agronomo as ida 
    from 
        specializzato,tipo_di_allevamento 
     where 
        specializzato.tipo_allevamento = tipo_di_allevamento.id_tipo and 
        (tipo_di_allevamento.descrizione ="gatti" or 
        tipo_di_allevamento.descrizione ="pesci" or 
        tipo_di_allevamento.descrizione ="gatti" and 
        tipo_di_allevamento.descrizione="pesci") 
    group by ida;