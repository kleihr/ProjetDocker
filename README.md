# Infrastructure Docker - Projet Docker

## Auteur
- kleihr - Chef de Projet **Infrastructure**
    [kleihr ](https://github.com/kleihr) 

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
│ ├── server.crt.example
│ └── server.key.example
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
├── .gitignore
├── docker-compose.yml
└── README.md
```
 
---

# Prérequis - Installation des outils nécessaires

Avant d'exécuter le projet, vous devez installer les outils suivants :

## 1. Docker Desktop (contient Docker et Docker Compose)

### Sur Windows
- Télécharger [Docker Desktop pour Windows](https://www.docker.com/products/docker-desktop)
- Installer l'exécutable téléchargé
- Redémarrer votre ordinateur
- Activer WSL 2 (Windows Subsystem for Linux 2) si demandé
- Vérifier l'installation :
```bash
docker --version
docker compose version
```

### Sur macOS
- Télécharger [Docker Desktop pour Mac](https://www.docker.com/products/docker-desktop)
- Double-cliquer sur le fichier `.dmg`
- Glisser-déposer Docker dans Applications
- Lancer Docker depuis Applications
- Vérifier l'installation :
```bash
docker --version
docker compose version
```

### Sur Linux (Ubuntu/Debian)
```bash
# Mettre à jour les paquets
sudo apt update
sudo apt upgrade -y

# Installer Docker
sudo apt install -y docker.io

# Installer Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Ajouter l'utilisateur actuel au groupe docker (pour éviter sudo)
sudo usermod -aG docker $USER
newgrp docker

# Vérifier l'installation
docker --version
docker compose version
```

## 2. Git

### Sur Windows
- Télécharger [Git pour Windows](https://git-scm.com/download/win)
- Installer avec les paramètres par défaut
- Vérifier :
```bash
git --version
```

### Sur macOS
```bash
brew install git
git --version
```

### Sur Linux
```bash
sudo apt install -y git
git --version
```

---

# Installation du projet

## 1. Cloner le projet

```bash
git clone https://github.com/kleihr/ProjetDocker.git
cd ProjetDocker
git checkout infrastructure
```

## 2. Créer le fichier `.env`

Copier le fichier `.env.example` vers `.env` :

```bash
cp .env.example .env
```

### Configuration du fichier `.env`

Éditer le fichier `.env` avec les valeurs suivantes :

```env
# Configuration MySQL
MYSQL_ROOT_PASSWORD=root_password_secure_2024
MYSQL_DATABASE=projet_docker
MYSQL_USER=app_user
MYSQL_PASSWORD=app_password_secure_2024

# Configuration Nginx
NGINX_PORT=80
NGINX_SSL_PORT=443

# Configuration application
APP_ENV=production
APP_DEBUG=false
```

**IMPORTANT** : À REMPLACER AVEC VOS PROPRES MOTS DE PASSE FORTS !

### Recommandations de sécurité pour les mots de passe
- Minimum 16 caractères
- Inclure majuscules, minuscules, chiffres et caractères spéciaux
- Ne jamais utiliser de mots de passe faibles ou faciles à deviner
- Exemple de mots de passe sécurisés :
  - `X7k#mP2@9qL$vR4wN`
  - `Secur3P@ssw0rd!2024`

## 3. Vérifier les prérequis

```bash
# Vérifier Docker
docker --version

# Vérifier Docker Compose
docker compose version

# Vérifier Git
git --version
```

## 4. Construire et démarrer l'infrastructure

```bash
# Démarrer tous les services (construction + lancement)
docker compose -f docker-compose.prod.yml up -d --build

# Afficher les logs en temps réel
docker compose -f docker-compose.prod.yml logs -f

# Arrêter les services
docker compose -f docker-compose.prod.yml down

# Arrêter et supprimer les volumes (ATTENTION : données perdues !)
docker compose -f docker-compose.prod.yml down -v
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
app_user
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

# Dépannage et résolution de problèmes

## Le service MySQL ne démarre pas

```bash
# Vérifier les logs
docker compose -f docker-compose.prod.yml logs mysql

# Possible causes :
# 1. Mot de passe root mal configuré dans .env
# 2. Le volume est corrompu
# 3. Port 3306 déjà utilisé

# Solution : Supprimer le volume et recommencer
docker volume rm mysql_data
docker compose -f docker-compose.prod.yml up -d --build
```

## Erreur de certificat SSL

```bash
# Régénérer les certificats
rm -rf app/nginx/ssl/
mkdir -p app/nginx/ssl/

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout app/nginx/ssl/server.key \
  -out app/nginx/ssl/server.crt \
  -subj "/C=FR/ST=France/L=Paris/O=ProjetDocker/CN=localhost"

# Redémarrer Nginx
docker compose -f docker-compose.prod.yml restart nginx
```

## Le fichier .env n'est pas lu

```bash
# Vérifier le fichier
cat .env

# Vérifier que le fichier n'est pas vide
test -s .env && echo "Le fichier .env existe et n'est pas vide" || echo "Le fichier .env est vide"

# Redémarrer les services
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d
```

## Les conteneurs consomment trop de ressources

```bash
# Vérifier l'utilisation des ressources
docker stats

# Limiter les ressources (à modifier dans docker-compose.prod.yml)
# Ajouter sous chaque service :
# deploy:
#   resources:
#     limits:
#       cpus: '0.5'
#       memory: 512M
#     reservations:
#       cpus: '0.25'
#       memory: 256M

docker compose -f docker-compose.prod.yml up -d
```

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
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

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

---

**Dernière mise à jour** : 6 octobre 2024
**Mainteneur** : kleihr
