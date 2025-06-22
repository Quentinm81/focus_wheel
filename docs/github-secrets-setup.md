# 🔐 Configuration des Secrets GitHub Actions

Ce guide explique comment configurer les secrets nécessaires pour le workflow CI/CD.

## 📋 Secrets requis

### 1. **STRIPE_SECRET_KEY** (Obligatoire)
- **Description** : Clé secrète Stripe pour l'API
- **Où la trouver** : [Dashboard Stripe](https://dashboard.stripe.com/apikeys)
- **Format** : `sk_test_...` (test) ou `sk_live_...` (production)
- **Configuration** :
  ```bash
  gh secret set STRIPE_SECRET_KEY --repo Quentinm81/focus_wheel
  ```

### 2. **STRIPE_WEBHOOK_SECRET** (Obligatoire)
- **Description** : Secret pour valider les webhooks Stripe
- **Où le trouver** : Dashboard Stripe > Webhooks > Votre endpoint
- **Format** : `whsec_...`
- **Configuration** :
  ```bash
  gh secret set STRIPE_WEBHOOK_SECRET --repo Quentinm81/focus_wheel
  ```

### 3. **API_KEY** (Obligatoire)
- **Description** : Clé API pour sécuriser les endpoints
- **Génération** : `openssl rand -hex 32`
- **Configuration** :
  ```bash
  gh secret set API_KEY --repo Quentinm81/focus_wheel
  ```

### 4. **CODECOV_TOKEN** (Recommandé)
- **Description** : Token pour uploader la couverture de code
- **Où le trouver** : [Codecov.io](https://codecov.io/) après connexion
- **Configuration** :
  ```bash
  gh secret set CODECOV_TOKEN --repo Quentinm81/focus_wheel
  ```

### 5. **SNYK_TOKEN** (Optionnel)
- **Description** : Token pour l'analyse de sécurité
- **Où le trouver** : [Snyk Dashboard](https://app.snyk.io/account)
- **Configuration** :
  ```bash
  gh secret set SNYK_TOKEN --repo Quentinm81/focus_wheel
  ```

### 6. **RENDER_API_KEY** (Pour déploiement)
- **Description** : Clé API Render pour le déploiement automatique
- **Où la trouver** : [Render Dashboard](https://dashboard.render.com/account/api-keys)
- **Configuration** :
  ```bash
  gh secret set RENDER_API_KEY --repo Quentinm81/focus_wheel
  ```

### 7. **SLACK_WEBHOOK_URL** (Optionnel)
- **Description** : URL webhook Slack pour les notifications
- **Où le trouver** : Slack App > Incoming Webhooks
- **Configuration** :
  ```bash
  gh secret set SLACK_WEBHOOK_URL --repo Quentinm81/focus_wheel
  ```

### 8. **GOOGLE_PLAY_SERVICE_ACCOUNT** (Pour Play Store)
- **Description** : JSON du compte de service Google Play
- **Où le trouver** : Google Play Console > API access
- **Format** : JSON complet encodé
- **Configuration** :
  ```bash
  # Encoder le fichier JSON en base64
  base64 -i google-play-key.json | pbcopy
  # Puis coller dans GitHub
  gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT --repo Quentinm81/focus_wheel
  ```

### 9. **APP_STORE_KEY** (Pour App Store)
- **Description** : Clé API App Store Connect
- **Où la trouver** : App Store Connect > Users and Access > Keys
- **Configuration** :
  ```bash
  gh secret set APP_STORE_KEY --repo Quentinm81/focus_wheel
  ```

## 🚀 Configuration rapide

### Via l'interface GitHub

1. Aller sur https://github.com/Quentinm81/focus_wheel/settings/secrets/actions
2. Cliquer sur "New repository secret"
3. Ajouter chaque secret avec son nom et sa valeur

### Via GitHub CLI

```bash
# Installation GitHub CLI si nécessaire
brew install gh  # macOS
# ou voir https://cli.github.com/

# Authentification
gh auth login

# Ajouter les secrets obligatoires
gh secret set STRIPE_SECRET_KEY --repo Quentinm81/focus_wheel
gh secret set STRIPE_WEBHOOK_SECRET --repo Quentinm81/focus_wheel
gh secret set API_KEY --repo Quentinm81/focus_wheel
```

## 🔍 Vérification

Pour vérifier les secrets configurés :

```bash
gh secret list --repo Quentinm81/focus_wheel
```

## ⚠️ Sécurité

- **Ne jamais** commiter ces valeurs dans le code
- Utiliser des valeurs différentes pour test/production
- Renouveler régulièrement les clés API
- Limiter les permissions au minimum nécessaire

## 📝 Notes

- Les secrets marqués "Obligatoire" sont nécessaires pour que le workflow fonctionne
- Les secrets "Recommandé" améliorent le workflow mais ne sont pas bloquants
- Les secrets "Optionnel" ajoutent des fonctionnalités supplémentaires

---
Dernière mise à jour : $(date +%Y-%m-%d)
