
#include <WiFi.h>
#include "secrets.h"
#include "ThingSpeak.h"
#include <OneWire.h>
#include <DallasTemperature.h>

// ---Wifi settings---
char ssid[] = SECRET_SSID;   // SSID located in secrets.h
char pass[] = SECRET_PASS;   // Password coming located in secrets.h
WiFiClient  client;

// ---ThingSpeak settings---
unsigned long myChannelNumber = SECRET_CH_ID;     // ThingSpeak channel ID located in secrets.h
const char * myWriteAPIKey = SECRET_WRITE_APIKEY; // ThingSpeak Write keylocated in secrets.h

#define VREF 3.3              // Analog reference voltage of the ADC
#define READINGSCOUNT 100     // The amount of reading to calculate the average from

//---PH---
#define PH_PIN A0

//---Temp---
#define TEMP_PIN 5
OneWire oneWire(TEMP_PIN);
DallasTemperature sensors(&oneWire);

// ---TDS---
#define TDS_PIN A2
#define SCOUNT  1           // sum of sample point
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

// Timer to calculate the intervall to read data and sending them
// Keep in mind, that ThingSpeak only accepts data in intervalls of 20 seconds or more (free plan).
long timer = 0;
long timeOut = 30000;

// This method is called once when the Arduino board is powered on or reset.
void setup() {
  
  // Initialize serial communication
  Serial.begin(9600);  

  // Initialize temperature sensor
  sensors.begin();
  
  // Initialize ThingSpeak
  ThingSpeak.begin(client); 

  // pinMode() is a function used to configure a digital pin as either an input or an output
  pinMode(TDS_PIN,INPUT);
  pinMode(PH_PIN,INPUT);
  pinMode(TEMP_PIN,INPUT);
}

// This method runs repeatedly every tick. 
// The arduino nano 33 IoT has a 48 MHz tickrate processor. 
// This means that hyper theoretically it ticks every 1 / 48 000 000 seconds (= 20,83 nanoseconds).
// Although this is getting influenced by many extern factors (e.g. operation count)
void loop() {
  // Execute the following code every previously defined seconds
  if (millis() > timeOut + timer)
  {
    timer = millis();

    // Connect to wifi and reconnect when connection is lost
    if(WiFi.status() != WL_CONNECTED){
      Serial.print("Attempting to connect to SSID: ");
      Serial.println(SECRET_SSID);
      while(WiFi.status() != WL_CONNECTED){
        WiFi.begin(ssid, pass);  // Connect to WPA/WPA2 network. Change this line if using open or WEP network
        Serial.print(".");
        delay(5000);     
      } 
      Serial.println("\nConnected.");
    }
    
    // Start reading the sensors
    sensors.requestTemperatures(); 
    for (int i = 0; i < READINGSCOUNT; i++)
    {
      readPH(i);
      readTDS(i);  
      readTemp(i);    
    }

    // Set read data to their respective ThingSpeak field 
    ThingSpeak.setField(1, getMedianNum(temp, READINGSCOUNT));
    ThingSpeak.setField(2, getMedianNum(tds, READINGSCOUNT));
    ThingSpeak.setField(3, mapFloat(getMedianNum(ph, READINGSCOUNT), 260.0, 460.0, 4.0, 9.18));

    // Serial output only for development reasons
    Serial.println("----------------------------------------------------------");
    Serial.print("TDS: ");
    Serial.print(getMedianNum(tds, READINGSCOUNT));
    Serial.println("ppm");
    Serial.print("PH: ");
    Serial.println(mapFloat(getMedianNum(ph, READINGSCOUNT), 260.0, 460.0, 4.0, 9.18));
    Serial.print("Temp: ");
    Serial.print(getMedianNum(temp, READINGSCOUNT));
    Serial.println("°C");
  
    // Send all set fields to ThingSpeak and look out if it succeeded
    int resultCode = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
    if(resultCode == 200){
      Serial.println("Channel update successful.");
    }
    else{
      Serial.print("Problem updating channel. HTTP error code " + String(resultCode));
    }
  }
}

// Read PH per analog reading and write it into a list to smoothen measurement data
void readPH(int index)
{
  float pH_Value = analogRead(PH_PIN); 
  ph[index] = pH_Value; 
}

// Read temperature via OneWire library and write it into a list to smoothen measurement data
void readTemp(int index)
{
  float temp_Value = sensors.getTempCByIndex(0); 
  temp[index] = temp_Value; 
}

// Read TDS value and apply some compensation algorithm
void readTDS(int index)
{
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
      float compensationVoltage=averageVoltage/compensationCoefficient;
      
      // Convert voltage value to TDS value
      tdsValue=(133.42*compensationVoltage*compensationVoltage*compensationVoltage - 255.86*compensationVoltage*compensationVoltage + 857.39*compensationVoltage)*0.5;
    }
  }
  tds[index] = tdsValue;
}

// This function will be used to get a stable TDS value from an array of readings.
int getMedianNum(float bArray[], int iFilterLen){
  int bTab[iFilterLen];
  for (byte i = 0; i<iFilterLen; i++)
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
  if ((iFilterLen & 1) > 0){
    bTemp = bTab[(iFilterLen - 1) / 2];
  }
  else {
    bTemp = (bTab[iFilterLen / 2] + bTab[iFilterLen / 2 - 1]) / 2;
  }
  return bTemp;
}

// Remap values after calibrating a sensor.
// For example we need to remap PH values from a specific analog range to mol/l.
float mapFloat(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}



