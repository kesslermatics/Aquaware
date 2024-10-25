
# How to identify any fish

This guide explains how to use the **Aquaware API** to identify fish species based on uploaded images. The API is available only to users with the **Premium Subscription Tier (Tier 3)**.

## API Endpoint

To identify a fish species, use the following API endpoint:

```
POST /api/identify_fish_from_image/
```

### Parameters:
- **image**: A form-data field that must contain the image file of the fish. The image should be in a supported format (JPEG, PNG, etc.).

### Example Request (using cURL):

```bash
curl -X POST https://dev.aquaware.cloud/api/identify_fish_from_image/ \
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
  "species": "betta",
  "confidence": 95.00
}
```

### Status Codes:
- **200 OK**: The fish was successfully detected and identified.
- **400 Bad Request**: If no image was uploaded or if the image format is invalid, the API will return a 400 status code.
- **403 Forbidden**: If the user is not subscribed to Tier 3 (Premium), the API will return this status code.
- **500 Internal Server Error**: If something goes wrong on the server or during the processing of the image, a 500 status code is returned.

## Limitations and Caution:

:::warning[Keep in Mind]

Please note that this API uses machine learning models to analyze the fish species. While it is generally accurate, there may be **edge cases** where:
- Species identification may not be perfect, especially if the image quality is low.
- Visual characteristics of certain fish may overlap, leading to misidentification.

:::

The species identification provided should be taken as a recommendation, not a definitive conclusion. **No liability** will be accepted for any incorrect identification or subsequent actions taken based on the API response.

It is always recommended to consult a fish expert or professional if you require absolute certainty regarding the fish species.

