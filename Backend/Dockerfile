# Verwenden Sie ein Basis-Image, das Python und Rust enthält
FROM rust:latest as builder

# Installieren Sie Python und pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv

# Kopieren Sie Ihr Projektverzeichnis in das Container-Image
COPY . /app

# Wechseln Sie in das Projektverzeichnis
WORKDIR /app

# Erstellen Sie eine virtuelle Umgebung
RUN python3 -m venv venv

# Aktivieren Sie die virtuelle Umgebung und installieren Sie die Python-Abhängigkeiten
RUN . venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt

# Installieren Sie die Cargo-Abhängigkeiten (falls erforderlich)
# RUN . venv/bin/activate && cargo build --release (dieser Schritt ist optional und abhängig von Ihren Anforderungen)

# Installieren Sie die Django-App-Abhängigkeiten
RUN . venv/bin/activate && python manage.py collectstatic --noinput

# Exponieren Sie den Port, auf dem Ihre Django-App läuft
EXPOSE 8000

# Starten Sie die Django-App in der virtuellen Umgebung
CMD ["/app/venv/bin/python", "manage.py", "runserver", "0.0.0.0:8000"]
