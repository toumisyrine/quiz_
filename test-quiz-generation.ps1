#!/usr/bin/env pwsh

Write-Host "=== Test de génération de quiz avec Gemini ===" -ForegroundColor Green

# Test 1: Vérifier que le service ai-service est accessible
Write-Host "`n1. Test de connectivité au service ai-service..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8082/api/ai/quiz/topics" -Method GET
    Write-Host "✅ Service ai-service accessible" -ForegroundColor Green
    Write-Host "Sujets suggérés: $($response -join ', ')" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur de connectivité: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Générer un quiz simple
Write-Host "`n2. Test de génération de quiz..." -ForegroundColor Yellow
$body = @{
    topic = "JavaScript Basics"
    difficulty = "EASY"
    questionCount = 2
    questionType = "MULTIPLE_CHOICE"
} | ConvertTo-Json

try {
    $quiz = Invoke-RestMethod -Uri "http://localhost:8082/api/ai/quiz/generate" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✅ Quiz généré avec succès!" -ForegroundColor Green
    Write-Host "Titre: $($quiz.title)" -ForegroundColor Cyan
    Write-Host "Description: $($quiz.description)" -ForegroundColor Cyan
    Write-Host "Nombre de questions: $($quiz.questions.Count)" -ForegroundColor Cyan
    
    # Afficher les questions
    for ($i = 0; $i -lt $quiz.questions.Count; $i++) {
        $q = $quiz.questions[$i]
        Write-Host "`nQuestion $($i + 1): $($q.text)" -ForegroundColor White
        Write-Host "Réponse correcte: $($q.correctAnswer)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erreur de génération: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorDetails = $_.Exception.Response | ConvertFrom-Json
        Write-Host "Détails: $($errorDetails.error)" -ForegroundColor Red
    }
    exit 1
}

# Test 3: Vérifier que Angular est accessible
Write-Host "`n3. Test de connectivité Angular..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:4200" -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Angular accessible sur http://localhost:4200" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Angular non accessible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Tests terminés ===" -ForegroundColor Green
Write-Host "🎉 Le générateur de quiz IA est opérationnel!" -ForegroundColor Magenta
Write-Host "📱 Interface: http://localhost:4200/dashboard/ai/generator" -ForegroundColor Cyan
Write-Host "🔧 API: http://localhost:8082/api/ai/quiz/generate" -ForegroundColor Cyan