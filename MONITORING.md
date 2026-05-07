# 📊 Guide de Monitoring avec Prometheus et Grafana

## 🎯 Vue d'ensemble

Ce projet utilise :
- **Prometheus** : Collecte des métriques des services
- **Grafana** : Visualisation des métriques
- **Actuator** : Expose les métriques de chaque service Spring Boot
- **Micrometer** : Format des métriques compatible Prometheus

---

## 📦 Services Monitorés

| Service | Port | Endpoint Prometheus |
|---------|------|---------------------|
| Eureka Server | 8761 | http://localhost:8761/actuator/prometheus |
| API Gateway | 8888 | http://localhost:8888/actuator/prometheus |
| AI Service | 8090 | http://localhost:8090/actuator/prometheus |
| Quiz-Feedback | 8089 | http://localhost:8089/actuator/prometheus |

---

## 🚀 Démarrage avec Docker Compose

### 1. Démarrer tous les services + Monitoring

```powershell
cd FrontOffice-main
docker-compose up -d
```

Cela démarre :
- ✅ Tous les microservices (Eureka, Gateway, AI, Quiz-Feedback)
- ✅ MySQL
- ✅ SonarQube + PostgreSQL
- ✅ **Prometheus** (port 9090)
- ✅ **Grafana** (port 3000)

### 2. Vérifier que tout fonctionne

```powershell
# Vérifier les conteneurs
docker ps

# Voir les logs
docker logs prometheus
docker logs grafana
```

---

## 📊 Accéder aux Interfaces

### Prometheus
- **URL** : http://localhost:9090
- **Pas de login requis**

### Grafana
- **URL** : http://localhost:3000
- **Username** : `admin`
- **Password** : `admin`

### Services
- **Eureka Dashboard** : http://localhost:8761
- **SonarQube** : http://localhost:9000

---

## 🔧 Configuration Prometheus

### Pour Docker (Vagrant VM)

Le fichier `prometheus.yml` utilise l'IP de votre VM Vagrant :

```yaml
scrape_configs:
  - job_name: 'eureka-server'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['192.168.56.10:8761']
```

### Pour Local (Développement)

Le fichier `prometheus-local.yml` utilise localhost :

```yaml
scrape_configs:
  - job_name: 'eureka-server'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['localhost:8761']
```

---

## 📈 Configurer Grafana

### 1. Ajouter Prometheus comme Data Source

1. Ouvrir Grafana : http://localhost:3000
2. Login : `admin` / `admin`
3. Aller dans **Configuration** → **Data Sources**
4. Cliquer **Add data source**
5. Sélectionner **Prometheus**
6. Configurer :
   - **URL** : `http://prometheus:9090` (si Docker) ou `http://localhost:9090` (si local)
   - Cliquer **Save & Test**

### 2. Importer un Dashboard Spring Boot

1. Aller dans **Dashboards** → **Import**
2. Entrer l'ID du dashboard : **11378** (Spring Boot 2.1 Statistics)
3. Ou utiliser l'ID : **4701** (JVM Micrometer)
4. Sélectionner la data source **Prometheus**
5. Cliquer **Import**

### 3. Dashboards Recommandés

| Dashboard | ID | Description |
|-----------|----|----|
| Spring Boot Statistics | 11378 | Métriques Spring Boot complètes |
| JVM Micrometer | 4701 | Métriques JVM détaillées |
| Spring Boot APM | 12900 | Application Performance Monitoring |

---

## 🔍 Requêtes Prometheus Utiles

### Métriques JVM

```promql
# Utilisation mémoire heap
jvm_memory_used_bytes{area="heap"}

# Threads actifs
jvm_threads_live_threads

# CPU usage
process_cpu_usage
```

### Métriques HTTP

```promql
# Nombre de requêtes HTTP
http_server_requests_seconds_count

# Temps de réponse moyen
rate(http_server_requests_seconds_sum[5m]) / rate(http_server_requests_seconds_count[5m])

# Requêtes par seconde
rate(http_server_requests_seconds_count[1m])
```

