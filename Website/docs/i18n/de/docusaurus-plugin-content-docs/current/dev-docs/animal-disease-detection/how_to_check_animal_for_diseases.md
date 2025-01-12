
# Wie man Tiere auf Krankheiten überprüft

Dieser Leitfaden erklärt, wie du die **Aquaware API** verwenden kannst, um Fische anhand hochgeladener Bilder auf Krankheiten zu überprüfen. Die API ist nur für Nutzer mit dem **Premium-Abonnement Tier 2** verfügbar.

## API-Endpunkt

Um einen Fisch auf Krankheiten zu überprüfen, verwende den folgenden API-Endpunkt:

```
POST /api/diseases/diagnosis/
```

### Parameter:

- **image**: Ein Form-Daten-Feld, das die Bilddatei des Fisches enthalten muss. Das Bild sollte in einem unterstützten Format vorliegen (JPEG, PNG usw.).

### Beispielanfrage (mit cURL):

```bash
curl -X POST https://dev.aquaware.cloud/api/diseases/diagnosis/   -H 'Authorization: Bearer your-access-token'   -F 'image=@/path-to-your-image/fish_image.jpg'
```

### Abonnementvoraussetzung:

Dieser Endpunkt ist nur für Nutzer mit einem **Premium-Abonnement (Tier 2)** zugänglich. Falls ein Nutzer mit einem niedrigeren Abonnement versucht, auf diesen Endpunkt zuzugreifen, gibt die API einen 403-Statuscode mit der Nachricht zurück:

```
{
  "detail": "Diese Funktion ist nur für Premium-Abonnenten verfügbar."
}
```

## Beispielantwort

Wenn der Fisch erfolgreich erkannt und analysiert wurde, gibt die API einen 200-Statuscode mit einer JSON-Antwort zurück, die etwa so aussieht:

```json
{
  "fish_detected": true,
  "condition": "Flossenfäule",
  "symptoms": "Die Flossen des Fisches wirken ausgefranst und haben weiße oder trübe Ränder. Dies deutet auf eine bakterielle Infektion hin, die das Flossengewebe angreift.",
  "curing": "Verbessere die Wasserqualität durch teilweise Wasserwechsel und eine ordnungsgemäße Filterung. Behandle mit einem antibakteriellen Medikament, das speziell für Aquarien geeignet ist.",
  "certainty": 90
}
```

### Statuscodes:

- **200 OK**: Der Fisch wurde erfolgreich erkannt und diagnostiziert.
- **400 Bad Request**: Wenn kein Bild hochgeladen wurde oder das Bildformat ungültig ist, gibt die API diesen Statuscode zurück.
- **403 Forbidden**: Wenn der Nutzer nicht zu Tier 3 (Premium) abonniert ist, gibt die API diesen Statuscode zurück.
- **500 Internal Server Error**: Wenn auf dem Server oder während der Bildverarbeitung ein Fehler auftritt, wird ein 500-Statuscode zurückgegeben.

## Einschränkungen und Vorsicht:

:::warning[Beachte]

Diese API verwendet maschinelles Lernen, um den Fisch und seinen Zustand zu analysieren. Obwohl sie allgemein genau ist, kann es **Sonderfälle** geben, bei denen:

- Krankheitssymptome subtil oder schwer erkennbar sind.
- Die natürlichen Muster oder das Erscheinungsbild des Fisches Krankheitssymptomen ähneln, aber harmlos sind.

:::

Die bereitgestellte Diagnose sollte als Empfehlung betrachtet werden, nicht als endgültiges Urteil. **Es wird keine Haftung** für falsche Diagnosen oder darauf basierende Maßnahmen übernommen.

Es wird empfohlen, bei ernsthaften Bedenken einen professionellen Tierarzt oder Fischgesundheitsexperten zu konsultieren.
