---
sidebar_position: 5
---

# Eine Umgebung löschen

Um eine Umgebung zu löschen, kannst du diesen API-Endpunkt verwenden:

- **URL:** `https://dev.aquaware.cloud/api/environments/<int:id>/`
- **Methode:** `DELETE`
- **Authentifizierung:** Du musst deinen API-Schlüssel mit angeben

## Wichtige Hinweise

Wenn du eine Umgebung löschst, **kann diese Aktion nicht rückgängig gemacht werden**. Stelle sicher, dass du dir vor dem Löschen sicher bist. Sobald eine Umgebung gelöscht wurde, kann sie nicht wiederhergestellt werden.

### Beispielanfrage

```bash
DELETE https://dev.aquaware.cloud/api/environments/1/
X-API-KEY: <dein-api-key>
```

### Beispielantwort

Wenn das Löschen erfolgreich ist, erhältst du eine Antwort `204 No Content` mit einer Erfolgsmeldung.

```json
{
  "message": "Umgebung erfolgreich gelöscht."
}
```

### Fehlerbehandlung

Wenn die Umgebung nicht dir gehört oder die ID nicht existiert, gibt die API einen `404 Not Found`-Fehler zurück.

```json
{
  "error": "Umgebung nicht gefunden oder gehört nicht diesem Nutzer."
}
```

:::info

Beim Löschen einer Umgebung werden die **Wasserwerte**, die mit dieser Umgebung verknüpft sind, **nicht aus der Datenbank gelöscht**. Sie sind jedoch nicht mehr mit einem Konto verknüpft. Diese Wasserwerte bleiben für Analysezwecke verfügbar, können aber nicht mehr dem Nutzer zugeordnet werden, der sie erstellt hat.

:::
