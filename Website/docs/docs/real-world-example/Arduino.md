---
sidebar_position: 1
---

# Aquaware API and Arduino

## Introduction

This tutorial demonstrates how to use an Arduino to collect water quality data (temperature and pH) and upload it to the Aquaware cloud API. We’ll be using the Arduino MKR WiFi 1010 microcontroller, equipped with WiFi capabilities, along with specific sensors to measure water parameters.

### Hardware and Software Requirements

- **Hardware:**
  - Arduino MKR WiFi 1010 or equivalent with WiFi support
  - DS18B20 Temperature Sensor
  - pH Sensor (analog output)
  - Breadboard and jumper wires
- **Software:**
  - Arduino IDE or VSCode with PlatformIO
  - Libraries: `WiFiNINA`, `ArduinoHttpClient`, `ArduinoJson`, `OneWire`, `DallasTemperature`

### Libraries Used

- **WiFiNINA**: For connecting to WiFi networks.
- **ArduinoHttpClient**: To send HTTP requests to the Aquaware API.
- **ArduinoJson**: For handling JSON payloads.
- **OneWire and DallasTemperature**: For reading temperature data from DS18B20 sensors.

## Setting Up the Environment

1. **Install the Arduino IDE (or use VSCode with PlatformIO).**
2. **Add the required libraries** by searching for them in the Library Manager or adding them manually:
   - WiFiNINA
   - ArduinoHttpClient
   - ArduinoJson
   - OneWire
   - DallasTemperature

## Wiring the Sensors

1. **Temperature Sensor (DS18B20):**

   - Connect the **VCC** pin to **5V**.
   - Connect the **GND** pin to **GND**.
   - Connect the **Data** pin to **Pin 5** on the Arduino.

2. **pH Sensor:**

   - Connect the **Signal** pin to **A0**.
   - Connect **VCC** to **5V** and **GND** to **GND**.

## Initialization

The code consists of three main parts: setup, loop, and helper functions for reading sensors and sending data to the server.

### WiFi Setup

The following lines are used to connect the Arduino to a Wi-Fi network. The credentials are stored in a `secrets.h` file for security purposes.

```cpp
char ssid[] = SECRET_SSID;   // SSID located in secrets.h
char pass[] = SECRET_PASS;   // Password located in secrets.h
char email[] = EMAIL;
char password[] = PASSWORD;

WiFiSSLClient wifiClient;
HttpClient client = HttpClient(wifiClient, "dev.aquaware.cloud", 443);
```

### Sensor Initialization

In the `setup()` function, the temperature sensor is initialized, and the board connects to the Wi-Fi network.

```cpp
void setup() {
  delay(10000);
  Serial.begin(9600);
  Serial.println("Setup started...");

  sensors.begin(); // Initialize temperature sensor
  connectToWiFi(); // Connect to Wi-Fi network
}

void connectToWiFi() {
  Serial.print("Connecting to Wi-Fi...");
  while (WiFi.status() != WL_CONNECTED) {
    WiFi.begin(ssid, pass);
    delay(500);
    Serial.print(".");
  }
  Serial.println(" connected.");
}
```

## Authentication Handling in the Arduino Code

To securely communicate with the Aquaware API, the Arduino code implements two important functions for handling authentication: `login()` and `refreshAccessToken()`. These functions ensure that the device can authenticate and maintain access to the API.

### 1. `login()`: Getting Access and Refresh Tokens

The `login()` function sends an HTTP POST request to the API with the user's email and password to obtain access and refresh tokens. These tokens are necessary for authenticating future requests.

#### Key Steps in the `login()` Function

- **Prepare the JSON payload** containing the email and password.
- **Send a POST request** to the `/api/users/login/` endpoint.
- **Check the response status code** to determine if the login was successful.
- **Deserialize the JSON response** to extract the access and refresh tokens, which are then stored for later use.

#### Code Example

```cpp
void login() {
  String payload = "{"email":"" + String(email) + "","password":"" + String(password) + ""}";
  client.beginRequest();
  client.post("/api/users/login/");
  client.sendHeader("Content-Type", "application/json");
  client.sendHeader("Content-Length", payload.length());
  client.beginBody();
  client.print(payload);
  client.endRequest();

  int statusCode = client.responseStatusCode();
  String response = client.responseBody();

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
```

### 2. `refreshAccessToken()`: Maintaining an Active Session

