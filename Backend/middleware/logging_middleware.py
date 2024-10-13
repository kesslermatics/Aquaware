import time
import logging
from django.utils.deprecation import MiddlewareMixin
from logs.models import APILogEntry
from datetime import timedelta
from django.utils import timezone


class APILoggingMiddleware(MiddlewareMixin):

    def process_request(self, request):
        request.start_time = time.time()

        # Check if the request contains binary data (e.g., file uploads)
        if request.content_type.startswith('multipart/form-data') or request.content_type.startswith(
                'application/octet-stream'):
            # Skip logging for binary data
            request_body = ''  # No need to decode
        else:
            request_body = request.body.decode('utf-8', errors='ignore') if request.body else ''

        request.query_params = request.GET.dict()

        # Save request details in request object to access in process_response
        request.log_data = {
            'method': request.method,
            'path': request.path,
            'query_params': request.query_params,
            'request_body': request_body,
            'headers': dict(request.headers),
            'remote_addr': request.META.get('REMOTE_ADDR'),
            'user_agent': request.META.get('HTTP_USER_AGENT', ''),
            'user': request.user.id if request.user.is_authenticated else None,
        }

    def process_response(self, request, response):
        # Calculate execution time
        execution_time = time.time() - request.start_time
        response_body = response.content.decode('utf-8', errors='ignore') if response.content else ''

        # Add response details to log_data
        request.log_data.update({
            'status_code': response.status_code,
            'response_body': response_body,
            'execution_time': execution_time,
        })

        # Create the log entry
        APILogEntry.objects.create(
            method=request.log_data['method'],
            path=request.log_data['path'],
            status_code=request.log_data['status_code'],
            query_params=request.log_data['query_params'],
            request_body=request.log_data['request_body'],
            response_body=request.log_data['response_body'],
            headers=request.log_data['headers'],
            execution_time=request.log_data['execution_time'],
            remote_addr=request.log_data['remote_addr'],
            user_agent=request.log_data['user_agent'],
            user_id=request.log_data['user'],
        )

        # Delete logs older than 30 days
        self.delete_old_logs()

        return response

    def process_exception(self, request, exception):
        logging.exception(f"Exception during request: {request.path}")

    def delete_old_logs(self):
        # Get the timestamp for 30 days ago
        cutoff_date = timezone.now() - timedelta(days=30)

        # Delete all logs older than 30 days based on the timestamp field
        APILogEntry.objects.filter(timestamp__lt=cutoff_date).delete()
