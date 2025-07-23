

---RESTORE
--Fall 3 :  jemand manipuliert versehentlich Daten
--DB restoren, aber unter anderern Namen.
--Wenn man die Chance und die Infos besitzt, die versehentlich veränderten
--Daten zu korrigieren...
--Korrektur per TSQL



--11:31 problem .. wann ... 11:29 (9Uhr)
--Workaround: unter einen anderen Namen restoren
--und anschlissend per TSQL irgendwie die Daten korrigieren in der OrgDB

--V letzte D und alle nachfolgenden Ts

USE [master]
RESTORE DATABASE [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1,  MOVE N'Kurs2014DB' TO N'D:\_SQLDB\Kurs2014DBxxALT.mdf',  MOVE N'Kurs2014DB_log' TO N'D:\_SQLDB\Kurs2014DBAxxLT_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--FALL 6: DB fehlerverdächtig.. Sie 
--muss zum letztmöglichen Zeitpukt restored werden



--möglichst ohne Datenverlust:
--V  D TTT

--Restore geht nur wenn keine Verbidungen auf der DB sind..


/*
alle Verbindungen schliessen.. Aktivitätsmonitr oder Kill Prozessnummer
Backup LOG
restore V
Restore D
Restore aller Ts.  (Zeitpunkt 11:27:39
--jetzt 11:50 ..also würde alles, was seit 11:27 I U D war weg sein...


jetzt nochmal einen T Sicherung 11:50:00
Restore von 11:34:13

Protokollfragment= der ungesichterte teil des Logfiles



*/

--Retsore ohne Datenverlust
--Allerdings sind neuere Daten im Backup und nicht in der DB..
--Die Fragmentsicherung sichert vor dem Restore automatisch den Teil des
--Protokolls, der noch nicht gesichert wurde...

USE [master]
ALTER DATABASE [Kurs2014DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
BACKUP LOG [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB_LogBackup_2021-02-23_11-54-09.bak' WITH NOFORMAT, NOINIT,  NAME = N'Kurs2014DB_LogBackup_2021-02-23_11-54-09', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5
ALTER DATABASE [Kurs2014DB] SET MULTI_USER

GO


USE [master]
GO
ALTER DATABASE [KursDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'KursDB'
GO

-----Fall 1---------------------------------------
--Wenn das Logfile weg oder defekt ist
USE [master]
GO
CREATE DATABASE [KursDB] ON 
( FILENAME = N'D:\_SQLDB\KursDB.mdf' )
 FOR ATTACH
GO

USE [master]
GO
CREATE DATABASE [KursDB] ON 
( FILENAME = N'D:\_SQLDB\KursDB.mdf' ),
( FILENAME = N'D:\_SQLDB\KursDB_log.ldf' )
 FOR ATTACH
GO

--resore aus Backup auf anderen server
USE [master]
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 1,  MOVE N'Kurs2014DB' TO N'D:\_HRDB\Kurs2014DB.mdf',  MOVE N'Kurs2014DB_log' TO N'D:\_HRDB\Kurs2014DB_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--Fall 5: Wir wissen, dass etwas gleich passieren kann
--SP Installation


--der Snapshot kopiert Seiten vor Änderungen in die Snapshotdatei
USE master
GO

-- Create the database snapshot..nur lesbar, daher keine Tlog
CREATE DATABASE SN_KursDb2014_1330 ON
(	NAME = Kurs2014DB, --logischer Dateiname der OriginalDB
	FILENAME = 'D:\_SQLDB\SN_KursDb2014_1330.mdf' )--der Name der Datendatei des Snapshot
AS SNAPSHOT OF Kurs2014DB;
GO

--Mit Hilfe des Snapshot wollen wir Restoren

--1: Alle User müssen von der SnapshotDB runter
---- und auch von der OrigDB

use master -- am besten selbst nicht auf einer der DB sein;-)
select * from sysprocesses where dbid in (DB_ID('northwind'),db_id('snnwind')
KILL 72
KILL 77


--dauert 1 Sekunde....Obwohl die DB 1 GB groß war....!!
restore database Kurs2014DB
from database_snapshot='SN_KursDb2014_1330'

--es ersetzt keine normale Sicherung...

--man kann nur den Zeitpunkt restoren, zu dem man den Snapshot machte

--Kann man einen Snapshot sichern.. ?
--Nein

--Kann man eine DB sichern, die einen Snapshot besitzt.. ?
--Ja klar

--Kann man einen Snapshot restoren?
--Hä?  Ohne Sicherung kein restore .. 


--Kann man einen DB  restoren, die einen Snapshot besitzt?
--Leider nein, aber falls alle Snapshots gelöscht werden, geht auch der Restore wieder
--Ein Snapshot kann keine Garantie haben, was die Lebensdauer betrifft
--EIN DB kann aber durchaus mehrer Snapshots haben

--Wie kann User von der DB werfen...
--aber sollte man das so tun...? ;-)

USE [master]
GO
ALTER DATABASE Kurs2014DB SET  MULTI_USER WITH NO_WAIT
GO

select * from sysprocesses where dbid = db_id('Kurs2014DB')


--NUR DIE SICHERUNG DES TLOGS LEERT DAS TLOG!!!!!!!!

---ALSO Sicherungsstrategie

--20 GB
--Arbeitszeiten: Mo bis Fr  7 Uhr  bis 18 Uhr
--DB Ausfallszeit: 30min (Reaktionszeit+Restorezeit)
--Maximaler Verlust in Zeit ausgedrückt  15min

--Was wäre , wenn Verlust in Zeit = 0 sein soll==> Hochverfügbarkeit (Cluster, Spiegeln, AVG))
--Was wäre, wenn ich das mit dderDB zeitlich hinbringe

/*
V  jeden Tag     (Mo bis Fr) abends um 19
D  alle 4 T oder eben jede Stunde (Mo bis Fr 8:20  - bis 18:20)
T  alle 15min nur Mo bis Fr (7:15 - 18:15)


Sicherungsintegrität, Prüfsummen bei Fehler fortsetzen

*/


