# Verwenden Sie ein Basis-Image, das Python und Rust enthält
FROM rust:latest as builder

# Installieren Sie Python und pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip

# Kopieren Sie Ihr Projektverzeichnis in das Container-Image
COPY . /app

# Wechseln Sie in das Projektverzeichnis
WORKDIR /app

# Installieren Sie die Python-Abhängigkeiten
RUN pip3 install -r requirements.txt

# Installieren Sie die Cargo-Abhängigkeiten (falls erforderlich)
# RUN cargo build --release (dieser Schritt ist optional und abhängig von Ihren Anforderungen)

# Installieren Sie die Django-App-Abhängigkeiten
RUN python3 manage.py collectstatic --noinput

# Exponieren Sie den Port, auf dem Ihre Django-App läuft
EXPOSE 8000

# Starten Sie die Django-App
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
