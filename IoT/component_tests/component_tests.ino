#include <Wire.h>
#include "DFRobot_LcdDisplay.h"
#include <OneWire.h>
#include <DallasTemperature.h>

// 🖥️ LCD Display Setup (I2C Address: 0x2c)
DFRobot_Lcd_IIC lcd(&Wire, 0x2c);

// 🌡️ Sensor Pins
#define TEMP_PIN D7     // Temperature Sensor on D7
#define TDS_PIN A0      // TDS Sensor on A0
#define TSS_PIN A2      // TSS Sensor on A2

// 🌡️ OneWire & DallasTemperature Setup
OneWire oneWire(TEMP_PIN);
DallasTemperature tempSensor(&oneWire);

// 📊 Progress Bar & Label IDs
uint8_t tempBar, tdsBar, tssBar;
uint8_t tempLabel, tdsLabel, tssLabel;
uint8_t clockLabel;

// 🕒 Time Variables
uint8_t hour = 12, minute = 45, second = 30;
uint8_t lastSecond = 0;

// 🕒 Simple Time Update Function (Simulated)
void updateClock() {
    second++;
    if (second > 59) {
        second = 0;
        minute++;
    }
    if (minute > 59) {
        minute = 0;
        hour++;
    }
    if (hour > 23) {
        hour = 0;
    }
}

void setup() {
    Serial.begin(115200);
    Serial.println("\n🚀 ESP32 Sensor Display Started...");

    // 🖥️ Initialize LCD
    Serial.println("🖥️ Initializing LCD...");
    if (lcd.begin()) {
        lcd.cleanScreen();
        lcd.setBackgroundColor(BLACK); // Set black background
        Serial.println("✅ LCD successfully started!");
    } else {
        Serial.println("❌ LCD error! Check I2C address.");
    }

    // 🌡️ Start temperature sensor
    tempSensor.begin();

    // ⏰ Draw Clock Display (Top Left)
    clockLabel = lcd.drawLcdTime(10, 10, hour, minute, second, 1, WHITE);

    // 🖼️ Draw Sensor Icons (Left Side)
    lcd.drawIcon(10, 40, "/sensor icon/thermometer.png", 120); // Temperature Icon
    lcd.drawIcon(10, 90, "/sensor icon/raindrops.png", 120);   // TDS Icon
    lcd.drawIcon(10, 140, "/sensor icon/pressure.png", 120);   // TSS Icon

    // 📊 Create Progress Bars (Aligned to Right Side)
    tempBar = lcd.creatBar(140, 45, 120, 15, ORANGE);
    tdsBar  = lcd.creatBar(140, 95, 120, 15, BLUE);
    tssBar  = lcd.creatBar(140, 145, 120, 15, GREEN);

    // 📄 Create Labels for Values
    tempLabel = lcd.drawString(270, 45, "0°C", 0, ORANGE);
    tdsLabel  = lcd.drawString(270, 95, "0 mg/L", 0, BLUE);
    tssLabel  = lcd.drawString(270, 145, "0 mg/L", 0, GREEN);

    // 🌊 Add Water Icons at Bottom
    lcd.drawIcon(0, 190, "/botany icon/Potted plant flower.png", 256);
    lcd.drawIcon(53, 190, "/botany icon/cactus3.png", 256);
    lcd.drawIcon(106, 190, "/botany icon/grass.png", 256);
    lcd.drawIcon(159, 190, "/botany icon/grass1.png", 256);
    lcd.drawIcon(212, 190, "/botany icon/cactus1.png", 256);
    lcd.drawIcon(265, 190, "/botany icon/cactus2.png", 256);
}

void loop() {
    // 🕒 Update Clock Every Second
    if (lastSecond != second) {
        lastSecond = second;
        updateClock();
        lcd.updateLcdTime(clockLabel, 10, 10, hour, minute, lastSecond, 1, WHITE);
    }

    // 🌡️ Read Temperature
    tempSensor.requestTemperatures();
    float temperature = tempSensor.getTempCByIndex(0);
    if (temperature == DEVICE_DISCONNECTED_C) {
        Serial.println("❌ No temperature sensor detected!");
        temperature = -99; // Error value
    }

    // 🔬 Read TDS & TSS values
    int tdsRaw = analogRead(TDS_PIN);
    int tssRaw = analogRead(TSS_PIN);

    // 🔢 Convert to mg/L (adjust values as needed)
    float tdsValue = (tdsRaw / 4095.0) * 1000;
    float tssValue = (tssRaw / 4095.0) * 500;

    // 🖥️ Update LCD Display with Sensor Values
    lcd.setBarValue(tempBar, temperature);
    lcd.updateString(tempLabel, 270, 45, String(temperature) + "°C", 0, ORANGE);

    lcd.setBarValue(tdsBar, tdsValue);
    lcd.updateString(tdsLabel, 270, 95, String(tdsValue) + " mg/L", 0, BLUE);

    lcd.setBarValue(tssBar, tssValue);
    lcd.updateString(tssLabel, 270, 145, String(tssValue) + " mg/L", 0, GREEN);

    // 📟 Serial Monitor Output
    Serial.print("🕒 Time: "); Serial.print(hour); Serial.print(":"); Serial.print(minute); Serial.print(":"); Serial.println(second);
    Serial.print("🌡️ Temperature: "); Serial.print(temperature); Serial.println(" °C");
    Serial.print("💧 TDS Value: "); Serial.print(tdsValue); Serial.println(" mg/L");
    Serial.print("🌀 TSS Value: "); Serial.print(tssValue); Serial.println(" mg/L");
    Serial.println("-----------------------------");

    delay(1000); // 🔄 Update every second
}
