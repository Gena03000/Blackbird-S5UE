#!/bin/bash

echo "🔧 Initialisation de l'environnement Python..."

# 1. Création d'un environnement virtuel
python -m venv venv
source venv/bin/activate

# 2. Mise à jour de pip
pip install --upgrade pip

# 3. Installation des dépendances principales
echo "📦 Installation des dépendances de production..."
pip install -r requirements.txt

# 4. Installation des dépendances de développement (si le fichier existe)
if [ -f "dev-requirements.txt" ]; then
  echo "🧪 Installation des dépendances de développement..."
  pip install -r dev-requirements.txt
else
  echo "⚠️ Aucun fichier dev-requirements.txt trouvé. Dépendances de dev non installées."
fi

# 5. Confirmation
echo "✅ Environnement prêt ! Active-le avec : source venv/bin/activate"
