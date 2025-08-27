# Étape 1 : Build JS
FROM node:18-alpine AS js-build
WORKDIR /js
COPY package*.json ./
RUN npm install --omit=dev
COPY . .

# Étape 2 : Build Python
FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY --from=js-build /js/static /app/static

ENV PORT=5000
ENV PYTHONUNBUFFERED=1

RUN useradd -m -s /bin/bash nonroot
USER nonroot

RUN addgroup --system nonroot && \
    adduser --system --ingroup nonroot nonroot && \
    chown -R nonroot:nonroot /app

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]


