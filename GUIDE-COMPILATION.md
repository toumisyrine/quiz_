# 📚 Guide de Compilation et Démarrage du Projet LearnHub

## 🎯 Vue d'ensemble

Ce projet contient :
- **4 services backend** (Spring Boot + Maven)
- **1 frontend** (Angular + npm)

---

## 📦 1. COMPILATION DU PROJET

### Option A : Compiler TOUT automatiquement

```powershell
cd FrontOffice-main
.\compile-all.ps1
```

### Option B : Compiler manuellement

#### Backend (chaque service)

```powershell
cd FrontOffice-main

# Eureka Server
cd backend/eureka-server
mvn clean package -DskipTests
cd ../..

# API Gateway
cd backend/api-gateway
mvn clean package -DskipTests
cd ../..

# AI Service
cd backend/ai-service
mvn clean package -DskipTests
cd ../..

# Quiz-Feedback Service
cd backend/quiz-feedback-service
mvn clean package -DskipTests
cd ../..
```

#### Frontend

```powershell
cd FrontOffice-main

# Installer les dépendances
npm install

# Compiler
npm run build
```

---

## 🚀 2. DÉMARRAGE LOCAL (Développement)

### Option A : Démarrer TOUS les services automatiquement

```powershell
cd FrontOffice-main
.\start-all-local.ps1
```

Cette commande ouvre 4 fenêtres PowerShell (une par service) dans le bon ordre.

### Option B : Démarrer manuellement (dans des terminaux séparés)

**Terminal 1 - Eureka Server:**
```powershell
cd FrontOffice-main/backend/eureka-server
mvn spring-boot:run
```
Attendre que "Started EurekaServerApplication" apparaisse.

**Terminal 2 - API Gateway:**
```powershell
cd FrontOffice-main/backend/api-gateway
mvn spring-boot:run
```
Attendre que "Started ApiGatewayApplication" apparaisse.

**Terminal 3 - AI Service:**
```powershell
cd FrontOffice-main/backend/ai-service
mvn spring-boot:run
```
Attendre que "Started AiServiceApplication" apparaisse.

**Terminal 4 - Quiz-Feedback Service:**
```powershell
cd FrontOffice-main/backend/quiz-feedback-service
mvn spring-boot:run
```
Attendre que "Started QuizFeedbackServiceApplication" apparaisse.

**Terminal 5 - Frontend (optionnel):**
```powershell
cd FrontOffice-main
npm start
```

---

## 🔍 3. VÉRIFICATION DES SERVICES

### URLs des services

| Service | URL | Description |
|---------|-----|-------------|
| **Eureka Dashboard** | http://localhost:8761 | Voir tous les services enregistrés |
| **API Gateway** | http://localhost:8888 | Point d'entrée principal |
| **AI Service** | http://localhost:8090 | Service d'IA (Gemini) |
| **Quiz-Feedback** | http://localhost:8089 | Service Quiz & Feedback |
| **Frontend** | http://localhost:4200 | Application Angular |

### Vérifier que tout fonctionne

1. **Ouvrir Eureka Dashboard:** http://localhost:8761
   - Vous devriez voir 3 services enregistrés : `API-GATEWAY`, `AI-SERVICE`, `QUIZ-FEEDBACK-SERVICE`

2. **Tester l'API Gateway:**
   ```powershell
   curl http://localhost:8888/actuator/health
   ```

3. **Tester AI Service via Gateway:**
   ```powershell
   curl http://localhost:8888/ai-service/actuator/health
   ```

4. **Tester Quiz-Feedback via Gateway:**
   ```powershell
   curl http://localhost:8888/quiz-feedback-service/actuator/health
   ```

---

## 🐳 4. DÉMARRAGE AVEC DOCKER

### Compiler et créer les images Docker

```powershell
cd FrontOffice-main

# Compiler tous les services
.\compile-all.ps1

# Créer les images Docker
docker build -t syrinaaa/eureka-server:latest -f backend/eureka-server/Dockerfile backend/eureka-server
docker build -t syrinaaa/api-gateway:latest -f backend/api-gateway/Dockerfile backend/api-gateway
docker build -t syrinaaa/ai-service:latest -f backend/ai-service/Dockerfile backend/ai-service
docker build -t syrinaaa/quiz-feedback-service:latest -f backend/quiz-feedback-service/Dockerfile backend/quiz-feedback-service
docker build -t syrinaaa/learnhub-frontend:latest -f Dockerfile.frontend .
```

### Démarrer avec Docker Compose

