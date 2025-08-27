# 🏗️ Étape 1 : Build dans une image légère
FROM node:18-alpine AS build
WORKDIR /app

FROM python:3.11-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

ENV PORT=8000

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]
