---
sidebar_position: 6
---

# Wasserwerte importieren

### Endpunkt

`POST /api/environments/<int:environment_id>/values/import/`

### Beschreibung

Diese API ermöglicht es Nutzern, Wasserwerte in eine Umgebung zu importieren, indem sie eine CSV-Datei hochladen. Nützlich für die Migration von Daten oder das Hinzufügen mehrerer Wasserwerte aus einer anderen Quelle.

### Authentifizierung

API-Schlüssel

### Anfrageparameter

- **environment_id**: Die ID der Umgebung (Ganzzahl)
- **file**: Eine CSV-Datei, die die Wasserwerte enthält (die Datei sollte Spalten wie „Measured At“, Parameter-Namen und deren Werte enthalten).

### Beispielanfrage

```
POST /api/environments/1/values/import/
```

### Beispiel-CSV-Format

```
Measured At,pH,Temperature,pH_unit,Temperature_unit
2024-09-24 10:30:00,7.2,24.5,pH,C
2024-09-23 10:30:00,7.0,24.2,pH,C
```

### Antwort

- **201 Created**: Wasserwerte erfolgreich importiert.
- **400 Bad Request**: Das CSV-Dateiformat ist ungültig oder es gibt ein Problem mit den Daten.
- **429 Too Many Requests**: Wasserwerte wurden zu häufig hochgeladen (basierend auf dem Nutzer-Abo).

### Anwendungsfall

Diese API ist ideal für Nutzer, die große Datenmengen aus anderen Quellen oder Systemen in ihre Aquaware-Umgebung importieren möchten. Eine großartige Möglichkeit, historische Wasserdaten effizient zu migrieren.
