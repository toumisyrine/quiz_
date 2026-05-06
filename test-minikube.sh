#!/bin/bash

# Script de test rapide pour déployer sur Minikube
# Usage: ./test-minikube.sh

set -e

echo "🚀 Test de déploiement LearnHub sur Minikube"

# Vérifier Minikube
if ! minikube status &> /dev/null; then
    echo "🔄 Démarrage de Minikube..."
    minikube start --driver=docker --memory=4096 --cpus=2
else
    echo "✅ Minikube déjà démarré"
fi

# Configurer kubectl pour Minikube
kubectl config use-context minikube

# Vérifier la connexion
echo "📊 Statut du cluster:"
kubectl cluster-info
kubectl get nodes

# Déployer l'application
echo "☸️ Déploiement de LearnHub..."
kubectl apply -f k8s-deploy.yaml

# Attendre que les pods soient prêts
echo "⏳ Attente des déploiements..."
kubectl rollout status deployment/mysql -n learnhub --timeout=300s
kubectl rollout status deployment/eureka-server -n learnhub --timeout=180s
kubectl rollout status deployment/api-gateway -n learnhub --timeout=180s
kubectl rollout status deployment/quiz-feedback-service -n learnhub --timeout=180s
kubectl rollout status deployment/ai-service -n learnhub --timeout=180s
kubectl rollout status deployment/frontend -n learnhub --timeout=180s

# Afficher le statut
echo ""
echo "📊 STATUT DU DÉPLOIEMENT:"
kubectl get pods -n learnhub -o wide
echo ""
kubectl get services -n learnhub

# Récupérer les URLs d'accès
echo ""
echo "🔗 ACCÈS AUX SERVICES:"
echo "Pour accéder aux services, utilisez:"
echo ""

# Minikube service URLs
minikube service eureka-service -n learnhub --url &
minikube service api-gateway-service -n learnhub --url &
minikube service frontend-service -n learnhub --url &

sleep 2

echo ""
echo "📋 Commandes utiles:"
echo "  minikube dashboard                    # Interface web Kubernetes"
echo "  kubectl get pods -n learnhub         # Voir les pods"
echo "  kubectl logs -f <pod-name> -n learnhub  # Voir les logs"
echo "  minikube service list -n learnhub    # Lister tous les services"
echo ""
echo "🎉 Déploiement terminé!"