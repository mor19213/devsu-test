# ------------------- Stage 1: Build Stage ------------------------------
FROM python:3.11-slim as builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# ------------------- Stage 2: Final Stage ------------------------------
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# RUN useradd -m myuser

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
# COPY --chown=myuser:myuser . .
COPY . .
ENV PATH=/home/myuser/.local/bin:$PATH

# USER myuser

EXPOSE 8000

RUN python manage.py makemigrations && \
    python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]