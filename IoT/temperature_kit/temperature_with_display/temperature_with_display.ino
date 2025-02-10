#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <DNSServer.h>
#include <WebServer.h>
#include <Preferences.h>

const char* apSSID = "Aquaware_Setup";
const char* apPassword = "12345678";

DNSServer dnsServer;
WebServer server(80);
Preferences preferences;

void startAccessPoint();
bool validateApiKey(String apiKey, String envId);
void clearPreferences();
void connectToWiFiAndValidate();

// HTML configuration page
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
        button { padding: 10px 20px; margin-top: 15px; background: #5277F5; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 16px; }
        button:hover { background: #405ecf; }
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

// Starts the ESP32 Access Point
void startAccessPoint() {
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

            Serial.println("Received credentials, trying to connect to WiFi...");
            WiFi.begin(ssid.c_str(), password.c_str());

            unsigned long startTime = millis();
            while (WiFi.status() != WL_CONNECTED && millis() - startTime < 10000) {
                delay(500);
                Serial.print(".");
            }

            if (WiFi.status() == WL_CONNECTED) {
                Serial.println("\nConnected to WiFi! Validating API Key...");
                if (validateApiKey(apiKey, envId)) {
                    Serial.println("API Key is valid, saving preferences...");
                    preferences.begin("wifi", false);
                    preferences.putString("ssid", ssid);
                    preferences.putString("password", password);
                    preferences.putString("api-key", apiKey);
                    preferences.putString("env-id", envId);
                    preferences.end();

                    server.send(200, "text/html", "<h3>Saved! Restarting ESP32...</h3>");
                    delay(2000);
                    ESP.restart();
                } else {
                    Serial.println("API Key validation failed!");
                    server.send(403, "text/html", "<h3>Invalid API Key or Environment ID!</h3>");
                }
            } else {
                Serial.println("WiFi connection failed. Restarting Access Point...");
                clearPreferences();
                startAccessPoint();
            }
        } else {
            server.send(400, "text/html", "<h3>Missing Data!</h3>");
        }
    });

    server.begin();
    Serial.println("Access Point started.");
}

// Validates the API Key by making a request
bool validateApiKey(String apiKey, String envId) {
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("Not connected to WiFi!");
        return false;
    }

    String url = "https://dev.aquaware.cloud/api/environments/" + envId;
    HTTPClient http;
    WiFiClientSecure client;
    client.setInsecure();

    http.begin(client, url);
    http.addHeader("x-api-key", apiKey);
    
    int httpResponseCode = http.GET();
    Serial.print("API Response Code: ");
    Serial.println(httpResponseCode);

    bool isValid = httpResponseCode == 200;
    http.end();
    
    return isValid;
}

// Clears stored preferences and resets configuration
void clearPreferences() {
    Serial.println("Clearing stored preferences...");
    preferences.begin("wifi", false);
    preferences.clear();
    preferences.end();
}

// Attempts to connect to WiFi and validate stored credentials
void connectToWiFiAndValidate() {
    preferences.begin("wifi", true);
    String ssid = preferences.getString("ssid", "");
    String password = preferences.getString("password", "");
    String apiKey = preferences.getString("api-key", "");
    String envId = preferences.getString("env-id", "");
    preferences.end();

    if (ssid != "" && password != "" && apiKey != "" && envId != "") {
        Serial.println("Connecting to stored WiFi...");
        WiFi.begin(ssid.c_str(), password.c_str());

        unsigned long startTime = millis();
        while (WiFi.status() != WL_CONNECTED && millis() - startTime < 10000) {
            delay(500);
            Serial.print(".");
        }

        if (WiFi.status() == WL_CONNECTED) {
            Serial.println("\nConnected to WiFi. Validating API Key...");
            if (validateApiKey(apiKey, envId)) {
                Serial.println("API Key is valid. Device ready.");
                return;
            } else {
                Serial.println("API Key validation failed. Restarting setup...");
                clearPreferences();
            }
        } else {
            Serial.println("WiFi connection failed. Restarting setup...");
            clearPreferences();
        }
    } else {
        Serial.println("No valid stored credentials found.");
    }

    startAccessPoint();
}

// Setup function
void setup() {
    Serial.begin(115200);
    Serial.println("Starting ESP32...");

    connectToWiFiAndValidate();
}

// Main loop
void loop() {
    dnsServer.processNextRequest();
    server.handleClient();
}
