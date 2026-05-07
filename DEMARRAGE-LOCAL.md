# 🚀 Guide de Démarrage Local des Services

## ⚠️ IMPORTANT : Ordre de Démarrage

Les services doivent être démarrés **dans cet ordre précis** :

1. **Eureka Server** (8761) - Attendre 30 secondes
2. **API Gateway** (8888) - Attendre 20 secondes  
3. **AI Service** (8090) - Attendre 15 secondes
4. **Quiz-Feedback Service** (8089) - Attendre 15 secondes

---

## 📋 Prérequis

- ✅ Java 17 installé
- ✅ Maven installé
- ✅ MySQL installé et démarré (pour quiz-feedback-service)
- ✅ Base de données `learnify_db` créée dans MySQL

### Créer la base de données MySQL

```sql
CREATE DATABASE IF NOT EXISTS learnify_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## 🎯 Méthode 1 : Script Automatique (Recommandé)

```powershell
cd FrontOffice-main
.\start-all-local.ps1
```

Ce script ouvre 4 fenêtres PowerShell et démarre tous les services dans le bon ordre.

---

## 🔧 Méthode 2 : Démarrage Manuel

### Terminal 1 - Eureka Server

```powershell
cd FrontOffice-main/backend/eureka-server
mvn spring-boot:run
```

**Attendre ce message :**
```
Started EurekaServerApplication in X seconds
```

**Vérifier :** http://localhost:8761

---

### Terminal 2 - API Gateway

```powershell
cd FrontOffice-main/backend/api-gateway
mvn spring-boot:run
```

**Attendre ce message :**
```
Started ApiGatewayApplication in X seconds
```

**Vérifier dans Eureka :** Le service `API-GATEWAY` doit apparaître

---

### Terminal 3 - AI Service

```powershell
cd FrontOffice-main/backend/ai-service
mvn spring-boot:run
```

**Attendre ce message :**
```
Started AiServiceApplication in X seconds
```

**Vérifier dans Eureka :** Le service `AI-SERVICE` doit apparaître

---

### Terminal 4 - Quiz-Feedback Service

```powershell
cd FrontOffice-main/backend/quiz-feedback-service
mvn spring-boot:run
```

**Attendre ce message :**
```
Started QuizFeedbackServiceApplication in X seconds
```

**Vérifier dans Eureka :** Le service `QUIZ-FEEDBACK-SERVICE` doit apparaître

---

## ✅ Vérification que tout fonctionne

### 1. Vérifier Eureka Dashboard

Ouvrir : http://localhost:8761

Vous devriez voir **3 services enregistrés** :
- `API-GATEWAY`
- `AI-SERVICE`
- `QUIZ-FEEDBACK-SERVICE`

### 2. Tester les services via API Gateway

```powershell
# Tester AI Service
curl http://localhost:8888/api/ai/actuator/health

# Tester Quiz-Feedback Service
curl http://localhost:8888/api/quizzes
```

### 3. Tester les services directement

```powershell
# Eureka Server
curl http://localhost:8761/actuator/health

# API Gateway
curl http://localhost:8888/actuator/health

# AI Service
curl http://localhost:8090/actuator/health

# Quiz-Feedback Service
curl http://localhost:8089/actuator/health
```

---

## 🛑 Arrêter les Services

Dans chaque terminal, appuyer sur **Ctrl+C**

Ou fermer les fenêtres PowerShell.

---

## 🐛 Dépannage

### Problème : "Cannot execute request on any known server"

**Cause :** Eureka Server n'est pas démarré ou pas accessible.

**Solution :**
1. Vérifier qu'Eureka Server est démarré : http://localhost:8761
2. Attendre 30 secondes après le démarrage d'Eureka
3. Redémarrer le service qui a l'erreur

---

### Problème : "Port already in use"

**Cause :** Un service utilise déjà le port.

**Solution :**

```powershell
# Trouver le processus qui utilise le port
netstat -ano | findstr "8761"
netstat -ano | findstr "8888"
netstat -ano | findstr "8089"
netstat -ano | findstr "8090"

