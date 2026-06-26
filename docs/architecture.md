# Architecture CityFlow

## Vue d'ensemble

CityFlow est une plateforme fictive de mobilité urbaine à Lyon. Elle illustre une **architecture polyglotte** : chaque moteur de persistance couvre un cas d'usage où il excelle, sans couche applicative intermédiaire (pas d'API, pas de frontend).

```text
                    ┌─────────────────────────────────────────┐
                    │           Données de référence           │
                    │  MongoDB : users, trips, vehicles        │
                    └─────────────────────────────────────────┘
                                        │
        ┌───────────────────────────────┼───────────────────────────────┐
        ▼                               ▼                               ▼
┌───────────────┐              ┌───────────────┐              ┌───────────────┐
│    Redis      │              │   Cassandra   │              │    Neo4j      │
│  Temps réel   │              │  Événements   │              │    Graphe     │
│  Cache / TTL  │              │  haute volume │              │  topologie    │
└───────────────┘              └───────────────┘              └───────────────┘
```

## Rôle de chaque base

| Base | Rôle | Pourquoi ce choix |
|------|------|-------------------|
| **MongoDB** | Profils utilisateurs, historique des trajets, flotte véhicules | Schéma flexible, documents imbriqués (adresses, préférences, tarifs), agrégations riches, recherche full-text |
| **Redis** | Positions véhicules, classements stations, sessions, rate limiting | Latence sub-milliseconde, structures en mémoire (Hash, Sorted Set), TTL natif |
| **Cassandra** | Passages en station, correspondances utilisateur | Écriture massive append-only, partitionnement temporel, lecture par station/jour optimisée |
| **Neo4j** | Réseau stations/lignes, itinéraires, hubs | Traversées de graphe, shortest path, analyse de centralité |

## Cohérence des données

Les identifiants sont **partagés entre bases** pour garantir la cohérence :

- `USR-001` … `USR-020` — utilisateurs (MongoDB + Cassandra + Redis sessions)
- `ST-*` — stations (MongoDB trips, Redis ranking, Cassandra passages, Neo4j nœuds)
- `LINE-*` — lignes (MongoDB trips, Cassandra, Neo4j)
- `VEH-*` — véhicules (MongoDB, Redis positions, Cassandra passages)

Aucune synchronisation automatique n'est implémentée : c'est un **choix pédagogique** qui reflète une architecture polyglotte réelle où chaque service possède sa copie dénormalisée des données dont il a besoin.

## Compromis acceptés

1. **Pas de transactions distribuées** — chaque base est autonome ; la cohérence est assurée par convention sur les identifiants.
2. **Dénormalisation** — les métadonnées station sont dupliquées dans Redis (cache) et Neo4j (graphe).
3. **Cassandra en single-node** — `SimpleStrategy` suffit pour la démo ; en production on utiliserait `NetworkTopologyStrategy`.
4. **Données Redis éphémères** — positions et sessions expirent (TTL) ; MongoDB reste la source de vérité pour l'historique.

## Ports et services Docker

| Service | Port hôte | Usage |
|---------|-----------|-------|
| MongoDB | 27017 | Base documentaire |
| Mongo Express | 8081 | Interface web MongoDB |
| Redis | 6379 | Cache temps réel |
| Cassandra | 9042 | Événements |
| Neo4j Browser | 7474 | Interface graphe |
| Neo4j Bolt | 7687 | Driver Cypher |

## Flux de démarrage

1. `docker compose up -d` démarre les 4 bases + Mongo Express.
2. MongoDB exécute `seed/mongodb/init.js` au premier démarrage.
3. Cassandra exécute les scripts CQL du dossier `seed/cassandra/`.
4. Le conteneur `redis-seed` peuple Redis après healthcheck.
5. Le conteneur `neo4j-seed` charge le graphe via `cypher-shell`.
