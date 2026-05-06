#!/bin/bash

# Script de déploiement Kubernetes rapide
# Usage: ./deploy-k8s.sh [environment] [image-tag]

set -e

ENVIRONMENT=${1:-production}
IMAGE_TAG=${2:-latest}
NAMESPACE="learnhub"

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🚀 Déploiement Kubernetes LearnHub"
echo "📦 Environment: $ENVIRONMENT"
echo "🏷️  Image Tag: $IMAGE_TAG"
echo "📂 Namespace: $NAMESPACE"
echo ""

# Vérifications préalables
log_info "Vérification des prérequis..."

if ! command -v kubectl &> /dev/null; then
    log_error "kubectl n'est pas installé"
    exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
    log_error "Impossible de se connecter au cluster Kubernetes"
    exit 1
fi

# Vérifier les images Docker Hub
log_info "Vérification des images Docker Hub..."
SERVICES=("eureka-server" "api-gateway" "quiz-feedback-service" "ai-service" "frontend")

for service in "${SERVICES[@]}"; do
    if docker pull "syrinaaa/${service}:${IMAGE_TAG}" &> /dev/null; then
        log_success "Image ${service}:${IMAGE_TAG} disponible"
    else
        log_error "Image ${service}:${IMAGE_TAG} non trouvée"
        exit 1
    fi
done

# Déploiement
log_info "Déploiement sur Kubernetes..."

# 1. Namespace et configuration
log_info "Application des configurations..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml

# 2. Base de données
log_info "Déploiement de MySQL..."
kubectl apply -f k8s/mysql.yaml

# Attendre que MySQL soit prêt
log_info "Attente de MySQL..."
kubectl rollout status deployment/mysql-deployment -n $NAMESPACE --timeout=180s

# 3. Services microservices
log_info "Déploiement des microservices..."
kubectl apply -f k8s/eureka-server.yaml
kubectl apply -f k8s/api-gateway.yaml
kubectl apply -f k8s/quiz-feedback-service.yaml
kubectl apply -f k8s/ai-service.yaml
kubectl apply -f k8s/frontend.yaml

# 4. Services NodePort
log_info "Configuration des services NodePort..."
kubectl apply -f k8s/services-nodeport.yaml

# 5. Attendre que tous les services soient prêts
log_info "Attente des déploiements..."

kubectl rollout status deployment/eureka-server -n $NAMESPACE --timeout=120s
kubectl rollout status deployment/api-gateway -n $NAMESPACE --timeout=120s
kubectl rollout status deployment/quiz-feedback-service -n $NAMESPACE --timeout=120s
kubectl rollout status deployment/ai-service -n $NAMESPACE --timeout=120s
kubectl rollout status deployment/frontend -n $NAMESPACE --timeout=120s

# 6. Vérification finale
log_info "Vérification du déploiement..."

echo ""
echo "📊 État des Pods:"
kubectl get pods -n $NAMESPACE -o wide

echo ""
echo "🌐 État des Services:"
kubectl get services -n $NAMESPACE

echo ""
echo "📈 État des HPA:"
kubectl get hpa -n $NAMESPACE 2>/dev/null || echo "Pas d'HPA configuré"

# Récupérer l'IP du node
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
if [ -z "$NODE_IP" ]; then
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
fi

log_success "🎉 Déploiement terminé avec succès!"
echo ""
echo "📋 Accès aux services:"
echo "🔍 Eureka Dashboard: http://$NODE_IP:30761"
echo "🌐 API Gateway: http://$NODE_IP:30888"
echo "📝 Quiz Service: http://$NODE_IP:30089"
echo "🤖 AI Service: http://$NODE_IP:30090"
echo "💻 Frontend: http://$NODE_IP:30080"
echo ""
echo "📊 Commandes utiles:"
echo "kubectl get pods -n $NAMESPACE"
echo "kubectl logs -f deployment/eureka-server -n $NAMESPACE"
echo "kubectl port-forward -n $NAMESPACE service/frontend-service 8080:80"
echo ""

# Test de santé rapide
log_info "Test de santé rapide..."
sleep 10

if kubectl get pods -n $NAMESPACE | grep -q "Running"; then
    log_success "✅ Des pods sont en cours d'exécution"
else
    log_warning "⚠️ Aucun pod en cours d'exécution détecté"
fi

echo ""
log_success "🚀 Déploiement LearnHub terminé!"