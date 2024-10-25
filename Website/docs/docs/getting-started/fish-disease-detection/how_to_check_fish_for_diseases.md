
# How to check fish for diseases

This guide explains how to use the **Aquaware API** to check fish for diseases based on uploaded images. The API is available only to users with the **Premium Subscription Tier (Tier 3)**.

## API Endpoint

To check a fish for diseases, use the following API endpoint:

```
POST /api/diseases/diagnosis-from-image/
```

### Parameters:
- **image**: A form-data field that must contain the image file of the fish. The image should be in a supported format (JPEG, PNG, etc.).

### Example Request (using cURL):

```bash
curl -X POST http://your-api-url.com/api/diseases/diagnosis-from-image/ \
  -H 'Authorization: Bearer your-access-token' \
  -F 'image=@/path-to-your-image/fish_image.jpg'
```

### Subscription Tier Requirement:
This endpoint is restricted to users with a **Premium Subscription (Tier 3)**. If a user with a lower-tier subscription attempts to access this endpoint, the API will return a 403 status code with a message:

```
{
  "detail": "This feature is only available for Premium subscribers."
}
```

## Example Response

If the fish is detected and analyzed successfully, the API will return a 200 status code with a JSON response similar to the following:

```json
{
  "fish_detected": true,
  "condition": "fin rot",
  "symptoms": "The fish's fins appear to be frayed and have white or cloudy edges. This is indicative of bacterial infection deteriorating the fin tissue.",
  "curing": "Improve water quality by performing partial water changes and ensuring proper filtration. Treat with an antibacterial medication specifically designed for aquarium use.",
  "certainty": 90
}
```

### Status Codes:
- **200 OK**: The fish was successfully detected and diagnosed.
- **400 Bad Request**: If no image was uploaded or if the image format is invalid, the API will return a 400 status code.
- **403 Forbidden**: If the user is not subscribed to Tier 3 (Premium), the API will return this status code.
- **500 Internal Server Error**: If something goes wrong on the server or during the processing of the image, a 500 status code is returned.

## Limitations and Caution:

:::warning[Keep in Mind]

Please note that this API uses machine learning models to analyze the fish and its condition. While it is generally accurate, there may be **edge cases** where:
- Symptoms of disease are subtle or not easily detectable.
- The fish’s natural patterns or appearance may resemble disease symptoms but are not harmful.

:::

The diagnosis provided should be taken as a recommendation, not a definitive conclusion. **No liability** will be accepted for any incorrect diagnosis or subsequent actions taken based on the API response.

It is always recommended to consult a professional veterinarian or fish health expert for any serious concerns about your fish.