use if exists ecole_2;

# exo 3 A
select prenom,etudiant.nom, c.nom from etudiant inner join classe c on etudiant.id_classe = c.id_classe;

# exo 3 B
select prenom,etudiant.nom, c.nom from etudiant left join classe c on etudiant.id_classe = c.id_classe;

# exo 3 C
select prenom,etudiant.nom, c.nom from etudiant right join classe c on etudiant.id_classe = c.id_classe;

# exo 3 D
select etudiant.prenom,etudiant.nom, classe.nom from classe left join etudiant on etudiant.id_classe = classe.id_classe;

# exo 3 E
select etudiant.prenom,etudiant.nom, classe.nom from classe left join etudiant on etudiant.id_classe = classe.id_classe where etudiant.id_classe is null;

# exo 3 F
select etudiant.prenom,etudiant.nom, classe.nom from classe right join etudiant on etudiant.id_classe = classe.id_classe where etudiant.id_classe is null;

------------------------------------------------------------------

# Exo 4
# 1 Afficher les noms et prénoms des étudiants de la classe ELECTRO-2. 
select etudiant.nom, etudiant.prenom from etudiant inner join classe c on etudiant.id_classe = c.id_classe where c.nom = "ELECTRO-2"; 

# 2 Afficher les noms et prénoms des étudiants de la classe ELECTRO-2, nés en 1993. 
select etudiant.nom, etudiant.prenom from etudiant inner join classe c on etudiant.id_classe = c.id_classe where c.nom = "ELECTRO-2" and YEAR(etudiant.date_de_naissance) = 1993;

# 3 Afficher le nom de la classe et de la salle de l’étudiant prénommé ‘Nathan’.
select classe.nom, classe.salle from classe inner join etudiant on etudiant.id_classe = classe.id_classe where etudiant.prenom = "Nathan";

# 4  Afficher le nom et le prénom du prof responsable de la classe ‘ELECTRO-2’
select professeur.nom, professeur.prenom from professeur inner join classe c on professeur.id_professeur = c.id_professeur where c.nom = "ELECTRO-2";

# 5  Afficher les noms, prénoms et date de naissance de tous les étudiants, dont Aline Rochat est responsable. 
select etudiant.nom, etudiant.prenom, etudiant.date_de_naissance from etudiant inner join classe c on etudiant.id_classe = c.id_classe inner join professeur p on c.id_professeur = p.id_professeur where p.nom = "Rochat" and p.prenom = "Aline";

#6 Afficher les noms et prénoms des profs responsables d’étudiants ayant plus de 10 périodes d’absences. 
select distinct professeur.nom, professeur.prenom from professeur inner join classe c on professeur.id_professeur = c.id_professeur inner join etudiant on etudiant.id_classe = c.id_classe where etudiant.nb_periodes_absence > 10;

#7 Afficher par ordre alphabétique le nom de toutes les matières et le nom des profs qui les enseignent (pour autant qu’un prof les enseigne). 
select matiere.nom, professeur.nom from matiere right join professeur_matiere on matiere.id_matiere = professeur_matiere.id_matiere right join professeur on professeur_matiere.id_professeur = professeur.id_professeur order by matiere.nom;

#8 Afficher le nom des matières qui ne sont enseignées par personne.
select matiere.nom from matiere left join professeur_matiere on matiere.id_matiere = professeur_matiere.id_matiere where professeur_matiere.id_professeur is null;

# ou 
select matiere.nom from matiere where matiere.id_matiere not in (select id_matiere from professeur_matiere);

#9 Afficher le nom des profs qui enseignent la natation ou la cryptographie. 
select professeur.nom from professeur inner join professeur_matiere on professeur.id_professeur = professeur_matiere.id_professeur inner join matiere on professeur_matiere.id_matiere = matiere.id_matiere where matiere.nom = "natation" or matiere.nom = "cryptographie";

#10 Afficher les noms des profs qui ne sont pas responsables de classe, ainsi que les noms des matières qu’ils enseignent. 
select professeur.nom, matiere.nom from professeur left join classe c on professeur.id_professeur = c.id_professeur left join professeur_matiere on professeur.id_professeur = professeur_matiere.id_professeur left join matiere on professeur_matiere.id_matiere = matiere.id_matiere where c.id_professeur is null;

#11 Afficher les noms des matières qui sont enseignées par le prof de l’étudiant ‘Thomas Lopez’. 
select matiere.nom from matiere inner join professeur_matiere on matiere.id_matiere = professeur_matiere.id_matiere inner join professeur on professeur_matiere.id_professeur = professeur.id_professeur inner join classe c on professeur.id_professeur = c.id_professeur inner join etudiant on etudiant.id_classe = c.id_classe where etudiant.nom = "Lopez" and etudiant.prenom = "Thomas";

#12  Afficher le nom du prof qui enseigne la natation et le yoga.
select nom from professeur
where id_professeur in (select id_professeur from professeur_matiere inner join matiere on professeur_matiere.id_matiere = matiere.id_matiere where matiere.nom = "natation") 
and id_professeur in (select id_professeur from professeur_matiere inner join matiere on professeur_matiere.id_matiere = matiere.id_matiere where matiere.nom = "yoga");

