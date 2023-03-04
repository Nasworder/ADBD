#1
DROP USER if exists 'cli1'@'%';
CREATE USER 'cli1'@'%' IDENTIFIED BY 'cli1';

DROP USER if exists 'cli2'@'%';
CREATE USER 'cli2'@'%' IDENTIFIED BY 'cli2';

DROP DATABASE if exists leshop;
CREATE DATABASE leshop;

GRANT CREATE, DROP ON leshop.* TO 'cli1'@'%';
GRANT CREATE, DROP ON leshop.* TO 'cli2'@'%';

############################################ Cli 1 ############################################
#2
use leshop;

drop table if exists client;

create table client(
    id_client int primary key auto_increment,
    nom varchar(25) not null,
    adresse varchar(50) not null,
    NPA smallint(4) not null,
    ville varchar(35) not null
);

#3
insert into client values (1, 'Dupont', 'Rue de la Paix 1', 1000, 'Lausanne');
insert into client values (2, 'Durand', 'Rue de la Gare 2', 2000, 'Neuchatel');
insert into client values (3, 'Dufour', 'Rue de la Gare 3', 3000, 'Biel');
insert into client values (4, 'Dumont', 'Rue de la Gare 4', 4000, 'Fribourg');
insert into client values (5, 'Dulac', 'Rue de la Gare 5', 5000, 'Yverdon');
insert into client values (6, 'Dufresne', 'Rue de la Gare 6', 6000, 'Sion');
insert into client values (7, 'Dussart', 'Rue de la Gare 7', 7000, 'Sierre');
insert into client values (8, 'Dutertre', 'Rue de la Gare 8', 8000, 'Zurich');
insert into client values (9, 'Dutour', 'Rue de la Gare 9', 9000, 'St-Gall');
insert into client values (10, 'Dutertre', 'Rue de la Gare 10', 1000, 'Lausanne');

#4
GRANT insert on leshop.client to 'cli1'@'%';
show grants for 'cli1'@'%';

############################################ Cli 2 ############################################
#5
use leshop;

drop table if exists commande;

create table commande(
    id_commande int primary key auto_increment,
    id_client int not null,
    libellé varchar(255) not null
);

#6
alter table commande add constraint fk_id_client foreign key (id_client) references client(id_client);

#7
grant alter on leshop.commande to 'cli2'@'%';
grant references on leshop.client to 'cli2'@'%';
show grants for 'cli2'@'%';

#8
use leshop;

drop table if exists commande;

create table commande(
    id_commande int primary key auto_increment,
    id_client int not null,
    libellé varchar(255) not null,
    constraint fk_id_client foreign key (id_client) references client(id_client)
);

#9
update client set nom = 'Duchene' where id_client = 1;
select * from client where id_client = 1;

############################################ Cli 1 ############################################
#10
grant create role on *.* to 'cli1'@'%';
grant all on leshop.client to 'cli1'@'%' with grant option;
grant super on *.* to 'cli1'@'%';
show grants for 'cli1'@'%';

create role 'MAJCLI';
grant ALL on leshop.client to 'MAJCLI';

#11
grant 'MAJCLI' to 'cli2'@'%';
show grants for 'cli2'@'%';
show grants for 'MAJCLI';

############################################ Cli 2 ############################################
#12
use leshop;

update client set nom = 'Duchene' where id_client = 1;
select * from client where id_client = 1;

SET DEFAULT ROLE ALL TO cli2;

#13
revoke update on leshop.client from 'cli1'@'%';
show grants for 'cli1'@'%';

#14
############################################ Cli 1 ############################################
use leshop;

update client set nom = 'Duchamp' where id_client = 1;
select * from client where id_client = 1;

############################################ Cli 2 ############################################
use leshop;

update client set nom = 'Duchampanhe' where id_client = 1;
select * from client where id_client = 1;

show grants for 'cli1'@'%';
show grants for 'cli2'@'%';
show grants for 'MAJCLI';