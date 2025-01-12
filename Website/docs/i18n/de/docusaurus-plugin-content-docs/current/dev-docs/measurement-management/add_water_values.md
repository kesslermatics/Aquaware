---
sidebar_position: 1
---

# Wasserwerte hinzufügen

## Endpunkt

`POST /api/environments/<int:environment_id>/values/"`

## Beschreibung

Dieser Endpunkt ermöglicht es dir, Wasserwerte zu einer bestimmten Umgebung hinzuzufügen. Jede Umgebung gehört einem Benutzer, und du kannst Wasserwerte nur basierend auf der Upload-Frequenz deines Abonnement-Plans einreichen. Dies dient der Ressourcenschonung und verhindert Spam-Anfragen an die API.

### Upload-Frequenz

- **Hobby-Plan**: Kann alle 12 Stunden neue Wasserwerte hochladen.
- **Business-Plan**: Kann alle 3 Stunden neue Wasserwerte hochladen.
- **Advanced-Plan**: Kann alle 30 Minuten neue Wasserwerte hochladen.

Wenn du versuchst, Werte vor Ablauf der erlaubten Zeit hochzuladen, erhältst du einen `429 Too Many Requests`-Fehler.

### Wasserparameter

Die folgenden Wasserparameter werden derzeit vom System unterstützt. Jeder Parameter hat eine zugehörige Einheit:

| Parameter Name     | Einheit  |
| ------------------ | ----- |
| PH                 | pH    |
| Temperature        | °C    |
| TDS                | ppm   |
| Oxygen             | mg/L  |
| Ammonia            | ppm   |
| Nitrite            | ppm   |
| Nitrate            | ppm   |
| Phosphate          | ppm   |
| Carbon Dioxide     | mg/L  |
| Salinity           | ppt   |
| General Hardness   | dGH   |
| Carbonate Hardness | dKH   |
| Copper             | ppm   |
| Iron               | ppm   |
| Calcium            | ppm   |
| Magnesium          | ppm   |
| Potassium          | ppm   |
| Chlorine           | ppm   |
| Redox Potential    | mV    |
| Silica             | ppm   |
| Boron              | ppm   |
| Strontium          | ppm   |
| Iodine             | ppm   |
| Molybdenum         | ppm   |
| Sulfate            | ppm   |
| Organic Carbon     | ppm   |
| Turbidity          | NTU   |
| Conductivity       | µS/cm |
| Suspended Solids   | mg/L  |
| Fluoride           | ppm   |
| Bromine            | ppm   |
| Chloride           | ppm   |

### Authentifizierung

- **API-Schlüssel**: Du musst mit deinem API-Schlüssel authentifiziert sein, um Wasserwerte hinzuzufügen. Deinen API-Schlüssel findest du unter „Profilinformationen“ oder in deinem „Dashboard“.

## Beispielanfrage

Hier ist ein Beispiel, wie du Wasserwerte für eine Umgebung hinzufügst:

### Anfrage-URL

```
POST /api/environments/3/values/
```

### Anfrage-Body

```json
{
  "Temperatur": 29.9,
  "PH": 8.2,
  "TDS": 630
}
```

## Antwort

- **201 Created**: Wasserwerte erfolgreich hinzugefügt.
- **400 Bad Request**: Fehler in der Anfrage, z. B. fehlende oder ungültige Felder.
- **404 Not Found**: Die Umgebung existiert nicht oder gehört nicht zum Benutzer.
- **429 Too Many Requests**: Du versuchst, Werte vor Ablauf der erlaubten Upload-Frequenzzeit hochzuladen.

## Beispielantwort

```json
{
    "id": 4,
    "environment": 3,
    "parameter": {
        "id": 1,
        "name": "PH",
        "unit": "pH"
    },
    "value": "8.200",
    "measured_at": "2024-09-23T11:19:09.432111Z"
},
{
    "id": 5,
    "environment": 3,
    "parameter": {
        "id": 2,
        "name": "Temperatur",
        "unit": "°C"
    },
    "value": "29.900",
    "measured_at": "2024-09-23T11:19:09.432111Z"
},
{
    "id": 6,
    "environment": 3,
    "parameter": {
        "id": 3,
        "name": "TDS",
        "unit": "ppm"
    },
    "value": "630.000",
    "measured_at": "2024-09-23T11:19:09.432111Z"
}
```
