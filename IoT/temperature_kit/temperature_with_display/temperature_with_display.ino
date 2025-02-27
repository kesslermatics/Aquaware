#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <DNSServer.h>
#include <WebServer.h>
#include <Preferences.h>
#include <Wire.h>
#include "DFRobot_LcdDisplay.h"
#include <OneWire.h>
#include <DallasTemperature.h>

// ----------------------------------------------------------------------------
// LCD setup (I2C address: 0x2c)
// ----------------------------------------------------------------------------
DFRobot_Lcd_IIC lcd(&Wire, 0x2c);

// ----------------------------------------------------------------------------
// Sensor pins (adjust according to your board)
// ----------------------------------------------------------------------------
#define TEMP_PIN  13  // e.g., "D7" on some boards = GPIO13
#define TDS_PIN   36  // e.g., "A0" on some ESP32 boards = GPIO36

// ----------------------------------------------------------------------------
// OneWire & DallasTemperature
// ----------------------------------------------------------------------------
OneWire oneWire(TEMP_PIN);
DallasTemperature tempSensor(&oneWire);

uint8_t tempLabel, tdsLabel;

uint8_t envNameLabel;

// ----------------------------------------------------------------------------
// WiFi / Server / Preferences
// ----------------------------------------------------------------------------
const char* apSSID     = "Aquaware_Setup";
const char* apPassword = "12345678";

DNSServer dnsServer;
WebServer server(80);
Preferences preferences;

// We now fix the refresh interval to 30 seconds (30,000 ms),
// even if the server returns a different interval.
unsigned long updateInterval = 30000;  // 30-second refresh
unsigned long lastUpdate      = 20000;

// ----------------------------------------------------------------------------
// HTML configuration page
// ----------------------------------------------------------------------------
const char* configPage = R"rawliteral(
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

// ----------------------------------------------------------------------------
// Function prototypes
// ----------------------------------------------------------------------------
void connectToWiFiAndValidate();
void fetchEnvironmentName(const String& envId);
void fetchUpdateFrequency();
void updateDisplay(float temperature, float tds);

void setup() {
  Serial.begin(115200);
  Serial.println("\n[Setup] Starting ESP32 Sensor Display...");

  // Initialize LCD
  if (lcd.begin()) {
    lcd.cleanScreen();
    lcd.setBackgroundColor(BLACK);
    Serial.println("[LCD] Successfully initialized.");
  } else {
    Serial.println("[LCD] Error initializing! Check I2C address/wiring.");
  }

  // Initialize temperature sensor
  tempSensor.begin();

  // Connect to WiFi and fetch environment info
  connectToWiFiAndValidate();

  // Retrieve environment name from Preferences
  preferences.begin("wifi", true);
  String envName = preferences.getString("env-name", "Unknown");
  preferences.end();

  // Show environment name at the top-left
  envNameLabel = lcd.drawString(10, 10, "", 2, WHITE);

  // Create labels for sensor values
  tempLabel = lcd.drawString(100,  45, "",    0, ORANGE);
  tdsLabel  = lcd.drawString(100,  95, "", 0, BLUE);

  lcd.drawString(20, 50, "TEMP: ", 1, ORANGE);
  lcd.drawString(20, 80, "TDS: ", 1, BLUE);

  // Set up web server routes
  server.on("/", HTTP_GET, []() {
    server.send(200, "text/html", configPage);
  });

  server.on("/save", HTTP_POST, []() {
    String ssid     = server.arg("ssid");
    String password = server.arg("password");
    String apiKey   = server.arg("apikey");
    String envId    = server.arg("envid");
    String language = server.arg("language");

    preferences.begin("wifi", false);
    preferences.putString("ssid", ssid);
    preferences.putString("password", password);
    preferences.putString("api-key", apiKey);
    preferences.putString("env-id", envId);
    preferences.putString("language", language); 
    preferences.end();

    // Reconnect and refetch environment info
    connectToWiFiAndValidate();

    server.send(200, "text/html", "<h2>Saved! The device will attempt to reconnect.</h2>");
  });

  server.begin();
}

void loop() {
  dnsServer.processNextRequest();
  server.handleClient();

  // Read and update sensor data every 'updateInterval' ms (currently 30 seconds)
  if (millis() - lastUpdate >= updateInterval) {
    lastUpdate = millis();

    // Read temperature
    tempSensor.requestTemperatures();
    float temperature = tempSensor.getTempCByIndex(0);
    if (temperature == DEVICE_DISCONNECTED_C) {
      Serial.println("[Sensors] Temperature sensor not found!");
      temperature = -99; // dummy error value
    }

    // Read TDS/TSS from analog inputs
    int tdsRaw = analogRead(TDS_PIN);

    // Convert raw values to mg/L (example scaling)
    float tdsValue = (tdsRaw / 4095.0f) * 1000;

    // Update LCD
    updateDisplay(temperature, tdsValue);

    // Print data to Serial
    Serial.print("[Sensors] Temperature: ");
    Serial.print(temperature);
    Serial.println(" °C");
    Serial.print("[Sensors] TDS: ");
    Serial.print(tdsValue);
    Serial.println(" mg/L");
    Serial.println("-----------------------------");
  }
}

// ----------------------------------------------------------------------------
// Update LCD display with sensor values
// ----------------------------------------------------------------------------
void updateDisplay(float temperature, float tds) {
  lcd.updateString(tempLabel, 100, 50, String(temperature) + "°C", 1, ORANGE);
  lcd.updateString(tdsLabel, 100, 80, String(tds) + " mg/L", 1, BLUE);
}

