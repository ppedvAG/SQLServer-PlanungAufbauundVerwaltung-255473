--�berwachungen

/*
�berwachungen auf einem SQL Server (engl. SQL Server Audits) dienen dazu,
sicherheitsrelevante oder compliance-bezogene Aktivit�ten im SQL Server 
zu protokollieren und nachzuvollziehen. Sie erm�glichen die Nachverfolgung 
von Zugriffen, �nderungen 
und Aktionen auf Datenbank- und Serverebene � also wer was wann gemacht hat.


In Microsoft SQL Server bezeichnet eine �berwachung (Audit) eine Kombination aus:

1. Serveraudit: die Konfiguration der �berwachung selbst (wohin wird geloggt, 
	z.?B. Datei, Windows Event Log).

2. Serveraudit-Spezifikationen (server audit specifications): definieren,
	was auf Serverebene �berwacht wird.

3. Datenbankaudit-Spezifikationen (database audit specifications): definieren, 
	was in einer bestimmten Datenbank �berwacht wird.

	Tipp: 
		-- bei Bedarf aktivieren
		-- Kategorische �berwachungsdateien (Security, Backup usw)
	
	Die Oberfl�che zur Anzeige Protokolls ist etwas "st�rrisch"
	Daher besser per TSQL
*/


select * from sys.fn_get_audit_file
(
'c:\_SQLBACKUP\Security_Maria_695631A9-6377-4125-AC23-DC21076C59A1_0_133918575140750000.sqlaudit'
,NULL
,NULL
) where 

	select * from sys.fn_getjjjjlkkk