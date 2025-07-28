				   /*

INDIZES

CLUST IX
=Tabelle in sortierter Form
nur 1x pro Tabelle
gut bei Bereichsabfragen, weil sortiert
gut bei eindeutigen Werten 
per SSMS wird immer beim PK ein CL IX gesetzt.. in vielen Fälle dumm


NON CLUST IX
= Kopie von Daten in sortierter Form
ca 1000 mal Tabelle
gut bei geringen Resultset (id)

--------------------------
Im Plan einer Abfragen kann man SCAN und SEEK entdecken.
Ein Scan ist immer ein komplettes Durchsuchen.
zB	TABLE SCAN = Durchsuchen einer kompletten  Tabelle
	IX SCAN = komlpettes Durchsuchen eines nicht guppierten Index

Ein Lookup = der Treffer im Nicht gruppierten Index enhtält nicht alle Informationen
			 Mit einem Nachschlagen in dem Heap oder gruppierte Index benötigt man zusätzliche Seiten
			 Nehmen die Lookups überhand (zu teuer) entscheidet sich der SQL Server zu einem SCAN
			 Der SCAN kann bereits sehr früh stattfinden (auch bei 1 % Treffer der Gesamtmenge )
			 Findet kein Lookup statt, kann der SQL Server sehr lange den SEEK aufrecht erhalten (auch bei 90% Treffer der Gesamtmenge)

			 --> vermeide Lookus

--Vorsicht: Index Scan ist nicht per se schlecht-- weniger Aufwand als Table Scan, aber SEEK wäre besser	:-)


--Optimierer entscheidet sich für einen Scan , wenn dieser weniger Kosten als ein Seek verursacht
--der Optimierer entscheidet sich für einen IX Scan, wenn dieser günstiger als ein Table Scan ist.

Für Admins toDo
-- selten oder nicht gebrauchte Indizes evtl löschen

	--Kann man unnütze IX finden: DMVs...!
	sys.dm_db_index_usage_Stats

--  Defragmentieren 
	-->Wartungsplan

--  fehlende erstellen
	--> Optimierungsratgeber
Tipp
-- Brent Ozar SP_blitzIndex-- First Responder Kit 0 Euro

--Wartung--> Wartungsplan: Reihenfolge IX Rebuild --> IX Reorg --> Spaltenstatistiken

--Stat:  akt nach 20% Änderung plus 500  zu spät, weil ab  ca 1% -- jeden Tag aktualisieren

--IX Reorg ab 10% 
--Rebuild ab 30%
--Tipp: Ola Hallengren -- das perfekte Skript für Wartung



