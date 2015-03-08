-- Producer (numprod [prim_key], name, surname, region, qtetot)
-- Wine (numwin [prim_key], vintage, annee, degree)
-- Crop (numprod [forein_key], numwin [forein_key], quantity)

DROP TABLE Crop;
DROP TABLE Wine;
DROP TABLE Producer;

CREATE TABLE Wine
-- Création de table
(numwin varchar(5) constraint pk_wine primary key,
vintage varchar(10),
annee number(4),
degre number(4,1)
);
CREATE TABLE Producer
-- Création de table
(numprod varchar(5) constraint pk_prod primary key,
name varchar(30),
surname varchar(30),
region varchar(30),
qtetot number(10,2) default 0
);
CREATE TABLE Crop
-- Création de table
(numwin varchar(5),
numprod varchar(5),
quantity number(6,2),
constraint pk_crop primary key(numwin,numprod)
);
-----------------------------------------
-- script de creation des cles étrangères
-----------------------------------------
ALTER TABLE Crop add constraint fk_Crop1 foreign key(numwin)
REFERENCES Wine(numwin);
ALTER TABLE Crop add constraint fk_Crop2 foreign key(numprod)
REFERENCES Producer(numprod);
-----------------------------------
-- exemple de jeu d'essai de départ
-----------------------------------
INSERT into Wine VALUES ('v1','c1',1994,12);
INSERT into Wine VALUES ('v2','c1',1994,13);
INSERT into Wine VALUES ('v3','c2',1992,10);
INSERT into Producer VALUES ('p1','Rotchild','','Beaujolais',0);
INSERT into Producer VALUES ('p2','Chateau Louis','','Loire',0);
INSERT into Producer VALUES ('p3','JC et Fils','','Beaujolais',0);
INSERT into Producer VALUES ('p4','Domaine de la bourdonnaise','','Loire',0);
INSERT into Crop VALUES ('v1','p1',100);
INSERT into Crop VALUES ('v2','p1',200);
INSERT into Crop VALUES ('v3','p1',100);
INSERT into Crop VALUES ('v1','p2',100);
INSERT into Crop VALUES ('v2','p3',200);
INSERT into Crop VALUES ('v3','p4',100);
----------------------------------------------------
-- mise à jour explicite car trigger non encore crée
----------------------------------------------------
UPDATE Producer SET qtetot = 400 WHERE numprod = 'p1';
UPDATE Producer SET qtetot = 100 WHERE numprod = 'p2';
UPDATE Producer SET qtetot = 200 WHERE numprod = 'p3';
UPDATE Producer SET qtetot = 100 WHERE numprod = 'p4';
-----------------------------------------------------
UPDATE Producer SET surname = 'Skobnikoff' WHERE numprod = 'p1';
UPDATE Producer SET surname = 'Obama' WHERE numprod = 'p2';
UPDATE Producer SET surname = 'Merkel' WHERE numprod = 'p3';
UPDATE Producer SET surname = 'Putin' WHERE numprod = 'p4';
UPDATE Producer SET surname = 'Ruben' WHERE numprod = 'p5';
UPDATE Producer SET surname = 'Bazarov' WHERE numprod = 'p6';