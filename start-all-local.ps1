#!/usr/bin/env pwsh
# Script pour démarrer tous les services localement

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DÉMARRAGE DE TOUS LES SERVICES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Continue"

# Fonction pour démarrer un service dans une nouvelle fenêtre
function Start-Service {
    param(
        [string]$ServiceName,
        [string]$ServicePath,
        [int]$Port
    )
    
    Write-Host "🚀 Démarrage de $ServiceName sur le port $Port..." -ForegroundColor Green
    
    $command = "cd '$ServicePath'; mvn spring-boot:run"
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $command
    
    Start-Sleep -Seconds 3
}

Write-Host "📋 Ordre de démarrage:" -ForegroundColor Yellow
Write-Host "  1. Eureka Server (8761)" -ForegroundColor White
Write-Host "  2. API Gateway (8888)" -ForegroundColor White
Write-Host "  3. AI Service (8090)" -ForegroundColor White
Write-Host "  4. Quiz-Feedback Service (8089)" -ForegroundColor White
Write-Host ""

# 1. Démarrer Eureka Server
Start-Service -ServiceName "Eureka Server" -ServicePath "$PSScriptRoot\backend\eureka-server" -Port 8761
Write-Host "⏳ Attente de 30 secondes pour Eureka Server..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 2. Démarrer API Gateway
Start-Service -ServiceName "API Gateway" -ServicePath "$PSScriptRoot\backend\api-gateway" -Port 8888
Write-Host "⏳ Attente de 20 secondes pour API Gateway..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# 3. Démarrer AI Service
Start-Service -ServiceName "AI Service" -ServicePath "$PSScriptRoot\backend\ai-service" -Port 8090
Write-Host "⏳ Attente de 15 secondes pour AI Service..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# 4. Démarrer Quiz-Feedback Service
Start-Service -ServiceName "Quiz-Feedback Service" -ServicePath "$PSScriptRoot\backend\quiz-feedback-service" -Port 8089
Write-Host "⏳ Attente de 15 secondes pour Quiz-Feedback Service..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ TOUS LES SERVICES SONT DÉMARRÉS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 URLs des services:" -ForegroundColor Yellow
Write-Host "  🔍 Eureka Dashboard:    http://localhost:8761" -ForegroundColor Cyan
Write-Host "  🌐 API Gateway:         http://localhost:8888" -ForegroundColor Cyan
Write-Host "  🤖 AI Service:          http://localhost:8090" -ForegroundColor Cyan
Write-Host "  📝 Quiz-Feedback:       http://localhost:8089" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Conseil: Vérifiez Eureka Dashboard pour voir tous les services enregistrés" -ForegroundColor Yellow
Write-Host ""
