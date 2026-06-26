# CityFlow

Plateforme fictive de **mobilité urbaine** à Lyon, démontrant une architecture de persistance **polyglotte** avec MongoDB, Redis, Cassandra et Neo4j.

Ce projet est un travail pédagogique : il n'inclut ni API ni interface graphique. L'objectif est de montrer **pourquoi** et **comment** utiliser chaque technologie NoSQL dans un contexte métier cohérent.

## Architecture globale

CityFlow répartit les données selon leur nature :

| Base | Données | Cas d'usage |
|------|---------|-------------|
| **MongoDB** | Utilisateurs, trajets, véhicules | Profils flexibles, agrégations, full-text |
| **Redis** | Positions, classements, sessions | Temps réel, cache, rate limiting |
| **Cassandra** | Passages en station, correspondances | Événements massifs, séries temporelles |
| **Neo4j** | Stations, lignes, connexions | Itinéraires, hubs, topologie réseau |

Voir [docs/architecture.md](docs/architecture.md) pour le détail.

## Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Docker Compose v2+)
- ~4 Go de RAM disponible (Cassandra et Neo4j sont gourmands au démarrage)

## Lancement

```bash
cd cityflow
cp .env.example .env
docker compose up -d
```

Attendre que tous les services soient healthy (~2 minutes, Cassandra peut prendre jusqu'à 90 s) :

```bash
docker compose ps
```

### Vérification rapide

```bash
# MongoDB — 20 users, 35 trips, 15 vehicles
docker exec cityflow-mongodb mongosh -u admin -p password --authenticationDatabase admin --eval "db.getSiblingDB('cityflow').users.countDocuments()"

# Redis — clés CityFlow
docker exec cityflow-redis redis-cli KEYS "cityflow:*"

# Cassandra — passages
docker exec cityflow-cassandra cqlsh -e "SELECT COUNT(*) FROM cityflow.station_passages;"

# Neo4j — stations
docker exec cityflow-neo4j cypher-shell -u neo4j -p cityflow2024 "MATCH (s:Station) RETURN count(s);"
```

## Accès aux interfaces

| Outil | URL | Identifiants |
|-------|-----|--------------|
| Mongo Express | http://localhost:8081 | — |
| Neo4j Browser | http://localhost:7474 | neo4j / cityflow2024 |
| Redis | localhost:6379 | — |
| Cassandra (cqlsh) | localhost:9042 | — |

## Structure du dépôt

```text
cityflow/
├── README.md
├── docker-compose.yml
├── .env.example
├── docs/
│   ├── architecture.md
│   ├── modelisation-mongodb.md
│   ├── modelisation-redis.md
│   ├── modelisation-cassandra.md
│   └── modelisation-neo4j.md
├── seed/
│   ├── mongodb/init.js
│   ├── redis/init.sh
│   ├── cassandra/init.cql (+ fichiers bulk)
│   └── neo4j/init.cypher
└── queries/
    ├── mongodb-queries.md
    ├── redis-queries.md
    ├── cassandra-queries.md
    └── neo4j-queries.md
```

## Données de démonstration

| Entité | Quantité |
|--------|----------|
| Utilisateurs | 20 |
| Trajets | 35 |
| Véhicules | 15 |
| Stations | 10 |
| Lignes | 5 |
| Passages Cassandra | ~470 |
| Correspondances | ~25 |

Les identifiants (`USR-*`, `ST-*`, `LINE-*`, `VEH-*`) sont cohérents entre toutes les bases.

## User stories

Chaque base couvre 4 user stories documentées dans `queries/` :

| Base | Stories | Concepts |
|------|---------|----------|
| MongoDB | US-M1 à US-M4 | Full-text, embed, agrégation, filtrage |
| Redis | US-R1 à US-R4 | Hash, Sorted Set, String, TTL, rate limit |
| Cassandra | US-C1 à US-C4 | Partition key, clustering, lecture temporelle |
| Neo4j | US-N1 à US-N4 | Shortest path, voisinage, hubs, traversée |

## Documentation

- [Architecture](docs/architecture.md)
- [Modélisation MongoDB](docs/modelisation-mongodb.md)
- [Modélisation Redis](docs/modelisation-redis.md)
- [Modélisation Cassandra](docs/modelisation-cassandra.md)
- [Modélisation Neo4j](docs/modelisation-neo4j.md)

## Requêtes

- [Requêtes MongoDB](queries/mongodb-queries.md)
- [Requêtes Redis](queries/redis-queries.md)
- [Requêtes Cassandra](queries/cassandra-queries.md)
- [Requêtes Neo4j](queries/neo4j-queries.md)

## Arrêt

```bash
docker compose down
```

Pour supprimer les volumes et repartir de zéro :

```bash
docker compose down -v
```
