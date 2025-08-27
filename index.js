require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();
const PORT = Number(process.env.PORT) || 3000;

// 🔐 Sécurité & journalisation
app.use(helmet());
app.use(express.json());
app.use(morgan('dev'));

// 🏠 Route principale
app.get('/', (req, res) => {
  res.status(200).send('✅ Blackbird est en ligne sur Railway !');
});

// 📦 Route API produits (à automatiser plus tard)
app.get('/api/produits', (req, res) => {
  const produits = [
    // Exemple statique
    {
      id: '10001',
      nom: 'Sac à main cuir noir',
      prix: '89.00 EUR',
      dispo: true
    }
  ];
  res.status(200).json(produits);
});

// 📡 Webhook Railway
app.post('/apps/blackbird-agent/webhook', (req, res) => {
  const { event, project, timestamp } = req.body;

  if (!event || !project || !timestamp) {
    console.warn('⚠️ Webhook incomplet reçu');
    return res.status(400).send('Données manquantes');
  }

  console.log(`🚀 Événement Railway reçu : ${event} pour ${project} à ${timestamp}`);

  if (event === 'DEPLOYMENT_SUCCEEDED') {
    console.log('✅ Déploiement réussi, Shopify peut réagir');
    // Tu peux déclencher une action ici (ex: appel API Shopify)
  }

  res.status(200).send('Webhook reçu');
});

// 🚀 Lancement du serveur
app.listen(PORT, () => {
  console.log(`🎉 Agent Shopify lancé sur Railway (port ${PORT})`);
});
