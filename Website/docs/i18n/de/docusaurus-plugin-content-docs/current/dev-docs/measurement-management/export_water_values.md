---
sidebar_position: 5
---

# Wasserwerte exportieren

### Endpunkt

`GET /api/environments/<int:environment_id>/values/export/`

### Beschreibung

Diese API ermöglicht es Nutzern, die Wasserwerte einer Umgebung als CSV-Datei zu exportieren. Besonders nützlich für Datensicherungen, die Weitergabe an Dritte oder für weitere Datenanalysen in Tabellenkalkulationsprogrammen.

### Authentifizierung

API-Schlüssel

### Anfrageparameter

- **environment_id**: Die ID der Umgebung (Ganzzahl)

### Beispielanfrage

```
GET /api/environments/4/values/export/
```

### Antwort

- **200 OK**: Gibt eine CSV-Datei mit den Wasserwerten der Umgebung zurück.

```
Measured At, pH, Temperatur, pH_unit, Temperatur_unit
2024-09-24 10:30:00, 7.2, 24.5, pH, C
2024-09-23 10:30:00, 7.0, 24.2, pH, C
```

- **404 Not Found**: Die Umgebung wurde nicht gefunden oder gehört nicht zum Benutzer.
- **400 Bad Request**: Ungültige Anfrage.

:::danger[Beachte]

Beim asynchronen Hochladen von Wasserwerten mit einem Arduino kann es vorkommen, dass die Werte für verschiedene Parameter eine Zeitdifferenz von wenigen Sekunden aufweisen. Um dies zu minimieren, haben wir ein System implementiert, das alle Messungen innerhalb eines 5-Minuten-Fensters gruppiert. Das bedeutet, dass exportierte Messungen immer zusammengefasst und innerhalb von 5-Minuten-Intervallen dargestellt werden, um Konsistenz zwischen den Parametern sicherzustellen und die Auswirkungen kleiner Zeitunterschiede zu reduzieren.

:::
