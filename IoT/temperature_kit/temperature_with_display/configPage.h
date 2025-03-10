#ifndef CONFIG_PAGE_H
#define CONFIG_PAGE_H

const char configPage[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Aquaware Setup</title>
    <style>
        body {
            font-family: Arial, sans-serif; 
            text-align: center; 
            margin: 0; 
            padding: 20px; 
            background-color: #061626; 
            color: #5277F5;
        }
        .input-container {
            position: relative; 
            width: 80%; 
            margin: 10px auto;
        }
        input {
            width: 100%; 
            padding: 10px; 
            margin: 5px 0; 
            border: 1px solid #5277F5; 
            background: white; 
            color: #061626; 
            border-radius: 5px; 
            outline: none; 
            font-size: 16px;
        }
        button {
            padding: 10px 20px; 
            margin-top: 15px; 
            background: #5277F5; 
            color: white; 
            border: none; 
            cursor: pointer; 
            border-radius: 5px; 
            font-size: 16px;
        }
        .language-selector {
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        select {
            padding: 5px;
            font-size: 16px;
            border: 1px solid #5277F5;
            background-color: white;
            color: #061626;
            border-radius: 5px;
            cursor: pointer;
        }
        .faq {
            margin-top: 30px;
            text-align: left;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 5px;
        }
        .faq h3 {
            color: #FFFFFF;
            font-size: 18px;
        }
        .faq p {
            font-size: 16px;
            color: #B0C4DE;
        }
        .faq a {
            color: #FFD700;
            text-decoration: none;
        }
        .faq a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Language Selector -->
    <div class="language-selector">
        <select id="language" onchange="changeLanguage()">
            <option value="en" selected>English</option>
            <option value="de">Deutsch</option>
        </select>
    </div>

    <h2 id="title">Aquaware Configuration</h2>
    <form action="/save" method="POST">
        <div class="input-container"><input type="text" name="ssid" id="ssid" placeholder="WiFi Name" required></div>
        <div class="input-container"><input type="password" name="password" id="password" placeholder="WiFi Password" required></div>
        <div class="input-container"><input type="text" name="apikey" id="apikey" placeholder="API Key" required></div>
        <div class="input-container"><input type="text" name="envid" id="envid" placeholder="Environment ID" required></div>
        <button type="submit" id="submit-btn">Save</button>
    </form>

    <!-- FAQ Section -->
    <div class="faq">
        <h3 id="faq-title">Where can I find my API Key and Environment ID?</h3>

        <h3 id="faq-api-title">API Key</h3>
        <p id="faq-api-text">
            You can find your API Key in your account settings on the Aquaware Dashboard:
            <a href="https://dashboard.aquaware.cloud/account" target="_blank">https://dashboard.aquaware.cloud/account</a>.
            Make sure you are logged in.
        </p>

        <h3 id="faq-env-title">Environment ID</h3>
        <p id="faq-env-text">
            The Environment ID can be found under the "Environments" section of the dashboard. 
            You need to create or select an environment first:
            <a href="https://dashboard.aquaware.cloud/environments" target="_blank">https://dashboard.aquaware.cloud/environments</a>.
        </p>
    </div>

    <script>
        function changeLanguage() {
            const language = document.getElementById("language").value;

            const translations = {
                "en": {
                    "title": "Aquaware Configuration",
                    "ssid": "WiFi Name",
                    "password": "WiFi Password",
                    "apikey": "API Key",
                    "envid": "Environment ID",
                    "submit-btn": "Save",
                    "faq-title": "Where can I find my API Key and Environment ID?",
                    "faq-api-title": "API Key",
                    "faq-api-text": "You can find your API Key in your account settings on the Aquaware Dashboard: ",
                    "faq-env-title": "Environment ID",
                    "faq-env-text": "The Environment ID can be found under the 'Environments' section of the dashboard. You need to create or select an environment first: "
                },
                "de": {
                    "title": "Aquaware Konfiguration",
                    "ssid": "WLAN-Name",
                    "password": "WLAN-Passwort",
                    "apikey": "API-Schlüssel",
                    "envid": "Umgebungs-ID",
                    "submit-btn": "Speichern",
                    "faq-title": "Wo finde ich meinen API-Schlüssel und die Umgebungs-ID?",
                    "faq-api-title": "API-Schlüssel",
                    "faq-api-text": "Du findest deinen API-Schlüssel in den Kontoeinstellungen auf dem Aquaware-Dashboard: ",
                    "faq-env-title": "Umgebungs-ID",
                    "faq-env-text": "Die Umgebungs-ID findest du im Bereich 'Umgebungen' des Dashboards. Du musst zuerst eine Umgebung erstellen oder auswählen: "
                }
            };

            document.getElementById("title").textContent = translations[language]["title"];
            document.getElementById("ssid").placeholder = translations[language]["ssid"];
            document.getElementById("password").placeholder = translations[language]["password"];
            document.getElementById("apikey").placeholder = translations[language]["apikey"];
            document.getElementById("envid").placeholder = translations[language]["envid"];
            document.getElementById("submit-btn").textContent = translations[language]["submit-btn"];
            
            document.getElementById("faq-title").textContent = translations[language]["faq-title"];
            document.getElementById("faq-api-title").textContent = translations[language]["faq-api-title"];
            document.getElementById("faq-env-title").textContent = translations[language]["faq-env-title"];
            
            document.getElementById("faq-api-text").innerHTML = translations[language]["faq-api-text"] +
                '<a href="https://dashboard.aquaware.cloud/account" target="_blank">https://dashboard.aquaware.cloud/account</a>.';
            document.getElementById("faq-env-text").innerHTML = translations[language]["faq-env-text"] +
                '<a href="https://dashboard.aquaware.cloud/environments" target="_blank">https://dashboard.aquaware.cloud/environments</a>.';
        }
    </script>
</body>
</html>

)rawliteral";

#endif // CONFIG_PAGE_H
