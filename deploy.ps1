# Script de déploiement PowerShell pour Windows
# Usage: .\deploy.ps1 [environment] [version]

param(
    [string]$Environment = "production",
    [string]$Version = "latest"
)

Write-Host "🚀 Déploiement de l'application LearnHub" -ForegroundColor Cyan
Write-Host "📦 Environment: $Environment" -ForegroundColor Yellow
Write-Host "🏷️  Version: $Version" -ForegroundColor Yellow

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Vérifications préalables
Write-Info "Vérification des prérequis..."

try {
    docker --version | Out-Null
} catch {
    Write-Error "Docker n'est pas installé ou accessible"
    exit 1
}

try {
    docker-compose --version | Out-Null
} catch {
    Write-Error "Docker Compose n'est pas installé ou accessible"
    exit 1
}

# Arrêt des services existants
Write-Info "Arrêt des services existants..."
docker-compose down --remove-orphans

# Pull des dernières images
Write-Info "Téléchargement des dernières images Docker..."
docker-compose pull

# Démarrage des services
Write-Info "Démarrage des services..."
docker-compose up -d

# Attendre que les services soient prêts
Write-Info "Attente du démarrage des services..."

function Test-ServiceHealth {
    param(
        [string]$ServiceName,
        [string]$Url,
        [int]$MaxAttempts = 30
    )
    
    Write-Info "Vérification de $ServiceName..."
    
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -eq 200) {
                Write-Success "$ServiceName est prêt ✅"
                return $true
            }
        } catch {
            # Service pas encore prêt
        }
        
        Write-Host "." -NoNewline
        Start-Sleep -Seconds 5
    }
    
    Write-Error "$ServiceName n'est pas prêt après $($MaxAttempts * 5) secondes"
    return $false
}

# Attendre un peu avant de commencer les vérifications
Start-Sleep -Seconds 30

# Vérification des services
$allServicesReady = $true

$allServicesReady = $allServicesReady -and (Test-ServiceHealth "Eureka Server" "http://localhost:8761/actuator/health")
$allServicesReady = $allServicesReady -and (Test-ServiceHealth "API Gateway" "http://localhost:8888/actuator/health")
$allServicesReady = $allServicesReady -and (Test-ServiceHealth "Quiz Feedback Service" "http://localhost:8089/actuator/health")
$allServicesReady = $allServicesReady -and (Test-ServiceHealth "AI Service" "http://localhost:8090/actuator/health")
$allServicesReady = $allServicesReady -and (Test-ServiceHealth "Frontend" "http://localhost:80")

if ($allServicesReady) {
    Write-Success "🎉 Déploiement terminé avec succès!"
    Write-Host ""
    Write-Host "📊 Services disponibles:" -ForegroundColor Cyan
    Write-Host "  🔍 Eureka Server:      http://localhost:8761" -ForegroundColor White
    Write-Host "  🌐 API Gateway:        http://localhost:8888" -ForegroundColor White
    Write-Host "  📝 Quiz Service:       http://localhost:8089" -ForegroundColor White
    Write-Host "  🤖 AI Service:         http://localhost:8090" -ForegroundColor White
    Write-Host "  💻 Frontend:           http://localhost:80" -ForegroundColor White
    Write-Host "  🗄️  MySQL:             localhost:3306" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Commandes utiles:" -ForegroundColor Cyan
    Write-Host "  docker-compose logs -f [service]  # Voir les logs" -ForegroundColor Gray
    Write-Host "  docker-compose ps                 # Statut des services" -ForegroundColor Gray
    Write-Host "  docker-compose down               # Arrêter tous les services" -ForegroundColor Gray
} else {
    Write-Error "❌ Certains services ne sont pas prêts. Vérifiez les logs avec: docker-compose logs"
    exit 1
}

# Proposer de voir les logs
$showLogs = Read-Host "Voulez-vous voir les logs en temps réel? (y/N)"
if ($showLogs -eq "y" -or $showLogs -eq "Y") {
    docker-compose logs -f
}