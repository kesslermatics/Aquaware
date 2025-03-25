#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <Preferences.h>
#include <Wire.h>
#include "DFRobot_LcdDisplay.h"
#include <OneWire.h>
#include <DallasTemperature.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include "esp_bt.h"
#include <BLE2902.h>
#include <PubSubClient.h>

DFRobot_Lcd_IIC lcd(&Wire, 0x2c);
#define TEMP_PIN  D7  // e.g., "D7" on some boards = GPIO13
#define TDS_PIN A0 
#define VREF 3.3  

OneWire oneWire(TEMP_PIN);
DallasTemperature tempSensor(&oneWire);

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;

WiFiClient espClient;
PubSubClient client(espClient);

uint8_t tempLabel, tdsLabel;
uint8_t envNameLabel;
uint8_t hour = 0, minute = 0;

Preferences preferences;

#define SERVICE_UUID        "12345678-1234-5678-1234-56789abcdef0"
#define CHARACTERISTIC_UUID "abcd1234-5678-1234-5678-abcdef123456"

unsigned long updateInterval = 1800000;  // 30 Minutes (30 * 60 * 1000 ms)
unsigned long lastUpload     = 0;
unsigned long lastDisplayUpdate = 25000;

const char* mqttServer = "crossover.proxy.rlwy.net";
const int mqttPort = 12112;

void connectToWiFiAndValidate();
void fetchEnvironmentName(const String& envId);
void fetchUpdateFrequency();
void updateDisplay(float temperature, float tds);
void sendSensorData(float temperature, float tds);
float readTDS(float temperature);
void callback(char* topic, byte* payload, unsigned int length);
void connectToMQTT();
void startBLESetup();

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        deviceConnected = true;
    }
    void onDisconnect(BLEServer* pServer) {
        deviceConnected = false;
    }
};

class MyCharacteristicCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic* pCharacteristic) {
    String value = String(pCharacteristic->getValue().c_str());
    if (value.length() > 0) {
        Serial.println(F("[BLE] Daten empfangen:"));
        Serial.println(value.c_str());

        int index = 0;
        String values[5];
        String data = String(value.c_str());

        while (data.length() > 0 && index < 5) {
            int commaIndex = data.indexOf(',');
            if (commaIndex == -1) {
                values[index] = data;
                data = "";
            } else {
                values[index] = data.substring(0, commaIndex);
                data = data.substring(commaIndex + 1);
            }
            index++;
        }

        // Werte speichern
        preferences.begin("wifi", false);
        preferences.putString("ssid", values[0]);
        preferences.putString("password", values[1]);
        preferences.putString("api-key", values[2]);
        preferences.putString("env-id", values[3]);
        preferences.putString("language", values[4]);
        preferences.end();

        // WLAN verbinden
        connectToWiFiAndValidate();

        if (WiFi.status() == WL_CONNECTED) {
            Serial.println("\n[WiFi] Connected!");

            // Setup markieren
            String apiKey = values[2];
            String envId  = values[3];
            String url = "https://dev.aquaware.cloud/api/environments/" + envId + "/mark-setup/";

            WiFiClientSecure client;
            client.setInsecure();
            HTTPClient http;
            http.begin(client, url);
            http.addHeader("Content-Type", "application/json");
            http.addHeader("x-api-key", apiKey);

            int responseCode = http.POST("{}");

            if (responseCode == 200) {
              
                connectToMQTT();
                Serial.println("[HTTP] Setup marked successfully.");
            } else {
                Serial.print("[HTTP] Failed to mark setup. Code: ");
                Serial.println(responseCode);
            }
            http.end();
        } else {
            Serial.println("\n[WiFi] Connection failed.");
        }
    }
}

};


