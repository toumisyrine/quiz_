# 🎓 Learnify - Plateforme d'apprentissage avec IA

Plateforme e-learning moderne avec microservices et intelligence artificielle intégrée.

## 🚀 Démarrage Rapide

### Prérequis
- ✅ Java 17+
- ✅ Maven 3.9+
- ✅ Node.js 18+
- ✅ Angular CLI 19
- ✅ MySQL (via XAMPP)

### Installation

1. **Cloner le projet**
```bash
git clone [votre-repo]
cd learnify
```

2. **Démarrer MySQL**
```
Ouvrez XAMPP Control Panel
Démarrez MySQL
```

3. **Importer la base de données**
```bash
# Double-cliquez sur:
import-database-xampp.bat
```

4. **Démarrer tous les services**
```bash
# Double-cliquez sur:
DEMARRAGE_QUOTIDIEN.bat
```

5. **Ouvrir l'application**
```
http://localhost:4200
```

## 📚 Documentation

- **[GUIDE_COMPLET_LEARNIFY.md](GUIDE_COMPLET_LEARNIFY.md)** - Guide complet d'utilisation
- **[TODO_DEMAIN.md](TODO_DEMAIN.md)** - Tâches à faire
- **[SERVICES_AI_FONCTIONNELS.md](SERVICES_AI_FONCTIONNELS.md)** - État des services IA
- **[LIENS_RAPIDES.html](LIENS_RAPIDES.html)** - Accès rapides (ouvrir dans navigateur)

## 🎯 Fonctionnalités

### ✅ Implémenté
- 📋 Gestion complète des quiz (CRUD)
- ⭐ Système de feedback
- 🤖 **LearnBot** - Chatbot IA (widget flottant)
- ✨ **Générateur de Quiz IA** - Création automatique de quiz
- 💡 **Feedback IA Personnalisé** - Analyse intelligente des performances
- 📊 Dashboard administrateur
- 🔄 Architecture microservices
- 🌐 API Gateway
- 🔍 Service Discovery (Eureka)

### 🚧 En cours / À faire
- 🔒 Authentification JWT
- 📊 Statistiques avancées
- 🔔 Notifications temps réel
- 📱 Responsive design optimisé
- 🧪 Tests automatisés

## 🏗️ Architecture

```
┌─────────────────┐
│  Angular App    │
│  (Port 4200)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  API Gateway    │
│  (Port 8080)    │
└────────┬────────┘
         │
    ┌────┴────┬──────────────┬──────────────┐
    ▼         ▼              ▼              ▼
┌────────┐ ┌────────┐  ┌──────────┐  ┌──────────┐
│ Quiz   │ │   AI   │  │  Eureka  │  │  MySQL   │
│Service │ │Service │  │  Server  │  │   DB     │
│ 8081   │ │ 8082   │  │   8761   │  │  3306    │
└────────┘ └────────┘  └──────────┘  └──────────┘
```

## 🛠️ Technologies

### Backend
- Spring Boot 3.2.0
- Spring Cloud (Eureka, Gateway)
- MySQL
- Lombok
- Maven

### Frontend
- Angular 19
- TypeScript
- Bootstrap 5
- RxJS
- SCSS

### IA
- OpenAI API (GPT-3.5-turbo)
- Mode fallback sans API

## 📂 Structure du Projet

```
learnify/
├── backend/
│   ├── eureka-server/          # Service Discovery
│   ├── api-gateway/            # API Gateway
│   ├── quiz-feedback-service/  # Gestion Quiz/Feedback
│   └── ai-service/             # Services IA
│
├── src/app/
│   ├── admin/                  # Dashboard Admin
│   ├── pages/                  # Pages publiques
│   ├── quiz-feedback/          # Module Quiz/Feedback
│   └── ai/                     # Module IA
│
├── DEMARRAGE_QUOTIDIEN.bat     # Script de démarrage
├── GUIDE_COMPLET_LEARNIFY.md   # Documentation complète
└── README.md                   # Ce fichier
```

## 🎮 Utilisation

### LearnBot (Chatbot IA)
1. Visible sur toutes les pages (widget en bas à droite)
2. Cliquez pour ouvrir
3. Posez vos questions
4. Recevez des réponses instantanées

### Générateur de Quiz IA
1. Allez sur: http://localhost:4200/ai/quiz-generator
2. Entrez un sujet (ex: "JavaScript Arrays")
3. Choisissez la difficulté et le nombre de questions
4. Générez et sauvegardez

### Passer un Quiz
1. Allez sur: http://localhost:4200/quiz
2. Sélectionnez un quiz
3. Répondez aux questions
4. Soumettez
5. Recevez un feedback IA personnalisé

## 🔧 Configuration

### OpenAI (Optionnel)
Pour activer l'IA complète:

1. Obtenez une clé API: https://platform.openai.com/api-keys
2. Éditez: `backend/ai-service/src/main/resources/application.yml`
3. Remplacez `your-api-key-here` par votre clé
4. Redémarrez ai-service

Sans clé API, le système fonctionne en mode fallback avec des réponses basiques.

### Base de données
```yaml
Host: localhost
Port: 3306
Database: learnify_db
Username: root
Password: (vide)
```

## 🐛 Dépannage

### Services ne démarrent pas
```bash
# Vérifier Java et Maven
java -version
mvn -version

# Nettoyer et recompiler
cd backend/[service]
mvn clean install
```

### Angular ne compile pas
```bash
# Nettoyer le cache
Remove-Item -Recurse -Force .angular
npm install
ng serve
```

### MySQL ne se connecte pas
```
1. Ouvrez XAMPP Control Panel
2. Vérifiez que MySQL est vert (Running)
3. Port 3306 doit être libre
```

## 📊 Ports

| Service | Port | URL |
|---------|------|-----|
| Angular | 4200 | http://localhost:4200 |
| API Gateway | 8080 | http://localhost:8080 |
| Quiz Service | 8081 | http://localhost:8081 |
| AI Service | 8082 | http://localhost:8082 |
| Eureka | 8761 | http://localhost:8761 |
| MySQL | 3306 | localhost:3306 |

## 🧪 Tests

```bash
# Backend
cd backend/[service]
mvn test

# Frontend
ng test
```

## 📝 Licence

Ce projet est développé dans un cadre éducatif.

## 👥 Contributeurs

- Votre équipe

## 📞 Support

Pour toute question, consultez:
- [GUIDE_COMPLET_LEARNIFY.md](GUIDE_COMPLET_LEARNIFY.md)
- [TODO_DEMAIN.md](TODO_DEMAIN.md)

---

**Version**: 1.0.0 avec IA  
**Dernière mise à jour**: 25 février 2026  
**Statut**: ✅ Fonctionnel en mode fallback

🚀 **Bon développement!**
