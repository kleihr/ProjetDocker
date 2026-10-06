# ProjetDocker

## Description
Un projet en Docker qui permet de déployer une application web automatisée avec une base de données.

## Auteurs
- MateoGrgic - **WordPress**
    [MateoGrgic](https://github.com/MateoGrgic)

## Branche WordPress

### Fonctionnalités implémentées
- Configuration Docker Compose pour WordPress
- Service MySQL pour la base de données
- Service PHP-FPM pour l'exécution WordPress
- Service Nginx comme reverse proxy
- Volumes persistants pour les données
- Réseau Docker interne sécurisé

### Installations nécessaires

#### Prérequis système
- Docker (version 20.10 ou supérieure)
- Docker Compose (version 1.29 ou supérieure)
- Git
- Terminal/Console (Bash, PowerShell, ou CMD selon votre OS)

#### Installation du projet
```bash
# 1. Cloner le repository
git clone https://github.com/kleihr/ProjetDocker.git
cd ProjetDocker

# 2. Checkout sur la branche WordPress
git checkout wordpress

# 3. Configurer les variables d'environnement
cp .env.example .env
# Éditer .env avec vos paramètres

# 4. Lancer les services
docker-compose up -d

# 5. Vérifier que les services sont en cours d'exécution
docker-compose ps
```

### Tests à effectuer

#### Test de connectivité
- [ ] Vérifier que tous les containers sont en état `Up`
- [ ] Accéder à WordPress via `http://localhost:8080`
- [ ] Vérifier l'accès à phpMyAdmin (si disponible) via `http://localhost:8081`

#### Test de la base de données
- [ ] Vérifier la connexion MySQL depuis le container WordPress
- [ ] Créer une table de test dans la base de données
- [ ] Vérifier la persistance des données après redémarrage des containers

#### Test de WordPress
- [ ] Finaliser l'installation initiale de WordPress
- [ ] Se connecter au tableau de bord administrateur
- [ ] Créer une page/article de test
- [ ] Vérifier que le contenu s'affiche correctement en front-end
- [ ] Tester l'upload d'images

#### Test de performance
- [ ] Vérifier les temps de réponse des pages
- [ ] Monitorer l'utilisation CPU et mémoire
- [ ] Vérifier les logs des services

#### Test de sécurité
- [ ] Vérifier que seuls les ports nécessaires sont exposés
- [ ] Tester les connexions avec des identifiants invalides
- [ ] Vérifier l'isolation du réseau Docker
- [ ] Vérifier les permissions des fichiers

#### Tests de persistance
- [ ] Arrêter les containers : `docker-compose down`
- [ ] Redémarrer les services : `docker-compose up -d`
- [ ] Vérifier que les données WordPress sont toujours présentes
- [ ] Vérifier que les données de la base de données sont conservées

### Dépannage
- Consulter les logs : `docker-compose logs -f [service_name]`
- Redémarrer un service : `docker-compose restart [service_name]`
- Nettoyer les ressources : `docker-compose down -v`