// ----------------------------------------------------------------------------
// Connect to WiFi and fetch environment data
// ----------------------------------------------------------------------------
void connectToWiFiAndValidate() {
  preferences.begin("wifi", true);
  String ssid     = preferences.getString("ssid", "");
  String password = preferences.getString("password", "");
  String apiKey   = preferences.getString("api-key", "");
  String envId    = preferences.getString("env-id", "");
  preferences.end();

  // If any required field is empty, start AP
  if (ssid == "" || password == "" || apiKey == "" || envId == "") {
    Serial.println("[WiFi] Starting Access Point...");

    WiFi.softAP(apSSID, apPassword);
    IPAddress apIP = WiFi.softAPIP();
    Serial.print("[WiFi] AP IP Address: ");
    Serial.println(apIP);

    // Start DNS Server to redirect all requests to the ESP32
    dnsServer.start(53, "*", apIP);

    // Handle all unknown routes by serving the configuration page
    server.onNotFound([]() {
        server.send(200, "text/html", configPage);
    });

    server.begin();
    Serial.println("[WiFi] Captive Portal ready. Connect to the AP and it should open automatically.");

    return;
  }

  // Connect as station
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());
  Serial.print("[WiFi] Connecting to: ");
  Serial.println(ssid);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n[WiFi] Connected!");

  // Fetch environment name and update frequency
  fetchEnvironmentName(envId);
  fetchUpdateFrequency();

  // After fetching environment name, update the top-left label on the LCD
  preferences.begin("wifi", true);
  String envName = preferences.getString("env-name", "Unknown");
  preferences.end();
  // Overwrite old text
  lcd.updateString(envNameLabel, 10, 10, envName, 2, WHITE);
}

void clearPreferences() {
    Serial.println("[System] Clearing stored preferences and resetting to Access Point mode...");
    preferences.begin("wifi", false);
    preferences.clear();
    preferences.end();
}

// ----------------------------------------------------------------------------
// Fetch environment name from server (handles 301 redirects)
// ----------------------------------------------------------------------------
void fetchEnvironmentName(const String& envId) {
  preferences.begin("wifi", true);
  String apiKey = preferences.getString("api-key", "");
  preferences.end();

  if (WiFi.status() != WL_CONNECTED) return;

  String url = "https://dev.aquaware.cloud/api/environments/" + envId + "/";

  HTTPClient http;
  WiFiClientSecure client;
  client.setInsecure();

  // Force follow redirects
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);

  http.begin(client, url);
  http.addHeader("x-api-key", apiKey);

  int httpResponseCode = http.GET();
  Serial.println("[EnvName] HTTP code: " + String(httpResponseCode));

  if (httpResponseCode == 200) {
    String response = http.getString();
    Serial.println("[EnvName] Response: " + response);

    int nameIndex = response.indexOf("\"name\":");
    if (nameIndex != -1) {
      int start = response.indexOf("\"", nameIndex + 7) + 1;
      int end   = response.indexOf("\"", start);
      if (start > 0 && end > start) {
        String envName = response.substring(start, end);

        preferences.begin("wifi", false);
        preferences.putString("env-name", envName);
        preferences.end();

        Serial.println("[EnvName] Extracted: " + envName);
      }
    }
  } else {
    Serial.println("[EnvName] Error or non-200 code.");
    clearPreferences();   
    setup();
  }
  http.end();
}

// ----------------------------------------------------------------------------
// Fetch update frequency and store it without using it (server might return
// e.g. {"milliseconds":43200000,...})
// ----------------------------------------------------------------------------
void fetchUpdateFrequency() {
  preferences.begin("wifi", true);
  String apiKey = preferences.getString("api-key", "");
  preferences.end();

  if (WiFi.status() != WL_CONNECTED) return;

  String url = "https://dev.aquaware.cloud/api/users/update-frequency/";
  HTTPClient http;
  WiFiClientSecure client;
  client.setInsecure();

  // Follow redirects
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);

  http.begin(client, url);
  http.addHeader("x-api-key", apiKey);

  int httpResponseCode = http.GET();
  Serial.println("[UpdateFreq] HTTP code: " + String(httpResponseCode));

  if (httpResponseCode == 200) {
    String response = http.getString();
    Serial.println("[UpdateFreq] Response: " + response);

    // Look for the "milliseconds" key
    int msIndex = response.indexOf("\"milliseconds\":");
    if (msIndex != -1) {
      int colonIndex = response.indexOf(':', msIndex);
      if (colonIndex != -1) {
        int start = colonIndex + 1;
        // The value might end at a comma or '}'.
        int commaIndex = response.indexOf(',', start);
        if (commaIndex == -1) {
          commaIndex = response.indexOf('}', start);
        }
        if (commaIndex == -1) {
          commaIndex = response.length();
        }
        String msValueStr = response.substring(start, commaIndex);
        msValueStr.trim();

        unsigned long newInterval = msValueStr.toInt();
        if (newInterval > 0) {
          // Store the interval in preferences, but do not use it
          preferences.begin("wifi", false);
          preferences.putULong("server-interval", newInterval);
          preferences.end();

          Serial.println("[UpdateFreq] Stored server interval: " + String(newInterval) + " ms (NOT applied)");
        } else {
          Serial.println("[UpdateFreq] Could not parse 'milliseconds' properly.");
        }
      }
    }
  } else {
    Serial.println("[UpdateFreq] Error or non-200 code.");
    clearPreferences();   
    setup();
  }
  http.end();
}
