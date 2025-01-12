---
sidebar_position: 3
---

# JWT-Tokens verstehen

Wenn du dich bei Aquaware anmeldest, erhältst du **JWT-Tokens**, die für die Authentifizierung und Autorisierung deiner Anfragen an die API entscheidend sind. JWT (JSON Web Token) ist ein sicheres, kompaktes Token-Format, das Informationen zwischen zwei Parteien darstellt.

## Arten von JWT-Tokens

Aquaware bietet zwei Arten von JWT-Tokens:

### Access Token

- Dieses Token wird zur Authentifizierung deiner API-Anfragen verwendet. Es hat eine **kurze Lebensdauer** (z. B. 5 Minuten), um die Sicherheit zu gewährleisten.
- Du musst das Access Token in der **Authorization Bearer Header** jeder Anfrage einschließen, die eine Authentifizierung erfordert.

### Refresh Token

- Dieses Token wird verwendet, um dein Access Token zu **erneuern**, wenn es abläuft. Es hat eine **längere Lebensdauer** (z. B. mehrere Tage/Monate/Jahre) und kann verwendet werden, um ein neues Access Token zu beantragen, ohne dass du dich erneut anmelden musst.

:::tip

Speichere das Refresh Token lokal (z. B. im Local Storage oder in einem sicheren Cookie), um deine Sitzung aufrechtzuerhalten und zu vermeiden, dass du ausgeloggt wirst. So kannst du neue Access Tokens anfordern, ohne deine Zugangsdaten erneut eingeben zu müssen.

:::

### Beispiel: Verwendung des Authorization Headers

Wenn du eine API-Anfrage sendest, musst du das Access Token im Request Header mit dem `Authorization: Bearer`-Schema übermitteln, so:

```bash
Authorization: Bearer <access_token>
```

## Access Token vs. Refresh Token

| **Aspekt**       | **Access Token**                                      | **Refresh Token**                         |
| ----------------- | ----------------------------------------------------- | ----------------------------------------- |
| **Zweck**        | Wird für authentifizierte API-Anfragen verwendet       | Wird verwendet, um ein neues Access Token zu generieren |
| **Lebensdauer**  | Kurzlebig (z. B. 15 Minuten)                           | Längerlebig (z. B. mehrere Tage)          |
| **Speicherort**  | Wird mit jeder Anfrage im Authorization Header gesendet | Wird lokal gespeichert (z. B. Local Storage) |
| **Wann nutzen**  | Bei jeder authentifizierten API-Anfrage                | Wenn das Access Token abläuft             |
