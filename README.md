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
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=your_secure_wordpress_password
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
 
# Prérequis d'installation

Avant d'exécuter le projet, assurez-vous d'avoir installé les éléments suivants :

## Système d'exploitation
- **Windows** : Windows 10/11 Pro, Enterprise ou Education (requis pour Docker Desktop)
- **macOS** : macOS 11 (Big Sur) ou version ultérieure
- **Linux** : Toute distribution récente (Ubuntu 20.04+, Debian 10+, Fedora 30+, etc.)

## Installation détaillée des dépendances

### 1. Docker

#### Windows & macOS
- Télécharger **Docker Desktop** depuis : https://www.docker.com/products/docker-desktop
- Installer en suivant l'assistant
- Vérifier l'installation :
```bash
docker --version
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker $USER
newgrp docker
```

#### Linux (Fedora/RHEL)
```bash
sudo dnf install -y docker docker-compose
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Docker Compose

#### Windows & macOS
Docker Compose est inclus dans Docker Desktop.

#### Linux (si non installé)
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Vérifier l'installation :
```bash
docker compose version
```

### 3. Git

#### Windows
- Télécharger depuis : https://git-scm.com/download/win
- Installer avec les paramètres par défaut

#### macOS
```bash
brew install git
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get install -y git
```

#### Linux (Fedora/RHEL)
```bash
sudo dnf install -y git
```

Vérifier l'installation :
```bash
git --version
```

### 4. Outils supplémentaires recommandés

#### MySQL Client (optionnel, pour tests)
```bash
# Ubuntu/Debian
sudo apt-get install -y mysql-client

# macOS
brew install mysql-client

# Fedora/RHEL
sudo dnf install -y mysql
```

#### cURL (pour tester les requêtes HTTP/HTTPS)
```bash
# Ubuntu/Debian
sudo apt-get install -y curl

# macOS
brew install curl

# Fedora/RHEL
sudo dnf install -y curl
```

#### Text Editor/IDE
- **VS Code** : https://code.visualstudio.com/
- **Sublime Text** : https://www.sublimetext.com/
- **Vim/Nano** : Inclus dans la plupart des distributions

---

# Installation

## 1. Cloner le projet

```bash
git clone https://github.com/kleihr/ProjetDocker.git
cd ProjetDocker
```

## 2. Créer le fichier `.env`

Copier le fichier modèle `.env.example` en `.env` :

```bash
cp .env.example .env
```

Éditer le fichier `.env` avec vos identifiants :

```bash
nano .env
# ou avec votre éditeur préféré
code .env
```

### Contenu du fichier `.env`

```env
# MySQL Configuration
MYSQL_ROOT_PASSWORD=RootSecurePassword123!
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=WordPressSecurePass456!

# Nginx Configuration
NGINX_PORT_HTTP=80
NGINX_PORT_HTTPS=443

# Service Configuration
COMPOSE_PROJECT_NAME=projet-docker
```

## 3. Vérifier les prérequis

```bash
docker --version
docker compose version
git --version
```

## 4. Vérifier la structure des fichiers

Assurez-vous que les fichiers SSL existent :

```bash
ls -la app/nginx/ssl/
# Devrait afficher : server.crt et server.key
```

Si les certificats n'existent pas, générer des certificats auto-signés :

```bash
mkdir -p app/nginx/ssl
openssl req -x509 -newkey rsa:4096 -keyout app/nginx/ssl/server.key -out app/nginx/ssl/server.crt -days 365 -nodes -subj "/CN=localhost"
```

## 5. Démarrer l'infrastructure

### Démarrage complet
```bash
docker compose -f docker-compose.prod.yml up -d
```

### Vérifier le statut des conteneurs
```bash
docker ps
```

Résultat attendu :
```
CONTAINER ID   IMAGE                      STATUS              NAMES
xxxxxxxx       projet-docker-nginx:latest Up 2 minutes        projet-docker-nginx-1
yyyyyyyy       projet-docker-mysql:latest Up 2 minutes        projet-docker-mysql-1
```

### Afficher les logs
```bash
docker compose -f docker-compose.prod.yml logs -f
```

### Arrêter l'infrastructure
```bash
docker compose -f docker-compose.prod.yml down
```

---

# Identifiants et Accès

## Accès à l'application web

Une fois les conteneurs démarrés :

```text
https://localhost
```

> Le certificat SSL étant autosigné, un avertissement de sécurité du navigateur peut apparaître. Il suffit d'accepter l'exception de sécurité pour poursuivre.

## Identifiants MySQL

### Accès MySQL depuis un conteneur
```bash
docker exec -it projet-docker-mysql-1 mysql -u root -p
```

Mot de passe root : `RootSecurePassword123!` (à remplacer par votre valeur dans `.env`)

### Identifiants utilisateur dédié
- **Utilisateur** : `wordpress`
- **Mot de passe** : `WordPressSecurePass456!` (à remplacer par votre valeur dans `.env`)
- **Base de données** : `wordpress`

### Se connecter avec l'utilisateur dédié
```bash
docker exec -it projet-docker-mysql-1 mysql -u wordpress -p wordpress
```

## Identifiants Nginx

Nginx n'a pas d'authentification directe sur le reverse proxy. Cependant :

- **Adresse** : https://localhost
- **Ports** :
  - Port 80 (HTTP) - redirige automatiquement vers HTTPS
  - Port 443 (HTTPS) - accès sécurisé

## Certificat SSL

- **Localisation** : `app/nginx/ssl/`
- **Fichiers** :
  - `server.crt` - Certificat public
  - `server.key` - Clé privée

---

# Tests d'infrastructure

## 1. Tests de démarrage

### Vérifier que tous les conteneurs sont actifs
```bash
docker ps
```

**Résultat attendu** : Deux conteneurs en cours d'exécution (nginx et mysql)

### Vérifier les logs d'erreur
```bash
docker compose -f docker-compose.prod.yml logs
```

**Résultat attendu** : Pas d'erreurs critiques

## 2. Tests de connectivité Nginx

### Test du reverse proxy HTTP
```bash
curl -i http://localhost
```

**Résultat attendu** : Redirection HTTP/301 vers HTTPS

### Test du reverse proxy HTTPS
```bash
curl -k -i https://localhost
```

**Résultat attendu** : Réponse 200 OK ou la page de Nginx/Application

### Test avec verbose (affiche les headers)
```bash
curl -k -v https://localhost
```

### Vérifier les ports ouvertes
```bash
# Linux/macOS
lsof -i :80
lsof -i :443