void setup() {
  delay(2000);
  Serial.begin(115200);
  Serial.println(F("\n[Setup] Starting ESP32 Sensor Display..."));

  esp_bt_controller_mem_release(ESP_BT_MODE_CLASSIC_BT);

  // 🔍 Check for stored WiFi config
  preferences.begin("wifi", true);
  String ssid = preferences.getString("ssid", "");
  String password = preferences.getString("password", "");
  String apiKey = preferences.getString("api-key", "");
  String envId = preferences.getString("env-id", "");
  preferences.end();

  bool hasCredentials = (ssid.length() > 0 && password.length() > 0 && apiKey.length() > 0 && envId.length() > 0);


  // 🔄 Init BLE only if no credentials found
  if (!hasCredentials) {
    startBLESetup();
  } else {
    Serial.println("Credentials found. No BLE needed");
    
    connectToWiFiAndValidate();
  }

  // 🖥️ Init LCD
  if (lcd.begin()) {
    lcd.cleanScreen();
    lcd.setBackgroundColor(BLACK);
    Serial.println(F("[LCD] Successfully initialized."));
  } else {
    Serial.println(F("[LCD] Error initializing! Check I2C address/wiring."));
  }

  envNameLabel = lcd.drawString(10, 10, "", 2, WHITE);
  tempLabel = lcd.drawString(100, 60, "", 1, ORANGE);
  tdsLabel = lcd.drawString(100, 110, "", 1, BLUE);

  tempSensor.begin();
}


void loop() {
  if (WiFi.status() == WL_CONNECTED) {
  if (!client.connected()) {
    connectToMQTT();  // Reconnect falls nötig
  }
    client.loop(); // Wichtig für eingehende Nachrichten
  }

  unsigned long currentTime = millis();

  if (currentTime - lastDisplayUpdate >= 30000) {

    lastDisplayUpdate = currentTime;

    tempSensor.requestTemperatures();
    float temperature = tempSensor.getTempCByIndex(0);
    float tdsValue = readTDS(temperature);

    updateDisplay(temperature, tdsValue);

    Serial.print("[Sensors] Temperature: ");
    Serial.print(temperature);
    Serial.println(F(" °C"));
    Serial.print("[Sensors] TDS: ");
    Serial.print(tdsValue);
    Serial.println(F(" mg/L"));
    Serial.println(F("-----------------------------"));
  }

  if (currentTime - lastUpload >= updateInterval) {
        lastUpload = currentTime;

        tempSensor.requestTemperatures();
        float temperature = tempSensor.getTempCByIndex(0);
        float tdsValue = readTDS(temperature);

        sendSensorData(temperature, tdsValue);
    }
}

void startBLESetup() {
  Serial.println(F("[BLE] Starte BLE Setup..."));

  BLEDevice::init("Aquaware BLE");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService* pService = pServer->createService(SERVICE_UUID);
  BLEDevice::setPower(ESP_PWR_LVL_N12);

  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_WRITE | 
    BLECharacteristic::PROPERTY_WRITE_NR |
    BLECharacteristic::PROPERTY_NOTIFY |
    BLECharacteristic::PROPERTY_INDICATE
  );

  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setCallbacks(new MyCharacteristicCallbacks());
  pService->start();

  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  BLEDevice::startAdvertising();

  Serial.println(F("[BLE] Advertising aktiv."));
}


void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("[MQTT] Message received on topic: ");
  Serial.println(topic);

  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  Serial.print("[MQTT] Payload: ");
  Serial.println(message);

  if (message == "reset") {
    preferences.begin("wifi", false);
    preferences.clear();
    preferences.end();
    ESP.restart();
} else if (message == "calibrate") {
    // z.B. Kalibrierung starten
    Serial.println("[MQTT] Starting calibration...");
}
}

void connectToMQTT() {
  preferences.begin("wifi", true);
  String apiKey = preferences.getString("api-key", "");
  String envId = preferences.getString("env-id", "");
  preferences.end();

  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);

  while (!client.connected()) {
    Serial.println("[MQTT] Connecting to broker...");
    if (client.connect("esp32_client", apiKey.c_str(), "dummy")) {
      Serial.println("[MQTT] Connected!");
      String topic = "env/" + envId + "/reset";
      client.subscribe(topic.c_str());
      Serial.print("[MQTT] Subscribed to: ");
      Serial.println(topic);
    } else {
      Serial.print("[MQTT] Failed. State: ");
      Serial.println(client.state());
      delay(2000);
    }
  }
}



