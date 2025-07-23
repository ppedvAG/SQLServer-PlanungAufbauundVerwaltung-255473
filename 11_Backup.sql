/*

Was kann passieren?

1. Logfile defekt
   Datendatei ist defekt	
2. HDD mit DB ist weg/defekt...
3. jemand manipuliert versehentlich Daten
4. SQL Server ist defekt, aber die HDD sind noch da..
5. Wenn man weiss, dass gleich was passieren kann..?
	Bei SP oder UP Installationen 
	wird oft auf ein Backup hingewiesen
6: DB Defekt.. korrupt (fehlerverdächtig)


Welche Sicherungen gibts denn?

Vollsicherung  V

Differentielle Sicherung  D

Transaktionsprotokollsicherung  T


Warum kann ich aber bei einer meiner DB keine T Sicherung machen..?
Weil es ein sog Wiederherstellungsmodel gibt...


pro DB 

Einfach
protokolliert INS UP DEL
werden TX nach Commit aus dem LOG gelöscht...es gibt nichts vernünftiges 
zu sichern

--> keine Logfile Sicherung
protokolliert auch INS UP DEL
aber massenoperation werden nicht exakt protokolliert

Massenprotkolliert

protokolliert INS UP DEL
aber massenoperation werden nicht exakt protokolliert

aber es wird nichts aus dem LOG entfernt


Vollständig
alles exakt protokollieren, was Änderungen in der DB stattfindet
wächst deutlich mehr
es löscht auch nichts aus dem Log

man kann hiermit auf Sekunde restoren....!


Wieviel Datenverlust in Zeit darf ich haben? 15min, 30min, 1h, aber auch 0
Wieviel zeit habe ich zum Restoren? 
-- wie lange darf einen DB ausfallen in Zeit?

diese Fragen ergeben die Sicherungsstrategie?


V
sichert die DB zu einem Zeitpukt, also auch nur diesen Zeitpubkt restoren
sichert die Dateien (nur Daten aber keine Leerräume)
auch Pfade und derern Dateinamen, auch Größenangaben

Differentielle 
sichert nur geänderte Seiten seit dem letzte V
Diff Sicherung ist auch wiedder nur ein Zeitpunkt

T
sichert wie ein Makro. Es werden alle Statements , die irgendwie "ändern"
protokoliert mit Zeitstempel
nur mit Hife des Logifles kann man auf Sekunde restoren

6 Uhr   V!
6:15	T
6:30	T
6:45    T
7 Uhr	D
		T
		T
	XXXX
		T
		T
		T
		T
12:00	D
		T!
		T!
12:30	T!

--Jetzt wissen wir folgendes:
Was ist der schnellste Restore , den man haben kann?
nur das V--> so oft wie möglich V Sicherung



Wie lange braucht man um ein T zu restoren?
so lange wie die darin befindlichen Aktionen dauerten.. in Summe
--> wir wollen nicht viele Ts und auch keinen großen Zeitumfang 
in den Ts haben
--> T sind oft nur im 15min Takt oder 30min


Wie oft mache ich dann eine D Sicherung?
ca alle 3 oder 4 T einen D Sicherung
Weil das D verkürzt sehr stark die restore Dauern
und sichert unseren Restore


Wir machen das T so häufig wie der max Datenverlust sein darf... zb 15min

Nur mit Hilfe der T Sicherung ist ein Sekundengenauer Restore möglich
Allerdings muss das Wiederherstellungsmodel auf Voll gesetzt sein.




*/

--VOLLSICHERUNG
BACKUP DATABASE Northwind2 TO  DISK = N'C:\_SQLBACKUP\Northwind.bak' 
	WITH NOFORMAT, NOINIT,  NAME = N'Northwind-Voll',
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--DIFF
BACKUP DATABASE Northwind2 TO  DISK = N'C:\_SQLBACKUP\Northwind.bak'
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  
NAME = N'Northwind-DIFF',
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


--TLOG
BACKUP LOG Northwind2 TO  
DISK = N'C:\_SQLBACKUP\Northwind.bak' WITH NOFORMAT, 
NOINIT,  NAME = N'Northwind-TLOG', SKIP, NOREWIND, 
NOUNLOAD,  STATS = 10 
GO


---V TTT D TTT D TTT



--Lösungen zu den Fällen
1. Logfile defekt
   Datendatei ist defekt	
   --DB anfügen und mind die mdf angeben...
   --ein fehlendes Logfile kann durch ein neues "ersetzt" werden


2. HDD mit DB ist weg/defekt...
	--Restore aus Backup

3. jemand manipuliert versehentlich Daten
	--Restore als DB mit anderen Namen
	--Vorsicht: Dateinamen anpassen
			--  kein Fragmentsicherung

4. SQL Server ist defekt, aber die HDD sind noch da..
	--DB anfügen auf anderen Server



5. Wenn man weiss, dass gleich was passieren kann..?
	Bei SP oder UP Installationen 
	wird oft auf ein Backup hingewiesen

	-->Snapshot

6: DB Defekt.. korrupt (fehlerverdächtig)-- Reperatur oder wenn notwendig restore
--Restore der DB 
--DB ersetzen / überschreiben / Benutzer von der DB trennen
--DB über das Menü restoren...
-- Protokollfragment erstellen lassen und gewünschten Zeitpunkt wählen



USE [master]
ALTER DATABASE [Northwind] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
BACKUP LOG [Northwind] TO  DISK = N'C:\_SQLBACKUP\Northwind_LogBackup_2023-10-30_11-42-29.bak' WITH NOFORMAT, NOINIT,  NAME = N'Northwind_LogBackup_2023-10-30_11-42-29', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [Northwind] FROM  DISK = N'C:\_SQLBACKUP\Northwind.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [Northwind] FROM  DISK = N'C:\_SQLBACKUP\Northwind.bak' WITH  FILE = 14,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUP\Northwind.bak' WITH  FILE = 15,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUP\Northwind.bak' WITH  FILE = 16,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUP\Northwind.bak' WITH  FILE = 17,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUP\Northwind_LogBackup_2023-10-30_11-42-29.bak' WITH  NOUNLOAD,  STATS = 5,  STOPAT = N'2023-10-30T10:59:52'
ALTER DATABASE [Northwind] SET MULTI_USER

