#!/bin/bash

# Script pour créer automatiquement une Pull Request
# Nécessite GitHub CLI (gh) installé et authentifié

echo "🔄 Création automatique de la Pull Request..."

# Vérifier si gh est installé
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI n'est pas installé. Installation en cours..."
    # Tentative d'installation selon l'OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh -y
    else
        echo "❌ Veuillez installer GitHub CLI manuellement: https://cli.github.com/"
        echo "   Puis créez la PR manuellement sur: https://github.com/Quentinm81/focus_wheel/pull/new/ci-prod-robustesse"
        exit 0
    fi
fi

# Créer la Pull Request
PR_TITLE="🚀 CI/CD Production Robustesse - Workflow complet avec Stripe et documentation"
PR_BODY=$(cat << 'EOF'
## 📋 Description

Cette Pull Request implémente un workflow CI/CD complet pour la production avec :

### ✅ Workflow CI/CD (`ci-prod-robustesse.yml`)
- **Flutter CI** : Tests, analyse de code, build APK/AAB, couverture
- **Backend CI** : Tests Node.js, intégration Stripe, webhooks
- **Documentation** : Audit et génération automatique
- **Déploiement** : Automatisation vers production
- **Rapports** : Génération de rapports de synthèse

### 🖥️ Backend serveur
- **API Express.js** avec sécurité (Helmet, CORS, rate limiting)
- **Intégration Stripe** complète (subscriptions, webhooks)
- **Tests unitaires** avec Jest et Supertest
- **Documentation API** détaillée

### 📚 Documentation
- **Guide d'onboarding** complet en français
- **README backend** avec tous les endpoints
- **Scripts de déploiement** automatisés
- **Documentation d'architecture**

### 🔒 Sécurité
- Variables d'environnement sécurisées
- Validation des webhooks Stripe
- Headers de sécurité HTTP
- Rate limiting configuré

## 🧪 Tests effectués
- [ ] Tests Flutter passants
- [ ] Tests backend passants  
- [ ] Build APK réussi
- [ ] Documentation générée

## 📝 Checklist avant merge
- [ ] Configurer les secrets GitHub Actions
- [ ] Vérifier les permissions du workflow
- [ ] Tester localement le serveur backend
- [ ] Valider la documentation d'onboarding

## 🔗 Liens utiles
- [Documentation Stripe](https://stripe.com/docs)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Guide d'onboarding](/docs/onboarding.md)
EOF
)

# Vérifier l'authentification GitHub CLI
if ! gh auth status &> /dev/null; then
    echo "⚠️  GitHub CLI n'est pas authentifié."
    echo "   Exécutez: gh auth login"
    echo "   Puis créez la PR manuellement sur: https://github.com/Quentinm81/focus_wheel/pull/new/ci-prod-robustesse"
    exit 0
fi

# Créer la PR
echo "📝 Création de la Pull Request..."
PR_URL=$(gh pr create \
    --title "$PR_TITLE" \
    --body "$PR_BODY" \
    --base main \
    --head ci-prod-robustesse \
    --assignee @me \
    2>&1)

if [ $? -eq 0 ]; then
    echo "✅ Pull Request créée avec succès !"
    echo "🔗 URL: $PR_URL"
    
    # Ajouter des labels si possible
    gh pr edit --add-label "enhancement,ci/cd,documentation" 2>/dev/null || true
else
    echo "⚠️  Impossible de créer la PR automatiquement."
    echo "   Créez-la manuellement sur: https://github.com/Quentinm81/focus_wheel/pull/new/ci-prod-robustesse"
fi