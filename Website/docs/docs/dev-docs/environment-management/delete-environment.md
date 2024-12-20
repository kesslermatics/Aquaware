---
sidebar_position: 5
---

# Delete an Environment

To delete an environment, you can use the following API endpoint:

- **URL:** `https://dev.aquaware.cloud/api/environments/<int:id>/`
- **Method:** `DELETE`
- **Authentication:** You must include your JWT **Access Token** in the request headers. Learn more about [JWT tokens here](../user-management/jwt-tokens.md).

## Important Notes

When you delete an environment, **this action cannot be undone**. Make sure you are certain before proceeding with the deletion. Once an environment is deleted, it cannot be recovered.

### Example Request

```bash
DELETE https://dev.aquaware.cloud/api/environments/1/
Authorization: Bearer <access_token>
```

### Example Response

If the deletion is successful, you will receive a `204 No Content` response along with a success message.

```json
{
  "message": "Environment deleted successfully."
}
```

### Error Handling

If the environment does not belong to you or the ID does not exist, the API will return a `404 Not Found` error.

```json
{
  "error": "Environment not found or does not belong to this user."
}
```

:::info

When you delete an environment, the **water values** associated with that environment are **not deleted** from the database. However, these water values are no longer linked to any account. They remain available for training analysis, but they can no longer be traced back to the user who created them.

:::
