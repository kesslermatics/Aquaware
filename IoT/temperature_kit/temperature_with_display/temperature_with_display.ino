#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <DNSServer.h>
#include <WebServer.h>
#include <Preferences.h>
#include "DFRobot_LcdDisplay.h"

// LCD Display Configuration
DFRobot_Lcd_IIC lcd(&Wire, 0x2c);
uint8_t labelId = 0;

const char* apSSID = "Aquaware_Setup";
const char* apPassword = "12345678";

DNSServer dnsServer;
WebServer server(80);
Preferences preferences;

void startAccessPoint();
bool validateApiKey(String apiKey, String envId);
void clearPreferences();
void connectToWiFiAndValidate();
void updateDisplay(String message);

// HTML Configuration Page
const char* configPage = R"rawliteral(
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Aquaware Setup</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 0; padding: 20px; background-color: #061626; color: #5277F5; }
        .input-container { position: relative; width: 80%; margin: 10px auto; }
        input { width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #5277F5; background: white; color: #061626; border-radius: 5px; outline: none; font-size: 16px; }
        .password-container { display: flex; align-items: center; position: relative; }
        .password-container input { flex: 1; padding-right: 40px; }
        .toggle-password { position: absolute; right: 10px; cursor: pointer; color: #5277F5; }
        button { padding: 10px 20px; margin-top: 15px; background: #5277F5; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 16px; }
        button:hover { background: #405ecf; }
    </style>
</head>
<body>
    <h2>Aquaware Configuration</h2>
    <form action="/save" method="POST">
        <div class="input-container"><input type="text" name="ssid" placeholder="WiFi Name" required></div>
        
        <div class="input-container password-container">
            <input type="password" name="password" id="password" placeholder="WiFi Password" required>
            <span class="toggle-password" onclick="togglePassword()">👁️</span>
        </div>
        
        <div class="input-container"><input type="text" name="apikey" placeholder="API Key" required></div>
        <div class="input-container"><input type="text" name="envid" placeholder="Environment ID" required></div>
        
        <button type="submit">Save</button>
    </form>

    <script>
        function togglePassword() {
            var passwordField = document.getElementById("password");
            if (passwordField.type === "password") {
                passwordField.type = "text";
            } else {
                passwordField.type = "password";
            }
        }
    </script>
</body>
</html>
)rawliteral";

// Starts the ESP32 Access Point
void startAccessPoint() {
    updateDisplay("Starting AP...");
    Serial.println("Starting Access Point...");
    
    WiFi.softAP(apSSID, apPassword);
    dnsServer.start(53, "*", WiFi.softAPIP());

    server.on("/", HTTP_GET, []() {
        server.send(200, "text/html", configPage);
    });

    server.on("/save", HTTP_POST, []() {
        if (server.hasArg("ssid") && server.hasArg("password") && server.hasArg("apikey") && server.hasArg("envid")) {
            String ssid = server.arg("ssid");
            String password = server.arg("password");
            String apiKey = server.arg("apikey");
            String envId = server.arg("envid");

            updateDisplay("Connecting WiFi...");
            Serial.println("Received credentials, trying to connect to WiFi...");
            WiFi.begin(ssid.c_str(), password.c_str());

            unsigned long startTime = millis();
            while (WiFi.status() != WL_CONNECTED && millis() - startTime < 10000) {
                delay(500);
                Serial.print(".");
            }

            if (WiFi.status() == WL_CONNECTED) {
                updateDisplay("WiFi Connected!");
                Serial.println("\nConnected to WiFi! Validating API Key...");

                if (validateApiKey(apiKey, envId)) {
                    updateDisplay("API Key valid! Saving...");
                    Serial.println("API Key is valid, saving preferences...");

                    preferences.begin("wifi", false);
                    preferences.putString("ssid", ssid);
                    preferences.putString("password", password);
                    preferences.putString("api-key", apiKey);
                    preferences.putString("env-id", envId);
                    preferences.end();

                    // server.send(200, "text/html", "<h3>Saved! Restarting ESP32...</h3>");
                    server.close();
                    delay(2000);
                    ESP.restart();
                } else {
                    updateDisplay("API Key Invalid!");
                    Serial.println("API Key validation failed!");
                    server.send(403, "text/html", "<h3>Invalid API Key or Environment ID!</h3>");
                }
            } else {
                updateDisplay("WiFi Failed!");
                Serial.println("WiFi connection failed. Restarting Access Point...");
                clearPreferences();
                startAccessPoint();
            }
        } else {
            updateDisplay("Missing Data!");
            server.send(400, "text/html", "<h3>Missing Data!</h3>");
        }
    });

    server.begin();
    Serial.println("Access Point started.");
}

// Validates the API Key
bool validateApiKey(String apiKey, String envId) {
    if (WiFi.status() != WL_CONNECTED) {
        updateDisplay("WiFi Not Connected!");
        Serial.println("Not connected to WiFi!");
        return false;
    }

    String url = "https://dev.aquaware.cloud/api/environments/";
    HTTPClient http;
    WiFiClientSecure client;
    client.setInsecure();

    http.begin(client, url);
    http.addHeader("x-api-key", apiKey);

    int httpResponseCode = http.GET();
    Serial.print("API Response Code: ");
    Serial.println(httpResponseCode);

    updateDisplay("API Response: " + String(httpResponseCode));

    bool isValid = httpResponseCode == 200;
    http.end();
    
    return isValid;
}

// Clears stored preferences
void clearPreferences() {
    updateDisplay("Clearing Preferences...");
    Serial.println("Clearing stored preferences...");
    preferences.begin("wifi", false);
    preferences.clear();
    preferences.end();
}

// Connects to WiFi and validates stored credentials
void connectToWiFiAndValidate() {
    preferences.begin("wifi", true);
    String ssid = preferences.getString("ssid", "");
    String password = preferences.getString("password", "");
    String apiKey = preferences.getString("api-key", "");
    String envId = preferences.getString("env-id", "");
    preferences.end();

    if (ssid != "" && password != "" && apiKey != "" && envId != "") {
        updateDisplay("Connecting to WiFi...");
        Serial.println("Connecting to stored WiFi...");
        WiFi.begin(ssid.c_str(), password.c_str());

        unsigned long startTime = millis();
        while (WiFi.status() != WL_CONNECTED && millis() - startTime < 10000) {
            delay(500);
            Serial.print(".");
        }

        if (WiFi.status() == WL_CONNECTED) {
            updateDisplay("Validating API...");
            Serial.println("\nConnected to WiFi. Validating API Key...");
            if (validateApiKey(apiKey, envId)) {
                updateDisplay("Device Ready!");
                Serial.println("API Key is valid. Device ready.");
                return;
            } else {
                updateDisplay("Invalid API Key!");
                Serial.println("API Key validation failed. Restarting setup...");
                clearPreferences();
            }
        } else {
            updateDisplay("WiFi Failed!");
            Serial.println("WiFi connection failed. Restarting setup...");
            clearPreferences();
        }
    } else {
        updateDisplay("No Credentials Found!");
        Serial.println("No valid stored credentials found.");
    }

    startAccessPoint();
}

// Updates LCD Display
void updateDisplay(String message) {
    lcd.cleanScreen();
    labelId = lcd.drawString(10, 10, message.c_str(), 1, BLUE);
}

// Setup function
void setup() {
    Serial.begin(115200);
    lcd.begin();
    lcd.cleanScreen();
    lcd.setBackgroundColor(WHITE);
    updateDisplay("Starting ESP32...");

    connectToWiFiAndValidate();
}

// Main loop
void loop() {
    dnsServer.processNextRequest();
    server.handleClient();
}
