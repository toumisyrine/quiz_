# Script pour démarrer tous les microservices LearnHub
# Utilisation: .\start-all-services.ps1

Write-Host "🚀 Démarrage de tous les services LearnHub..." -ForegroundColor Green

# Vérifier les variables d'environnement
if (-not $env:GEMINI_API_KEY) {
    Write-Host "⚠️  GEMINI_API_KEY n'est pas définie!" -ForegroundColor Yellow
    Write-Host "Définissez-la avec: `$env:GEMINI_API_KEY='votre_cle'" -ForegroundColor Yellow
}

# Fonction pour démarrer un service dans une nouvelle fenêtre
function Start-Service {
    param(
        [string]$ServiceName,
        [string]$ServicePath,
        [int]$Port
    )
    
    Write-Host "📦 Démarrage de $ServiceName sur le port $Port..." -ForegroundColor Cyan
    
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$ServicePath'; Write-Host '🔧 $ServiceName - Port $Port' -ForegroundColor Green; mvn spring-boot:run"
    
    Start-Sleep -Seconds 2
}

$BackendPath = "$PSScriptRoot\backend"

# 1. Eureka Server (DOIT démarrer en premier)
Write-Host "`n1️⃣  Démarrage d'Eureka Server..." -ForegroundColor Magenta
Start-Service -ServiceName "Eureka Server" -ServicePath "$BackendPath\eureka-server" -Port 8761
Write-Host "⏳ Attente de 30 secondes pour qu'Eureka démarre..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 2. API Gateway
Write-Host "`n2️⃣  Démarrage de l'API Gateway..." -ForegroundColor Magenta
Start-Service -ServiceName "API Gateway" -ServicePath "$BackendPath\api-gateway" -Port 8080
Start-Sleep -Seconds 10

# 3. Services métier
Write-Host "`n3️⃣  Démarrage des services métier..." -ForegroundColor Magenta

Start-Service -ServiceName "User Service" -ServicePath "$BackendPath\user-service" -Port 8087
Start-Sleep -Seconds 5

Start-Service -ServiceName "AI Service" -ServicePath "$BackendPath\ai-service" -Port 8085
Start-Sleep -Seconds 5

Start-Service -ServiceName "Quiz-Feedback Service" -ServicePath "$BackendPath\quiz-feedback-service" -Port 8081
Start-Sleep -Seconds 5

Start-Service -ServiceName "Preevaluation Service" -ServicePath "$BackendPath\preevaluation-service" -Port 8089
Start-Sleep -Seconds 5

Start-Service -ServiceName "Course Service" -ServicePath "$BackendPath\course-service" -Port 8083
Start-Sleep -Seconds 5

Start-Service -ServiceName "Event Service" -ServicePath "$BackendPath\event-service" -Port 8084
Start-Sleep -Seconds 5

Start-Service -ServiceName "Job Service" -ServicePath "$BackendPath\job-service" -Port 8086
Start-Sleep -Seconds 5

Start-Service -ServiceName "Payment Service" -ServicePath "$BackendPath\payment-service" -Port 8088
Start-Sleep -Seconds 5

Start-Service -ServiceName "Certificate Service" -ServicePath "$BackendPath\certificate-service" -Port 8090
Start-Sleep -Seconds 5

# 4. Frontend Angular
Write-Host "`n4️⃣  Démarrage du Frontend Angular..." -ForegroundColor Magenta
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; Write-Host '🎨 Frontend Angular - Port 4200' -ForegroundColor Green; npm start"

Write-Host "`n✅ Tous les services sont en cours de démarrage!" -ForegroundColor Green
Write-Host "`n📋 Résumé des ports:" -ForegroundColor Cyan
Write-Host "   - Frontend:           http://localhost:4200" -ForegroundColor White
Write-Host "   - Eureka:             http://localhost:8761" -ForegroundColor White
Write-Host "   - API Gateway:        http://localhost:8080" -ForegroundColor White
Write-Host "   - Quiz-Feedback:      http://localhost:8081" -ForegroundColor White
Write-Host "   - Course:             http://localhost:8083" -ForegroundColor White
Write-Host "   - Event:              http://localhost:8084" -ForegroundColor White
Write-Host "   - AI:                 http://localhost:8085" -ForegroundColor White
Write-Host "   - Job:                http://localhost:8086" -ForegroundColor White
Write-Host "   - User:               http://localhost:8087" -ForegroundColor White
Write-Host "   - Payment:            http://localhost:8088" -ForegroundColor White
Write-Host "   - Preevaluation:      http://localhost:8089" -ForegroundColor White
Write-Host "   - Certificate:        http://localhost:8090" -ForegroundColor White

Write-Host "`n⏳ Attendez quelques minutes que tous les services démarrent complètement..." -ForegroundColor Yellow
Write-Host "📊 Vérifiez Eureka Dashboard: http://localhost:8761" -ForegroundColor Cyan
