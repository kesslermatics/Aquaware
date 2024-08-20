import logging
from functools import wraps

logger = logging.getLogger("django.request")

def log_view(func):
    @wraps(func)
    def wrapper(request, *args, **kwargs):
        logger.info(f"Start handling {request.method} request for {request.path} in {func.__name__}")
        response = func(request, *args, **kwargs)
        logger.info(f"Finished handling {request.method} request for {request.path} in {func.__name__}")
        return response
    return wrapper
