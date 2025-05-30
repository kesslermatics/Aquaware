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

uint8_t tempLabel, tdsLabel, phLabel, ecLabel, orpLabel, doLabel;
uint8_t envNameLabel;
uint8_t statusLabel;  // Für untere Statuszeile
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
void updateDisplay(float temperature, float tds, float ph, float ec, float orp, float doVal);
void sendSensorData(float temperature, float tds);
float readTDS(float temperature);
void callback(char* topic, byte* payload, unsigned int length);
void connectToMQTT();
void startBLESetup();
void updateStatus(String messageDe, String messageEn);
String replaceUmlauts(String input);

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

    while (!lcd.begin()) {
        delay(1000);
        Serial.print(F("[LCD] ."));
    }
    
lcd.cleanScreen();
    lcd.setBackgroundColor(BLACK);
    Serial.println(F("[LCD] Successfully initialized."));

  envNameLabel = lcd.drawString(10, 10, "", 2, WHITE);
  tempLabel = lcd.drawString(30, 60, "", 1, WHITE);
  tdsLabel = lcd.drawString(30, 90, "", 1, WHITE);
  phLabel = lcd.drawString(30, 120, "", 1, WHITE);
  ecLabel = lcd.drawString(30, 110, "", 1, WHITE);
  orpLabel = lcd.drawString(30, 110, "", 1, WHITE);
  doLabel = lcd.drawString(30, 110, "", 1, WHITE);
  statusLabel = lcd.drawString(30, 220, "", 2, ORANGE);

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

    updateDisplay(30, 430, 7.1, 0, 0, 87);

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
  updateStatus("Bereit für App", "Ready for app");
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
    String clientId = apiKey + "-" + envId;
    if (client.connect(clientId.c_str(), apiKey.c_str(), "dummy")) {      
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

void updateDisplay(float temperature, float tds, float ph, float ec, float orp, float doVal) {
    preferences.begin("wifi", true);
    String envName = preferences.getString("env-name", "");
    String language = preferences.getString("language", "en");
    preferences.end();

    bool isWiFiConnected = (WiFi.status() == WL_CONNECTED);

    int yPos = 60;  // Startposition für erste Zeile

    // ENV-Name nur anzeigen, wenn verbunden
    if (isWiFiConnected && envName.length() > 0) {
        lcd.updateString(envNameLabel, 30, 10, replaceUmlauts(envName), 2, WHITE);
        updateStatus("WLAN verbunden", "WiFi Connected");
    } else {
        updateStatus("Einrichten per App", "Setup required via app");
    }

    // Temperaturanzeige (nur wenn gültig)
    if (temperature != -127.0) {
        String tempStr = "TEM: " + String(temperature, 1) + "°C";
        lcd.updateString(tempLabel, 30, yPos, tempStr, 1, WHITE);
        yPos += 30;
    }

    // TDS-Anzeige
    if (tds != 0) {
        String tdsStr = "TDS: " + String(tds, 1) + " mg/L";
        lcd.updateString(tdsLabel, 30, yPos, tdsStr, 1, WHITE);
        yPos += 30;
    }

    // pH-Anzeige
    if (ph != 0) {
        String phStr = "pH : " + String(ph, 2);
        lcd.updateString(phLabel, 30, yPos, phStr, 1, WHITE);
        yPos += 30;
    }

    // EC-Anzeige
    if (ec != 0) {
        String ecStr = "EC : " + String(ec, 2) + " mS/cm";
        lcd.updateString(ecLabel, 30, yPos, ecStr, 1, WHITE);
        yPos += 30;
    }

    // ORP-Anzeige
    if (orp != 0) {
        String orpStr = "ORP: " + String(orp, 1) + " mV";
        lcd.updateString(orpLabel, 30, yPos, orpStr, 1, WHITE);
        yPos += 30;
    }

    // DO-Anzeige
    if (doVal != 0) {
        String doStr = "DO : " + String(doVal, 1) + " mg/L";
        lcd.updateString(doLabel, 30, yPos, doStr, 1, WHITE);
    }
}

void updateStatus(String messageDe, String messageEn) {
  preferences.begin("wifi", true);
  String language = preferences.getString("language", "en");
  preferences.end();

  String msg = (language == "de") ? messageDe : messageEn;

  lcd.updateString(statusLabel, 30, 200, msg, 2, ORANGE);
  
}

String replaceUmlauts(String input) {
    input.replace("ä", "ae");
    input.replace("ö", "oe");
    input.replace("ü", "ue");
    input.replace("Ä", "Ae");
    input.replace("Ö", "Oe");
    input.replace("Ü", "Ue");
    input.replace("ß", "ss");
    return input;
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
    // Falls WiFi verbunden, abrufen von envName und Update-Frequency
    if (isWiFiConnected) {
        fetchEnvironmentName(envId);   
    }
    else {
      updateStatus("Einrichten per App", "Setup required via app");
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

        preferences.end();
        ESP.restart();
    } else {
        Serial.println(F("[API] Data successfully sent!")); 
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