CREATE INDEX index_allevamento_id_allevamento ON allevamento(id_allevamento);
CREATE INDEX index_visita_allevamento ON visita(allevamento);
CREATE INDEX index_agronomo_mat_dip ON agronomo(mat_dip);
CREATE INDEX index_dipendente_matricola ON dipendente(matricola);
CREATE INDEX index_terreno_id_terreno ON terreno(id_terreno);
CREATE INDEX index_analizza_terreno ON analizza(terreno);
CREATE INDEX index_agronomo_id_agronomo ON agronomo(id_agronomo);
CREATE INDEX index_contadino_id_contadino ON contadino(id_contadino);
CREATE INDEX index_coltiva_contadino ON coltiva(contadino);
CREATE INDEX index_coltiva_terreno ON coltiva(terreno);
CREATE INDEX index_viene_coltivato on viene_coltivato(prodotto);


-- 3 )) Seleziona id,nome,cognome, il numero di allevamenti che visitano,il numero di terreni   che analizzano e lo stipendio annuale degli agronomi guadagnano  più di 1500€
select 
        p.m1 as IDAgronomo,
        p.n1 as Nome,
        p.c1 as Cognome,
        p.sa1 as StipendioAnnuale,
        ifnull(p.t,"Nessuno") as TerreniAnalizzati,
        ifnull(q.r,"Nessuno") as AllevamentiVisitati
from 
       (select  nome as n1,cognome as c1,stipendio_annuale as sa1,count(*) as t,id_agronomo as m1  from dipendente force index(index_dipendente_matricola),analizza force index(index_analizza_terreno),terreno force index(index_terreno_id_terreno ),agronomo force index (index_agronomo_id_agronomo) where dipendente.matricola =agronomo.mat_dip and agronomo.id_agronomo = analizza.agronomo and analizza.terreno=terreno.id_terreno group by agronomo having sa1 >=1500) as p
       left join
       (select  nome as n2,cognome as c2,stipendio_annuale as sa2,count(*) as r,id_agronomo as m2 from dipendente force index(index_dipendente_matricola),visita force index(index_visita_allevamento),allevamento force index(index_allevamento_id_allevamento),agronomo force index (index_agronomo_id_agronomo) where dipendente.matricola =agronomo.mat_dip and agronomo.id_agronomo = visita.agronomo and visita.allevamento=allevamento.id_allevamento group by agronomo having sa2>=1500 ) as q
        on p.m1 = q.m2 
    order by  (StipendioAnnuale)DESC;





-- 7 )Seleziona il terreno più grande con più di un dipendente che lavora ad esso,la città,la via in cui si trova ed il numero totale di dipendenti (agronomi e contadini) che lavorano a quel terreno 

select 
    terreno.id_terreno as IdTerreno,
    terreno.dimensione as Dimensione,
    ifnull(ag.a,0)+ifnull(con.c,0) as DipendentiCheSeNeOccupano,
    ifnull(ag.a,0) as AgronomiCheAnalzzano,
    ifnull(con.c,0) as ContadiniCheColtivano
from 
    
    (select id_terreno as ita ,dimensione as dimta,count(*) as a from agronomo force index(index_agronomo_id_agronomo),analizza force index(index_analizza_terreno),terreno force index (index_terreno_id_terreno) where agronomo.id_agronomo = analizza.agronomo and analizza.terreno=terreno.id_terreno group by ita ) as ag
    left join 
    (select id_terreno as itc,dimensione as dimtc, count(*) as c from contadino force index(index_contadino_id_contadino),coltiva force index(index_coltiva_terreno),terreno force index (index_terreno_id_terreno) where contadino.id_contadino = coltiva.contadino and coltiva.terreno = terreno.id_terreno group by itc ) as con
    on ag.ita = con.itc
    left join
    terreno
    on terreno.id_terreno = ag.ita
    having DipendentiCheSeNeOccupano >=1
    order by Dimensione DESC limit 1;


    -- 17 ) Seleziona gli agronomi che visitano l’allevamento di struzzi più costoso

select 
    id_agronomo as Agronomo,
    d.nome as Nome,
    d.cognome as Cognome,
     s1.ida as IdAllevamento,
     s1.pa as PrezzoTotaleStruzzi
from 
    agronomo as a,visita force index(index_visita_allevamento) ,dipendente as d, (select id_allevamento as ida, qta*prezzo as pa from allevamento force index(index_allevamento_id_allevamento) ,tipo_di_allevamento where allevamento.tipo_allevamento = tipo_di_allevamento.id_tipo and tipo_di_allevamento.descrizione ="struzzi" order by pa DESC limit 1) as s1
where 
    visita.allevamento = s1.ida and visita.agronomo = a.id_agronomo and a.mat_dip = d.matricola;


 -- 20) seleziona per ogni prodotto il numero di terreni che coltivano il prodotto tranne maggese

select 
        prodotto as Prodotto,
        nome as NomeProdotto,
        descrizione as DescProdotto,
        count(*) as NumeroTerreni
    from
        viene_coltivato force index (index_viene_coltivato),prodotto
    where 
        viene_coltivato.prodotto = prodotto.id_prodotto and prodotto.nome <> "maggese" group by prodotto;