void updateDisplay(float temperature, float tds) {
    preferences.begin("wifi", true);
    String envName = preferences.getString("env-name", "");
    String language = preferences.getString("language", "en");
    preferences.end();

    bool isWiFiConnected = (WiFi.status() == WL_CONNECTED);

    lcd.cleanScreen();

    // Zeige nur den Environment-Namen, wenn WiFi verbunden ist
    if (isWiFiConnected && envName.length() > 0) {
        lcd.drawString(10, 10, envName, 2, WHITE);
    }

    // Position der Sensorwerte
    int iconX = 30;
    int valueX = 100;
    int tempY = 40;
    int tdsY = 90;

    // Temperaturanzeige
    lcd.drawIcon(iconX, tempY, "/sensor icon/thermometer.png", 120);
    lcd.drawString(valueX, tempY + 20, String(temperature) + "°C", 1, ORANGE);

    // TDS-Anzeige
    lcd.drawIcon(iconX, tdsY, "/sensor icon/raindrops.png", 120);
    lcd.drawString(valueX, tdsY + 20, String(tds) + " mg/L", 1, BLUE);

    // WiFi-Statusanzeige am unteren Rand
    if (language == "de") {
        lcd.drawString(30, 200, isWiFiConnected ? "WLAN verbunden" : "WLAN nicht verbunden", 2, ORANGE);
    } else {
        lcd.drawString(30, 200, isWiFiConnected ? "WiFi Connected" : "WiFi Not Connected", 2, ORANGE);
    }
}

void connectToWiFiAndValidate() {
    preferences.begin("wifi", true);
    String ssid = preferences.getString("ssid", "");
    String password = preferences.getString("password", "");
    String apiKey = preferences.getString("api-key", "");
    String envId = preferences.getString("env-id", "");
    String language = preferences.getString("language", "en");
    preferences.end();

    Serial.println(ssid);
    Serial.println(password);

    // Versuche, sich mit WiFi zu verbinden
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid.c_str(), password.c_str());

    int maxAttempts = 20;
    int attempts = 0;

    while (WiFi.status() != WL_CONNECTED && attempts < maxAttempts) {
        delay(500);
        Serial.print(".");
        attempts++;
    }

    if (WiFi.status() != WL_CONNECTED) {
    Serial.println("\n[WiFi] Verbindung fehlgeschlagen. Setze Preferences zurück...");

    preferences.begin("wifi", false);
    preferences.clear();
    preferences.end();

    delay(1000);
    setup(); // Neustart der Konfiguration
}

    bool isWiFiConnected = (WiFi.status() == WL_CONNECTED);

    // **WiFi-Statusanzeige unten aktualisieren**
    lcd.cleanScreen();
    if (language == "de") {
        lcd.drawString(30, 200, isWiFiConnected ? "WLAN verbunden" : "WLAN nicht verbunden", 2, ORANGE);
    } else {
        lcd.drawString(30, 200, isWiFiConnected ? "WiFi Connected" : "WiFi Not Connected", 2, ORANGE);
    }

    // Falls WiFi verbunden, abrufen von envName und Update-Frequency
    if (isWiFiConnected) {
        fetchEnvironmentName(envId);   
    }
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
  
  if (httpResponseCode == 200) {
    String response = http.getString();

    int nameIndex = response.indexOf("\"name\":");
    if (nameIndex != -1) {
      int start = response.indexOf("\"", nameIndex + 7) + 1;
      int end   = response.indexOf("\"", start);
      if (start > 0 && end > start) {
        String envName = response.substring(start, end);

        preferences.begin("wifi", false);
        preferences.putString("env-name", envName);
        preferences.end();
      }
    }
  } else {
    Serial.println(F("[EnvName] Error or non-200 code."));
    lcd.drawString(30, 200, "Error while fetching env-name", 2, ORANGE);

    // ⚠️ Alle gespeicherten Credentials löschen
    preferences.begin("wifi", false);
    preferences.clear();
    preferences.end();

    delay(2000);
    ESP.restart();  // Neustart erzwingen
}
  http.end();
}

void sendSensorData(float temperature, float tds) {
    preferences.begin("wifi", true);
    String apiKey = preferences.getString("api-key", "");
    String envId = preferences.getString("env-id", "");
    preferences.end();

    if (WiFi.status() != WL_CONNECTED || apiKey == "" || envId == "") {
        Serial.println(F("[API] No WiFi or missing credentials. Skipping data send."));
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

    int httpResponseCode = http.POST(payload);

    if (httpResponseCode != 201) {
        Serial.println(F("[ERROR] API request failed! Resetting device..."));
        preferences.begin("wifi", false);
        lcd.drawString(30, 200, "Error while uploading", 1, ORANGE);  

        preferences.end();
        ESP.restart();
    } else {
        Serial.println(F("[API] Data successfully sent!"));
        lcd.drawString(30, 200, "Error while sending data", 2, ORANGE);  
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