### Métriques Eureka

```promql
# Services enregistrés
eureka_server_registry_size

# Heartbeats reçus
rate(eureka_server_heartbeats_received_total[1m])
```

---

## 🎨 Créer un Dashboard Personnalisé

### 1. Créer un nouveau Dashboard

1. Cliquer sur **+** → **Dashboard**
2. Cliquer **Add new panel**

### 2. Exemples de Panels

#### Panel 1 : Requêtes HTTP par Service

```promql
sum by (application) (rate(http_server_requests_seconds_count[5m]))
```

#### Panel 2 : Utilisation Mémoire

```promql
jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} * 100
```

#### Panel 3 : Temps de Réponse P95

```promql
histogram_quantile(0.95, sum by (le, application) (rate(http_server_requests_seconds_bucket[5m])))
```

---

## 🚨 Alertes Prometheus

Créer un fichier `alerts.yml` :

```yaml
groups:
  - name: microservices
    interval: 30s
    rules:
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.job }} is down"
          description: "{{ $labels.job }} has been down for more than 1 minute."

      - alert: HighMemoryUsage
        expr: (jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"}) > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.application }}"
          description: "Memory usage is above 90% for more than 5 minutes."

      - alert: HighResponseTime
        expr: histogram_quantile(0.95, sum by (le, application) (rate(http_server_requests_seconds_bucket[5m]))) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time on {{ $labels.application }}"
          description: "95th percentile response time is above 1 second."
```

---

## 🐳 Démarrage Local (Sans Docker)

### 1. Installer Prometheus

**Windows :**
```powershell
# Télécharger depuis https://prometheus.io/download/
# Extraire dans C:\prometheus

# Copier la config
cp prometheus-local.yml C:\prometheus\prometheus.yml

# Démarrer
cd C:\prometheus
.\prometheus.exe
```

### 2. Installer Grafana

**Windows :**
```powershell
# Télécharger depuis https://grafana.com/grafana/download
# Installer et démarrer le service
```

---

## 📊 Métriques Disponibles

### Actuator Endpoints

Chaque service expose :

```
/actuator/health       - État de santé
/actuator/info         - Informations du service
/actuator/metrics      - Liste des métriques
/actuator/prometheus   - Métriques format Prometheus
```

### Exemples de Métriques

```
# JVM
jvm.memory.used
jvm.memory.max
jvm.threads.live
jvm.gc.pause

# HTTP
http.server.requests
http.server.requests.active

# Tomcat
tomcat.sessions.active.current
tomcat.threads.busy

# Logback
logback.events

# System
system.cpu.usage
system.load.average.1m
```

---

## 🔧 Dépannage

### Prometheus ne collecte pas les métriques

**Vérifier :**
1. Les services sont démarrés
2. Les endpoints Actuator sont accessibles :
   ```powershell
   curl http://localhost:8761/actuator/prometheus
   ```
3. La configuration Prometheus est correcte
4. Les targets sont "UP" dans Prometheus : http://localhost:9090/targets

### Grafana ne se connecte pas à Prometheus

**Solution :**
- Si Docker : Utiliser `http://prometheus:9090`
- Si Local : Utiliser `http://localhost:9090`

### Pas de données dans Grafana

**Vérifier :**
1. Prometheus collecte bien les données : http://localhost:9090/graph
2. La data source est configurée correctement
3. Le time range dans Grafana est correct (Last 5 minutes)

---

## 📚 Ressources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Micrometer Documentation](https://micrometer.io/docs)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)

---

## 🎯 Checklist de Monitoring

- [ ] Prometheus collecte les métriques de tous les services
- [ ] Grafana est connecté à Prometheus
- [ ] Dashboard Spring Boot importé
- [ ] Alertes configurées (optionnel)
- [ ] Métriques visibles dans Grafana
- [ ] Tous les services apparaissent dans Eureka

---

**Dernière mise à jour :** 7 Mai 2026
