#!/bin/bash

# Script de déploiement automatisé pour Focus Wheel
# Usage: ./scripts/deploy.sh [production|staging]

set -e

ENVIRONMENT=${1:-staging}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🚀 Déploiement Focus Wheel - Environnement: $ENVIRONMENT"
echo "⏰ Timestamp: $TIMESTAMP"

# Vérification de l'environnement
if [[ "$ENVIRONMENT" != "production" && "$ENVIRONMENT" != "staging" ]]; then
    echo "❌ Environnement invalide. Utilisez 'production' ou 'staging'"
    exit 1
fi

# Vérification des prérequis
echo "🔍 Vérification des prérequis..."

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé"
    exit 1
fi

# Vérification de la branche
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$ENVIRONMENT" == "production" && "$CURRENT_BRANCH" != "main" ]]; then
    echo "❌ Le déploiement en production doit se faire depuis la branche 'main'"
    echo "   Branche actuelle: $CURRENT_BRANCH"
    exit 1
fi

# Tests avant déploiement
echo "🧪 Exécution des tests..."

# Tests Flutter
echo "📱 Tests Flutter..."
flutter test --coverage || {
    echo "❌ Les tests Flutter ont échoué"
    exit 1
}

# Tests Backend
echo "🖥️  Tests Backend..."
cd server
npm test || {
    echo "❌ Les tests backend ont échoué"
    exit 1
}
cd ..

# Build de l'application
echo "🔨 Build de l'application..."

# Build Flutter
if [[ "$ENVIRONMENT" == "production" ]]; then
    echo "📱 Build Flutter Release..."
    flutter build apk --release --split-per-abi
    flutter build appbundle --release
else
    echo "📱 Build Flutter Debug..."
    flutter build apk --debug
fi

# Préparation du backend
echo "🖥️  Préparation du backend..."
cd server
npm ci --only=production
cd ..

# Création du tag Git
if [[ "$ENVIRONMENT" == "production" ]]; then
    TAG="v$TIMESTAMP"
    echo "🏷️  Création du tag: $TAG"
    git tag -a "$TAG" -m "Déploiement production $TIMESTAMP"
    git push origin "$TAG"
fi

# Déploiement
echo "🚀 Déploiement en cours..."

if [[ "$ENVIRONMENT" == "production" ]]; then
    # Déploiement production
    echo "🌍 Déploiement en production..."
    
    # Backend - Render.com ou autre
    # Exemple avec Render CLI (à adapter selon votre hébergeur)
    # render deploy --service=focus-wheel-api
    
    # Upload APK vers Google Play
    # fastlane deploy_production
    
    # Notification Slack
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"🚀 Déploiement production Focus Wheel terminé - Tag: $TAG\"}" \
        "$SLACK_WEBHOOK_URL" 2>/dev/null || true
else
    # Déploiement staging
    echo "🧪 Déploiement en staging..."
    
    # Backend staging
    # render deploy --service=focus-wheel-api-staging
    
    # Upload APK vers distribution interne
    # fastlane deploy_staging
fi

# Rapport de déploiement
echo "📊 Génération du rapport..."
cat > "deployment-report-$TIMESTAMP.md" << EOF
# Rapport de déploiement Focus Wheel

**Date:** $(date)
**Environnement:** $ENVIRONMENT
**Branche:** $CURRENT_BRANCH
**Commit:** $(git rev-parse HEAD)
**Tag:** ${TAG:-N/A}

## Artefacts générés

- APK: build/app/outputs/flutter-apk/
- Bundle: build/app/outputs/bundle/release/
- Coverage: coverage/

## Checklist post-déploiement

- [ ] Vérifier l'endpoint /health du backend
- [ ] Tester la connexion Stripe
- [ ] Vérifier les logs de production
- [ ] Tester l'application sur device réel
- [ ] Monitorer les métriques

## Notes

Déploiement automatisé réussi.
EOF

echo "✅ Déploiement terminé avec succès!"
echo "📄 Rapport disponible: deployment-report-$TIMESTAMP.md"
echo ""
echo "🔍 Actions post-déploiement:"
echo "   1. Vérifier l'endpoint: https://api.focuswheel.com/health"
echo "   2. Tester les webhooks Stripe"
echo "   3. Monitorer les logs"
echo "   4. Tester sur device réel"