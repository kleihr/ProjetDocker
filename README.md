# Infrastructure Docker - Projet Docker

## Auteur
- kleihr - Chef de Projet **Infrastrucutre**
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

### Générer un nouveau certificat SSL (si nécessaire)

```bash
# Créer la clé privée et le certificat
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout app/nginx/ssl/server.key \
  -out app/nginx/ssl/server.crt \
  -subj "/C=FR/ST=France/L=Paris/O=ProjetDocker/CN=localhost"

# Définir les permissions
chmod 600 app/nginx/ssl/server.key
chmod 644 app/nginx/ssl/server.crt
```

 
---
 
## MySQL
 
La base de données utilise l'image officielle MySQL 8.0.
 
Configuration personnalisée :
 
```text
config/mysql/my.cnf
```
 
Objectifs :
 
- personnalisation du serveur MySQL ;
- limitation de certaines fonctionnalités ;
- configuration centralisée.

### Accès à MySQL

```bash
# Accéder au shell MySQL depuis le conteneur
docker exec -it projet_docker-mysql-1 mysql -u root -p

# Entrer le mot de passe : root_password_secure_2024
```

### Commandes MySQL utiles

```sql
-- Voir les bases de données
SHOW DATABASES;

-- Utiliser la base de données
USE projet_docker;

-- Lister les utilisateurs
SELECT User, Host FROM mysql.user;

-- Créer un nouvel utilisateur
CREATE USER 'app_user'@'%' IDENTIFIED BY 'app_password_secure_2024';
GRANT ALL PRIVILEGES ON projet_docker.* TO 'app_user'@'%';
FLUSH PRIVILEGES;

-- Vérifier la connexion d'un utilisateur
SHOW GRANTS FOR 'app_user'@'%';
```

 
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

### Commandes Docker Compose utiles

```bash
# Afficher l'état des services
docker compose -f docker-compose.prod.yml ps

# Afficher les logs d'un service spécifique
docker compose -f docker-compose.prod.yml logs mysql
docker compose -f docker-compose.prod.yml logs nginx

# Redémarrer un service
docker compose -f docker-compose.prod.yml restart mysql

# Reconstruire les images
docker compose -f docker-compose.prod.yml build --no-cache

# Exécuter une commande dans un conteneur
docker compose -f docker-compose.prod.yml exec mysql ls -la
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

### Vérifier les volumes

```bash
# Lister tous les volumes Docker
docker volume ls

# Inspecter un volume spécifique
docker volume inspect mysql_data

# Supprimer un volume (attention : données perdues !)
docker volume rm mysql_data
```
 
---
 
# Variables d'environnement
 
Les informations sensibles ne sont pas stockées directement dans le dépôt.
 
Fichier utilisé :
 
```text
.env
```
 
Variables configurées :
 
```env
MYSQL_ROOT_PASSWORD=root_password_secure_2024
MYSQL_DATABASE=projet_docker
MYSQL_USER=app_user
MYSQL_PASSWORD=app_password_secure_2024
NGINX_PORT=80
NGINX_SSL_PORT=443
APP_ENV=production
APP_DEBUG=false
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

# Tests à effectuer

## 1. Vérification des conteneurs

```bash
# Vérifier que tous les conteneurs sont en cours d'exécution
docker compose -f docker-compose.prod.yml ps

# Résultat attendu :
# NAME                     COMMAND                  SERVICE    STATUS
# projet_docker-mysql-1    "docker-entrypoint.s…"   mysql      Up (healthy)
# projet_docker-nginx-1    "/docker-entrypoint.…"   nginx      Up
```

## 2. Test de connectivité Nginx

```bash
# Test en HTTP (doit rediriger vers HTTPS)
curl -I http://localhost

# Test en HTTPS (accepter le certificat autosigné)
curl -k https://localhost

# Résultat attendu : 200 OK ou page d'accueil
```

## 3. Test de connectivité MySQL

