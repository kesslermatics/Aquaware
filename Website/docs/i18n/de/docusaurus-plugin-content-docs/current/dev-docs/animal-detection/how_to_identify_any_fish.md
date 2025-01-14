
# Wie man ein aquatisches Tier identifiziert

Dieser Leitfaden erklärt, wie du die **Aquaware API** verwenden kannst, um aquatische Tierarten anhand hochgeladener Bilder zu identifizieren. Die API ist nur für Nutzer mit dem **Premium-Abonnement Tier 2** verfügbar.

## API-Endpunkt

Um eine aquatische Tierart zu identifizieren, verwende den folgenden API-Endpunkt:

```
POST /api/animal/identify/
```

### Parameter:

- **image**: Ein Form-Daten-Feld, das die Bilddatei des aquatischen Tieres enthalten muss. Das Bild sollte in einem unterstützten Format vorliegen (JPEG, PNG usw.).

### Beispielanfrage (mit cURL):

```bash
curl -X POST https://dev.aquaware.cloud/api/animal/identify/ \
  -H 'X-API-KEY: dein-api-key' \
  -F 'image=@/path-to-your-image/animal_image.jpg'
```

### Abonnementvoraussetzung:

Dieser Endpunkt ist nur für Nutzer mit einem **Premium-Abonnement (Tier 2)** zugänglich. Falls ein Nutzer mit einem niedrigeren Abonnement versucht, auf diesen Endpunkt zuzugreifen, gibt die API einen 403-Statuscode mit der Nachricht zurück:

```
{
  "detail": "Diese Funktion ist nur für Premium-Abonnenten verfügbar."
}
```

## Beispielantwort

Wenn das Tier erfolgreich erkannt und analysiert wurde, gibt die API einen 200-Statuscode mit einer JSON-Antwort zurück, die etwa so aussieht:

```json
{
  "animal_detected": true,
  "species": "Betta",
  "habitat": "Süßwasserteiche und langsam fließende Bäche",
  "diet": "Karnivor, frisst Insekten und Larven",
  "average_size": "5-7 cm",
  "behavior": "Aggressiv gegenüber anderen Männchen, bevorzugt Isolation",
  "lifespan": "2-5 Jahre",
  "visual_characteristics": "Farbenfroher Körper mit großen Flossen und lebhaften Mustern"
}
```

### Statuscodes:

- **200 OK**: Das Tier wurde erfolgreich erkannt und identifiziert.
- **400 Bad Request**: Wenn kein Bild hochgeladen wurde oder das Bildformat ungültig ist, gibt die API diesen Statuscode zurück.
- **403 Forbidden**: Wenn der Nutzer nicht zu Tier 3 (Premium) abonniert ist, gibt die API diesen Statuscode zurück.
- **500 Internal Server Error**: Wenn auf dem Server oder während der Bildverarbeitung ein Fehler auftritt, wird ein 500-Statuscode zurückgegeben.

## Einschränkungen und Vorsicht:

:::warning[Beachte]

Diese API verwendet maschinelles Lernen, um die Tierart zu analysieren. Obwohl sie allgemein genau ist, kann es **Sonderfälle** geben, bei denen:

- Die Identifikation der Spezies aufgrund niedriger Bildqualität ungenau ist.
- Die visuellen Merkmale bestimmter aquatischer Tiere sich überschneiden, was zu Fehlidentifikationen führen kann.

:::

Die bereitgestellte Identifikation sollte als Empfehlung betrachtet werden, nicht als endgültiges Urteil. **Es wird keine Haftung** für falsche Identifikationen oder darauf basierende Maßnahmen übernommen.

Es wird empfohlen, bei absoluter Sicherheit einen Experten oder Fachmann für aquatische Tiere zu konsultieren.
