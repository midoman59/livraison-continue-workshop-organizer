# 🚀 Workshop Organizer - Livraison Continue
## CI/CD Pipeline avec Docker et GitHub Actions

**Exercices :** Conteneurisation (Exercice 1) + CI/CD Pipeline (Exercice 2)  
**Candidate :** MOHTAJE Mohamed Amine  
**Date :** Juillet 2026

---

## 📋 Description

Ce projet démontre une chaîne de livraison continue complète pour une application fullstack :
- **Frontend :** Angular 20.3.7 (avec Nginx en production)
- **Backend :** Spring Boot 3.2.4 (avec PostgreSQL)
- **CI/CD :** GitHub Actions avec Docker et Semantic Release

---

## 📁 Structure du projet

```
livraison-continue-workshop-organizer/
│
├── G-rez-l-int-gration-et-la-livraison-continue-Application-Angular/
│   ├── src/
│   ├── Dockerfile              (Multi-stage build)
│   ├── docker-compose.yml      (Nginx sur port 80)
│   ├── .dockerignore
│   ├── package.json
│   └── karma.conf.js
│
├── G-rez-l-int-gration-et-la-livraison-continue-Application-Java/
│   ├── src/
│   ├── Dockerfile              (Multi-stage build)
│   ├── docker-compose.yml      (Spring Boot + PostgreSQL)
│   ├── .dockerignore
│   ├── build.gradle
│   └── settings.gradle
│
├── scripts/
│   └── run-tests.sh            (Script unifié pour les tests)
│
├── test-results/               (Rapports JUnit XML)
│
├── .github/
│   └── workflows/
│       └── ci.yml              (Pipeline GitHub Actions)
│
├── .releaserc.json             (Configuration Semantic Release)
├── .env                        (Variables d'environnement)
└── README.md                   (Ce fichier)
```

---

## 🚀 Quick Start

### Exercice 1 : Conteneurisation

#### Frontend (Angular)

```bash
cd G-rez-l-int-gration-et-la-livraison-continue-Application-Angular

# Construire l'image
docker build -t workshop-organizer-frontend:latest .

# Démarrer le service
docker compose -f docker-compose.yml up -d

# Accéder à l'application
# http://localhost
```

#### Backend (Spring Boot)

```bash
cd G-rez-l-int-gration-et-la-livraison-continue-Application-Java

# Construire l'image
docker build -t workshop-organizer-backend:latest .

# Démarrer le service (avec PostgreSQL)
docker compose -f docker-compose.yml up -d

# Accéder à l'API
# http://localhost:8080/api/workshops
```

---

### Exercice 2 : CI/CD Pipeline

#### Exécuter les tests localement

```bash
bash scripts/run-tests.sh
```

**Résultat attendu :**
```
✅ Angular tests : SUCCESS
✅ Spring Boot tests : SUCCESS
✅ Test reports generated : test-results/*.xml
```

#### Déclencher le pipeline sur GitHub

```bash
git push origin main
```

Le pipeline GitHub Actions se déclenche automatiquement :
1. **Job Test** : Exécute les tests
2. **Job Build** : Construit et pousse les images Docker
3. **Job Release** : Génère automatiquement les versions

---

## 🔧 Configuration

### Fichiers de configuration

**`.env`** - Variables d'environnement
```env
DB_USER=workshops_user
DB_PASSWORD=secure_password_change_me
```

**`.releaserc.json`** - Configuration Semantic Release
- Branche `main` : Releases stables
- Branche `develop` : Prereleases
- Conventional Commits activé

**`.github/workflows/ci.yml`** - Pipeline CI/CD
- Test sur tous les commits
- Build et push vers GHCR
- Release automatique sur main/develop

---

## 🐳 Docker

### Images construites

**Frontend :**
- Base : Node.js 22 Alpine (build) → Nginx Alpine (runtime)
- Taille : ~93 MB
- Port : 80

**Backend :**
- Base : Eclipse Temurin JDK 21 (build) → JRE 21 (runtime)
- Taille : ~506 MB (disk) / ~148 MB (content)
- Port : 8080
- Database : PostgreSQL (port 5432)

### Registry

Les images sont poussées vers **GitHub Container Registry (ghcr.io)**