```bash
# Se connecter à MySQL avec le root
docker exec -it projet_docker-mysql-1 mysql -u root -p

# Entrer le mot de passe : root_password_secure_2024
# Vérifier :
SHOW DATABASES;
SELECT VERSION();
EXIT;

# Test depuis l'hôte (si le connecteur MySQL est installé)
mysql -h 127.0.0.1 -u app_user -p projet_docker

# Entrer le mot de passe : app_password_secure_2024
```

## 4. Test des volumes persistants

```bash
# Vérifier que le volume MySQL existe
docker volume ls | grep mysql_data

# Afficher les logs pour vérifier les erreurs
docker compose -f docker-compose.prod.yml logs

# Arrêter et redémarrer pour vérifier la persistance
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d

# Les données doivent être récupérées (vérifier dans MySQL)
```

## 5. Test de sécurité

```bash
# Vérifier que MySQL n'expose pas le port 3306
netstat -tlnp | grep 3306  # Linux
netstat -an | grep 3306     # macOS
netstat -an | findstr 3306  # Windows

# Résultat attendu : pas de résultat ou seulement localhost:3306

# Vérifier les permissions des fichiers SSL
ls -la app/nginx/ssl/

# Résultat attendu : 
# -rw------- 1 user group  1704 Oct  6 10:00 server.key
# -rw-r--r-- 1 user group  1319 Oct  6 10:00 server.crt
```

## 6. Test du certificat SSL

```bash
# Afficher les informations du certificat
openssl x509 -in app/nginx/ssl/server.crt -text -noout

# Vérifier la date d'expiration
openssl x509 -in app/nginx/ssl/server.crt -noout -dates
```

## 7. Test des logs

```bash
# Afficher les logs de tous les services
docker compose -f docker-compose.prod.yml logs

# Afficher les logs en temps réel
docker compose -f docker-compose.prod.yml logs -f

# Afficher les logs d'un service spécifique
docker compose -f docker-compose.prod.yml logs mysql
docker compose -f docker-compose.prod.yml logs nginx
```

## 8. Test de charge (optionnel)

```bash
# Installer Apache Bench (si nécessaire)
# macOS : brew install httpd
# Linux : sudo apt install apache2-utils
# Windows : télécharger depuis Apache HTTP Server

# Test de charge simple (1000 requêtes, 10 concurrentes)
ab -n 1000 -c 10 -k https://localhost/

# Résultat attendu : tous les tests doivent réussir
```

---

# Identifiants et accès

## Accès Nginx/Application

| Protocole | URL | Port |
|-----------|-----|------|
| HTTP | http://localhost | 80 |
| HTTPS | https://localhost | 443 |

> ⚠️ **Note** : Le certificat SSL étant autosigné, un avertissement de sécurité du navigateur peut apparaître. Acceptez l'exception pour poursuivre.

## Accès MySQL

### Depuis le conteneur (ligne de commande)

```bash
docker exec -it projet_docker-mysql-1 mysql -u root -p
```

**Identifiant root** :
- Utilisateur : `root`
- Mot de passe : `root_password_secure_2024`
- Port : `3306` (interne au conteneur, non exposé)

### Pour l'application

**Identifiant application** :
- Utilisateur : `app_user`
- Mot de passe : `app_password_secure_2024`
- Base de données : `projet_docker`
- Hôte : `mysql` (depuis le conteneur)
- Port : `3306`

### Depuis un outil graphique (Workbench, DBeaver, etc.)

> ⚠️ **ATTENTION** : MySQL n'est pas exposé vers l'extérieur. Pour accéder depuis un outil graphique en dehors du conteneur, vous devez modifier le `docker-compose.prod.yml` et ajouter une exposition du port (NON RECOMMANDÉ en production) :

```yaml
mysql:
  ports:
    - "3306:3306"  # À ajouter temporairement pour les tests
```

Puis relancer :
```bash
docker compose -f docker-compose.prod.yml up -d
```

**Connexion** :
- Hôte : `127.0.0.1` ou `localhost`
- Utilisateur : `app_user`
- Mot de passe : `app_password_secure_2024`
- Base de données : `projet_docker`

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
