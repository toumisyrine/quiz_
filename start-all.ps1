# Script de démarrage complet du projet LearnHub
Write-Host "🚀 Démarrage du projet LearnHub avec microservices..." -ForegroundColor Green

# 1. Démarrer Eureka Server (Service Discovery)
Write-Host "🔍 Démarrage Eureka Server (Port 8761)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'backend/eureka-server'; mvn spring-boot:run"

# Attendre que Eureka démarre
Write-Host "⏳ Attente du démarrage d'Eureka (30 secondes)..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

# 2. Démarrer Quiz Feedback Service
Write-Host "📦 Démarrage Quiz Feedback Service (Port 8081)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'backend/quiz-feedback-service'; mvn spring-boot:run"

# 3. Démarrer AI Service
Write-Host "🤖 Démarrage AI Service (Port 8082)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'backend/ai-service'; mvn spring-boot:run"

# Attendre que les services s'enregistrent
Write-Host "⏳ Attente de l'enregistrement des services (20 secondes)..." -ForegroundColor Cyan
Start-Sleep -Seconds 20

# 4. Démarrer API Gateway
Write-Host "🌐 Démarrage API Gateway (Port 8080)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'backend/api-gateway'; mvn spring-boot:run"

# Attendre que la gateway démarre
Write-Host "⏳ Attente du démarrage de la Gateway (15 secondes)..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

# 5. Démarrer Frontend Angular
Write-Host "🎨 Démarrage Frontend Angular (Port 4200)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm start"

Write-Host ""
Write-Host "✅ Tous les services sont en cours de démarrage!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 URLs d'accès:" -ForegroundColor White
Write-Host "📱 Frontend: http://localhost:4200" -ForegroundColor Cyan
Write-Host "🎮 Kids Zone: http://localhost:4200/kids" -ForegroundColor Cyan
Write-Host "⚙️  Admin: http://localhost:4200/dashboard" -ForegroundColor Cyan
Write-Host "🔍 Eureka Dashboard: http://localhost:8761" -ForegroundColor Cyan
Write-Host "🌐 API Gateway: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  Attendre 2-3 minutes pour que tous les services soient complètement opérationnels" -ForegroundColor Yellow