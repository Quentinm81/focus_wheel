# 🚀 Guide d'Onboarding - Focus Wheel

## Bienvenue dans l'équipe ! 👋

Ce guide vous aidera à configurer votre environnement de développement pour l'application Focus Wheel.

## 📋 Prérequis

### Outils nécessaires
- **Flutter** 3.10.0 ou supérieur ([Installation](https://flutter.dev/docs/get-started/install))
- **Node.js** 18 ou supérieur ([Installation](https://nodejs.org/))
- **Git** ([Installation](https://git-scm.com/))
- **Android Studio** ou **Xcode** (selon votre plateforme cible)
- **VS Code** ou **Android Studio** avec les extensions Flutter/Dart

### Comptes requis
- Compte **GitHub** avec accès au repository
- Compte **Stripe** (mode test) pour les paiements
- Accès aux secrets GitHub Actions (demander à l'équipe DevOps)

## 🛠️ Installation

### 1. Cloner le repository

```bash
git clone https://github.com/[votre-organisation]/focus-wheel.git
cd focus-wheel
```

### 2. Configuration Flutter

```bash
# Vérifier l'installation Flutter
flutter doctor

# Installer les dépendances Flutter
flutter pub get

# Générer les fichiers nécessaires
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configuration Backend

```bash
# Naviguer vers le dossier serveur
cd server

# Installer les dépendances Node.js
npm install

# Copier le fichier d'environnement
cp .env.example .env
```

### 4. Configuration des variables d'environnement

Éditez le fichier `server/.env` avec vos clés :

```env
# Configuration serveur
PORT=3000
NODE_ENV=development

# Stripe (récupérer sur https://dashboard.stripe.com/test/apikeys)
STRIPE_SECRET_KEY=sk_test_votre_cle_secrete
STRIPE_WEBHOOK_SECRET=whsec_votre_secret_webhook

# API
API_KEY=generer_une_cle_aleatoire
CORS_ORIGIN=http://localhost:3000

# Base de données (si applicable)
DATABASE_URL=postgresql://user:password@localhost:5432/focuswheel
```

### 5. Configuration Stripe CLI

```bash
# Installer Stripe CLI
npm install -g stripe

# Se connecter à Stripe
stripe login

# Écouter les webhooks en local
stripe listen --forward-to localhost:3000/webhook
```

## 🚀 Lancer l'application

### Terminal 1 : Backend
```bash
cd server
npm run dev
```

### Terminal 2 : Stripe Webhooks
```bash
stripe listen --forward-to localhost:3000/webhook
```

### Terminal 3 : Flutter
```bash
# Pour iOS
flutter run -d iPhone

# Pour Android
flutter run -d emulator

# Pour Web
flutter run -d chrome
```

## 🧪 Tests

### Tests Flutter
```bash
# Tests unitaires
flutter test

# Tests avec couverture
flutter test --coverage

# Tests d'intégration
flutter test integration_test/
```

### Tests Backend
```bash
cd server

# Tous les tests
npm test

# Tests avec couverture
npm test -- --coverage

# Tests en mode watch
npm test -- --watch
```

### Tests E2E
```bash
# Lancer les tests d'intégration complets
flutter drive --target=test_driver/app.dart
```

## 📱 Build et Déploiement

### Build de développement

```bash
# Android APK (debug)
flutter build apk --debug

# iOS (debug)
flutter build ios --debug --simulator
```

### Build de production

```bash
# Android APK
flutter build apk --release --split-per-abi

# Android App Bundle (pour Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔄 Workflow Git

### Branches
- `main` : Production
- `develop` : Développement
- `feature/*` : Nouvelles fonctionnalités
- `bugfix/*` : Corrections de bugs
- `hotfix/*` : Corrections urgentes

### Process de développement

1. **Créer une branche**
   ```bash
   git checkout -b feature/ma-nouvelle-fonctionnalite
   ```

2. **Développer et commiter**
   ```bash
   git add .
   git commit -m "feat: description de la fonctionnalité"
   ```

3. **Pousser la branche**
   ```bash
   git push origin feature/ma-nouvelle-fonctionnalite
   ```

4. **Créer une Pull Request**
   - Aller sur GitHub
   - Créer une PR vers `develop`
   - Attendre la revue de code et les tests CI

### Convention de commit
Nous utilisons [Conventional Commits](https://www.conventionalcommits.org/) :
- `feat:` Nouvelle fonctionnalité
- `fix:` Correction de bug
- `docs:` Documentation
- `style:` Formatage, pas de changement de code
- `refactor:` Refactoring
- `test:` Ajout de tests
- `chore:` Maintenance

## 🔍 Débogage

### Flutter
```bash
# Logs détaillés
flutter run --verbose

# Nettoyer le cache
flutter clean
flutter pub cache repair

# Analyser le code
flutter analyze
```

### Backend
```bash
# Logs du serveur
npm run dev

# Déboguer avec Chrome DevTools
node --inspect index.js
```

### Problèmes courants

#### Erreur de build Flutter
```bash
flutter clean
rm -rf .dart_tool/
flutter pub get
flutter build apk
```

#### Erreur Stripe webhook
- Vérifier que `STRIPE_WEBHOOK_SECRET` est correct
- S'assurer que `stripe listen` est en cours d'exécution
- Vérifier les logs Stripe CLI

#### Erreur de dépendances Node.js
```bash
cd server
rm -rf node_modules package-lock.json
npm install
```

## 📚 Ressources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Stripe API Reference](https://stripe.com/docs/api)
- [Express.js Guide](https://expressjs.com/)
- Architecture du projet : `/docs/architecture/`
- Conventions de code : `/docs/dev/code_conventions.md`

### Outils internes
- Tableau Kanban : [Lien Jira/Trello]
- Documentation API : `/docs/api/`
- Design System : [Lien Figma]

### Contacts
- **Slack** : #focus-wheel-dev
- **Email équipe** : dev-team@focuswheel.com
- **Lead technique** : [Nom] - [email]
- **Product Owner** : [Nom] - [email]

## 🚨 En cas d'urgence

### Hotfix en production
1. Créer une branche depuis `main` : `git checkout -b hotfix/description`
2. Corriger et tester localement
3. Push et créer une PR urgente vers `main`
4. Notifier l'équipe sur Slack

### Rollback
```bash
# Identifier le commit stable
git log --oneline

# Revenir au commit précédent
git revert [commit-hash]

# Ou reset hard (attention!)
git reset --hard [commit-hash]
```

### Contacts d'urgence
- **DevOps de garde** : +33 6 XX XX XX XX
- **Incident Slack** : #incidents
- **Status page** : status.focuswheel.com

---

## ✅ Checklist du premier jour

- [ ] Accès GitHub accordé
- [ ] Environnement local configuré
- [ ] Tests lancés avec succès
- [ ] Premier build réussi
- [ ] Accès Stripe test configuré
- [ ] Documentation lue
- [ ] Présentation à l'équipe faite
- [ ] Premier commit de test effectué

Bienvenue dans l'équipe Focus Wheel ! 🎉

*Dernière mise à jour : [Date automatique lors du CI/CD]*