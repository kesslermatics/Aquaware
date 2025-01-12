---
sidebar_position: 4
---

# Zugriffstoken erneuern

Der Prozess des **Erneuerns des Zugriffstokens** ist entscheidend, um deine Sitzung aktiv zu halten, ohne dass du dich jedes Mal neu anmelden musst, wenn dein Zugriffstoken abläuft. Mit dem Refresh-Token kann ein neues Zugriffstoken generiert werden, um eine durchgehende Authentifizierung zu gewährleisten.

### Endpunkt

```
POST https://dev.aquaware.cloud/api/users/auth/token/refresh/
```

### Anfrage-Body

Der Anfrage-Body enthält das Refresh-Token, das bei der ursprünglichen Authentifizierung ausgegeben wurde:

```json
{
  "refresh": "dein_refresh_token"
}
```

**Beispiel:**

In Postman oder einem anderen API-Client kannst du eine POST-Anfrage senden, um dein Zugriffstoken wie im Screenshot gezeigt zu erneuern:

- Methode: `POST`
- URL: `https://dev.aquaware.cloud/api/users/auth/token/refresh/`
- Body: form-data mit dem Schlüssel `refresh` und deinem Refresh-Token.

### Antwort

Bei Erfolg wird ein neues Zugriffstoken zurückgegeben:

```json
{
  "access": "new_access_token"
}
```

### Lebenszyklus von Tokens

Das **Zugriffstoken** hat normalerweise eine kurze Lebensdauer (z. B. 5 bis 30 Minuten). Wenn es abläuft, kannst du mit dem **Refresh-Token**, das eine wesentlich längere Ablaufzeit hat (z. B. 7 Tage oder mehr), ein neues Zugriffstoken anfordern.

### Sicherheitstipp

:::tip
Speichere das **Refresh-Token** sicher, entweder im **local storage** oder in einem sicheren Cookie. Tokens sollten niemals so gespeichert werden, dass sie von unbefugten Dritten zugänglich sind.
:::

Durch das Beibehalten des Refresh-Tokens kannst du eingeloggt bleiben, ohne häufig deine Anmeldedaten neu eingeben zu müssen.

### Autorisierungs-Header

Bei weiteren Anfragen denk daran, das neu ausgestellte Zugriffstoken im `Authorization`-Header zu übergeben:

```
Authorization: Bearer new_access_token
```

So kannst du API-Anfragen mit dem neu erstellten Token authentifizieren.