# Windows PowerShell
netstat -ano | findstr :80
netstat -ano | findstr :443
```

## 3. Tests de connectivité MySQL

### Vérifier que MySQL répond sur le réseau Docker
```bash
docker exec projet-docker-nginx-1 ping projet-docker-mysql-1
```

**Résultat attendu** : Réponse PING positive

### Tester la connexion MySQL depuis le conteneur Nginx
```bash
docker exec projet-docker-nginx-1 mysql -h projet-docker-mysql-1 -u wordpress -p -e "SELECT 1;"
```

**Résultat attendu** : Affiche `1` sans erreurs

### Connexion directe à MySQL
```bash
docker exec -it projet-docker-mysql-1 mysql -u root -p
```

Une fois connecté, exécuter :
```sql
SHOW DATABASES;
SELECT User FROM mysql.user;
USE wordpress;
SHOW TABLES;
EXIT;
```

## 4. Tests du réseau Docker

### Vérifier le réseau projet-network
```bash
docker network ls
docker network inspect projet-docker_projet-network
```

**Résultat attendu** : Le réseau Docker existe et contient les deux conteneurs

### Test de communication inter-conteneurs
```bash
docker exec projet-docker-nginx-1 curl -k https://localhost
```

## 5. Tests des volumes

### Vérifier la persistance des données
```bash
docker volume ls
docker volume inspect projet-docker_mysql_data
```

### Tester la persistance
```bash
# Créer une table test
docker exec -it projet-docker-mysql-1 mysql -u wordpress -p wordpress -e "CREATE TABLE test (id INT);"

# Arrêter les conteneurs
docker compose -f docker-compose.prod.yml down

# Redémarrer les conteneurs
docker compose -f docker-compose.prod.yml up -d

# Vérifier que la table existe toujours
docker exec -it projet-docker-mysql-1 mysql -u wordpress -p wordpress -e "SHOW TABLES;"
```

**Résultat attendu** : La table `test` existe toujours après le redémarrage

## 6. Tests de sécurité

### Vérifier que MySQL n'est pas exposé publiquement
```bash
# Devrait échouer si le port n'est pas exposé
mysql -h localhost -u root -p
```

**Résultat attendu** : Erreur de connexion (port 3306 non exposé)

### Vérifier les certificats SSL
```bash
# Afficher les informations du certificat
openssl x509 -in app/nginx/ssl/server.crt -text -noout
```

### Vérifier server_tokens off dans Nginx
```bash
curl -k -i https://localhost | grep -i "Server:"
```

**Résultat attendu** : Header "Server:" absent ou minimal

## 7. Tests de déploiement automatisé

### Exécuter le script de déploiement
```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

**Résultat attendu** : Vérification des prérequis et démarrage automatique

### Initialiser la base de données
```bash
chmod +x scripts/init-db.sh
./scripts/init-db.sh
```

## 8. Checklist de vérification complète

- [ ] Docker est installé et actif (`docker --version`)
- [ ] Docker Compose est installé (`docker compose version`)
- [ ] Git est installé (`git --version`)
- [ ] Fichier `.env` créé avec les identifiants configurés
- [ ] Certificats SSL existent dans `app/nginx/ssl/`
- [ ] Tous les conteneurs démarrent avec `docker ps`
- [ ] Nginx répond sur https://localhost (avec certificat accepté)
- [ ] MySQL accepte les connexions avec les identifiants `.env`
- [ ] Le volume MySQL persiste après `docker compose down` et `up`
- [ ] Les logs ne contiennent pas d'erreurs critiques
- [ ] Le port 3306 n'est pas exposé publiquement

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

# Commandes utiles

## Gestion des conteneurs
```bash
# Voir les conteneurs actifs
docker ps

# Voir tous les conteneurs
docker ps -a

# Afficher les logs
docker compose -f docker-compose.prod.yml logs -f

# Logs d'un service spécifique
docker compose -f docker-compose.prod.yml logs -f mysql
docker compose -f docker-compose.prod.yml logs -f nginx

# Accéder au shell d'un conteneur
docker exec -it projet-docker-mysql-1 bash
docker exec -it projet-docker-nginx-1 bash
```

## Gestion des volumes
```bash
# Lister les volumes
docker volume ls

# Supprimer un volume
docker volume rm projet-docker_mysql_data

# Inspecter un volume
docker volume inspect projet-docker_mysql_data
```

## Gestion du réseau
```bash
# Lister les réseaux
docker network ls

# Inspecter un réseau
docker network inspect projet-docker_projet-network
```

## Nettoyer l'infrastructure
```bash
# Arrêter tous les conteneurs
docker compose -f docker-compose.prod.yml down

# Arrêter et supprimer les volumes (attention : données perdues)
docker compose -f docker-compose.prod.yml down -v

# Supprimer toutes les images non utilisées
docker image prune

# Nettoyer complètement (conteneurs, images, réseaux non utilisés)
docker system prune -a
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
