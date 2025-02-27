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
    </style>
</head>
<body>
    <h2>Aquaware Configuration</h2>
    <form action="/save" method="POST">
        <div class="input-container"><input type="text" name="ssid" placeholder="WiFi Name" required></div>
        <div class="input-container"><input type="password" name="password" placeholder="WiFi Password" required></div>
        <div class="input-container"><input type="text" name="apikey" placeholder="API Key" required></div>
        <div class="input-container"><input type="text" name="envid" placeholder="Environment ID" required></div>
        <button type="submit">Save</button>
    </form>
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

    preferences.begin("wifi", false);
    preferences.putString("ssid", ssid);
    preferences.putString("password", password);
    preferences.putString("api-key", apiKey);
    preferences.putString("env-id", envId);
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
    WiFi.mode(WIFI_AP);
    WiFi.softAP(apSSID, apPassword);
    dnsServer.start(53, "*", WiFi.softAPIP());
    Serial.println("[WiFi] AP started: " + String(apSSID));
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
  }
  http.end();
}
