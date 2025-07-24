--Evi

select * from customers

select * from ma.personal

select * from ma.projekte

select * from it.projekte


--Evi soll Tabellen anlegen dürfen

create table ma.test (matest int)

--Soll IT Projekte lesen

select * from it.projekte

select * from projekte


select * from dbo.employees

--Wenn Evi Sichten erstellen möchte dann sind 2 Rechte erforderlich:
-- 1. Die Datenbank muss die Erlubnis geben eine View anlegen zu dürfen
	
-- 2. Das Schema muss zusätzlich zustimmen, das Recht innerhalb des Schemas anwenden zu dürfen

--ALS ADMIN ausführen 	  -- Recht auf DB für CREATE VIEW
  EXECUTE AS Login='SA2'
use [Testdb]
GO
GRANT CREATE VIEW TO [Susi]
GO
--Recht aus CREATE , ALTER DROP innerhalb eines Schema
GRANT CREATE VIEW TO [Susi]
GO
REVERT

 --ALS SUSI


create view ma.vProjekte
as
select * from it.projekte
UNION ALL
select * from ma.projekte


alter view ma.vProjekte
as
select * from dbo.employees

--MA Evi darf lesen
--dbo Employees Lesen verweigert

select * from vprojekte

--Was sollte man demnach nie tun!
-->Gib nie einem normal sterblichen User das Recht
--Create View / Procedure /function
select * from ma.projekte


