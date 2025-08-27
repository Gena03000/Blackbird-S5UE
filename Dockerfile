# Étape 1 : Build JS (si tu as des assets à compiler)
FROM node:18-alpine AS js-build
WORKDIR /js
COPY package*.json ./
RUN npm install --omit=dev
COPY . .

# Étape 2 : Build final Python avec les fichiers JS intégrés
FROM python:3.11-slim

# Dépendances système minimales
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copier uniquement les fichiers nécessaires
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet
COPY . .

# Si tu veux inclure les fichiers JS compilés :
# COPY --from=js-build /js/static /app/static

# Variables d’environnement
ENV PORT=5000
ENV PYTHONUNBUFFERED=1

# Commande de démarrage
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]

