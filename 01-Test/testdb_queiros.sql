# Auteur : Adriano José Queirós da Silva
# Date : 10.01.2023



drop database if exists taches_db;


# Question 1
create database taches_db;

use taches_db;

# Question 2
create table employe(
    id_employe int primary key auto_increment,
    prenom varchar(45) not null,
    nom varchar(45) not null,
    date_embauche date not null,
    index (prenom)
);

# Question 3
insert into employe (prenom, nom, date_embauche) values('Alice','Bonjour', '2018-10-03');
insert into employe (prenom, nom, date_embauche) values('David','Rossi', '2021-04-05');
insert into employe (prenom, nom, date_embauche) values('Nicolas','Rotondo', '2023-01-01');

# Question 4
create table tache(
    id_tache int primary key auto_increment,
    nom varchar(15) not null unique,
    tarif_horaire decimal(5,2) not null default 90
    constraint tarif_horaire_check check (tarif_horaire >= 60 and tarif_horaire <= 200),
    index (nom)
);

# Question 5
insert into tache (nom,tarif_horaire) values('support', 70);
insert into tache (nom,tarif_horaire) values('audit', 180);
insert into tache (nom,tarif_horaire) values('administration', 120);
#insert into tache (nom,tarif_horaire) values('divers', 30);
#ERROR 3819 (HY000) at line 39: Check constraint 'tarif_horaire_check' is violated.

# Question 6
create table tache_employe(
    id_tache_employe int primary key auto_increment,
    id_employe int not null,
    id_tache int not null,
    nombre_heures int not null,
    date_tache date not null,
    unique (id_employe, id_tache, date_tache),
    constraint ni_samedi_ni_dimanche check(dayofweek(date_tache) not in (1,7)),
    foreign key (id_employe) references employe(id_employe) on delete restrict on update cascade,
    foreign key (id_tache) references tache(id_tache) on delete cascade on update cascade
);

# Question 7
insert into tache_employe (id_employe, id_tache, nombre_heures, date_tache) values((select id_employe from employe where prenom = 'Alice'),(select id_tache from tache where nom = "audit"),9 , '2022-12-22');
insert into tache_employe (id_employe, id_tache, nombre_heures, date_tache) values((select id_employe from employe where prenom = 'David'),(select id_tache from tache where nom = "administration"),8 , '2022-12-21');
insert into tache_employe (id_employe, id_tache, nombre_heures, date_tache) values((select id_employe from employe where prenom = 'David'),(select id_tache from tache where nom = "support"),6 , '2022-12-22');
insert into tache_employe (id_employe, id_tache, nombre_heures, date_tache) values((select id_employe from employe where prenom = 'David'),(select id_tache from tache where nom = "support"),8 , '2022-12-23');

# Question 8

#1
select prenom, nom, tache_employe.date_tache from employe inner join tache_employe on employe.id_employe = tache_employe.id_employe;

#2
select prenom, nom from employe where id_employe not in (select id_employe from tache_employe);

#3
select distinct prenom, employe.nom from employe inner join tache_employe te on employe.id_employe = te.id_employe inner join tache t on te.id_tache = t.id_tache where t.nom like 'a%';

#4
select prenom, employe.nom, sum(nombre_heures) from employe inner join tache_employe te on employe.id_employe = te.id_employe inner join tache t on te.id_tache = t.id_tache where date_tache between '2022-12-20' and '2022-12-24' group by prenom, employe.nom;

#5 
select prenom, employe.nom from employe inner join tache_employe te on employe.id_employe = te.id_employe inner join tache t on te.id_tache = t.id_tache group by prenom, employe.nom having count(*) > 2;

#6
select prenom, employe.nom, sum(tarif_horaire * nombre_heures) from employe inner join tache_employe te on employe.id_employe = te.id_employe inner join tache t on te.id_tache = t.id_tache where month(date_tache) = 12  group by prenom, employe.nom;

# Question 9

alter table tache modify nom varchar(25);
