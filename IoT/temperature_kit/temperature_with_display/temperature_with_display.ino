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
#include "configPage.h"

DFRobot_Lcd_IIC lcd(&Wire, 0x2c);
#define TEMP_PIN  D7  // e.g., "D7" on some boards = GPIO13
#define TDS_PIN A0 
#define VREF 3.3  

OneWire oneWire(TEMP_PIN);
DallasTemperature tempSensor(&oneWire);

uint8_t tempLabel, tdsLabel;
uint8_t envNameLabel;
uint8_t hour = 0, minute = 0;

const char* apSSID     = "Aquaware Setup";
const char* apPassword = "12345678";

DNSServer dnsServer;
WebServer server(80);
Preferences preferences;

unsigned long updateInterval = 1800000;  // 30 Minutes (30 * 60 * 1000 ms)
unsigned long lastUpload     = 0;
unsigned long lastDisplayUpdate = 0;

void connectToWiFiAndValidate();
void fetchEnvironmentName(const String& envId);
void fetchUpdateFrequency();
void updateDisplay(float temperature, float tds);
void sendSensorData(float temperature, float tds);
float readTDS(float temperature);

void setup() {
  delay(2000);
  Serial.begin(115200);
  Serial.println("\n[Setup] Starting ESP32 Sensor Display...");

  if (lcd.begin()) {
    lcd.cleanScreen();
    lcd.setBackgroundColor(BLACK);
    Serial.println("[LCD] Successfully initialized.");
  } else {
    Serial.println("[LCD] Error initializing! Check I2C address/wiring.");
  }

  envNameLabel = lcd.drawString(10, 10, "", 2, WHITE);
  tempLabel = lcd.drawString(100, 60, "", 1, ORANGE);
  tdsLabel = lcd.drawString(100, 110, "", 1, BLUE);

  tempSensor.begin();

  connectToWiFiAndValidate();

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

    connectToWiFiAndValidate();

    server.send(200, "text/html", "<h2>Saved! The device will attempt to reconnect.</h2>");
  });

  server.begin();
}

void loop() {
  dnsServer.processNextRequest();
  server.handleClient();
  unsigned long currentTime = millis();

  if (currentTime - lastDisplayUpdate >= 30000) {

    lastDisplayUpdate = currentTime;

    tempSensor.requestTemperatures();
    float temperature = tempSensor.getTempCByIndex(0);
    float tdsValue = readTDS(temperature);

    updateDisplay(temperature, tdsValue);

    Serial.print("[Sensors] Temperature: ");
    Serial.print(temperature);
    Serial.println(" °C");
    Serial.print("[Sensors] TDS: ");
    Serial.print(tdsValue);
    Serial.println(" mg/L");
    Serial.println("-----------------------------");
  }

  if (currentTime - lastUpload >= updateInterval) {
        lastUpload = currentTime;

        tempSensor.requestTemperatures();
        float temperature = tempSensor.getTempCByIndex(0);
        float tdsValue = readTDS(temperature);

        sendSensorData(temperature, tdsValue);
    }
}

