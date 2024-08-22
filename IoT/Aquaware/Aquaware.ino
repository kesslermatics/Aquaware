#include <WiFiNINA.h>
#include <ArduinoHttpClient.h>
#include <ArduinoJson.h>
#include "secrets.h"
#include <OneWire.h>
#include <DallasTemperature.h>

// ---WiFi settings---
char ssid[] = SECRET_SSID;   // SSID located in secrets.h
char pass[] = SECRET_PASS;   // Password located in secrets.h
char email[] = EMAIL;
char password[] = PASSWORD;

// WiFi and client setup
WiFiSSLClient wifiClient;
HttpClient client = HttpClient(wifiClient, "aquaware-production.up.railway.app", 443);

#define VREF 3.3              // Analog reference voltage of the ADC
#define READINGSCOUNT 100     // The amount of reading to calculate the average from

// ---PH---
#define PH_PIN A0

// ---Temp---
#define TEMP_PIN 5
OneWire oneWire(TEMP_PIN);
DallasTemperature sensors(&oneWire);

// ---TDS---
#define TDS_PIN A2
#define SCOUNT  1           // sum of sample points
float analogBuffer[SCOUNT];     // store the analog value in the array, read from ADC
float analogBufferTemp[SCOUNT];
int analogBufferIndex = 0;
int copyIndex = 0;
float averageVoltage = 0;
float temperature = 21; 
float tdsValue = 0;

// Lists of input to smoothen the result
float tds[READINGSCOUNT];
float ph[READINGSCOUNT];
float temp[READINGSCOUNT];

// Timer to calculate the interval to read data and send them
long timer = 0;
long timeOut = 180000; // 30 minutes in milliseconds

String accessToken = "";
String refreshToken = "";

// This method is called once when the Arduino board is powered on or reset.
void setup() {
  delay(10000);
  // Initialize serial communication
  Serial.begin(9600);  
  Serial.println("Setup started...");

  // Initialize temperature sensor
  sensors.begin();
  Serial.println("Temperature sensor initialized.");

  // Connect to Wi-Fi
  connectToWiFi();
  Serial.println("Wi-Fi setup completed.");
}

// This method runs repeatedly every tick.
void loop() {

  if (millis() > timeOut + timer) {
    timer = millis();
    Serial.println("Timer triggered...");

    // Check Wi-Fi connection
    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("Wi-Fi not connected. Reconnecting...");
      connectToWiFi();
    } else {
      Serial.println("Wi-Fi connected.");
    }

    // Login to get the access and refresh tokens if not already available
    if (accessToken == "") {
      Serial.println("No access token found. Logging in...");
      login();
    }

    // Start reading the sensors
    sensors.requestTemperatures(); 
    for (int i = 0; i < READINGSCOUNT; i++) {
      readPH(i);
      readTDS(i);  
      readTemp(i);    
    }

    // Prepare data to send
    float medianTemp = getMedianNum(temp, READINGSCOUNT);
    float medianPH = mapFloat(getMedianNum(ph, READINGSCOUNT), 260.0, 460.0, 4.0, 9.18);
    float medianTDS = getMedianNum(tds, READINGSCOUNT);

    // Serial output for debugging
    Serial.println("----------------------------------------------------------");
    Serial.print("TDS: ");
    Serial.print(medianTDS);
    Serial.println(" ppm");
    Serial.print("PH: ");
    Serial.println(medianPH);
    Serial.print("Temp: ");
    Serial.print(medianTemp);
    Serial.println(" °C");

    // Refresh the access token if needed
    Serial.println("Refreshing access token...");
    refreshAccessToken();

    // Send the data to the server
    Serial.println("Sending data to the server...");
    bool success = sendData(medianTemp, medianPH, medianTDS);

    if (success) {
      Serial.println("Data successfully sent to the server.");
    } else {
      Serial.println("Failed to send data to the server.");
    }
  }
}

// Connect to Wi-Fi
void connectToWiFi() {
  Serial.print("Connecting to Wi-Fi...");
  while (WiFi.status() != WL_CONNECTED) {
    WiFi.begin(ssid, pass);
    delay(500);
    Serial.print(".");
  }
  Serial.println(" connected.");
}

// Login to get access and refresh tokens
void login() {
  String payload = "{\"email\":\"" + String(email) + "\",\"password\":\"" + String(password) + "\"}";
  client.beginRequest();
  client.post("/api/users/login/");
  client.sendHeader("Content-Type", "application/json");
  client.sendHeader("Content-Length", payload.length());
  client.beginBody();
  client.print(payload);
  client.endRequest();
  Serial.println(client.connected());
  while(!client.available()){}
  int statusCode = client.responseStatusCode();
  
  Serial.println(statusCode);
  String response = client.responseBody();
  Serial.println(statusCode);

  if (statusCode == 202) {
    StaticJsonDocument<202> doc;
    deserializeJson(doc, response);

    accessToken = doc["access"].as<String>();
    refreshToken = doc["refresh"].as<String>();

    Serial.println("Login successful.");
  } else {
    Serial.print("Login failed, error: ");
    Serial.println(statusCode);
    Serial.println("Response:");
    Serial.println(response);
  }
}

