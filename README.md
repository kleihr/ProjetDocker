#  Documentation - Partie Monitoring

## Vue d'ensemble

Cette partie du projet a pour objectif de surveiller le bon fonctionnement de l'application et de son infrastructure Docker. Elle permet de suivre les performances, la disponibilité, et l'état des services via des outils spécialisés.

Le monitoring de ce projet repose principalement sur :

- Prometheus : collecte et stockage des métriques
- Grafana : visualisation des métriques dans des tableaux de bord
- Docker : orchestration et exécution des services

---

##  Architecture du monitoring

Le monitoring est structuré autour de plusieurs composants :

```text
monitoring/
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   ├── dashboards/
│   └── datasources/

```

### Rôle de chaque service

- Prometheus : collecte des métriques depuis les services exposés
- Grafana : création de dashboards et visualisation des données
- Docker Compose : lancement des services ensemble

---

##  Démarrage rapide

### Prérequis

Avant de lancer le monitoring, vérifiez que vous avez :

- Docker installé
- Docker Compose installé
- Les ports suivants libres :
  - 9090 pour Prometheus
  - 3000 pour Grafana

### Lancer le monitoring

Depuis la racine du projet :

```bash
docker-compose up -d
```

Ou, si le monitoring est séparé dans un dossier dédié :

```bash
cd monitoring
docker-compose up -d
```

### Vérifier les services

```bash
docker-compose ps
```

### Accéder aux interfaces

- Prometheus : http://localhost:9090
- Grafana : http://localhost:3000

---

## ⚙️ Prometheus

### Objectif

Prometheus est utilisé pour collecter les métriques du système et des applications. Il interroge régulièrement les endpoints de santé ou de métriques exposés par les services.

### Fichier de configuration

Le fichier principal est :

```yaml
prometheus/prometheus.yml
```

Il contient notamment :

- la fréquence de collecte (`scrape_interval`)
- les cibles à surveiller (`targets`)
- les jobs Prometheus

Exemple de configuration :

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
```

### Vérification de la configuration

```bash
docker exec -it prometheus promtool check config /etc/prometheus/prometheus.yml
```

### Vérifier les cibles actives

Dans l’interface Prometheus, ouvrez :

- Status
- Targets

Cela permet de voir si les services surveillés sont bien accessibles.

---

##  Grafana

### Objectif

Grafana permet de visualiser les métriques collectées par Prometheus au travers de dashboards. Il s’agit de la partie la plus utile pour le suivi visuel de l’infra et des services.

### Accès par défaut

- URL : http://localhost:3000
- Login : admin
- Mot de passe : admin

### Configuration

Il faut ajouter Prometheus comme source de données :

1. Ouvrir Grafana
2. Aller dans Configuration > Sources de données
3. Ajouter une source Prometheus
4. Entrer l’URL de Prometheus : `http://prometheus:9090`
5. Enregistrer

### Dashboard recommandé

Les dashboards peuvent contenir :

- CPU / mémoire
- utilisation du disque
- trafic réseau
- latence des services
- nombre de requêtes HTTP
- erreurs et taux de réponse

---


##  Bonnes pratiques de monitoring

Pour que le monitoring soit efficace, il est conseillé d’ajouter :

- des métriques de santé par service
- des alertes sur la disponibilité
- des seuils de CPU, mémoire et disque
- des métriques sur les requêtes HTTP
- des logs centralisés

Exemples de métriques utiles :

- `up`
- `process_cpu_seconds_total`
- `node_memory_MemAvailable_bytes`
- `http_requests_total`
- `http_request_duration_seconds`

---

##  Vérification du bon fonctionnement

### Contrôler les services Docker

```bash
docker ps
```

### Vérifier les logs

```bash
docker-compose logs -f
```

### Vérifier Prometheus

- Charger la page d’accueil Prometheus
- Vérifier que les jobs sont en `UP`
- Vérifier les cibles dans l’onglet `Targets`

### Vérifier Grafana

- Connecter Grafana
- Vérifier que la source de données est active
- Charger ou créer un dashboard

---

## Dépannage rapide

### Prometheus ne démarre pas

Vérifier la configuration :

```bash
docker-compose logs prometheus
```

### Grafana ne répond pas

```bash
docker-compose logs grafana
```

### Aucune donnée visible

Vérifier :

- la source de données Prometheus
- les cibles dans `Targets`
- les ports exposés
- la configuration `prometheus.yml`

---

##  Fichiers importants

- `monitoring/docker-compose.yml` : lancement des services
- `monitoring/prometheus/prometheus.yml` : configuration Prometheus
- `monitoring/grafana/datasources/` : configuration des sources de données
- `monitoring/grafana/dashboards/` : dashboards Grafana


---

##  Objectif final

La partie monitoring permet d’avoir une vue claire sur l’état de l’application et de l’infrastructure. Grâce à Prometheus et Grafana, il est possible de surveiller les performances, détecter les anomalies et réagir rapidement aux incidents.

---

## Auteur

Projet Docker - Partie Monitoring
