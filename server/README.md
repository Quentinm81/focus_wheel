# Focus Wheel – Backend (Node/Express + Stripe)

Ce dossier contient l’API qui gère les abonnements Stripe, le webhook, ainsi que les tests.

---
## 1. Prérequis

* Node 20+
* Stripe CLI (pour tester les webhooks) : <https://stripe.com/docs/stripe-cli>

---
## 2. Installation locale

```bash
# 1. Cloner le repo et se placer dans le dossier
cd server

# 2. Copier la configuration d’environnement
cp .env.example .env            # puis remplir les valeurs

# 3. Installer les dépendances
npm ci

# 4. Lancer les tests (Jest + Supertest)
npm test

# 5. Démarrer le serveur pour le dev
npm run dev                     # nodemon sur http://localhost:$PORT
```

### Smoke-test rapide

```bash
npm run validate                # npm test + script smoke sur /create-subscription
```

---
## 3. Tests des webhooks avec Stripe CLI

```bash
# Terminal 1 : écoute les évènements test Stripe et les relaie en local
stripe listen --forward-to localhost:$PORT/webhook

# Terminal 2 : envoie un évènement de test
stripe trigger customer.subscription.updated
```

---
## 4. Déploiement

1. Pousser le code sur GitHub (branche `main` ou `develop`).
2. Sur Render / Railway / AWS :
   * Renseigner toutes les variables d’environnement listées dans `.env.example`.
   * Commande de build : `npm ci`
   * Commande de démarage : `node index.js`.
3. Vérifier les logs de l’app + configurer le Stripe CLI en mode `--live` pour pointer vers l’URL publique.

---
## 5. CI GitHub Actions

* Toute Pull-Request touchant le dossier `server/` déclenche l’action `Backend CI` qui exécute `npm test` sur Ubuntu-latest avec Node 20.
* Le fichier de workflow se trouve dans `.github/workflows/backend-ci.yml`.