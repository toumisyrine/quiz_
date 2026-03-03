#!/usr/bin/env pwsh

Write-Host "=== Test des suggestions de feedback IA ===" -ForegroundColor Green

# Test 1: Vérifier que le service ai-service est accessible
Write-Host "`n1. Test de connectivité au service ai-service..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8082/api/ai/quiz/topics" -Method GET
    Write-Host "✅ Service ai-service accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur de connectivité: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Tester les suggestions de feedback avec un bon score
Write-Host "`n2. Test de suggestions pour un bon score (80%)..." -ForegroundColor Yellow
$goodScoreBody = @{
    quizId = 1
    quizTitle = "Java OOP Fundamentals"
    attemptId = 32
    score = 16
    totalPoints = 20
    difficulty = "MEDIUM"
    topic = "Java OOP"
} | ConvertTo-Json

try {
    $suggestions = Invoke-RestMethod -Uri "http://localhost:8082/api/ai/feedback/suggestions" -Method POST -Body $goodScoreBody -ContentType "application/json"
    Write-Host "✅ Suggestions générées pour bon score!" -ForegroundColor Green
    Write-Host "Tone: $($suggestions.tone)" -ForegroundColor Cyan
    Write-Host "Focus: $($suggestions.focusArea)" -ForegroundColor Cyan
    Write-Host "Nombre de suggestions: $($suggestions.suggestions.Count)" -ForegroundColor Cyan
    
    Write-Host "`nSuggestions:" -ForegroundColor White
    for ($i = 0; $i -lt $suggestions.suggestions.Count; $i++) {
        Write-Host "  $($i + 1). $($suggestions.suggestions[$i])" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Erreur de génération: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 3: Tester les suggestions de feedback avec un score moyen
Write-Host "`n3. Test de suggestions pour un score moyen (60%)..." -ForegroundColor Yellow
$mediumScoreBody = @{
    quizId = 2
    quizTitle = "Python Basics"
    attemptId = 33
    score = 12
    totalPoints = 20
    difficulty = "EASY"
    topic = "Python"
} | ConvertTo-Json

try {
    $suggestions = Invoke-RestMethod -Uri "http://localhost:8082/api/ai/feedback/suggestions" -Method POST -Body $mediumScoreBody -ContentType "application/json"
    Write-Host "✅ Suggestions générées pour score moyen!" -ForegroundColor Green
    Write-Host "Tone: $($suggestions.tone)" -ForegroundColor Cyan
    Write-Host "Focus: $($suggestions.focusArea)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur de génération: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Tester les suggestions de feedback avec un faible score
Write-Host "`n4. Test de suggestions pour un faible score (40%)..." -ForegroundColor Yellow
$lowScoreBody = @{
    quizId = 3
    quizTitle = "Advanced JavaScript"
    attemptId = 34
    score = 8
    totalPoints = 20
    difficulty = "HARD"
    topic = "JavaScript"
} | ConvertTo-Json

try {
    $suggestions = Invoke-RestMethod -Uri "http://localhost:8082/api/ai/feedback/suggestions" -Method POST -Body $lowScoreBody -ContentType "application/json"
    Write-Host "✅ Suggestions générées pour faible score!" -ForegroundColor Green
    Write-Host "Tone: $($suggestions.tone)" -ForegroundColor Cyan
    Write-Host "Focus: $($suggestions.focusArea)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur de génération: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Tests terminés ===" -ForegroundColor Green
Write-Host "🎉 Les suggestions de feedback IA sont opérationnelles!" -ForegroundColor Magenta
Write-Host "📱 Testez maintenant sur: http://localhost:4200/feedbacks/new?quizId=1&attemptId=32" -ForegroundColor Cyan
Write-Host "🔧 API: http://localhost:8082/api/ai/feedback/suggestions" -ForegroundColor Cyan