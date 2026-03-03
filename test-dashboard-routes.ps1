#!/usr/bin/env pwsh

Write-Host "=== Test des routes du dashboard ===" -ForegroundColor Green

# Vérifier que Angular est accessible
Write-Host "`n1. Test de connectivité Angular..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:4200" -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Angular accessible sur http://localhost:4200" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Angular non accessible: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Liste des routes dashboard à tester
$dashboardRoutes = @(
    "/dashboard",
    "/dashboard/dashboard",
    "/dashboard/users",
    "/dashboard/courses",
    "/dashboard/events", 
    "/dashboard/clubs",
    "/dashboard/quizzes",
    "/dashboard/attempts",
    "/dashboard/feedbacks",
    "/dashboard/ai/generator"
)

Write-Host "`n2. Test des routes dashboard..." -ForegroundColor Yellow

foreach ($route in $dashboardRoutes) {
    $url = "http://localhost:4200$route"
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $route" -ForegroundColor Green
        } else {
            Write-Host "⚠️  $route (Status: $($response.StatusCode))" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ $route (Erreur: $($_.Exception.Message))" -ForegroundColor Red
    }
}

# Test des routes publiques importantes
$publicRoutes = @(
    "/",
    "/courses",
    "/events",
    "/clubs", 
    "/quizzes",
    "/feedbacks"
)

Write-Host "`n3. Test des routes publiques..." -ForegroundColor Yellow

foreach ($route in $publicRoutes) {
    $url = "http://localhost:4200$route"
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $route" -ForegroundColor Green
        } else {
            Write-Host "⚠️  $route (Status: $($response.StatusCode))" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ $route (Erreur: $($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`n=== Résumé des routes ===" -ForegroundColor Green
Write-Host "📱 Dashboard principal: http://localhost:4200/dashboard" -ForegroundColor Cyan
Write-Host "🏠 Page d'accueil: http://localhost:4200/" -ForegroundColor Cyan
Write-Host "🎯 Générateur IA: http://localhost:4200/dashboard/ai/generator" -ForegroundColor Cyan
Write-Host "📝 Feedback avec IA: http://localhost:4200/feedbacks/new?quizId=1&attemptId=32" -ForegroundColor Cyan

Write-Host "`n📋 Navigation Dashboard disponible:" -ForegroundColor White
Write-Host "  • Dashboard" -ForegroundColor Gray
Write-Host "  • Users" -ForegroundColor Gray
Write-Host "  • Courses" -ForegroundColor Gray
Write-Host "  • Events" -ForegroundColor Gray
Write-Host "  • Clubs" -ForegroundColor Gray
Write-Host "  • Quizzes" -ForegroundColor Gray
Write-Host "  • Quiz Attempts" -ForegroundColor Gray
Write-Host "  • Feedbacks" -ForegroundColor Gray
Write-Host "  • AI Quiz Generator" -ForegroundColor Gray

Write-Host "`n🎉 Test des routes terminé!" -ForegroundColor Magenta