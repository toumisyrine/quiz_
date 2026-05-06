# Script pour démarrer tous les microservices sans Docker
Write-Host "=== Démarrage de tous les microservices ===" -ForegroundColor Cyan

$services = @(
    "eureka-server",
    "api-gateway",
    "user-service",
    "course-service",
    "event-service",
    "job-service",
    "payment-service",
    "certificate-service",
    "preevaluation-service",
    "ai-service"
)

Write-Host "`nDémarrage des services..." -ForegroundColor Yellow

foreach ($service in $services) {
    $servicePath = Join-Path $PSScriptRoot $service
    
    if (Test-Path $servicePath) {
        Write-Host "`n[$service] Démarrage..." -ForegroundColor Green
        
        # Démarrer le service dans une nouvelle fenêtre PowerShell
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$servicePath'; Write-Host 'Démarrage de $service...' -ForegroundColor Cyan; mvn spring-boot:run"
        
        Start-Sleep -Seconds 2
    } else {
        Write-Host "[$service] Service non trouvé, ignoré" -ForegroundColor Yellow
    }
}

Write-Host "`n=== Tous les services sont en cours de démarrage ===" -ForegroundColor Green
Write-Host "Chaque service s'ouvre dans sa propre fenêtre PowerShell" -ForegroundColor Cyan
Write-Host "`nAttendez 2-3 minutes que tous les services démarrent complètement." -ForegroundColor Yellow
Write-Host "`nServices disponibles sur:" -ForegroundColor Cyan
Write-Host "  - Eureka Dashboard: http://localhost:8761" -ForegroundColor White
Write-Host "  - API Gateway: http://localhost:8888" -ForegroundColor White
