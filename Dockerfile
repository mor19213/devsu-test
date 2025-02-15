# Stage 1: Builder
FROM python:3.11-slim as builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN useradd -m myuser

WORKDIR /app

COPY --from=builder /root/.local /home/myuser/.local
COPY --chown=myuser:myuser . .

ENV PATH=/home/myuser/.local/bin:$PATH

USER myuser

EXPOSE 8000

CMD ["python", "manage.py", "runserver"]