------------------------------------------------------------------

# Exo 5

#1 Sélectionner les lieux d’habitation des étudiants. Chaque lieu ne doit apparaître qu’une seule fois. 
select distinct localite from etudiant;

#2 Afficher le nombre total d’étudiants.
select count(id_etudiant) from etudiant;

#3 Afficher le nombre d’étudiants de la classe ‘ELECTRO-2’
select count(id_etudiant) from etudiant inner join classe c on etudiant.id_classe = c.id_classe where c.nom = "ELECTRO-2";

#4 Afficher le nombre d’étudiants de chaque classe (avec le nom de la classe).
select c.nom, count(etudiant.id_etudiant) from etudiant inner join classe c on etudiant.id_classe = c.id_classe group by c.nom;

#5 Afficher la date de naissance du plus jeune étudiant. 
select max(date_de_naissance) from etudiant;

#6 Afficher le nombre d’absences total des étudiants. 
select sum(nb_periodes_absence) from etudiant;

#7 Afficher le nombre d’absences total de chaque classe.
select c.nom, sum(etudiant.nb_periodes_absence) from etudiant inner join classe c on etudiant.id_classe = c.id_classe group by c.nom;

#8 Afficher le nom de la classe ayant un nombre d’absence moyen de plus de 100. 
select c.nom from etudiant inner join classe c on etudiant.id_classe = c.id_classe group by c.nom having avg(etudiant.nb_periodes_absence) > 100;

#9  Afficher les matières qui sont données par plusieurs profs, ainsi que le nombre de profs 
select matiere.nom, count(professeur_matiere.id_matiere) from matiere inner join professeur_matiere on matiere.id_matiere = professeur_matiere.id_matiere group by matiere.nom having count(professeur_matiere.id_matiere) > 1;

#10  Afficher le prénom, le nom et la date de naissance du plus vieil étudiant. 
select prenom, nom, min(date_de_naissance) from etudiant;

------------------------------------------------------------------

# Exo 6

#1 Afficher tous les étudiants qui sont nés le jeudi ou le vendredi.
select * from etudiant where dayofweek(date_de_naissance) = 5 or dayofweek(date_de_naissance) = 6;

#2 Afficher seulement les étudiants qui ont plus de 21 ans.
select * from etudiant where YEAR(now()) - YEAR(date_de_naissance) > 21;

#3 Afficher les dates de naissance avec la date sous ce format : Nom du mois en abrégé en 3 lettres, Année sur 4 chiffres.
select concat(upper(left(monthname(date_de_naissance), 3)), " ", year(date_de_naissance)) from etudiant;

#4 Afficher les étudiants qui sont nés entre le 1er octobre 1984 et le 5 mars 1989.
select * from etudiant where date_de_naissance between "1984-10-01" and "1985-03-05";

#5 Pour chaque jour de la semaine afficher le nombre d’étudiants nés chaque jour de la semaine.
select dayname(date_de_naissance) as day, count(id_etudiant) from etudiant group by day order by dayofweek(date_de_naissance);

#6 Pour chaque jour de la semaine afficher le nombre d’étudiants nés chaque jour de la semaine ayant un nombre d’absences inférieur à 5.
select dayname(date_de_naissance) as day, count(id_etudiant) from etudiant where nb_periodes_absence < 5 group by day order by dayofweek(date_de_naissance);

#7 Afficher tous les étudiants de la classe ‘SCM3a’ qui ont moins de 21 ans et qui sont nés un jeudi.
select * from etudiant inner join classe c on etudiant.id_classe = c.id_classe where c.nom = "SCM3a" and where dayofweek(date_de_naissance) = 5 and YEAR(now()) - YEAR(date_de_naissance) < 21;

#8 Afficher le nom et la date de naissance du plus jeune étudiant.
select nom, date_de_naissance from etudiant where date_de_naissance like (select min(date_de_naissance) from etudiant);

#ou
select nom, date_de_naissance from etudiant group BY date_de_naissance order by date_de_naissance limit 1;

------------------------------------------------------------------

# Exo 7

#1 Afficher le nombre de caractères du nom de chaque étudiant.
select nom, length(nom) from etudiant;

#2 Afficher les 5 premières du nom de chaque étudiant.
select nom, substring(nom, 1, 5) from etudiant;

#ou
select nom, left(nom, 5) from etudiant;

#3 Afficher le rang de la lettre  « r » à partir de la 3ème lettre dans le nom des étudiants.
select nom, locate("r", substring(nom, 3)) from etudiant;

#4 Afficher le prénom et le nom des étudiants en majuscule.
select upper(prenom), upper(nom) from etudiant;

#5 Concaténer le nom et le prénom.
select concat(nom, prenom) from etudiant;

#6 Remplacer tous les ‘i’ par des ‘o’ dans le nom de chaque étudiant.
select replace(nom, "i", "o") from etudiant;

# 5  Afficher les noms, prénoms et date de naissance de tous les étudiants, dont Aline Rochat est responsable.

























 
