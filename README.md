# Projet Docker - Infrastructure, WordPress et Monitoring

## Auteurs

- **kleihr** - Infrastructure (https://github.com/kleihr)
- **adskkn** - Monitoring (https://github.com/adskkn)
- **MateoGrgic** - WordPress (https://github.com/MateoGrgic)

---

## Description

Ce projet a été réalisé dans le cadre d'un laboratoire d'apprentissage Docker.

L'objectif est de déployer une infrastructure complète composée de :

- Nginx comme reverse proxy HTTPS
- WordPress comme application web
- MySQL comme base de données
- Prometheus pour la collecte des métriques
- Grafana pour la visualisation des données

L'ensemble des services est orchestré à l'aide de Docker Compose.

---

# Architecture du projet

```text
Utilisateur
     │
     ▼
   Nginx (HTTPS)
     │
     ▼
  WordPress
     │
     ▼
    MySQL

Grafana ─────► Prometheus
```

---

# Structure du projet

```text
ProjetDocker/
│
├── app/
│   ├── nginx/
│   └── wordpress/
│
├── config/
│   ├── mysql/
│   └── wordpress/
│
├── docker/
│   ├── nginx/
│   ├── mysql/
│   └── wordpress/
│
├── grafana/
├── prometheus/
├── scripts/
│
├── .env.example
├── .gitignore
├── docker-compose.yml
├── docker-compose.prod.yml
└── README.md
```

---

# Services

## Nginx

Nginx joue le rôle de reverse proxy.

Fonctionnalités :

- Redirection HTTP vers HTTPS
- Gestion du certificat SSL
- Reverse proxy vers WordPress
- Masquage de la version du serveur

Fichier de configuration :

```text
app/nginx/default.conf
```

---

## WordPress

WordPress constitue l'application web principale du projet.

Fonctionnalités :

- Utilisation des variables d'environnement pour la connexion à la base de données
- Stockage des thèmes et plugins dans `wp-content`
- Intégration avec MySQL

Dockerfile :

```text
docker/wordpress/Dockerfile
```

---

## MySQL

MySQL assure le stockage des données de WordPress.

Fonctionnalités :

- Configuration personnalisée via `my.cnf`
- Volume persistant Docker
- Utilisation d'un utilisateur dédié à l'application

Configuration :

```text
config/mysql/my.cnf
```

---

## Prometheus

Prometheus collecte les métriques de supervision.

Configuration :

```text
prometheus/prometheus.yml
```

Accès :

```text
http://localhost:9090
```

---

## Grafana

Grafana permet la visualisation des métriques collectées par Prometheus.

Accès :

```text
http://localhost:3000
```

---

# Variables d'environnement

Pour des raisons de sécurité, le fichier `.env` n'est pas présent dans le dépôt.

Créer un fichier :

```text
.env
```

à partir du modèle :

```text
.env.example
```

Exemple :

```env
MYSQL_ROOT_PASSWORD=R00t!2026_Docker
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=WP!2026_Database
```

---

# Certificats SSL

Les certificats SSL locaux ne sont pas inclus dans le dépôt.

Créer les certificats :

```bash
openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout app/nginx/ssl/server.key \
-out app/nginx/ssl/server.crt
```

Exemple de configuration :

```text
Country Name: CH
State or Province Name: Vaud
Locality Name: Lausanne
Organization Name: Projet Docker
Organizational Unit Name: Infrastructure
Common Name: localhost
```

---

# Lancement du projet

## Développement

```bash
docker compose up -d
```

## Production

```bash
docker compose -f docker-compose.prod.yml up -d
```

---

# Vérification

Afficher les conteneurs :

```bash
docker ps
```

Les services suivants doivent être actifs :

```text
nginx
mysql
wordpress
prometheus
grafana
```

---

# Accès aux services

## WordPress

```text
https://localhost
```

ou

```text
https://projetdocker.local
```

selon la configuration utilisée.

## Grafana

```text
http://localhost:3000
```

## Prometheus

```text
http://localhost:9090
```

---

# Sécurité

Les mesures suivantes ont été implémentées :

- HTTPS avec certificat SSL
- Reverse proxy Nginx
- Variables d'environnement pour les secrets
- Réseau Docker privé
- Volume persistant pour MySQL
- Compte MySQL dédié à l'application
- Masquage de la version Nginx (`server_tokens off`)
- Redémarrage automatique des services
- Option Docker `no-new-privileges`

---

# Déploiement automatisé

Le script :

```text
scripts/deploy.sh
```

permet d'automatiser :

- la vérification de Docker ;
- la création des volumes ;
- la construction des images ;
- le démarrage des services.

Exécution :

```bash
./scripts/deploy.sh
```

---

# Conclusion

Ce projet met en œuvre une architecture conteneurisée complète reposant sur Docker et Docker Compose.

L'environnement intègre :

- une couche applicative WordPress ;
- une base de données MySQL persistante ;
- un reverse proxy Nginx en HTTPS ;
- un système de supervision basé sur Prometheus et Grafana ;
- plusieurs bonnes pratiques de sécurité adaptées à un environnement de laboratoire et d'apprentissage.