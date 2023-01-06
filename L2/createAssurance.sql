drop database if exists assurance;
create database if not exists assurance;

use assurance;

create table if not exists client( 
    id_client int primary key auto_increment, 
    nom varchar(35) not null, 
    adresse varchar(35)
);


create table if not exists contrat(
    id_contrat int primary key auto_increment,
    type enum('habitation','RC','casco') default 'RC' not null,
    date_contrat datetime not null default now(),
    id_client int not null,
    constraint fk_contrat_client foreign key (id_client) references client(id_client) on delete cascade
);



create table if not exists vehicule(
    id_vehicule int primary key auto_increment,
    no_chassis int not null unique,
    modele varchar(20) not null,
    annee int(4) not null,
    cylindre char(3) not null,
    id_client int,
    id_contrat int,
    constraint anneechk check (annee > 2000),
    constraint cylindrechk check (cylindre like '_L_'),
    constraint fk_vehicule_client foreign key (id_client) references client(id_client) on delete set null,
    constraint fk_vehicule_contrat foreign key (id_contrat) references contrat(id_contrat) on delete set null
);


#mysql trigger to check if id_contrat in vehicule is id_client in contrat
create trigger if not exists fk_vehicule_contrat_check
before insert on vehicule
for each row
begin
    if new.id_contrat is not null then
        if (select id_client from contrat where id_contrat = new.id_contrat) != new.id_client then
            signal sqlstate '45000'
            set message_text = 'id_contrat does not match id_client';
        end if;
    end if;
end;

#mysql trigger to check if id_contrat in vehicule is id_client in contrat on modify
create trigger if not exists fk_vehicule_contrat_check_mod
before update on vehicule
for each row
begin
    if new.id_contrat is not null then
        if (select id_client from contrat where id_contrat = new.id_contrat) != new.id_client then
            signal sqlstate '45000'
            set message_text = 'id_contrat does not match id_client';
        end if;
    end if;
end;

create table if not exists sinistre(
    id_sinistre int primary key auto_increment,
    date_sinistre date not null,
    montant int not null,
    constraint montantchk check (montant > 0 and montant < 9000)
);

create table if not exists implication(
    id_sinistre int,
    id_vehicule int,
    primary key(id_sinistre, id_vehicule),
    constraint id_sinistre foreign key (id_sinistre) references sinistre(id_sinistre),
    constraint id_vehicule foreign key (id_vehicule) references vehicule(id_vehicule),
    constraint nbsininstre check (id_sinistre <=50000)
);











