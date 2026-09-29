#!/bin/bash

echo "=== Déploiement de l'infrastructure ==="

# Vérification de Docker
if ! command -v docker &> /dev/null
then
    echo "Docker n'est pas installé."
    exit 1
fi

# Vérification de Docker Compose
if ! docker compose version &> /dev/null
then
    echo "Docker Compose n'est pas disponible."
    exit 1
fi

echo "Création du volume MySQL..."

docker volume create mysql_data 2>/dev/null || true

echo "Construction des images..."

docker compose -f docker-compose.prod.yml build

echo "Démarrage des services..."

docker compose -f docker-compose.prod.yml up -d

echo "Services en cours d'exécution :"

docker ps

echo "=== Déploiement terminé ==="
