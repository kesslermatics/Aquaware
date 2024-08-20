import logging


class LoggingMixin:
    """
    Provides full logging of requests and responses
    """
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.logger = logging.getLogger('django.request')
    def initial(self, request, *args, **kwargs):
        try:
            self.logger.debug({
                "request": request.data,
                "method": request.method,
                "endpoint": request.path,
                "user": request.user.username,
                "ip_address": request.META.get('REMOTE_ADDR'),
                "user_agent": request.META.get('HTTP_USER_AGENT')
            })
        except Exception:
            self.logger.exception("Error logging request data")
        super().initial(request, *args, **kwargs)
    def finalize_response(self, request, response, *args, **kwargs):
        try:
            self.logger.debug({
                "response": response.data,
                "status_code": response.status_code,
                "user": request.user.username,
                "ip_address": request.META.get('REMOTE_ADDR'),
                "user_agent": request.META.get('HTTP_USER_AGENT')
            })
        except Exception:
            self.logger.exception("Error logging response data")
        return super().finalize_response(request, response, *args, **kwargs)