-- ----------------------------------------------------------------------------------------
-- Trigger Coltiva
-- Questo trigger si attiva quando si vuole inserire una tupla nella tabella Coltiva.
-- Controlla il corretto inserimento della data d'inizio e di fine coltivazione (din < df).
-- ----------------------------------------------------------------------------------------


drop trigger if exists trigger_coltiva;
delimiter // 
create trigger trigger_coltiva 
BEFORE INSERT on viene_coltivato
for each row 
begin
	declare messaggio varchar(200); -- messaggio di output

    declare data_inizio date; -- data inizio coltivazione prodotto
    declare data_fine date; -- data fine coltivazione prodotto
    
    if(new.data_fine <= new.data_inizio) then 
    	set messaggio = 'ERRORE: LA DATA DI FINE COLTIVAZIONE DEL PRODOTTO NON PUO\' ESSERE MINORE E/O UGUALE ALLA DATA DI INIZIO COLTIVAZIONE';
    	signal sqlstate '45000' set message_text = messaggio;
    end if;
end //
delimiter ;


-- ----------------------------------------------------------------------------------------
-- Trigger Utilizza
-- Questo trigger si attiva quando si vuole inserire una tupla nella tabella Utilizza.
-- Controlla se il dipendente è un contadino e se quest'ultimo è in possesso di patente.
-- Se non è un contadino e\o non è in possesso di patente allora si impedisce l'inserimento della tupla.
-- ----------------------------------------------------------------------------------------

drop trigger if exists trigger_utilizza;
delimiter //
create trigger trigger_utilizza
before insert on Utilizza 
for each row
begin
		declare q int; -- risultato select

		declare messaggio varchar(200); -- messaggio di output
		select dipendente.n_patente into q from dipendente,contadino where dipendente.matricola = new.contadino ;
		if q = null then
			set messaggio = ' ERRORE: IL DIPENDENTE SELEZIONATO NON PUO\' UTILIZZARE UNA MACCHINA AGRICOLA PERCHE\' NON E\' IN POSSESSO DI UNA PATENTE VALIDA';
			signal sqlstate '45000' set message_text = messaggio;
		end if;
end; // 
delimiter ;  
			