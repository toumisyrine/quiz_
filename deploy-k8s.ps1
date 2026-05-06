# Script de déploiement Kubernetes PowerShell
# Usage: .\deploy-k8s.ps1 [environment] [image-tag]

param(
    [string]$Environment = "production",
    [string]$ImageTag = "latest"
)

$Namespace = "learnhub"

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

Write-Host "🚀 Déploiement Kubernetes LearnHub" -ForegroundColor Cyan
Write-Host "📦 Environment: $Environment" -ForegroundColor Yellow
Write-Host "🏷️ Image Tag: $ImageTag" -ForegroundColor Yellow
Write-Host "📂 Namespace: $Namespace" -ForegroundColor Yellow
Write-Host ""

# Vérifications préalables
Write-Info "Vérification des prérequis..."

try {
    kubectl version --client | Out-Null
} catch {
    Write-Error "kubectl n'est pas installé ou accessible"
    exit 1
}

try {
    kubectl cluster-info | Out-Null
} catch {
    Write-Error "Impossible de se connecter au cluster Kubernetes"
    exit 1
}

# Vérifier les images Docker Hub
Write-Info "Vérification des images Docker Hub..."
$Services = @("eureka-server", "api-gateway", "quiz-feedback-service", "ai-service", "frontend")

foreach ($service in $Services) {
    try {
        docker pull "syrinaaa/${service}:${ImageTag}" | Out-Null
        Write-Success "Image ${service}:${ImageTag} disponible"
    } catch {
        Write-Error "Image ${service}:${ImageTag} non trouvée"
        exit 1
    }
}

# Déploiement
Write-Info "Déploiement sur Kubernetes..."

# 1. Namespace et configuration
Write-Info "Application des configurations..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml

# 2. Base de données
Write-Info "Déploiement de MySQL..."
kubectl apply -f k8s/mysql.yaml

# Attendre que MySQL soit prêt
Write-Info "Attente de MySQL..."
kubectl rollout status deployment/mysql-deployment -n $Namespace --timeout=180s

# 3. Services microservices
Write-Info "Déploiement des microservices..."
kubectl apply -f k8s/eureka-server.yaml
kubectl apply -f k8s/api-gateway.yaml
kubectl apply -f k8s/quiz-feedback-service.yaml
kubectl apply -f k8s/ai-service.yaml
kubectl apply -f k8s/frontend.yaml

# 4. Services NodePort
Write-Info "Configuration des services NodePort..."
kubectl apply -f k8s/services-nodeport.yaml

# 5. Attendre que tous les services soient prêts
Write-Info "Attente des déploiements..."

kubectl rollout status deployment/eureka-server -n $Namespace --timeout=120s
kubectl rollout status deployment/api-gateway -n $Namespace --timeout=120s
kubectl rollout status deployment/quiz-feedback-service -n $Namespace --timeout=120s
kubectl rollout status deployment/ai-service -n $Namespace --timeout=120s
kubectl rollout status deployment/frontend -n $Namespace --timeout=120s

# 6. Vérification finale
Write-Info "Vérification du déploiement..."

Write-Host ""
Write-Host "📊 État des Pods:" -ForegroundColor Cyan
kubectl get pods -n $Namespace -o wide

Write-Host ""
Write-Host "🌐 État des Services:" -ForegroundColor Cyan
kubectl get services -n $Namespace

Write-Host ""
Write-Host "📈 État des HPA:" -ForegroundColor Cyan
try {
    kubectl get hpa -n $Namespace
} catch {
    Write-Host "Pas d'HPA configuré" -ForegroundColor Gray
}

# Récupérer l'IP du node
$NodeIP = kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}'
if ([string]::IsNullOrEmpty($NodeIP)) {
    $NodeIP = kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'
}

Write-Success "🎉 Déploiement terminé avec succès!"
Write-Host ""
Write-Host "📋 Accès aux services:" -ForegroundColor Cyan
Write-Host "🔍 Eureka Dashboard: http://$NodeIP:30761" -ForegroundColor White
Write-Host "🌐 API Gateway: http://$NodeIP:30888" -ForegroundColor White
Write-Host "📝 Quiz Service: http://$NodeIP:30089" -ForegroundColor White
Write-Host "🤖 AI Service: http://$NodeIP:30090" -ForegroundColor White
Write-Host "💻 Frontend: http://$NodeIP:30080" -ForegroundColor White
Write-Host ""
Write-Host "📊 Commandes utiles:" -ForegroundColor Cyan
Write-Host "kubectl get pods -n $Namespace" -ForegroundColor Gray
Write-Host "kubectl logs -f deployment/eureka-server -n $Namespace" -ForegroundColor Gray
Write-Host "kubectl port-forward -n $Namespace service/frontend-service 8080:80" -ForegroundColor Gray
Write-Host ""

# Test de santé rapide
Write-Info "Test de santé rapide..."
Start-Sleep -Seconds 10

$RunningPods = kubectl get pods -n $Namespace | Select-String "Running"
if ($RunningPods) {
    Write-Success "✅ Des pods sont en cours d'exécution"
} else {
    Write-Warning "⚠️ Aucun pod en cours d'exécution détecté"
}

Write-Host ""
Write-Success "🚀 Déploiement LearnHub terminé!"