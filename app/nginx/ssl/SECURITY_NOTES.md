# Notes de Sécurité - Limitations du Laboratoire

## Contexte

Ce projet est développé dans un **contexte d'apprentissage et de laboratoire**. Par conséquent, certaines mesures de sécurité de niveau production n'ont pas pu être implémentées. Ce document explique les limitations actuelles et les recommandations pour un déploiement en production.

---

## Limitations de Sécurité Identifiées

### 1. **Certificat SSL Autosigné**

#### Situation actuelle
- Utilisation d'un certificat **SSL autosigné** généré localement
- Valide pendant **365 jours** uniquement
- Accepté automatiquement par le navigateur (après confirmation d'exception)

#### Pourquoi en laboratoire ?
- Certificats SSL valides (Let's Encrypt, Comodo, etc.) nécessitent un **domaine enregistré**
- Génération automatique via Let's Encrypt demande une infrastructure publique
- Coûts potentiels pour certains certificats premium

#### Recommandations pour la Production
```bash
# Utiliser Let's Encrypt (GRATUIT) avec Certbot
sudo apt install certbot python3-certbot-nginx
sudo certbot certonly --standalone -d votre-domaine.com

# Ou via Docker :
# Ajouter un service Certbot dans docker-compose.prod.yml
# pour renouveler automatiquement les certificats
```

---

### 2. **Expositions de Ports**

#### Situation actuelle
- Ports HTTP (80) et HTTPS (443) exposés pour accéder à Nginx
- MySQL isolé sur le réseau Docker (non exposé directement)

#### Limitations
- Aucun **firewall applicatif (WAF)** implémenté
- Pas de **rate limiting** avancé
- Pas de **IPS/IDS** (Intrusion Prevention System)

#### Recommandations pour la Production
```yaml
# Ajouter Traefik ou ModSecurity pour :
# - Validation des requêtes
# - Protection contre les attaques couantes (SQL injection, XSS)
# - Rate limiting et throttling
# - Gestion des certificats SSL automatique
```

---

### 3. **Mots de Passe et Secrets**

#### Situation actuelle
- Variables d'environnement dans un fichier `.env` local
- Mots de passe présents en clair dans la mémoire des conteneurs

#### Limitations
- Pas de **gestionnaire de secrets** (Vault, AWS Secrets Manager)
- Pas de **rotation automatique** des mots de passe
- Risque si fichier `.env` exposé par erreur

#### Recommandations pour la Production
```bash
# Utiliser HashiCorp Vault
# Ou AWS Secrets Manager / Azure Key Vault
# Avec rotation automatique tous les 90 jours

# Exemple avec Vault :
docker run -d \
  -p 8200:8200 \
  -e 'VAULT_DEV_ROOT_TOKEN_ID=mytoken' \
  vault server -dev
```

---

### 4. **Authentification et Accès**

#### Situation actuelle
- Authentification basique via mots de passe MySQL
- Pas de **Multi-Factor Authentication (MFA)**
- Pas de système de **rôles et permissions granulaires**

#### Limitations
- Un seul utilisateur applicatif (`app_user`)
- Pas de contrôle d'accès basé sur les rôles (RBAC)

#### Recommandations pour la Production
```nginx
# Ajouter l'authentification OAuth2/OpenID Connect
# Implémenter MFA pour les accès administrateurs
# Utiliser des rôles MySQL avec permissions minimales

# Exemple pour Nginx :
location / {
    auth_request /oauth2/auth;
    # ...
}
```

---

### 5. **Logging et Monitoring**

#### Situation actuelle
- Logs standard de Docker/Nginx/MySQL
- Pas de **centralisation des logs**
- Pas de **monitoring en temps réel**
- Pas de **alertes**

#### Limitations
- Difficile de détecter les intrusions
- Pas de traçabilité complète des actions
- Impossible de faire de l'analyse forensique avancée

#### Recommandations pour la Production
```yaml
# Ajouter ELK Stack (Elasticsearch, Logstash, Kibana)
# ou Prometheus + Grafana pour :
# - Centralization des logs
# - Alertes automatiques
# - Dashboards de monitoring
# - Audit trail complet
```

---

### 6. **Réseau et Isolation**

#### Situation actuelle
- Réseau Docker privé (`projet-network`)
- Isolation basique entre conteneurs

#### Limitations
- Pas de **segmentation avancée** du réseau
- Pas de **VPN** pour l'accès à distance
- Pas de **chiffrement inter-conteneurs**

#### Recommandations pour la Production
```yaml
# Mettre en place :
# - VPC/VNet sur cloud provider
# - Sous-réseaux isolés par service
# - Network policies Kubernetes
# - Chiffrement TLS inter-services (mTLS)
```

---

### 7. **Mises à Jour et Patches**

#### Situation actuelle
- Images Docker utilisent les versions actuelles
- Pas de **politique de mise à jour automatique**

#### Limitations
- Risque de vulnérabilités non patchées
- Pas de **scanning automatique** des dépendances

#### Recommandations pour la Production
```bash
# Utiliser :
# - Dependabot (GitHub) pour les dépendances
# - Trivy ou Grype pour scanner les images Docker
# - Politique de mise à jour régulière (hebdomadaire)

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image votre-image:latest
```

---

### 8. **Sauvegardes et Récupération**

#### Situation actuelle
- Volumes Docker persistants pour MySQL
- Pas de **politique de sauvegarde**
- Pas de **plan de récupération d'urgence**

#### Limitations
- Perte de données en cas de défaillance du volume
- Pas de **RPO/RTO** défini

#### Recommandations pour la Production
```bash
# Implémenter :
# - Sauvegardes quotidiennes (mysqlump / Percona XtraBackup)
# - Réplication MySQL
# - Snapshots cloud automatiques
# - Tests réguliers de restauration

# Exemple simple :
docker compose exec -T mysql mysqldump \
  -u root -p$MYSQL_ROOT_PASSWORD \
  --all-databases > backup.sql
```

---

## Tableau Récapitulatif

| Domaine | Laboratoire | Production | Priorité |
|---------|-------------|-----------|----------|
| **SSL/TLS** | Autosigné | Let's Encrypt / CA | Critique |
| **WAF** | Absent | ModSecurity/Traefik | Haute |
| **Secrets** | .env local | Vault/AWS Secrets | Critique |
| **MFA** | Absent | Obligatoire | Haute |
| **Logs** | Local | Centralisés (ELK) | Haute |
| **Monitoring** | Basique | Prometheus/Grafana | Haute |
| **VPN** | Absent | Requis | Critique |
| **Sauvegardes** | Absent | Automatiques | Critique |
| **RBAC** | Basique | Granulaire | Moyenne |
| **Scanning** | Absent | Trivy/Grype | Moyenne |

---

## But Pédagogique

Ce projet démontre :
- Les **principes fondamentaux** de Docker et containerisation
- La **sécurité basique** (isolation réseau, variables d'env)
- L'**orchestration** avec Docker Compose
- La **persistance des données** avec volumes

**Ce n'est PAS** un déploiement production-ready.

---

## Passage à la Production

Pour transformer cette infrastructure en production, suivre cette checklist :

### Phase 1 : Sécurité Critique (Semaine 1)
- [ ] Configurer certificat SSL valide (Let's Encrypt)
- [ ] Implémenter gestionnaire de secrets (Vault)
- [ ] Configurer sauvegardes automatiques MySQL
- [ ] Mettre en place VPN/accès sécurisé

### Phase 2 : Monitoring (Semaine 2-3)
- [ ] Centraliser les logs (ELK Stack)
- [ ] Ajouter Prometheus + Grafana
- [ ] Configurer alertes
- [ ] Audit trail complet

### Phase 3 : Protection (Semaine 4)
- [ ] Ajouter WAF (ModSecurity/Traefik)
- [ ] Implémenter rate limiting
- [ ] Ajouter scanning des images (Trivy)
- [ ] Configurer RBAC MySQL

### Phase 4 : Résilience (Semaine 5-6)
- [ ] Configurer réplication MySQL
- [ ] Mettre en place load balancing
- [ ] Tests de récupération d'urgence
- [ ] Documentation runbooks

---

## Ressources Recommandées

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/cis-benchmarks/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

Note : Ce document doit être revu régulièrement et mis à jour en fonction des évolutions du projet et des nouvelles menaces identifiées.

Dernière mise à jour : octobre 2024
Auteur : kleihr
