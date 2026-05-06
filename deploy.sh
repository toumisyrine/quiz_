#!/bin/bash

# Script de déploiement automatique
# Usage: ./deploy.sh [environment] [version]

set -e

ENVIRONMENT=${1:-production}
VERSION=${2:-latest}

echo "🚀 Déploiement de l'application LearnHub"
echo "📦 Environment: $ENVIRONMENT"
echo "🏷️  Version: $VERSION"

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Fonction de nettoyage en cas d'erreur
cleanup() {
    log_error "Erreur détectée. Nettoyage en cours..."
    docker-compose down --remove-orphans
    exit 1
}

trap cleanup ERR

# Vérifications préalables
log_info "Vérification des prérequis..."

if ! command -v docker &> /dev/null; then
    log_error "Docker n'est pas installé"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    log_error "Docker Compose n'est pas installé"
    exit 1
fi

# Arrêt des services existants
log_info "Arrêt des services existants..."
docker-compose down --remove-orphans

# Pull des dernières images
log_info "Téléchargement des dernières images Docker..."
docker-compose pull

# Démarrage des services
log_info "Démarrage des services..."
docker-compose up -d

# Attendre que les services soient prêts
log_info "Attente du démarrage des services..."

# Fonction pour vérifier la santé d'un service
check_service_health() {
    local service_name=$1
    local url=$2
    local max_attempts=30
    local attempt=1

    log_info "Vérification de $service_name..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s "$url" > /dev/null 2>&1; then
            log_success "$service_name est prêt ✅"
            return 0
        fi
        
        echo -n "."
        sleep 5
        ((attempt++))
    done
    
    log_error "$service_name n'est pas prêt après $((max_attempts * 5)) secondes"
    return 1
}

# Vérification des services
sleep 30  # Attendre un peu avant de commencer les vérifications

check_service_health "Eureka Server" "http://localhost:8761/actuator/health"
check_service_health "API Gateway" "http://localhost:8888/actuator/health"
check_service_health "Quiz Feedback Service" "http://localhost:8089/actuator/health"
check_service_health "AI Service" "http://localhost:8090/actuator/health"
check_service_health "Frontend" "http://localhost:80"

# Affichage du statut final
log_success "🎉 Déploiement terminé avec succès!"
echo ""
echo "📊 Services disponibles:"
echo "  🔍 Eureka Server:      http://localhost:8761"
echo "  🌐 API Gateway:        http://localhost:8888"
echo "  📝 Quiz Service:       http://localhost:8089"
echo "  🤖 AI Service:         http://localhost:8090"
echo "  💻 Frontend:           http://localhost:80"
echo "  🗄️  MySQL:             localhost:3306"
echo ""
echo "📋 Commandes utiles:"
echo "  docker-compose logs -f [service]  # Voir les logs"
echo "  docker-compose ps                 # Statut des services"
echo "  docker-compose down               # Arrêter tous les services"
echo ""

# Afficher les logs en temps réel (optionnel)
read -p "Voulez-vous voir les logs en temps réel? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose logs -f
fi