				   /*

INDIZES

CLUST IX
=Tabelle in sortierter Form
nur 1x pro Tabelle
gut bei Bereichsabfragen, weil sortiert
gut bei eindeutigen Werten 
per SSMS wird immer beim PK ein CL IX gesetzt.. in vielen F�lle dumm


NON CLUST IX
= Kopie von Daten in sortierter Form
ca 1000 mal Tabelle
gut bei geringen Resultset (id)

--------------------------
Im Plan einer Abfragen kann man SCAN und SEEK entdecken.
Ein Scan ist immer ein komplettes Durchsuchen.
zB	TABLE SCAN = Durchsuchen einer kompletten  Tabelle
	IX SCAN = komlpettes Durchsuchen eines nicht guppierten Index

Ein Lookup = der Treffer im Nicht gruppierten Index enht�lt nicht alle Informationen
			 Mit einem Nachschlagen in dem Heap oder gruppierte Index ben�tigt man zus�tzliche Seiten
			 Nehmen die Lookups �berhand (zu teuer) entscheidet sich der SQL Server zu einem SCAN
			 Der SCAN kann bereits sehr fr�h stattfinden (auch bei 1 % Treffer der Gesamtmenge )
			 Findet kein Lookup statt, kann der SQL Server sehr lange den SEEK aufrecht erhalten (auch bei 90% Treffer der Gesamtmenge)

			 --> vermeide Lookus

--Vorsicht: Index Scan ist nicht per se schlecht-- weniger Aufwand als Table Scan, aber SEEK w�re besser	:-)


--Optimierer entscheidet sich f�r einen Scan , wenn dieser weniger Kosten als ein Seek verursacht
--der Optimierer entscheidet sich f�r einen IX Scan, wenn dieser g�nstiger als ein Table Scan ist.

F�r Admins toDo
-- selten oder nicht gebrauchte Indizes evtl l�schen

	--Kann man unn�tze IX finden: DMVs...!
	sys.dm_db_index_usage_Stats

--  Defragmentieren 
	-->Wartungsplan

--  fehlende erstellen
	--> Optimierungsratgeber
Tipp
-- Brent Ozar SP_blitzIndex-- First Responder Kit 0 Euro

--Wartung--> Wartungsplan: Reihenfolge IX Rebuild --> IX Reorg --> Spaltenstatistiken

--Stat:  akt nach 20% �nderung plus 500  zu sp�t, weil ab  ca 1% -- jeden Tag aktualisieren

--IX Reorg ab 10% 
--Rebuild ab 30%
--Tipp: Ola Hallengren -- das perfekte Skript f�r Wartung