// ----------------------------------------------------------------------------
// Update LCD display with sensor values
// ----------------------------------------------------------------------------
void updateDisplay(float temperature, float tds) {
    // Retrieve environment name from Preferences
    preferences.begin("wifi", true);
    String envName = preferences.getString("env-name", "");
    preferences.end();

    // Only update the screen if an environment is set
    if (envName.length() > 0) {
      lcd.drawIcon(30, 40, "/sensor icon/thermometer.png", 120);
      lcd.drawIcon(20, 90, "/sensor icon/raindrops.png", 120);

        // Update environment name
        lcd.updateString(envNameLabel, 10, 10, envName, 2, WHITE);

        // Update temperature & TDS values
        lcd.updateString(tempLabel, 100, 60, String(temperature) + "°C", 1, ORANGE);
        lcd.updateString(tdsLabel, 100, 110, String(tds) + " mg/L", 1, BLUE);
    }
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

    lcd.cleanScreen();
    lcd.drawString(10, 50, "Verbinde mit WLAN:", 1, WHITE);
    lcd.drawString(10, 70, "Aquaware_Setup", 1, WHITE);
    lcd.drawString(10, 90, "Passwort: 12345678", 1, WHITE);

    lcd.drawString(10, 140, "Connect to WiFi:", 1, WHITE);
    lcd.drawString(10, 160, "Aquaware_Setup", 1, WHITE);
    lcd.drawString(10, 180, "Password: 12345678", 1, WHITE);

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

  // Retrieve the saved language preference
  preferences.begin("wifi", true);
  String language = preferences.getString("language", "en"); // Default to English
  preferences.end();

  lcd.cleanScreen();

  if (language == "de") {
    lcd.drawString(10, 20, "Verbinde mit WLAN...", 2, WHITE);
    lcd.drawString(10, 50, ssid.c_str(), 1, WHITE);
  } else {  // Default: English
    lcd.drawString(10, 20, "Connecting to WiFi...", 2, WHITE);
    lcd.drawString(10, 50, ssid.c_str(), 1, WHITE);
  }


  // Connect as station
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());
  Serial.print("[WiFi] Connecting to: ");
  Serial.println(ssid);

  unsigned long startAttemptTime = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - startAttemptTime < 10000) {  // 10 Sekunden Timeout
      delay(500);
      Serial.print(".");
  }
  Serial.println("\n[WiFi] Connected!");

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WiFi] Connected!");

    preferences.begin("wifi", true);
    String language = preferences.getString("language", "en"); // Default to English
    preferences.end();

    lcd.cleanScreen();
    Serial.println(language);
    if (language == "de") {
        lcd.drawString(10, 30, "WLAN verbunden!", 2, WHITE);
        lcd.drawString(10, 50, ssid.c_str(), 1, WHITE);
        lcd.drawString(10, 80, "Warte auf Messung...", 1, WHITE);
    } else {  // Default: English
        lcd.drawString(10, 30, "WiFi connected!", 2, WHITE);
        lcd.drawString(10, 50, ssid.c_str(), 1, WHITE);
        lcd.drawString(10, 80, "Waiting for measurement...", 1, WHITE);
    }
    delay(5000);
    lcd.cleanScreen();

    // Fetch environment name and update interval
    fetchEnvironmentName(envId);
    fetchUpdateFrequency();

    // Update environment name in the display
    preferences.begin("wifi", true);
    String envName = preferences.getString("env-name", "Unknown");
    preferences.end();

  } else {
    Serial.println("\n[WiFi] Connection failed! Restarting AP...");

    lcd.cleanScreen();

    if (language == "de") {
        lcd.drawString(10, 20, "WLAN fehlgeschlagen!", 2, WHITE);
        lcd.drawString(10, 50, "Starte AP-Modus...", 1, WHITE);
    } else {  // Default: English
        lcd.drawString(10, 20, "WiFi failed!", 2, WHITE);
        lcd.drawString(10, 50, "Starting AP mode...", 1, WHITE);
    }

    delay(3000);
    preferences.begin("wifi", false);
    preferences.end();
    ESP.restart();
  }

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
    
    lcd.drawString(30, 150, "Error while fetching env-name", 2, ORANGE);  
  } else {
    Serial.println("[EnvName] Error or non-200 code.");
    lcd.drawString(30, 150, "Error while fetching env-name", 2, ORANGE);  
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
    lcd.drawString(30, 150, "Error while fetching frequency", 2, ORANGE);  
    setup();
  }
  http.end();
}

void sendSensorData(float temperature, float tds) {
    preferences.begin("wifi", true);
    String apiKey = preferences.getString("api-key", "");
    String envId = preferences.getString("env-id", "");
    preferences.end();

    if (WiFi.status() != WL_CONNECTED || apiKey == "" || envId == "") {
        Serial.println("[API] No WiFi or missing credentials. Skipping data send.");
        return;
    }

    String url = "https://dev.aquaware.cloud/api/environments/" + envId + "/values/";
    
    HTTPClient http;
    WiFiClientSecure client;
    client.setInsecure();

    http.begin(client, url);
    http.addHeader("Content-Type", "application/json");
    http.addHeader("x-api-key", apiKey);

    // JSON Payload erstellen
    String payload = "{\"Temperature\": " + String(temperature) + ", \"TDS\": " + String(tds) + "}";

    Serial.println("[API] Sending data: " + payload);

    int httpResponseCode = http.POST(payload);
    Serial.println("[API] Response Code: " + String(httpResponseCode));

    if (httpResponseCode != 201) {
        Serial.println("[ERROR] API request failed! Resetting device...");
        preferences.begin("wifi", false);
        lcd.drawString(30, 120, "Error while uploading", 1, ORANGE);  

        preferences.end();
        ESP.restart();
    } else {
        Serial.println("[API] Data successfully sent!");
        lcd.drawString(30, 150, "Error while sending data", 2, ORANGE);  
    }

    http.end();
}   

float readTDS(float temperature) {
    int rawADC = analogRead(TDS_PIN);
    float voltage = (rawADC / 4095.0) * VREF;

    float compensationCoefficient = 1.0 + 0.02 * (temperature - 25.0);
    float compensationVoltage = voltage / compensationCoefficient;

    float tdsValue = (133.42 * pow(compensationVoltage, 3)
                     - 255.86 * pow(compensationVoltage, 2)
                     + 857.39 * compensationVoltage) * 0.5;
    return tdsValue;
}