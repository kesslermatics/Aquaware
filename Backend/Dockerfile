FROM python:3.10.2-slim

ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    pkg-config \
    libcairo2-dev \
    python3-dev

WORKDIR /app

COPY requirements.txt ./

RUN .\venv\Scripts\activate
RUN pip install -r requirements.txt

COPY . ./

CMD python manage.py migrate & daphne -b 0.0.0.0 -p $PORT arriva.asgi:application