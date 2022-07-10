use universita;

create table studenti(
id int not null auto_increment,
nome varchar(255) not null,
cognome varchar(255) not null,
data_di_nascita date not null,
email varchar(255) not null unique,
anno_di_immatricolazione year not null,
primary key(id)
);

create table esami(
id int not null auto_increment,
nome varchar(255) not null,
data_svolgimento date not null,
ora time not null,
cfu smallint not null,
primary key(id)
);

create table corsi_di_laurea(
id int not null auto_increment,
nome varchar(255) not null,
durata int not null,
id_dipartimento int not null,
id_professore_responsabile int not null,
primary key(id)
);

create table professori(
id int not null auto_increment,
nome varchar(255) not null,
cognome varchar(255) not null,
data_di_nascita date not null,
primary key(id)
);

create table dipartimenti(
id int not null auto_increment,
nome varchar(255) not null,
id_professore_responsabile int not null,
primary key(id)
);

create table studenti_esami(
id_studente int not null,
id_esame int not null,
primary key(id_studente, id_esame)
);

alter table studenti_esami 
add constraint foreign key(id_studente) references studenti(id);

alter table studenti_esami 
add constraint foreign key(id_esame) references esami(id);

alter table corsi_di_laurea 
add constraint foreign key(id_professore_responsabile) references professori(id);

alter table corsi_di_laurea 
add constraint foreign key(id_dipartimento) references dipartimenti(id);

alter table dipartimenti 
add constraint foreign key(id_professore_responsabile) references proferssori(id);

-- popolo le tabelle

insert into studenti(nome, cognome, data_di_nascita, email, anno_di_immatricolazione)
values ('Michelangelo', 'De Nicola', '1999-05-26', 'mikidenicola@gmail.com', 2018),
('Enza', 'De Nicola', '2003-01-07', 'enzadenicola@gmail.com', 2003),
('Pietro', 'Natale', '2000-04-27', 'pietronatale@gmail.com', 2022);

insert into professori(nome, cognome, data_di_nascita)
values('Francesco', 'Limone', '1955-08-23'),
('Teresa', 'Murino', '1970-06-04');

insert into dipartimenti(nome, id_professore_responsabile)
values('dipartimento di ingegneria industriale', 2);

insert into corsi_di_laurea(nome, durata, id_dipartimento, id_professore_responsabile)
values('ingegneria gestionale', 3, 1, 2),
('ingegneria meccanica', 3, 1, 1);

insert into esami(nome, data_svolgimento, ora, cfu)
values('meccanica razionale', '2021-02-12', '09:00', 12),
('basi di dati', '2022-07-01', '10:00', 9);


-- bonus arbitrario -> provo trigger sulla tabella

-- 1.L'inserimento di nome e cognome sulla tabella studenti avviene con caratteri maiuscoli: 
-- implementa un before trigger che all'atto dell'inserimento porta tutti i caratteri al maiuscolo
create trigger studente_bef_ins    -- create nome trigger
before insert on studenti          -- before/after evento scatenante (fire)
for each row                       -- applicato ad ogni riga
begin      
	:new.nome := upper(:new.Nome);
    :new.cognome := upper(:new.Cognome);
end;

-- 2.Controllo sull'orario dell'esame: all'atto dell'inserimento sulla tabella esami (before sull'ins), controlla che l'orario
-- di inserimento dell'esame sia maggiore dell'ora attuale (e che la data sia maggiore di quella odierna)
create or replace trigger esame_bef_ins
before insert on esami
for each ROW 
DECLARE                 -- introduce la sezione dichiarativa -> le variabili sono visibili solo all'interno del trigger 
errore exception;
begin
	if to_char(:new.ora,'hh24.mi.ss') < to_char(sysdate,'hh24.mi.ss')
	then raise errore;
end if;
if to_char(:new.data_svolgimento) < to_char(sysdate)
    then raise errore;
end if;
exception               -- sollevo un errore utente con una condizione when ->
when errore then raise_application_error (-20001,'data non valida');
end;





















