# Focus Wheel Backend API

Backend RESTful API pour l'application Focus Wheel avec intégration Stripe pour la gestion des abonnements.

## 🚀 Démarrage rapide

```bash
# Installer les dépendances
npm install

# Configurer l'environnement
cp .env.example .env
# Éditer .env avec vos clés

# Lancer en développement
npm run dev

# Lancer en production
npm start
```

## 📦 Scripts disponibles

| Script | Description |
|--------|-------------|
| `npm start` | Lance le serveur en mode production |
| `npm run dev` | Lance le serveur en développement avec hot reload (nodemon) |
| `npm test` | Lance les tests Jest |
| `npm run test:ci` | Lance les tests en mode CI avec couverture |
| `npm run lint` | Vérifie le code avec ESLint |
| `npm run stripe:test` | Lance l'écoute des webhooks Stripe en local |
| `npm run stripe:webhook` | Déclenche un webhook de test |

## 🔧 Configuration

### Variables d'environnement

Créez un fichier `.env` à la racine du dossier `server/` :

```env
# Configuration serveur
PORT=3000
NODE_ENV=development

# Stripe
STRIPE_SECRET_KEY=sk_test_...  # Clé secrète Stripe (mode test)
STRIPE_WEBHOOK_SECRET=whsec_... # Secret pour valider les webhooks

# API
API_KEY=your_secure_api_key
CORS_ORIGIN=http://localhost:3000

# Base de données (optionnel)
DATABASE_URL=postgresql://user:password@localhost:5432/focuswheel

# JWT (pour l'authentification)
JWT_SECRET=your_jwt_secret

# Email (optionnel)
EMAIL_API_KEY=your_email_api_key
EMAIL_FROM=noreply@focuswheel.com
```

### Configuration Stripe

1. Créez un compte sur [Stripe](https://stripe.com)
2. Récupérez vos clés API en mode test
3. Configurez le webhook endpoint :
   ```bash
   stripe listen --forward-to localhost:3000/webhook
   ```
4. Copiez le secret webhook dans `.env`

## 📡 API Endpoints

### Santé et informations

#### `GET /health`
Vérification de l'état du serveur.

**Réponse :**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T12:00:00.000Z",
  "environment": "development"
}
```

#### `GET /api`
Informations sur l'API.

**Réponse :**
```json
{
  "message": "Focus Wheel API",
  "version": "1.0.0",
  "endpoints": {
    "health": "/health",
    "subscriptions": "/api/subscriptions",
    "webhook": "/webhook"
  }
}
```

### Gestion des abonnements

#### `GET /api/subscriptions`
Liste les abonnements Stripe.

**Headers requis :**
- `Authorization: Bearer {API_KEY}`

**Réponse :**
```json
{
  "data": [
    {
      "id": "sub_123",
      "customer": "cus_123",
      "status": "active",
      "current_period_end": 1234567890
    }
  ]
}
```

#### `POST /api/subscriptions/create`
Crée un nouvel abonnement.

**Body :**
```json
{
  "customerId": "cus_123",
  "priceId": "price_123"
}
```

**Réponse :**
```json
{
  "id": "sub_123",
  "status": "active",
  "customer": "cus_123"
}
```

#### `POST /api/subscriptions/cancel`
Annule un abonnement.

**Body :**
```json
{
  "subscriptionId": "sub_123"
}
```

**Réponse :**
```json
{
  "id": "sub_123",
  "status": "canceled",
  "canceled_at": 1234567890
}
```

### Webhooks

#### `POST /webhook`
Endpoint pour recevoir les événements Stripe.

**Headers requis :**
- `stripe-signature: t=...,v1=...`

**Événements gérés :**
- `payment_intent.succeeded`
- `subscription.created`
- `subscription.updated`
- `subscription.deleted`
- `customer.subscription.trial_will_end`

## 🧪 Tests

### Lancer les tests

```bash
# Tous les tests
npm test

# Avec couverture
npm test -- --coverage

# En mode watch
npm test -- --watch

# Un fichier spécifique
npm test server.test.js
```

### Structure des tests

```
server/
├── __tests__/
│   ├── server.test.js      # Tests API généraux
│   ├── stripe.test.js      # Tests intégration Stripe
│   └── webhooks.test.js    # Tests webhooks
```

### Tester les webhooks Stripe

```bash
# Terminal 1 : Lancer le serveur
npm run dev

# Terminal 2 : Écouter les webhooks
stripe listen --forward-to localhost:3000/webhook

# Terminal 3 : Déclencher un événement
stripe trigger payment_intent.succeeded
```

## 🔒 Sécurité

### Mesures implémentées

- **Helmet.js** : Headers de sécurité HTTP
- **CORS** : Contrôle des origines autorisées
- **Rate Limiting** : 100 requêtes par 15 minutes par IP
- **Validation Stripe** : Vérification des signatures webhook
- **Variables d'environnement** : Secrets non versionnés

### Bonnes pratiques

1. **Ne jamais commiter le fichier `.env`**
2. Utiliser des clés API différentes par environnement
3. Activer HTTPS en production
4. Mettre à jour régulièrement les dépendances
5. Auditer avec `npm audit`

## 🚀 Déploiement

### Prérequis
- Node.js 18+
- Variables d'environnement configurées
- Certificat SSL (production)

### Render.com

1. Connecter le repository GitHub
2. Configurer les variables d'environnement
3. Build command : `npm install`
4. Start command : `npm start`

### Heroku

```bash
# Créer l'app
heroku create focus-wheel-api

# Configurer les variables
heroku config:set NODE_ENV=production
heroku config:set STRIPE_SECRET_KEY=sk_live_...

# Déployer
git push heroku main
```

### Docker

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## 📊 Monitoring

### Logs
- Développement : Console
- Production : Fichiers dans `/logs`

### Métriques
- Temps de réponse des endpoints
- Taux d'erreur
- Utilisation mémoire/CPU

### Alertes recommandées
- Endpoint `/health` down
- Taux d'erreur > 5%
- Temps de réponse > 1s

## 🐛 Dépannage

### Erreurs courantes

#### "Cannot find module"
```bash
rm -rf node_modules package-lock.json
npm install
```

#### "Stripe webhook error"
- Vérifier `STRIPE_WEBHOOK_SECRET`
- S'assurer que `stripe listen` est actif
- Vérifier l'URL du webhook

#### "Port already in use"
```bash
# Trouver le processus
lsof -i :3000
# Tuer le processus
kill -9 [PID]
```

## 📝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit (`git commit -m 'Add AmazingFeature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.

## 👥 Équipe

- Backend Lead : [Nom]
- DevOps : [Nom]
- Contact : dev-team@focuswheel.com

---

Pour plus d'informations, consultez la [documentation complète](../docs/).