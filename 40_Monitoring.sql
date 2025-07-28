--Monitoring


-- ----------------------  live Problem	-----------------------------------------------
---- Reihenfolge f�r Monitoring
--1.  Taskmanager: Ausschluss andere Dinge (Anitvirentool, Viren, Trojaner..)
---		zB unbekannte Prozessse mit Admin Account
-->		nix gefunden...-->SQL Server 

--2 SQL Server genauer anschauen
-->   Aktivit�tsmonitor  
----> Wartezust�nde.. worauf warten aktuell. innerhalb der letzten Sekunden bzw in der letzten Zeit
-------> damit haben wir schon mal die Richtung , in der wir weitersehen m�ssen.

--f�r genauere Infos: auch der Aktivit�tsmonitor wertet Systemsichetn aus, wie zB:

---Oder wir fragen den SQL Server	==> DMVs Glenn Berry DMVs

select * from sys.dm_os_wait_stats

--wait_time = gesamte Wartezeit
--signal_time = Wartezeit auf Ressource  (= ein Teil der gesamt Wartezeit)
--alle Zeiten sind kummulierend

--alle Sessions mit SID > 50 sind User (auch Agent)

--Suspended: warten auf Ressource
--Runnable: Warten auf CPU
--Running: Abfrage ist gestartet




--Query--Postkasten(Fifo)--> Worker(Analyse)-- Ressourcen!!

--                    supended  |runnable    |RUNNING
---(LCK_M_S)|........................|........................| 70ms bis das Ding l�uft
--          0                 50ms CPU 20ms

--wait_time_ms: Gesamte Dauer: 70ms
--              Signal_time_ms: Anteil der CPU: 70-20=50

--leider sind die Werte kummilierend seit Neustart :-(
--wenn der Anteil der signaltime > 25% sein sollte, dann CPU Engpass

select * from sys.dm_os_wait_stats
--eigtl m�ssten wir folgendes tun
-- wenn man alle Wartezeiten addiert = gemsamte  Laufzeit des Servers
--Wartezeit einer Ressource im Vergleich zur gesamt Laufzteit

--sammlet alle Wartezeiten kummulierend seit Neustart
--> Glenn Berry: Abfrage auf OS WAIT STATS berechnet die Top Kandidaten der Ressourcenengp�sse seit Neustart.

--DO NOT RESTART SQL SERVER!! wenn du wissen m�chtest, war r langsam war. Alle DMVs werden zur�ckgesetzt


--Idee 
--Wenn wir alle zB 10min die Wartenzeiten speichern w�rden inkl Zeit der Messung, 
-- dann k�nnten wir gro�e Ver�nderungen in zumindest 10 Intervallen eingrenzen.
LCK_M_S	   242	5894499	1855310	33    um 10 Uhr
LCK_M_S	   242	5894499	1855310	33   um 10:10 
LCK_M_S	   242	8745766	1855310	33  um 10:20

--------------DMVs Data Management Views-------------
-- siehe im Projekt Z_SQL_Server_2019_Diagnostic Information Queries.sql
--eine ganze Sammlung von n�tzlichen DMvs

select * from sysprocesses --alle Prozesse der User haben ein SPID > 50

---------------F�r eine historische Betrachtung--------------------
--ist der SQL neugestartet , sind die DMVs zur�ckgestzt worden. Somit wertvolle Infos weg...
--also evtl Aufzeichnen


--Sehr gut: QUeryStore - der ABfragespeicher ----------------------
--zeigt die Top Kandidaten je nach Dauer , CPU, Lesen, Schreieben usw auch nach Neustart auf Minuten genau
--wenn man das m�chte
--Standard( Stundengenau)
-- der Abfragespeicher wird nach Neustart nicht resetet!!
-- und besitzt vordefiniert Berichte f�r  Wartestatistiken, oder Abfragen mit h�chsten Ressourcenverbrauch
-- ab sql 2016 , aber bis inkl SQL 2019 deaktiviert (pro DB). Ab SQL 2022 stdm��g aktiviert


---per TSQL ----------------------------------------
-- set statistics io, time on 
--Untersuchen der  Abfragepl�ne

--Diese bieten wertvolle Hinweise
--IO = Anzahl der Seiten
--time = ms des CPU Aufwands, Dauer in ms, 	 Analyse und Kompilierzeit
set statistics io,time on

select * from orders where freight > 10


select * from custorders where id = 100
--250ms CPU .. 128ms Dauer... 60240 Seiten



----Meldung: Problem SQL langsam


/*

---------------------Aufzeichnug von Werten



--TOOL Perfmon (NT): Messwerte einer SQLInstanz und Windows Messwerte------------------------------
---------> Grafische Auswertung.. sehr leicht um Problem zu erkennen

--TOO Profiler: Tool um Abfragen aufzuzeichen--------------------------------------------------



*/


