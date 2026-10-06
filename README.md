# Infrastructure Docker - Projet Docker

## Auteur
- shimestu - Chef de Projet **Infrastrucutre**
    [shimestu ](https://github.com/shimetsu) 

## Description
 
Cette partie du projet est dédiée à l'infrastructure Docker. Elle a pour objectif de fournir un environnement sécurisé et reproductible permettant d'héberger les différents services de l'application.
 
L'infrastructure repose principalement sur :
 
- Nginx comme reverse proxy HTTPS
- MySQL comme système de gestion de base de données
- Docker Compose pour l'orchestration des conteneurs
- Docker Volumes pour la persistance des données
- Variables d'environnement pour la gestion de la configuration
- Réseau Docker privé pour l'isolation des services
 
---
 
# Structure des dossiers
 
```text
ProjetDocker/
│
├── app/
│ └── nginx/
│ ├── default.conf
│ └── ssl/
│ ├── server.crt
│ └── server.key
│
├── config/
│ └── mysql/
│ └── my.cnf
│
├── docker/
│ └── mysql/
│ └── Dockerfile
│ └── nginx/
│ └── Dockerfile
│
├── scripts/
│ └── deploy.sh
│ └── init-db.sh
│
├── .env.example
├── .env
├── .gitignore
├── docker-compose.prod.yml
└── README.md
```
 
---
 
# Composants de l'infrastructure
 
## Nginx
 
Nginx est utilisé comme reverse proxy.
 
Son rôle est de :
 
- recevoir les requêtes des utilisateurs ;
- gérer le protocole HTTPS ;
- rediriger les requêtes vers les services de l'application ;
- centraliser l'accès à l'application.
 
Le fichier de configuration se trouve ici :
 
```text
app/nginx/default.conf
```
 
---
 
## HTTPS
 
Le projet utilise un certificat SSL autosigné.
 
Les fichiers SSL sont stockés dans :
 
```text
app/nginx/ssl/
```
 
Fichiers :
 
```text
server.crt
server.key
```
 
Nginx écoute sur :
 
```text
Port 80 -> HTTP
Port 443 -> HTTPS
```
 
Une redirection automatique HTTP → HTTPS est configurée.
 
---
 
## MySQL
 
La base de données utilise l'image officielle MySQL.
 
Configuration personnalisée :
 
```text
config/mysql/my.cnf
```
 
Objectifs :
 
- personnalisation du serveur MySQL ;
- limitation de certaines fonctionnalités ;
- configuration centralisée.
 
---
 
# Docker Compose
 
L'orchestration des services est réalisée avec :
 
```text
docker-compose.prod.yml
```
 
Services gérés :
 
```yaml
mysql
nginx
```
 
Docker Compose permet :
 
- le déploiement automatisé ;
- la création des réseaux ;
- la gestion des volumes ;
- le démarrage simultané des services.
 
Lancement :
 
```bash
docker compose -f docker-compose.prod.yml up -d
```
 
Arrêt :
 
```bash
docker compose -f docker-compose.prod.yml down
```
 
---
 
# Réseau Docker
 
Un réseau privé Docker est utilisé :
 
```yaml
projet-network
```
 
Objectifs :
 
- isoler les services ;
- permettre la communication entre conteneurs ;
- éviter l'exposition inutile des services.
 
---
 
# Persistance des données
 
Les données MySQL sont stockées dans un volume Docker :
 
```yaml
mysql_data
```
 
Cela permet de conserver les données même après :
 
```bash
docker compose down
```
 
Le volume est automatiquement réutilisé lors du redémarrage des conteneurs.
 
---
 
# Variables d'environnement
 
Les informations sensibles ne sont pas stockées directement dans le dépôt.
 
Fichier utilisé :
 
```text
.env
```
 
Variables configurées :
 
```env
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=
```
 
Le fichier `.env` est ignoré par Git :
 
```gitignore
.env
```
 
Un fichier modèle est fourni :
 
```text
.env.example
```
 
afin de permettre à tout utilisateur de recréer son propre fichier `.env`.
 
---
 
# Bonnes pratiques de sécurité mises en place
 
Les mesures de sécurité suivantes ont été implémentées :
 
## HTTPS
 
- chiffrement des communications ;
- certificat SSL configuré dans Nginx.
 
## Variables d'environnement
 
- mots de passe stockés hors du fichier de configuration principal.
 
## Réseau privé Docker
 
- isolation des conteneurs dans un réseau dédié.
 
## MySQL non exposé
 
Le port MySQL n'est pas publié vers l'extérieur :
 
```yaml
3306/tcp
```
 
La base de données n'est accessible que depuis les conteneurs autorisés.
 
## Utilisateur dédié
 
L'application utilise un compte MySQL dédié :
 
```text
wordpress
```
 
et non le compte :
 
```text
root
```
 
## Masquage des informations serveur
 
Nginx est configuré avec :
 
```nginx
server_tokens off;
```
 
afin de ne pas exposer sa version.
 
## Redémarrage automatique
 
Les services utilisent :
 
```yaml
restart: unless-stopped
```
 
afin d'assurer leur disponibilité.
 
---
 
# Déploiement automatisé
 
Le script :
 
```text
scripts/deploy.sh
```
 
permet d'automatiser :
 
- la vérification des prérequis ;
- la création des volumes ;
- la construction des images ;
- le démarrage des conteneurs.
 
Exécution :
 
```bash
./scripts/deploy.sh
```
 
---
 
# Prérequis
 
Avant d'exécuter le projet :
 
- Docker Desktop installé
- Docker Compose installé
 
Vérification :
 
```bash
docker --version
docker compose version
```
 
---
 
# Installation
 
## 1. Cloner le projet
 
```bash
git clone <repository>
```
 
## 2. Créer le fichier `.env`
 
Créer un fichier `.env` à partir du modèle fourni :
 
```text
.env.example
```
 
## 3. Démarrer l'infrastructure
 
```bash
docker compose -f docker-compose.prod.yml up -d
```
 
## 4. Vérifier les conteneurs
 
```bash
docker ps
```
 
---
 
# Accès au projet
 
Une fois les conteneurs démarrés :
 
```text
https://localhost
```
 
> Le certificat SSL étant autosigné, un avertissement de sécurité du navigateur peut apparaître. Il suffit d'accepter l'exception de sécurité pour poursuivre.
 
---
 
# Conclusion
 
Cette infrastructure fournit :
 
- un reverse proxy Nginx sécurisé en HTTPS ;
- une base de données MySQL persistante ;
- une orchestration complète avec Docker Compose ;
- un stockage persistant via Docker Volumes ;
- une configuration sécurisée grâce aux variables d'environnement ;
- plusieurs bonnes pratiques de sécurité Docker adaptées à un environnement de développement et d'apprentissage.
 
Elle constitue la base technique du projet et permet l'intégration des composants WordPress et Monitoring développés dans les autres branches du dépôt.