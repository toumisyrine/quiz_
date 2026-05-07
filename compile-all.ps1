#!/usr/bin/env pwsh
# Script de compilation complète du projet LearnHub

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  COMPILATION COMPLÈTE DU PROJET" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"
$services = @("eureka-server", "api-gateway", "ai-service", "quiz-feedback-service")
$failedServices = @()

# 1. Compiler les services backend
Write-Host "1️⃣  COMPILATION DES SERVICES BACKEND" -ForegroundColor Yellow
Write-Host "-----------------------------------" -ForegroundColor Yellow

foreach ($service in $services) {
    Write-Host ""
    Write-Host "📦 Compilation de $service..." -ForegroundColor Green
    
    try {
        Set-Location "backend/$service"
        mvn clean package -DskipTests
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ $service compilé avec succès!" -ForegroundColor Green
        } else {
            Write-Host "❌ Erreur lors de la compilation de $service" -ForegroundColor Red
            $failedServices += $service
        }
        
        Set-Location ../..
    }
    catch {
        Write-Host "❌ Exception lors de la compilation de $service : $_" -ForegroundColor Red
        $failedServices += $service
        Set-Location ../..
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# 2. Compiler le frontend
Write-Host ""
Write-Host "2️⃣  COMPILATION DU FRONTEND ANGULAR" -ForegroundColor Yellow
Write-Host "-----------------------------------" -ForegroundColor Yellow
Write-Host ""

try {
    Write-Host "📦 Installation des dépendances npm..." -ForegroundColor Green
    npm install
    
    Write-Host ""
    Write-Host "📦 Compilation du frontend..." -ForegroundColor Green
    npm run build
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Frontend compilé avec succès!" -ForegroundColor Green
    } else {
        Write-Host "❌ Erreur lors de la compilation du frontend" -ForegroundColor Red
        $failedServices += "frontend"
    }
}
catch {
    Write-Host "❌ Exception lors de la compilation du frontend : $_" -ForegroundColor Red
    $failedServices += "frontend"
}

# 3. Résumé
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RÉSUMÉ DE LA COMPILATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($failedServices.Count -eq 0) {
    Write-Host "🎉 TOUS LES SERVICES ONT ÉTÉ COMPILÉS AVEC SUCCÈS!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Services backend compilés:" -ForegroundColor Cyan
    foreach ($service in $services) {
        Write-Host "  ✅ $service" -ForegroundColor Green
    }
    Write-Host "  ✅ frontend" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Les fichiers JAR sont dans:" -ForegroundColor Yellow
    Write-Host "   backend/*/target/*.jar" -ForegroundColor White
    Write-Host ""
    Write-Host "📁 Le frontend compilé est dans:" -ForegroundColor Yellow
    Write-Host "   dist/learnhub/" -ForegroundColor White
} else {
    Write-Host "⚠️  CERTAINS SERVICES ONT ÉCHOUÉ:" -ForegroundColor Red
    foreach ($failed in $failedServices) {
        Write-Host "  ❌ $failed" -ForegroundColor Red
    }
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