The `refreshAccessToken()` function helps keep the connection to the API alive by refreshing the access token before it expires. It uses the refresh token obtained during login.

#### Key Steps in the `refreshAccessToken()` Function

- **Send a POST request** to the `/api/users/token/refresh/` endpoint with the refresh token.
- **Check the response status code** to ensure that the token refresh was successful.
- **Update the access token** for future authenticated requests.

#### Code Example

```cpp
bool refreshAccessToken() {
  client.beginRequest();
  client.post("/api/users/token/refresh/");
  client.sendHeader("Content-Type", "application/json");

  String payload = "{"refresh":"" + refreshToken + ""}";
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
```

### Best Practices for Authentication

1. **Securely Store Tokens:** Always store the access and refresh tokens securely to prevent unauthorized access.
2. **Regularly Refresh Tokens:** Refresh the access token periodically to avoid interruptions in data transmission.
3. **Handle Errors Gracefully:** Implement robust error handling to account for failed login attempts or token refresh operations.
4. **Use HTTPS:** Always use secure connections (HTTPS) when transmitting sensitive data like login credentials or tokens.

## Sending Sensor Data to the Aquaware API

The `sendData()` function in the Arduino code is responsible for transmitting the collected water quality measurements (temperature and pH) to the Aquaware cloud API. It constructs an HTTP POST request, which includes the data as a JSON payload, and sends it to the server for storage and further processing.

### Breakdown of the `sendData()` Function

1. **Prepare the HTTP Request:**

   - The function uses the `HttpClient` library to start a new HTTP request. The request is sent to the endpoint `/api/measurements/add/3/`, which is responsible for accepting measurement data. **Remember to change the {3} to your environment-id**
   - The `Content-Type` header is set to `application/json` to indicate that the payload is in JSON format.
   - The `Authorization` header is used to include the access token, allowing the server to authenticate the request.

1. **Create the JSON Payload:**

   - The payload is a JSON-formatted string that includes the temperature, pH, and TDS values.
   - Example: `{"Temperature":25.0,"PH":7.4}`

1. **Send the Request:**

   - The `client.beginBody()` function is used to start sending the body of the request. The JSON payload is then transmitted, and the request is completed using `client.endRequest()`.

1. **Handle the Server Response:**
   - The function checks the HTTP status code returned by the server. A status code of `201` indicates that the data was successfully received and stored.
   - If the data is not successfully sent, the function outputs the error code and server response for debugging.

### Code Example

```cpp
bool sendData(float temp, float ph, float tds) {
  client.beginRequest();
  client.post("/api/measurements/add/3/");
  client.sendHeader("Content-Type", "application/json");
  client.sendHeader("Authorization", "Bearer " + accessToken);

  String payload = "{"Temperature":" + String(temp) + ","PH":" + String(ph) + ","TDS":" + String(tds) + "}";
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
```

### Best Practices for Data Transmission

1. **Check the Status Code:** Always verify the server's response to ensure the data was received correctly.
2. **Log Data Locally Before Sending:** Keep a local copy of the data in case the network transmission fails, allowing for a retry mechanism.
3. **Use Secure Endpoints:** Always use HTTPS to ensure that the data is transmitted securely.
4. **Avoid Hardcoding API Endpoints:** Consider using configuration files or variables for endpoints to facilitate easier maintenance.

### Error Handling

If the server does not return a `201` status code, the function outputs the error for debugging purposes. The response should be carefully logged to identify potential issues, such as authentication failures or server errors.

## Main Loop Explanation in the Arduino Code

In the Arduino sketch, the `loop()` function continuously executes, checking conditions and performing tasks as required. This example uses a timer-based approach to read sensor data and send it to the server. While polling is a technique where the code constantly checks for a condition or data change, using a timer allows for more efficient processing by executing tasks at specified intervals. Here, the timer is set to 30 minutes (for **Advanced** and **Premium Plans**), and the loop includes specific logic to handle WiFi connectivity and token management.

### Polling vs. Timer-Based Approach

- **Polling:** Involves continuously checking the state of a condition or sensor. It can consume more power and resources because the code runs repeatedly without pauses.
- **Timer-Based Approach:** Executes specific code only at defined intervals, which helps conserve power and reduces the amount of redundant processing. For this tutorial, a timer is used to execute the data reading and sending process every 30 minutes.

### Timer Configuration in the Loop

