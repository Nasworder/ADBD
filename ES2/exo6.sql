use leshop;

#1
grant all on leshop.* to 'cli2'@'%' with grant option;
show grants for 'cli2'@'%';

#2
ALTER TABLE commande add montant decimal(10,2) not null check ( montant < 10000 );

#3
INSERT INTO commande (id_client, libellé, montant) VALUES
(1, 'Commande 1', 500),
(2, 'Commande 2', 1000),
(3, 'Commande 3', 750),
(4, 'Commande 4', 200),
(5, 'Commande 5', 800),
(6, 'Commande 6', 1500),
(7, 'Commande 7', 300),
(8, 'Commande 8', 600),
(9, 'Commande 9', 900),
(1, 'Commande 10', 1200),
(1, 'Commande 11', 3000);

#################### cli2 ####################
#4
CREATE or replace view VUE1 as select client.nom, sum(montant) as 'Montant Total' from commande inner join client on commande.id_client = client.id_client group by client.nom;
select * from VUE1;

#check vue
USE information_schema;
SELECT table_name, table_schema, check_option, is_updatable FROM views where table_name LIKE 'vue1';

#5
grant select on leshop.VUE1 to 'cli1'@'%';
show grants for 'cli1'@'%';

#6
#################### cli1 ####################
CREATE or replace view VUE2 as select client.nom, client.NPA, client.ville, c.libellé, c.montant from client inner join commande c on client.id_client = c.id_client where client.npa = 1000;

#################### cli2 ####################
GRANT ALL ON leshop.* to cli1 WITH GRANT OPTION;

select * from VUE2;

select table_name, table_schema, check_option, is_updatable from information_schema.views where table_name like 'VUE2';

#7
revoke all on leshop.* from cli2;
revoke MAJCLI from cli2;
grant all on leshop.VUE2 to cli2;
show grants for cli2;
select * from client;
select * from VUE2;
update VUE2 set NPA = 1001;

update client set NPA = 1000 where NPA = 1001;

#8
CREATE or replace view VUE2 as select client.nom, client.NPA, client.ville, c.libellé, c.montant from client inner join commande c on client.id_client = c.id_client where client.npa = 1000 with check option;
select table_name, table_schema, check_option, is_updatable from information_schema.views where table_name like 'VUE2';
update VUE2 set NPA = 1001;
update VUE2 set montant = 1000 where nom = 'Dumont';

#9
CREATE or replace view VUE2 as select client.id_client, client.nom, client.NPA, client.ville, c.libellé, c.montant from client inner join commande c on client.id_client = c.id_client where client.npa = 1000 with check option;
select table_name, table_schema, check_option, is_updatable from information_schema.views where table_name like 'VUE2';

#10
grant all on leshop.commande to cli2;
grant create view on leshop.* to cli2;
show grants for cli2;
create view VUE3 as select VUE2.id_client, VUE2.nom, commande.id_commande, commande.libellé from VUE2 inner join commande on VUE2.id_client = commande.id_client;
grant All on leshop.VUE3 to cli2;
select table_name, table_schema, check_option, is_updatable from information_schema.views where table_name like 'VUE3';

#11
update VUE3 set id_client = 30 where id_client = 1;
update VUE3 set nom = 'Dumont' where nom = 'Duchampagne';
update VUE3 set id_commande = 20 where id_commande = 1;
update VUE3 set libellé = 'Commande 20' where libellé = 'Commande 1';

#12
insert into VUE3 (id_client, nom, id_commande, libellé) values (1, 'Dumont', 1, 'Commande 1');







