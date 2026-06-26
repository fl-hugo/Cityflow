# Modélisation Cassandra — CityFlow

Keyspace : `cityflow`  
Tables : `station_passages`, `user_connections`

## Table `station_passages`

Enregistre chaque passage d'un utilisateur dans une station (badge, validation ticket).

```cql
CREATE TABLE station_passages (
    station_id   text,
    event_date   date,
    event_time   time,
    user_id      text,
    line_id      text,
    direction    text,
    vehicle_id   text,
    PRIMARY KEY ((station_id, event_date), event_time)
) WITH CLUSTERING ORDER BY (event_time DESC);
```

### Choix de partitionnement

| Colonne | Rôle | Justification |
|---------|------|---------------|
| **Partition key** `(station_id, event_date)` | Regroupe tous les passages d'une station pour un jour donné | Requête US-C1 : « passages à Part-Dieu le 26/06 » = **une seule partition** |
| **Clustering** `event_time DESC` | Tri intra-partition | Les passages les plus récents apparaissent en premier sans tri côté client |

### Compromis

- ✅ Lecture par station + date très efficace
- ❌ Requête « tous les passages d'un utilisateur » nécessiterait une table complémentaire (non requise ici)
- Taille de partition : ~50-100 événements/jour/station → largement sous la limite recommandée (~100 Mo)

## Table `user_connections`

Enregistre les correspondances (changement de ligne) d'un utilisateur.

```cql
CREATE TABLE user_connections (
    user_id          text,
    connection_date  date,
    event_time       time,
    from_station     text,
    to_station       text,
    line_from        text,
    line_to          text,
    wait_minutes     int,
    PRIMARY KEY (user_id, connection_date, event_time)
) WITH CLUSTERING ORDER BY (connection_date DESC, event_time DESC);
```

### Choix de partitionnement

| Colonne | Rôle | Justification |
|---------|------|---------------|
| **Partition key** `user_id` | Un utilisateur = une partition | US-C2 : historique des correspondances d'un utilisateur |
| **Clustering** `connection_date DESC, event_time DESC` | Tri chronologique inverse | Dernières correspondances en premier |

### Compromis

- ✅ Accès rapide par utilisateur
- ❌ Requête « toutes les correspondances à Bellecour » impossible sans table secondaire (acceptable pour la démo)

## Volume de données

| Table | Quantité |
|-------|----------|
| station_passages | ~470 événements |
| user_connections | ~25 correspondances |

Les identifiants (`USR-*`, `ST-*`, `LINE-*`, `VEH-*`) sont alignés avec MongoDB et Neo4j.

## Optimisation lecture temporelle

Le modèle est optimisé pour des **requêtes temporelles bornées** :

1. Filtrer par `station_id` + `event_date` (partition exacte)
2. Utiliser `event_time` avec des bornes (`>=`, `<=`) grâce au clustering
3. `LIMIT` pour paginer les résultats récents

C'est le pattern **Time Series** classique dans Cassandra : une partition par entité + bucket temporel (ici : jour).