The timer is set up to check every 30 minutes (1,800,000 milliseconds). For the free Hobby plan, the interval would be set to 2 hours (7,200,000 milliseconds). When the timer condition is met, the code performs the following actions:

1. **Check the WiFi Status:** The code verifies if the device is still connected to WiFi. If not, it attempts to reconnect. This ensures reliable data transmission.
2. **Refresh the Access Token:** The access token is refreshed before sending data to maintain an active session with the server.
3. **Sensor Data Collection:** The temperature and pH readings are taken using smoothing techniques to reduce the impact of outliers.

### Code Example for the `loop()` Function

```cpp
void loop() {
  // Check if the timer interval has passed
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

    // Refresh the access token if needed
    Serial.println("Refreshing access token...");
    if (!refreshAccessToken()) {
      Serial.println("Failed to refresh access token, re-logging...");
      login();
    }

    // Start reading the sensors
    sensors.requestTemperatures();
    for (int i = 0; i < READINGSCOUNT; i++) {
      readPH(i);  // Read pH value
      readTemp(i); // Read temperature value
    }

    // Calculate the median values for stable measurements
    float medianTemp = getMedianNum(temp, READINGSCOUNT);
    float medianPH = mapFloat(getMedianNum(ph, READINGSCOUNT), 260.0, 460.0, 4.0, 9.18);

    // Output the measurements
    Serial.println("----------------------------------------------------------");
    Serial.print("PH: ");
    Serial.println(medianPH);
    Serial.print("Temp: ");
    Serial.print(medianTemp);
    Serial.println(" °C");

    // Send the data to the server
    Serial.println("Sending data to the server...");
    bool success = sendData(medianTemp, medianPH, 0); // TDS omitted for brevity

    if (success) {
      Serial.println("Data successfully sent to the server.");
    } else {
      Serial.println("Failed to send data to the server.");
    }
  }
}
```

### Explanation of Sensor Reading Functions

#### 1. Reading Temperature (`readTemp()`)

The `readTemp()` function retrieves temperature data from the DS18B20 sensor. It stores the values in an array to apply smoothing and reduce the impact of outliers.

```cpp
void readTemp(int index) {
  float temp_Value = sensors.getTempCByIndex(0);
  temp[index] = temp_Value;
}
```

#### 2. Reading pH (`readPH()`)

The `readPH()` function captures the pH value from the analog pin. The values are stored in an array for further processing to ensure that any outlier readings do not significantly affect the final result.

```cpp
void readPH(int index) {
  float pH_Value = analogRead(PH_PIN);
  ph[index] = pH_Value;
}
```

### Handling `READINGSCOUNT`

The `READINGSCOUNT` parameter determines the number of sensor readings taken for each measurement cycle. By taking multiple readings and computing the median, the effect of outliers is minimized, providing more accurate sensor data. In this code, the readings are stored in arrays (`temp` for temperature and `ph` for pH), and the median of these values is used as the final measurement.

### Best Practices

1. **Use Median Filtering:** Helps stabilize sensor readings by reducing the influence of outliers.
2. **Check Connectivity Before Data Transmission:** Ensures that data is only sent when the device is connected to the network.
3. **Manage Timer Intervals Based on Plan:** Adjust the timer interval based on the subscription plan to comply with data transmission frequency limits.

## Complete Code

```cpp
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
HttpClient client = HttpClient(wifiClient, "dev.aquaware.cloud", 443);

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
long timeOut = 1800000; // 30 minutes in milliseconds

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
    if (!refreshAccessToken()) {
      Serial.println("Failed to refresh access token, re-logging...");
      login();
    }

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

  int statusCode = client.responseStatusCode();
  String response = client.responseBody();

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
  client.post("/api/users/token/refresh/");
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
  client.post("/api/measurements/add/3/");
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
      averageVoltage = getMedianNum(analogBufferTemp,SCOUNT) * (float)VREF / 1024.0;

      float compensationCoefficient = 1.0+0.02*(temperature-25.0);
      float compensationVoltage = averageVoltage/compensationCoefficient;

      tdsValue = (133.42*compensationVoltage*compensationVoltage*compensationVoltage - 255.86*compensationVoltage*compensationVoltage + 857.39*compensationVoltage)*0.5;
    }
  }
  tds[index] = tdsValue;
}

// Get a stable value from an array of readings.
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

float mapFloat(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

```
