# Script de démarrage pour les services essentiels LearnHub
Write-Host "🚀 DÉMARRAGE DES SERVICES ESSENTIELS LEARNHUB" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

$services = @(
    @{Name="Eureka Server"; Path="eureka-server"; Port=8761; Color="Blue"},
    @{Name="API Gateway"; Path="api-gateway"; Port=8888; Color="Green"},
    @{Name="Quiz Feedback Service"; Path="quiz-feedback-service"; Port=8089; Color="Yellow"},
    @{Name="AI Service"; Path="ai-service"; Port=8090; Color="Magenta"}
)

Write-Host "`n📋 Services à démarrer:" -ForegroundColor White
foreach ($service in $services) {
    Write-Host "  • $($service.Name) (Port $($service.Port))" -ForegroundColor $service.Color
}

Write-Host "`n⚠️  IMPORTANT: Démarrez dans cet ordre!" -ForegroundColor Red
Write-Host "1. Eureka Server (obligatoire en premier)" -ForegroundColor Blue
Write-Host "2. API Gateway" -ForegroundColor Green  
Write-Host "3. Quiz Feedback Service" -ForegroundColor Yellow
Write-Host "4. AI Service" -ForegroundColor Magenta

Write-Host "`n🔥 Démarrage automatique..." -ForegroundColor Cyan

foreach ($service in $services) {
    Write-Host "`n🚀 Démarrage de $($service.Name)..." -ForegroundColor $service.Color
    
    $servicePath = $service.Path
    
    # Démarrer le service dans une nouvelle fenêtre PowerShell
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\$servicePath'; Write-Host 'Démarrage de $($service.Name)...' -ForegroundColor $($service.Color); mvn spring-boot:run"
    
    # Attendre un peu entre chaque service
    if ($service.Name -eq "Eureka Server") {
        Write-Host "⏳ Attente de 30 secondes pour Eureka..." -ForegroundColor Blue
        Start-Sleep -Seconds 30
    } else {
        Start-Sleep -Seconds 5
    }
}

Write-Host "`n✅ TOUS LES SERVICES SONT EN COURS DE DÉMARRAGE!" -ForegroundColor Green
Write-Host "`n📊 URLs importantes:" -ForegroundColor Cyan
Write-Host "  • Eureka Dashboard: http://localhost:8761" -ForegroundColor Blue
Write-Host "  • API Gateway: http://localhost:8888" -ForegroundColor Green
Write-Host "  • Quiz API: http://localhost:8888/api/quizzes" -ForegroundColor Yellow
Write-Host "  • AI API: http://localhost:8888/api/ai" -ForegroundColor Magenta

Write-Host "`n⏰ Attendez 2-3 minutes que tous les services démarrent complètement." -ForegroundColor Yellow
Write-Host "🎯 Votre projet LearnHub est prêt!" -ForegroundColor Green