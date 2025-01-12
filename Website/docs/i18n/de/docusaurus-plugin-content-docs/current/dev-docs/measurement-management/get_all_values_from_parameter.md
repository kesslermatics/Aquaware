---
sidebar_position: 2
---

# Alle Werte eines Parameters abrufen

Der Endpunkt **Alle Werte eines Parameters abrufen** ermöglicht es dir, alle Wasserwerte für einen bestimmten Parameter in einer Umgebung abzurufen. Das ist nützlich, um Trends im Laufe der Zeit zu überwachen, z. B. um zu sehen, wie sich der pH-Wert oder die Temperatur des Wassers verändert hat.

## Endpunkt

`GET /api/environments/<int:environment_id>/values/parameters/<str:parameter_name>/<int:number_of_entries>/`

## Anfrageparameter

1. **environment_id**: Die ID der Umgebung, aus der du die Wasserwerte abrufen möchtest. Erforderlich und sollte eine Ganzzahl sein.
2. **parameter_name**: Der Name des Wasserparameters, den du abrufen möchtest. Muss ein String sein und mit einem der unterstützten Wasserparameter übereinstimmen.
3. **number_of_entries**: Die Anzahl der neuesten Einträge, die du für den angegebenen Parameter abrufen möchtest. Erforderlich und sollte eine Ganzzahl sein.

## Header

| Name          | Typ   | Beschreibung                                     |
| ------------- | ------ | ----------------------------------------------- |
| Authorization | string | Bearer-Token für Authentifizierung (Access Token). |
| Content-Type  | string | Muss auf `application/json` gesetzt sein.       |

## Beispielanfrage

```bash
curl -X GET "https://dev.aquaware.cloud/api/environments/1/values/parameters/PH/10/" -H "x-api-key: <api_key>"
-H "Content-Type: application/json"
```

## Beispielantwort

```json
{
  "parameter": "PH",
  "values": [
    {
      "measured_at": "2023-09-20T12:45:00Z",
      "value": 7.5,
      "unit": "pH"
    },
    {
      "measured_at": "2023-09-19T12:45:00Z",
      "value": 7.6,
      "unit": "pH"
    },
    {
      "measured_at": "2023-09-18T12:45:00Z",
      "value": 7.4,
      "unit": "pH"
    }
  ]
}
```

Im obigen Beispiel haben wir die letzten 3 pH-Werte aus Umgebung 123 abgerufen.
Jeder Eintrag enthält die Zeit der Messung (`measured_at`), den Wert (`value`) und die Einheit der Messung (`unit`).
