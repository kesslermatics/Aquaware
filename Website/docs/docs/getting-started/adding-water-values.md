---
sidebar_position: 5
---

# Adding Water Parameters

To maintain accurate records of your aquatic environment, you can upload water parameters directly to your environment. Below, you'll find all the details you need to get started, including how to use your API Key and Environment ID, as well as how to send data using a POST request.

## Prerequisites

Before uploading water parameters, ensure you have the following:

1. **API Key**: Your unique API Key can be found in the [Aquaware Dashboard](https://aquaware.cloud/dashboard). This key is required for authorization.
2. **Environment ID**: The ID of the specific environment you want to upload data to. This is visible in the environment list on your dashboard.

:::note[Keep in mind]
The frequency of uploading water parameters depends on your subscription plan. You can view your plan and its upload frequency in the dashboard. For example, users on the Premium Plan can upload parameters every 30 minutes, while others may have longer intervals.
:::

---

## How to Upload Parameters

You can upload water parameters by sending a POST request to the following endpoint:

```
https://dev.aquaware.cloud/api/environments/<int:environment_id>/values/
```

### Headers

- **`x-api-key`**: Your API Key for authorization.

### Example Body

Here’s an example body for uploading water temperature. Assuming your subscription allows uploads every 3 hours:

```json
{
  "Temperature": 29.9
}
```

You can replace `Temperature` with any other available parameter.

---

## Supported Water Parameters

Aquaware supports a wide range of parameters to monitor your aquatic environment. Below is the full list:

| Name               | Unit  |
| ------------------ | ----- |
| PH                 | pH    |
| Temperature        | °C    |
| TDS                | ppm   |
| Oxygen             | mg/L  |
| Ammonia            | ppm   |
| Nitrite            | ppm   |
| Nitrate            | ppm   |
| Phosphate          | ppm   |
| Carbon Dioxide     | mg/L  |
| Salinity           | ppt   |
| General Hardness   | dGH   |
| Carbonate Hardness | dKH   |
| Copper             | ppm   |
| Iron               | ppm   |
| Calcium            | ppm   |
| Magnesium          | ppm   |
| Potassium          | ppm   |
| Chlorine           | ppm   |
| Redox Potential    | mV    |
| Silica             | ppm   |
| Boron              | ppm   |
| Strontium          | ppm   |
| Iodine             | ppm   |
| Molybdenum         | ppm   |
| Sulfate            | ppm   |
| Organic Carbon     | ppm   |
| Turbidity          | NTU   |
| Conductivity       | µS/cm |
| Suspended Solids   | mg/L  |
| Fluoride           | ppm   |
| Bromine            | ppm   |
| Chloride           | ppm   |

---

## Example: Uploading Temperature with Arduino

If you’re using Arduino and a temperature sensor, here’s a simple example of how to upload water temperature every 3 hours:

### Code Snippet

```cpp
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "your_wifi_ssid";
const char* password = "your_wifi_password";

const String apiEndpoint = "https://dev.aquaware.cloud/api/environments/<Environment_ID>/values/";
const String apiKey = "your_api_key";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to WiFi");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(apiEndpoint);
    http.addHeader("Content-Type", "application/json");
    http.addHeader("x-api-key", apiKey);

    String payload = "{"Temperature":29.9}";
    int httpResponseCode = http.POST(payload);

    if (httpResponseCode > 0) {
      Serial.printf("POST Response Code: %d\n", httpResponseCode);
    } else {
      Serial.printf("Error: %s\n", http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  }

  delay(10800000); // Delay 3 hours
}
```

---

Perfect, that's it. Now you can look into your water values with our official app.
