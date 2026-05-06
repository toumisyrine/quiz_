# Script de compilation de tous les microservices LearnHub
# Utilisation: .\compile-all-services.ps1

Write-Host "🔨 Compilation de tous les microservices LearnHub..." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$BackendPath = "$PSScriptRoot\backend"
$ErrorCount = 0
$SuccessCount = 0

$services = @(
    @{Name="Eureka Server"; Path="eureka-server"},
    @{Name="API Gateway"; Path="api-gateway"},
    @{Name="AI Service"; Path="ai-service"},
    @{Name="Quiz-Feedback Service"; Path="quiz-feedback-service"},
    @{Name="User Service"; Path="user-service"},
    @{Name="Course Service"; Path="course-service"},
    @{Name="Event Service"; Path="event-service"},
    @{Name="Job Service"; Path="job-service"},
    @{Name="Payment Service"; Path="payment-service"},
    @{Name="Certificate Service"; Path="certificate-service"},
    @{Name="Preevaluation Service"; Path="preevaluation-service"}
)

$TotalServices = $services.Count
$CurrentService = 0

foreach ($service in $services) {
    $CurrentService++
    Write-Host "`n[$CurrentService/$TotalServices] 📦 Compilation de $($service.Name)..." -ForegroundColor Cyan
    
    $ServicePath = Join-Path $BackendPath $service.Path
    
    if (-not (Test-Path $ServicePath)) {
        Write-Host "   ⚠️  Service non trouvé: $ServicePath" -ForegroundColor Yellow
        $ErrorCount++
        continue
    }
    
    Push-Location $ServicePath
    
    try {
        $output = mvn clean install -DskipTests 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ $($service.Name) compilé avec succès!" -ForegroundColor Green
            $SuccessCount++
        } else {
            Write-Host "   ❌ Erreur lors de la compilation de $($service.Name)" -ForegroundColor Red
            Write-Host "   Détails: $output" -ForegroundColor Red
            $ErrorCount++
        }
    }
    catch {
        Write-Host "   ❌ Exception lors de la compilation: $_" -ForegroundColor Red
        $ErrorCount++
    }
    finally {
        Pop-Location
    }
}

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host "📊 Résumé de la compilation:" -ForegroundColor Cyan
Write-Host "   ✅ Succès: $SuccessCount/$TotalServices" -ForegroundColor Green
Write-Host "   ❌ Erreurs: $ErrorCount/$TotalServices" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })

if ($ErrorCount -eq 0) {
    Write-Host "`n🎉 Tous les services sont compilés avec succès!" -ForegroundColor Green
    Write-Host "`n📋 Prochaines étapes:" -ForegroundColor Cyan
    Write-Host "   1. Démarrer MySQL et créer les bases de données" -ForegroundColor White
    Write-Host "   2. Configurer les variables d'environnement (GEMINI_API_KEY, etc.)" -ForegroundColor White
    Write-Host "   3. Exécuter: .\start-all-services.ps1" -ForegroundColor White
    Write-Host "   4. Ouvrir http://localhost:4200" -ForegroundColor White
} else {
    Write-Host "`n⚠️  Certains services n'ont pas pu être compilés." -ForegroundColor Yellow
    Write-Host "   Vérifiez les erreurs ci-dessus et réessayez." -ForegroundColor Yellow
    exit 1
}

Write-Host "`n💡 Astuce: Pour compiler le frontend:" -ForegroundColor Cyan
Write-Host "   cd $PSScriptRoot" -ForegroundColor White
Write-Host "   npm install" -ForegroundColor White
Write-Host "   npm run build" -ForegroundColor White
