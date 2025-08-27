# Étape JS
FROM node:18-alpine AS js-build
WORKDIR /js
COPY package*.json ./
RUN npm install --omit=dev
COPY . .

# Étape Python
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

ENV PORT=5000
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]
