from datetime import datetime
from django.utils.deprecation import MiddlewareMixin
from django.contrib.auth import get_user_model
from logs.models import APILogEntry

User = get_user_model()

class APILoggingMiddleware(MiddlewareMixin):
    def process_request(self, request):
        # Store request start time
        request.start_time = datetime.now()

    def process_response(self, request, response):
        # Capture the information you want to log
        method = request.method
        path = request.path
        status_code = response.status_code
        remote_addr = request.META.get('REMOTE_ADDR')
        user_agent = request.META.get('HTTP_USER_AGENT', '')
        query_params = request.GET.dict()
        post_data = request.POST.dict() if request.method == 'POST' else None
        user = request.user if request.user.is_authenticated else None
        request_body = request.body.decode('utf-8') if request.body else ''
        timestamp = request.start_time

        # Log the information to the database
        APILogEntry.objects.create(
            method=method,
            path=path,
            status_code=status_code,
            remote_addr=remote_addr,
            user_agent=user_agent,
            query_params=query_params,
            post_data=post_data,
            user=user,
            request_body=request_body,
            timestamp=timestamp,
        )

        return response
