/*

  Das korrekte Vergeben von Rechten in SQL Server folgt einem strukturierten und rollenbasierten Sicherheitsmodell. Dabei spielen die Konzepte Login, User, Schema und Rollen eine zentrale Rolle. Hier eine systematische Erklärung:

🔑 1. Login (Serverzugang)
Login ist das Konto für die Authentifizierung am SQL Server (Instanz-Ebene).

Es gibt zwei Arten:

SQL-Logins (Benutzername + Passwort)

Windows-Logins / Gruppen (integrierte Authentifizierung)

⚠️ Ein Login alleine gibt keine Berechtigung auf Datenbankebene, sondern nur die Verbindung zum SQL Server.

Beispiel:

CREATE LOGIN MaxMuster WITH PASSWORD = 'StarkesPasswort123!';
👤 2. User (Zugriff innerhalb einer Datenbank)
Ein User ist die datenbankspezifische Identität eines Logins.

Jede Datenbank benötigt einen eigenen User, um Zugriffsrechte auf Objekte in dieser Datenbank zu verwalten.

Zuordnung:

-- In der Ziel-Datenbank ausführen
CREATE USER MaxMusterUser FOR LOGIN MaxMuster;
🔄 Ein Login kann in mehreren Datenbanken ein eigener User sein – mit unterschiedlichen Rechten.

🗂️ 3. Schema (Container für Objekte)
Ein Schema ist ein logischer Container für Datenbankobjekte wie Tabellen, Sichten, Prozeduren etc.

Benutzer erhalten Rechte auf Objekte im Schema oder auf das Schema selbst.

Beispiel:

-- Eigenes Schema für Berichte erstellen
CREATE SCHEMA Reporting AUTHORIZATION MaxMusterUser;

Rechte auf Schema:
-- SELECT auf alle Objekte im Schema erlauben
GRANT SELECT ON SCHEMA::Reporting TO MaxMusterUser;
🧩 4. Rollen (Rechte bündeln)
SQL Server kennt vordefinierte Rollen sowie benutzerdefinierte Rollen:

🔹 a) Serverrollen (Instanz-Ebene)
Beispiele:

sysadmin, securityadmin, serveradmin


-- Login zur sysadmin-Rolle hinzufügen
ALTER SERVER ROLE sysadmin ADD MEMBER MaxMuster;
🔹 b) Datenbankrollen (Datenbank-Ebene)
Standardrollen (in jeder DB vorhanden):

db_datareader, db_datawriter, db_owner, db_ddladmin, ...


-- Benutzer der Rolle db_datareader hinzufügen
ALTER ROLE db_datareader ADD MEMBER MaxMusterUser;
🔹 c) Benutzerdefinierte Rollen
Damit kann man gezielt eigene Rechtepakete schnüren:


-- Neue Rolle für nur-Lesezugriff
CREATE ROLE Leserrolle;

-- SELECT-Recht auf ein Schema vergeben
GRANT SELECT ON SCHEMA::Reporting TO Leserrolle;

-- Benutzer zur Rolle hinzufügen
ALTER ROLE Leserrolle ADD MEMBER MaxMusterUser;
🔐 Best Practices zur Rechtevergabe
Minimalprinzip: Nur die Rechte vergeben, die wirklich notwendig sind.

Indirekte Rechtevergabe: Benutzer → Rolle → Rechte → Objekt
(nicht direkt GRANT auf User, sondern auf Rollen)

Verwendung von Schemas zur Trennung von Zuständigkeiten und für saubere Rechtevergabe.

Auditing & Review: Regelmäßig überprüfen, welche Logins und Benutzer welche Rechte haben.

🔁 Ablauf im Überblick
Login erstellen (Instanz-Ebene)

User in der DB anlegen (pro Datenbank)

Rollen zuweisen (statt direkt Rechte vergeben)

Schema- oder Objektrechte über Rollen steuern

*/