# Tuer le processus (remplacer PID par le numéro trouvé)
taskkill /PID <PID> /F
```

---

### Problème : AI Service - "Failed to configure a DataSource"

**Cause :** L'ancienne configuration essayait de se connecter à une base de données.

**Solution :** Ce problème est résolu. Si vous l'avez encore :

```powershell
cd FrontOffice-main/backend/ai-service
mvn clean package -DskipTests
mvn spring-boot:run
```

---

### Problème : Quiz-Feedback Service - "Access denied for user 'root'"

**Cause :** Mauvais mot de passe MySQL.

**Solution :** Modifier `backend/quiz-feedback-service/src/main/resources/application.yml` :

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/learnify_db
    username: root
    password: "VOTRE_MOT_DE_PASSE"  # Mettre votre mot de passe MySQL
```

---

### Problème : Service ne s'enregistre pas dans Eureka

**Cause :** Eureka URL incorrecte ou Eureka pas démarré.

**Solution :**
1. Vérifier qu'Eureka est accessible : http://localhost:8761
2. Vérifier les logs du service pour voir les erreurs de connexion
3. Attendre 30-60 secondes (l'enregistrement peut prendre du temps)
4. Redémarrer le service

---

## 📊 Ports Utilisés

| Service | Port | URL |
|---------|------|-----|
| Eureka Server | 8761 | http://localhost:8761 |
| API Gateway | 8888 | http://localhost:8888 |
| AI Service | 8090 | http://localhost:8090 |
| Quiz-Feedback Service | 8089 | http://localhost:8089 |
| Frontend (optionnel) | 4200 | http://localhost:4200 |
| MySQL | 3306 | localhost:3306 |

---

## 🔄 Redémarrer un Service

Si un service plante ou ne fonctionne pas correctement :

1. **Arrêter le service** : Ctrl+C dans son terminal
2. **Attendre 5 secondes**
3. **Redémarrer** : `mvn spring-boot:run`
4. **Vérifier dans Eureka** après 30 secondes

---

## 💡 Conseils

### Pour un démarrage plus rapide

Compiler tous les services une fois :

```powershell
cd FrontOffice-main
.\compile-all.ps1
```

Ensuite, les démarrages suivants seront plus rapides.

### Pour voir les logs en temps réel

Les logs s'affichent automatiquement dans chaque terminal.

Pour filtrer les logs importants :

```powershell
# Voir seulement les erreurs
mvn spring-boot:run | Select-String "ERROR"

# Voir seulement les infos de démarrage
mvn spring-boot:run | Select-String "Started"
```

### Pour tester rapidement

Créer un fichier `test-services.ps1` :

```powershell
Write-Host "Testing Eureka..." -ForegroundColor Yellow
curl http://localhost:8761/actuator/health

Write-Host "`nTesting API Gateway..." -ForegroundColor Yellow
curl http://localhost:8888/actuator/health

Write-Host "`nTesting AI Service..." -ForegroundColor Yellow
curl http://localhost:8090/actuator/health

Write-Host "`nTesting Quiz-Feedback Service..." -ForegroundColor Yellow
curl http://localhost:8089/actuator/health
```

---

## 🎯 Workflow Recommandé

### Développement quotidien

1. **Démarrer les services** : `.\start-all-local.ps1`
2. **Vérifier Eureka** : http://localhost:8761
3. **Développer votre code**
4. **Tester via API Gateway** : http://localhost:8888
5. **Arrêter les services** : Ctrl+C dans chaque terminal

### Après modification du code

```powershell
# Arrêter le service modifié (Ctrl+C)
# Recompiler
cd backend/<service-name>
mvn clean package -DskipTests

# Redémarrer
mvn spring-boot:run
```

---

**Dernière mise à jour :** 7 Mai 2026
