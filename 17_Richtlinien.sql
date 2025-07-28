										 /*

Richtlinien

Facets: was kann man pro Objekt wie Tabellen oder Datenbanken beobachten
--( Eigenschaften )


--Bedingungen : wir stellen Bedingungen, was gelten muss


Richtlininen: prüfen die Bedingungen
--können verhindern 8nicht immer), oder auswerten (grün/rot)
--können auch (seleten) Richtlinien umsetzten


--> Registrierte Server
--Gruppe besteht aus mehreren Servern
--Server können in verschiedenen Gruppen mehrfach registriert werden


--Abfrage und Richtlinen auf der Gruppen werden bei allesn Servern der Gruppe ausgeführt



--evtl mehrere SQL Server 

--best practice: Richtlinien aus SQL 2017 oder früher lassen sich auch in SQL 2019 anwenden
--allerdings nicht jede ist perfekt
/*
Trenne Daten von Log
Ist Backup auf dem selben Datnträger wie DB
Ist das letzte Backup mehr als 24 Std
Guest muss inaktiv
Wiederherstellungsmodel: FULL


*/