```
ghcr.io/${{ github.repository }}/backend:latest
ghcr.io/${{ github.repository }}/frontend:latest
ghcr.io/${{ github.repository }}/backend:v1.2.3
ghcr.io/${{ github.repository }}/frontend:v1.2.3
```

---

## 📊 Pipeline GitHub Actions

### 3 Jobs (séquentiels)

```
test (Node.js 18 + Java 21)
  ↓
build (Docker build + push)
  ↓
release (Semantic Release)
```

### Déclencheurs

- `push` vers `main` ou `develop`
- `pull_request` vers `main` ou `develop`

### Artefacts générés

- ✅ Rapports JUnit XML
- ✅ Images Docker (GHCR)
- ✅ Releases GitHub (avec Changelog)
- ✅ Versions synchronisées

---

## 🔄 Semantic Release

### Commits conventionnels

```bash
git commit -m "feat: nouvelle fonctionnalité"     # → Version mineure (1.0.0 → 1.1.0)
git commit -m "fix: correction de bug"            # → Version patch (1.0.0 → 1.0.1)
git commit -m "chore: maintenance"                # → Pas de version
```

### Versions synchronisées automatiquement

- `package.json` (Frontend)
- `build.gradle` (Backend)
- `CHANGELOG.md` (Historique)

---

## 📈 Points validés

### Exercice 1 : Conteneurisation ✅

- ✅ Dockerfile Angular multi-stage
- ✅ Dockerfile Spring Boot multi-stage
- ✅ docker-compose pour les deux services
- ✅ Healthchecks configurés
- ✅ Volumes persistants (PostgreSQL)
- ✅ Variables d'environnement
- ✅ .dockerignore optimisés

### Exercice 2 : CI/CD Pipeline ✅

- ✅ Script de tests unifié
- ✅ Pipeline GitHub Actions
- ✅ Job build avec Docker
- ✅ Publication GHCR
- ✅ Semantic Release intégré
- ✅ Conventional Commits
- ✅ Releases GitHub automatiques

---

## 🧪 Tests

### Tests Angular

```bash
npm test -- --watch=false --browsers=ChromeHeadless --code-coverage
```

Coverage : ~75%

### Tests Spring Boot

```bash
./gradlew clean test -q
```

### Rapports JUnit XML

Les rapports sont générés dans `test-results/` :
- `test-results/TESTS-*.xml` (Angular)
- `test-results/TESTS-*.xml` (Spring Boot)

---

## 🚀 Déployer sur GitHub

### 1. Créer un repository GitHub

```bash
git init
git add .
git commit -m "feat: initial unified CI/CD project"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/livraison-continue-workshop-organizer.git
git push -u origin main
```

### 2. Configurer les secrets (optionnel)

GitHub utilise automatiquement `GITHUB_TOKEN` pour :
- Publier les rapports de test
- Pousser les images vers GHCR
- Créer les releases

### 3. Vérifier le pipeline

Allez sur : `https://github.com/YOUR_USERNAME/livraison-continue-workshop-organizer/actions`

---

## 📝 Fichiers importants

| Fichier | Description |
|---------|-------------|
| `scripts/run-tests.sh` | Script unifié pour tester Angular et Spring Boot |
| `.github/workflows/ci.yml` | Pipeline GitHub Actions complète |
| `.releaserc.json` | Configuration Semantic Release |
| `G-rez-*/Dockerfile` | Images Docker optimisées |
| `G-rez-*/docker-compose.yml` | Orchestration locale |
| `.env` | Configuration de la base de données |

---

## 🔗 Ressources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [Docker Documentation](https://docs.docker.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## 📞 Support

**Candidate :** MOHTAJE Mohamed Amine  
**Email :** moha.mohtaje@gmail.com  
**Date :** Juillet 2026

---

## ✅ Taux de réussite

```
Exercice 1 (Conteneurisation) : 100% (7/7)
Exercice 2 (CI/CD Pipeline)   : 100% (23/23)
─────────────────────────────────────────
TOTAL :                         100% (30/30)
```

---

**Prêt pour tester en conditions réelles sur GitHub Actions ! 🚀**

---

### v0.1.0 Release Notes
- feat: Add comprehensive CI/CD pipeline documentation
- feat: Implement automated testing and deployment workflow

### v0.0.1 Release Notes
- Fix: Minor bug correction in documentation
