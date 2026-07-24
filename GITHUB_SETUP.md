# 🚀 Guide de déploiement sur GitHub

## Objective
Pousser le projet sur GitHub et tester le pipeline CI/CD en conditions réelles.

---

## Step 1️⃣ : Initialiser le repository Git

```bash
cd C:\Projects\Livraison_continue\livraison-continue-workshop-organizer

# Initialiser git
git init

# Ajouter tous les fichiers
git add .

# Faire le commit initial
git commit -m "feat: initial unified CI/CD project

- Add Angular 20.3.7 frontend with Dockerfile and docker-compose
- Add Spring Boot 3.2.4 backend with Dockerfile and docker-compose
- Add unified test script for both applications
- Add GitHub Actions CI/CD pipeline with 3 jobs
- Add Semantic Release configuration for automatic versioning
- Add comprehensive documentation"

# Renommer la branche en main
git branch -M main
```

---

## Step 2️⃣ : Créer un repository sur GitHub

1. Aller à https://github.com/new
2. Remplir les informations :
   - **Repository name** : `livraison-continue-workshop-organizer`
   - **Description** : `CI/CD Pipeline avec Docker et GitHub Actions - Workshop Organizer`
   - **Public** : Oui (pour tester les GitHub Actions)
   - **Initialize with** : Non (le code est déjà local)
3. Cliquer "Create repository"

---

## Step 3️⃣ : Pousser le code vers GitHub

```bash
# Ajouter l'URL du repository
git remote add origin https://github.com/YOUR_USERNAME/livraison-continue-workshop-organizer.git

# Pousser vers main
git push -u origin main
```

⚠️ **Remplacez** `YOUR_USERNAME` par votre username GitHub

---

## Step 4️⃣ : Vérifier le pipeline en action

### A. Accéder à GitHub Actions

1. Aller à https://github.com/YOUR_USERNAME/livraison-continue-workshop-organizer/actions
2. Vous devriez voir un workflow "CI Pipeline" en cours d'exécution

### B. Vérifier les 3 jobs

Le pipeline exécute 3 jobs séquentiellement :

```
🔵 test          ← Tests Angular + Spring Boot
   ↓
🟢 build         ← Build Docker + Push GHCR
   ↓
🟣 release       ← Semantic Release + Versioning
```

**Résultats attendus :**
- ✅ Job test : Tests passent
- ✅ Job build : Images Docker construites et poussées
- ✅ Job release : Release créée (si commits conventionnels)

### C. Voir les rapports de test

1. Cliquer sur le workflow "CI Pipeline"
2. Cliquer sur le job "Run Tests"
3. Chercher "Publish test results"
4. Voir les rapports XML

### D. Voir les images Docker

1. Aller à https://github.com/YOUR_USERNAME/packages
2. Voir les images `backend` et `frontend`
3. Voir les tags : `latest` et SHA du commit

---

## Step 5️⃣ : Tester Semantic Release

### Scenario 1 : Fix (patch release)

```bash
git commit -m "fix: correction d'un bug mineur"
git push origin main
```

**Résultat attendu :**
- Pipeline crée automatiquement `v0.0.1`
- Release GitHub est créée
- Images Docker sont retaguées avec la version

### Scenario 2 : Feature (minor release)

```bash
git commit -m "feat: nouvelle fonctionnalité importante"
git push origin main
```

**Résultat attendu :**
- Pipeline crée automatiquement `v0.1.0`
- Release GitHub est créée
- Images Docker sont retaguées avec la version

### Scenario 3 : Non-release (chore)

```bash
git commit -m "chore: mise à jour des dépendances"
git push origin main
```

**Résultat attendu :**
- Pipeline s'exécute normalement
- Pas de nouvelle release créée
- Images Docker retaguées avec `latest` uniquement

---

## 📊 Résumé du pipeline testé

### Job 1 : Test
- ✅ Checkout du code
- ✅ Setup Node.js 22 + Java 21
- ✅ Cache npm et Gradle
- ✅ Exécution `./scripts/run-tests.sh`
- ✅ Rapport des tests
- ✅ Publication des résultats

### Job 2 : Build
- ✅ Login au GitHub Container Registry
- ✅ Build image backend (Dockerfile multi-stage)
- ✅ Build image frontend (Dockerfile multi-stage)
- ✅ Push vers GHCR avec tags (SHA + latest)
- ✅ Résumé des images construites

### Job 3 : Release
- ✅ Analyse des commits conventionnels
- ✅ Génération de la version (semantic)
- ✅ Création de la release GitHub
- ✅ Génération du CHANGELOG
- ✅ Retag des images Docker avec version
- ✅ Synchronisation des versions dans les fichiers

---

## 🔍 Troubleshooting

### Les tests échouent
- Vérifier les logs du job "Run Tests"
- Vérifier `scripts/run-tests.sh` est exécutable
- Vérifier Node.js 22 et Java 21 sont bien configurés

### Les images ne sont pas poussées
- Vérifier le GITHUB_TOKEN a les bonnes permissions
- Vérifier `.github/workflows/ci.yml` ligne 91-93
- Vérifier GHCR accepte les images publiques

### Semantic Release ne crée pas de release
- Vérifier les commits suivent Conventional Commits
- Vérifier `.releaserc.json` est valide
- Vérifier GITHUB_TOKEN a permission `contents: write`

---

## 📌 Checklist finale

- [ ] Repository créé sur GitHub
- [ ] Code poussé vers main
- [ ] Pipeline exécuté (3 jobs réussis)
- [ ] Images Docker dans GHCR
- [ ] Rapports de test visibles
- [ ] Release créée (après commits conventionnels)
- [ ] Versions synchronisées dans les fichiers

---

## 🎉 Succès !

Si tous les points sont cochés, le pipeline fonctionne parfaitement en conditions réelles ! 🚀

Vous avez maintenant :
✅ Une chaîne de livraison continue complète
✅ Tests automatisés
✅ Build Docker automatisé
✅ Versioning sémantique automatique
✅ Releases GitHub automatisées

Bravo ! 🎉

---

**Date :** Juillet 2026  
**Candidate :** MOHTAJE Mohamed Amine  
**Email :** moha.mohtaje@gmail.com
