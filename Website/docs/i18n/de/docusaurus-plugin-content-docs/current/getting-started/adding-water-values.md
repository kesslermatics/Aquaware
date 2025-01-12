---
sidebar_position: 5
---

# Wasserparameter hinzufügen

Um genaue Aufzeichnungen über deine Wasserumgebung zu führen, kannst du Wasserparameter direkt in deine Umgebung hochladen. Hier findest du alle Details, die du benötigst, einschließlich der Verwendung deines API-Schlüssels und der Umgebungs-ID sowie der Übermittlung von Daten per POST-Anfrage.

## Voraussetzungen

Bevor du Wasserparameter hochlädst, stelle sicher, dass du Folgendes hast:

1. **API-Schlüssel**: Deinen einzigartigen API-Schlüssel findest du im [Aquaware Dashboard](https://dashboard.aquaware.cloud). Dieser Schlüssel ist für die Autorisierung erforderlich.
2. **Umgebungs-ID**: Die ID der spezifischen Umgebung, zu der du Daten hochladen möchtest. Diese ist in der Umgebungsliste deines Dashboards sichtbar.

:::note[Wichtig]
Die Häufigkeit, mit der du Wasserparameter hochladen kannst, hängt von deinem Abonnementplan ab. Du kannst deinen Plan und dessen Upload-Frequenz im Dashboard einsehen. Zum Beispiel können Nutzer des Premium-Plans Parameter alle 30 Minuten hochladen, während andere längere Intervalle haben.
:::

---

## So lädst du Parameter hoch

Du kannst Wasserparameter über eine POST-Anfrage an den folgenden Endpunkt hochladen:

```
https://dev.aquaware.cloud/api/environments/<int:environment_id>/values/
```

### Header

- **`x-api-key`**: Dein API-Schlüssel für die Autorisierung.

### Beispiel-Body

Hier ist ein Beispiel-Body für das Hochladen der Wassertemperatur. Angenommen, dein Abonnement erlaubt Uploads alle 3 Stunden:

```json
{
  "Temperature": 29.9
}
```

Du kannst `Temperature` durch jeden anderen verfügbaren Parameter ersetzen.

---

## Unterstützte Wasserparameter

Aquaware unterstützt eine Vielzahl von Parametern zur Überwachung deiner Wasserumgebung. Hier ist die vollständige Liste:

| Name               | Unit  |
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

---

## Beispiel: Temperatur mit Arduino hochladen

Wenn du Arduino und einen Temperatursensor nutzt, hier ein einfaches Beispiel, wie du die Wassertemperatur alle 3 Stunden hochladen kannst:

### Code-Beispiel

```cpp
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "dein_wifi_ssid";
const char* password = "dein_wifi_passwort";

const String apiEndpoint = "https://dev.aquaware.cloud/api/environments/<Environment_ID>/values/";
const String apiKey = "dein_api_key";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Verbinde mit WiFi...");
  }

  Serial.println("Mit WiFi verbunden");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(apiEndpoint);
    http.addHeader("Content-Type", "application/json");
    http.addHeader("x-api-key", apiKey);

    String payload = "{"Temperature":29.9}";
    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      Serial.printf("POST-Antwortcode: %d
", httpResponseCode);
    } else {
      Serial.printf("Fehler: %s
", http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  }

  delay(10800000); // Verzögerung: 3 Stunden
}
```

---

Perfekt, das war's. Jetzt kannst du deine Wasserwerte mit unserer offiziellen App ansehen.