```powershell
cd FrontOffice-main
docker-compose up -d
```

### Arrêter Docker Compose

```powershell
docker-compose down
```

---

## ☸️ 5. DÉPLOIEMENT KUBERNETES (Minikube)

### Prérequis

```powershell
# Démarrer Minikube
minikube start

# Créer le namespace
kubectl create namespace learnhub
```

### Déployer sur Kubernetes

```powershell
cd FrontOffice-main

# Appliquer les manifests
kubectl apply -f k8s-deploy.yaml -n learnhub

# Vérifier les pods
kubectl get pods -n learnhub

# Vérifier les services
kubectl get svc -n learnhub
```

### Accéder aux services

```powershell
# Lister les URLs
minikube service list -n learnhub

# Obtenir les URLs
echo "Eureka: http://$(minikube ip):$(kubectl get svc eureka-service -n learnhub -o jsonpath='{.spec.ports[0].nodePort}')"
echo "API Gateway: http://$(minikube ip):$(kubectl get svc api-gateway-service -n learnhub -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Frontend: http://$(minikube ip):$(kubectl get svc frontend-service -n learnhub -o jsonpath='{.spec.ports[0].nodePort}')"
```

---

## 🔧 6. DÉPANNAGE

### Problème : Service ne démarre pas

**Solution 1 - Vérifier les logs:**
```powershell
# Pour Maven
mvn spring-boot:run

# Pour Docker
docker logs <container-name>

# Pour Kubernetes
kubectl logs -n learnhub <pod-name>
```

**Solution 2 - Vérifier les ports:**
```powershell
# Windows
netstat -ano | findstr "8761"
netstat -ano | findstr "8888"
netstat -ano | findstr "8089"
netstat -ano | findstr "8090"
```

### Problème : AI Service - DataSource error

**Solution:** Le fichier `application.yml` et `AiServiceApplication.java` ont été mis à jour pour désactiver JPA. Recompiler :
```powershell
cd backend/ai-service
mvn clean package -DskipTests
```

### Problème : Frontend ne compile pas

**Solution:**
```powershell
cd FrontOffice-main

# Nettoyer le cache
rm -r -fo .angular/cache
rm -r -fo node_modules
rm package-lock.json

# Réinstaller
npm install
npm run build
```

### Problème : Eureka ne voit pas les services

**Solution:**
1. Vérifier que Eureka est démarré en premier
2. Attendre 30-60 secondes pour l'enregistrement
3. Vérifier les logs des services pour les erreurs de connexion

---

## 📝 7. COMMANDES UTILES

### Maven

```powershell
# Compiler sans tests
mvn clean package -DskipTests

# Compiler avec tests
mvn clean package

# Démarrer le service
mvn spring-boot:run

# Nettoyer
mvn clean
```

### npm

```powershell
# Installer les dépendances
npm install

# Démarrer en mode dev
npm start

# Compiler pour production
npm run build

# Nettoyer
rm -r -fo node_modules .angular/cache
```

### Docker

```powershell
# Lister les images
docker images

# Lister les conteneurs
docker ps -a

# Voir les logs
docker logs <container-name>

# Arrêter tous les conteneurs
docker stop $(docker ps -aq)

# Supprimer tous les conteneurs
docker rm $(docker ps -aq)
```

### Kubernetes

```powershell
# Voir tous les pods
kubectl get pods -n learnhub

# Voir les logs d'un pod
kubectl logs -n learnhub <pod-name>

# Décrire un pod
kubectl describe pod -n learnhub <pod-name>

# Supprimer tous les déploiements
kubectl delete -f k8s-deploy.yaml -n learnhub

# Redémarrer un déploiement
kubectl rollout restart deployment <deployment-name> -n learnhub
```

---

## 🎓 8. ARCHITECTURE DU PROJET

```
┌─────────────────┐
│   Frontend      │
│  (Angular)      │
│   Port 4200     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  API Gateway    │
│   Port 8888     │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌──────────────┐
│AI Service│ │Quiz-Feedback │
│Port 8090│ │  Port 8089   │
└─────────┘ └──────────────┘
    │              │
    └──────┬───────┘
           ▼
    ┌─────────────┐
    │Eureka Server│
    │  Port 8761  │
    └─────────────┘
```

---

## 📞 Support

Pour toute question ou problème, vérifiez :
1. Les logs des services
2. Le dashboard Eureka (http://localhost:8761)
3. Les ports ne sont pas déjà utilisés
4. Les services sont démarrés dans le bon ordre

---

**Dernière mise à jour:** 7 Mai 2026
