/*

master
"herz"
Login, Datenbanken, Konfiguration

Backup: Backup..!


model
--Vorlage f�r neue DBs
create database testdb
--�nderungen an der model haben Auswirkung auf alle danach erzeugten DBS
--Einstellungen, Tabellen
--Backup der modelDB: nur notwendig , wenn �nderungen
--alternativ per Script

USE [master]
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modeldev', SIZE = 9216KB )
GO


msdb
DB f�r den Agent
Zeitpl�ne, Jobs, Proxykonten, Warnungen , DB Email
SSIS Pakete (SQL Server Integration Services)  Datenimport Export
Wartungsplan = SSSI Paet

Backup: regelm��ig



tempdb
#tab   ##tab
Zeilenversionierung
IX Rebuild 
Auslagerungen
--so schnell sein

Backup:  No


--welche tut am meisten weh:?
msdb


--------------------------------------
distribution (replikation)

mssqlsystemressources


Sicherung der SystemDbs

Wartungsplan
Vollst�ndige Sicherung --> SytemDbs --> einmal t�glich -- > 
--> Unterordner anlegen lassen -->
--> Checksumme+Integrit�tspr�fung + Kompression + bei Fehler fortsetzen
--> Logfile + Email, wenn man will




*/