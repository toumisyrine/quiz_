# Makefile pour automatiser les déploiements LearnHub
# Usage: make deploy ENV=production TAG=latest

.PHONY: help deploy deploy-staging deploy-prod check-images clean status logs

# Variables par défaut
ENV ?= production
TAG ?= latest
NAMESPACE = learnhub
DOCKER_REGISTRY = syrinaaa

# Services
SERVICES = eureka-server api-gateway quiz-feedback-service ai-service frontend

help: ## Afficher l'aide
	@echo "🚀 LearnHub Kubernetes Deployment"
	@echo ""
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

check-prereq: ## Vérifier les prérequis
	@echo "🔍 Vérification des prérequis..."
	@command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl non installé"; exit 1; }
	@command -v docker >/dev/null 2>&1 || { echo "❌ docker non installé"; exit 1; }
	@kubectl cluster-info >/dev/null 2>&1 || { echo "❌ Cluster Kubernetes non accessible"; exit 1; }
	@echo "✅ Prérequis OK"

check-images: check-prereq ## Vérifier la disponibilité des images Docker
	@echo "🐳 Vérification des images Docker Hub..."
	@for service in $(SERVICES); do \
		echo "Vérification de $(DOCKER_REGISTRY)/$$service:$(TAG)..."; \
		docker pull $(DOCKER_REGISTRY)/$$service:$(TAG) >/dev/null 2>&1 || { echo "❌ Image $$service:$(TAG) non trouvée"; exit 1; }; \
		echo "✅ $$service:$(TAG) disponible"; \
	done

deploy: check-images ## Déployer sur Kubernetes
	@echo "🚀 Déploiement LearnHub (ENV=$(ENV), TAG=$(TAG))"
	@echo "📂 Namespace: $(NAMESPACE)"
	
	# Configuration
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/configmap.yaml
	
	# Base de données
	@echo "🗄️ Déploiement MySQL..."
	kubectl apply -f k8s/mysql.yaml
	kubectl rollout status deployment/mysql-deployment -n $(NAMESPACE) --timeout=180s
	
	# Microservices
	@echo "🚀 Déploiement des microservices..."
	kubectl apply -f k8s/eureka-server.yaml
	kubectl rollout status deployment/eureka-server -n $(NAMESPACE) --timeout=120s
	
	kubectl apply -f k8s/api-gateway.yaml
	kubectl apply -f k8s/quiz-feedback-service.yaml
	kubectl apply -f k8s/ai-service.yaml
	kubectl apply -f k8s/frontend.yaml
	
	# Services NodePort
	kubectl apply -f k8s/services-nodeport.yaml
	
	# Attendre tous les déploiements
	@echo "⏳ Attente des déploiements..."
	kubectl rollout status deployment/api-gateway -n $(NAMESPACE) --timeout=120s
	kubectl rollout status deployment/quiz-feedback-service -n $(NAMESPACE) --timeout=120s
	kubectl rollout status deployment/ai-service -n $(NAMESPACE) --timeout=120s
	kubectl rollout status deployment/frontend -n $(NAMESPACE) --timeout=120s
	
	@echo "✅ Déploiement terminé!"
	@make status

deploy-staging: ## Déployer en staging
	@make deploy ENV=staging TAG=latest

deploy-prod: ## Déployer en production
	@make deploy ENV=production TAG=latest

status: ## Afficher le statut du déploiement
	@echo "📊 Statut du déploiement LearnHub"
	@echo ""
	@echo "📦 Pods:"
	@kubectl get pods -n $(NAMESPACE) -o wide
	@echo ""
	@echo "🌐 Services:"
	@kubectl get services -n $(NAMESPACE)
	@echo ""
	@echo "📈 HPA:"
	@kubectl get hpa -n $(NAMESPACE) 2>/dev/null || echo "Pas d'HPA configuré"
	@echo ""
	@NODE_IP=$$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'); \
	echo "🔗 Accès aux services:"; \
	echo "  🔍 Eureka: http://$$NODE_IP:30761"; \
	echo "  🌐 Gateway: http://$$NODE_IP:30888"; \
	echo "  📝 Quiz: http://$$NODE_IP:30089"; \
	echo "  🤖 AI: http://$$NODE_IP:30090"; \
	echo "  💻 Frontend: http://$$NODE_IP:30080"

logs: ## Afficher les logs des services
	@echo "📋 Logs des services LearnHub"
	@echo ""
	@for service in $(SERVICES); do \
		echo "--- Logs de $$service ---"; \
		kubectl logs -n $(NAMESPACE) deployment/$$service --tail=10 || true; \
		echo ""; \
	done

clean: ## Supprimer le déploiement
	@echo "🧹 Suppression du déploiement LearnHub..."
	@kubectl delete namespace $(NAMESPACE) --ignore-not-found=true
	@echo "✅ Nettoyage terminé"

restart: ## Redémarrer tous les services
	@echo "🔄 Redémarrage des services..."
	@for service in $(SERVICES); do \
		kubectl rollout restart deployment/$$service -n $(NAMESPACE); \
	done
	@echo "✅ Redémarrage lancé"

scale: ## Scaler les services (usage: make scale SERVICE=api-gateway REPLICAS=5)
	@if [ -z "$(SERVICE)" ] || [ -z "$(REPLICAS)" ]; then \
		echo "❌ Usage: make scale SERVICE=<service> REPLICAS=<number>"; \
		exit 1; \
	fi
	@echo "📈 Scaling $(SERVICE) à $(REPLICAS) replicas..."
	@kubectl scale deployment/$(SERVICE) -n $(NAMESPACE) --replicas=$(REPLICAS)
	@kubectl rollout status deployment/$(SERVICE) -n $(NAMESPACE)

port-forward: ## Port-forward vers les services locaux
	@echo "🔗 Port-forwarding des services..."
	@echo "Eureka: http://localhost:8761"
	@echo "Gateway: http://localhost:8888"
	@echo "Frontend: http://localhost:8080"
	@echo ""
	@echo "Appuyez sur Ctrl+C pour arrêter"
	@kubectl port-forward -n $(NAMESPACE) service/eureka-server-service 8761:8761 &
	@kubectl port-forward -n $(NAMESPACE) service/api-gateway-service 8888:8888 &
	@kubectl port-forward -n $(NAMESPACE) service/frontend-service 8080:80 &
	@wait

debug: ## Debug des pods en erreur
	@echo "🔍 Debug des pods en erreur..."
	@kubectl get pods -n $(NAMESPACE) --field-selector=status.phase!=Running -o name | while read pod; do \
		echo "--- Debug de $$pod ---"; \
		kubectl describe $$pod -n $(NAMESPACE); \
		kubectl logs $$pod -n $(NAMESPACE) --tail=20; \
		echo ""; \
	done