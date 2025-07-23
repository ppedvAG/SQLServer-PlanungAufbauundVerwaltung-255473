											  /*

  IO Optimierung im Setup

  Volumewartungstask:  kein Ausnullen...auch beim Restore

  DB -Pfade:  Trenne Log von Daten physikalisch 
  .mdf
  .ldf

  TempDB
  --eig Datenträger (trenne Daten von Logfile)
  --soll soviele Datendateien haben wie Kerne (max 8)


  CPU
  MAXDOP = Anzahl der Kerne (max 8)
  !! Fehlt Kostenschwellenwert : ab 5 SQL Dollar  sollte höher sein: 25 Datawarehouse / 50 OLTP (Shop)


  Memory
  Setze den Wert: MAX Memory  (Gesamt - OS)


  --Welche DB beinhaltet Logins: master
  --Jobs : msdb
  --

  Wer führt die Schritte des AGent Jobs aus:
  -a) das AgentDienstkonto
  -b) Proxykonto


  DBMail

  PROFIL
  Mailserveradresse
  Port
  Absendeadresse
  Authorisierung

  Infos zum Versand : dbo.sysmail....(msdb)










*/