from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class APILogEntry(models.Model):
    method = models.CharField(max_length=10, null=True, blank=True)
    path = models.CharField(max_length=255, null=True, blank=True)
    status_code = models.IntegerField(null=True, blank=True)
    remote_addr = models.CharField(max_length=45, null=True, blank=True)
    user_agent = models.CharField(max_length=255, null=True, blank=True)
    query_params = models.TextField(null=True, blank=True)
    post_data = models.TextField(null=True, blank=True)
    user = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL)
    request_body = models.TextField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