// Refresh the access token
bool refreshAccessToken() {
  client.beginRequest();
  client.post("https://aquaware-production.up.railway.app/api/users/token/refresh/");
  client.sendHeader("Content-Type", "application/json");

  String payload = "{\"refresh\":\"" + refreshToken + "\"}";
  client.sendHeader("Content-Length", payload.length());
  client.beginBody();
  client.print(payload);
  client.endRequest();

  int statusCode = client.responseStatusCode();
  String response = client.responseBody();

  if (statusCode == 200) {
    StaticJsonDocument<200> doc;
    deserializeJson(doc, response);

    accessToken = doc["access"].as<String>();

    Serial.println("Access token refreshed.");
    return true;
  } else {
    Serial.print("Failed to refresh token, error: ");
    Serial.println(statusCode);
    Serial.println("Response:");
    Serial.println(response);
    return false;
  }
}

// Send data to the server
bool sendData(float temp, float ph, float tds) {
  client.beginRequest();
  client.post("https://aquaware-production.up.railway.app/api/measurements/add/3/");
  client.sendHeader("Content-Type", "application/json");
  client.sendHeader("Authorization", "Bearer " + accessToken);

  String payload = "{\"Temperature\":" + String(temp) + ",\"PH\":" + String(ph) + ",\"TDS\":" + String(tds) + "}";
  client.sendHeader("Content-Length", payload.length());
  client.beginBody();
  client.print(payload);
  client.endRequest();

  int statusCode = client.responseStatusCode();
  String response = client.responseBody();

  if (statusCode == 201) {
    Serial.println("Data sent successfully.");
    return true;
  } else {
    Serial.print("Failed to send data, error: ");
    Serial.println(statusCode);
    Serial.println("Response:");
    Serial.println(response);
    return false;
  }
}

// Read PH per analog reading and write it into a list to smoothen measurement data
void readPH(int index) {
  float pH_Value = analogRead(PH_PIN); 
  ph[index] = pH_Value; 
}

// Read temperature via OneWire library and write it into a list to smoothen measurement data
void readTemp(int index) {
  float temp_Value = sensors.getTempCByIndex(0); 
  temp[index] = temp_Value; 
}

// Read TDS value and apply some compensation algorithm
void readTDS(int index) {
  static unsigned long analogSampleTimepoint = millis();
  // Every 40 milliseconds read the analog value from the ADC
  if(millis()-analogSampleTimepoint > 40U){    
    analogSampleTimepoint = millis();
    analogBuffer[analogBufferIndex] = analogRead(TDS_PIN); 
    analogBufferIndex++;
    if(analogBufferIndex == SCOUNT){ 
      analogBufferIndex = 0;
    }
  }   
  static unsigned long printTimepoint = millis();
  if(millis()-printTimepoint > 800U){
    printTimepoint = millis();
    for(copyIndex=0; copyIndex<SCOUNT; copyIndex++){
      analogBufferTemp[copyIndex] = analogBuffer[copyIndex];
      
      // Read the analog value more stable by the median filtering algorithm, and convert to voltage value
      averageVoltage = getMedianNum(analogBufferTemp,SCOUNT) * (float)VREF / 1024.0;
      
      // Temperature compensation formula: FinalResult(25°C) = FinalResult(current)/(1.0+0.02*(fTP-25.0)); 
      float compensationCoefficient = 1.0+0.02*(temperature-25.0);
      float compensationVoltage = averageVoltage/compensationCoefficient;
      
      // Convert voltage value to TDS value
      tdsValue = (133.42*compensationVoltage*compensationVoltage*compensationVoltage - 255.86*compensationVoltage*compensationVoltage + 857.39*compensationVoltage)*0.5;
    }
  }
  tds[index] = tdsValue;
}

// This function will be used to get a stable TDS value from an array of readings.
int getMedianNum(float bArray[], int iFilterLen) {
  int bTab[iFilterLen];
  for (byte i = 0; i < iFilterLen; i++)
    bTab[i] = bArray[i];

  int i, j, bTemp;
  for (j = 0; j < iFilterLen - 1; j++) {
    for (i = 0; i < iFilterLen - j - 1; i++) {
      if (bTab[i] > bTab[i + 1]) {
        bTemp = bTab[i];
        bTab[i] = bTab[i + 1];
        bTab[i + 1] = bTemp;
      }
    }
  }

  if ((iFilterLen & 1) > 0) {
    bTemp = bTab[(iFilterLen - 1) / 2];
  } else {
    bTemp = (bTab[iFilterLen / 2] + bTab[iFilterLen / 2 - 1]) / 2;
  }

  return bTemp;
}

// Remap values after calibrating a sensor.
// For example, we need to remap pH values from a specific analog range to mol/l.
float mapFloat(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
