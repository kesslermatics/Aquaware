"""Django's command-line utility for administrative tasks."""
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aquaware.settings')
django.setup()
import sys

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()


def main():
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
