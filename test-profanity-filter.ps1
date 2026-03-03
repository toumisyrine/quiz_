#!/usr/bin/env pwsh

Write-Host "=== Test du système de filtrage des mots inappropriés ===" -ForegroundColor Green

# Vérifier que le service quiz-feedback est accessible
Write-Host "`n1. Test de connectivité au service quiz-feedback..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8081/api/feedbacks" -Method GET
    Write-Host "✅ Service quiz-feedback accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Service quiz-feedback non accessible: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Assurez-vous que le service quiz-feedback est démarré sur le port 8081" -ForegroundColor Yellow
    exit 1
}

# Test 2: Tester la création d'un feedback avec contenu approprié
Write-Host "`n2. Test de création de feedback avec contenu approprié..." -ForegroundColor Yellow
$goodFeedback = @{
    quizId = 1
    courseId = 1
    studentId = 1
    studentName = "Test User"
    rating = 5
    comment = "Excellent quiz, très instructif et bien conçu!"
    type = "QUIZ_FEEDBACK"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "http://localhost:8081/api/feedbacks" -Method POST -Body $goodFeedback -ContentType "application/json"
    Write-Host "✅ Feedback approprié créé avec succès (ID: $($result.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur lors de la création du feedback approprié: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Tester la création d'un feedback avec contenu inapproprié (français)
Write-Host "`n3. Test de création de feedback avec contenu inapproprié (français)..." -ForegroundColor Yellow
$badFeedbackFr = @{
    quizId = 1
    courseId = 1
    studentId = 2
    studentName = "Test User 2"
    rating = 1
    comment = "Ce quiz est vraiment merde, c'est de la connerie totale!"
    type = "QUIZ_FEEDBACK"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "http://localhost:8081/api/feedbacks" -Method POST -Body $badFeedbackFr -ContentType "application/json"
    Write-Host "⚠️  Feedback inapproprié accepté (ne devrait pas arriver)" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✅ Feedback inapproprié correctement rejeté" -ForegroundColor Green
        $errorDetails = $_.Exception.Response.Content | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($errorDetails.detectedWords) {
            Write-Host "Mots détectés: $($errorDetails.detectedWords -join ', ')" -ForegroundColor Cyan
        }
    } else {
        Write-Host "❌ Erreur inattendue: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 4: Tester la création d'un feedback avec contenu inapproprié (anglais)
Write-Host "`n4. Test de création de feedback avec contenu inapproprié (anglais)..." -ForegroundColor Yellow
$badFeedbackEn = @{
    quizId = 1
    courseId = 1
    studentId = 3
    studentName = "Test User 3"
    rating = 1
    comment = "This quiz is fucking terrible, what a piece of shit!"
    type = "QUIZ_FEEDBACK"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "http://localhost:8081/api/feedbacks" -Method POST -Body $badFeedbackEn -ContentType "application/json"
    Write-Host "⚠️  Feedback inapproprié accepté (ne devrait pas arriver)" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✅ Feedback inapproprié correctement rejeté" -ForegroundColor Green
        $errorDetails = $_.Exception.Response.Content | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($errorDetails.detectedWords) {
            Write-Host "Mots détectés: $($errorDetails.detectedWords -join ', ')" -ForegroundColor Cyan
        }
    } else {
        Write-Host "❌ Erreur inattendue: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 5: Tester la création d'un feedback avec contenu partiellement censuré
Write-Host "`n5. Test de création de feedback avec contenu partiellement censuré..." -ForegroundColor Yellow
$partialBadFeedback = @{
    quizId = 1
    courseId = 1
    studentId = 4
    studentName = "Test User 4"
    rating = 2
    comment = "Le quiz était f*ck difficile mais instructif quand même"
    type = "QUIZ_FEEDBACK"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "http://localhost:8081/api/feedbacks" -Method POST -Body $partialBadFeedback -ContentType "application/json"
    Write-Host "⚠️  Feedback avec censure partielle accepté (ne devrait pas arriver)" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✅ Feedback avec censure partielle correctement rejeté" -ForegroundColor Green
        $errorDetails = $_.Exception.Response.Content | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($errorDetails.detectedWords) {
            Write-Host "Mots détectés: $($errorDetails.detectedWords -join ', ')" -ForegroundColor Cyan
        }
    } else {
        Write-Host "❌ Erreur inattendue: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== Résumé du système de filtrage ===" -ForegroundColor Green
Write-Host "🛡️  Filtrage côté backend: Validation et rejet des contenus inappropriés" -ForegroundColor Cyan
Write-Host "🔍 Filtrage côté frontend: Validation en temps réel pendant la saisie" -ForegroundColor Cyan
Write-Host "🌐 Support multilingue: Français, Anglais, variantes avec caractères spéciaux" -ForegroundColor Cyan
Write-Host "⭐ Remplacement automatique: Les mots inappropriés sont remplacés par des *" -ForegroundColor Cyan

Write-Host "`n📱 Testez maintenant sur l'interface:" -ForegroundColor White
Write-Host "• http://localhost:4200/feedbacks/new" -ForegroundColor Gray
Write-Host "• http://localhost:4200/dashboard/feedbacks/new" -ForegroundColor Gray

Write-Host "`n🎉 Test du système de filtrage terminé!" -ForegroundColor Magenta