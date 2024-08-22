from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class APILogEntry(models.Model):
    timestamp = models.DateTimeField(auto_now_add=True)
    method = models.CharField(max_length=10)
    path = models.CharField(max_length=255)
    query_params = models.TextField(blank=True, null=True)  # Store query parameters as JSON or plain text
    request_body = models.TextField(blank=True, null=True)  # Store the request body
    response_body = models.TextField(blank=True, null=True)  # Store the response body
    status_code = models.IntegerField()
    headers = models.TextField(blank=True, null=True)  # Store headers as JSON or plain text
    execution_time = models.FloatField()  # Time taken to process the request in seconds
    remote_addr = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.CharField(max_length=255, blank=True, null=True)
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)

    class Meta:
        verbose_name = "API Log Entry"
        verbose_name_plural = "API Log Entries"

    def __str__(self):
        return f"{self.timestamp} {self.method} {self.path} {self.status_code}"