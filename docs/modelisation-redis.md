# Modélisation Redis — CityFlow

Redis sert de **couche temps réel et cache** pour CityFlow. Toutes les clés sont préfixées `cityflow:` pour éviter les collisions.

## Structures de clés

### US-R1 — Positions véhicules (Hash + TTL)

```
cityflow:vehicle:position:{vehicleId}
```

| Champ | Type | Description |
|-------|------|-------------|
| lat | string | Latitude |
| lng | string | Longitude |
| speed | string | Vitesse km/h |
| heading | string | Cap en degrés |
| updatedAt | string | Horodatage ISO 8601 |

**TTL : 60 secondes** — si le véhicule ne remonte plus de position, la clé disparaît automatiquement.

**Pourquoi Hash ?** Un véhicule a plusieurs attributs de position mis à jour ensemble ; le Hash permet une lecture/écriture atomique de tous les champs.

### US-R2 — Classement stations (Sorted Set)

```
cityflow:station:ranking:daily
cityflow:station:ranking:weekly
```

| Élément | Score | Description |
|---------|-------|-------------|
| ST-PART-DIEU | 1247 | Nombre de passages du jour |
| ST-BELLECOUR | 982 | … |

**Pourquoi Sorted Set ?** Classement natif par score avec `ZREVRANGE` en O(log N). Idéal pour un top-N des stations les plus fréquentées.

### US-R3 — Rate limiting (String + TTL)

```
cityflow:ratelimit:route:{userId}
```

| Valeur | TTL | Description |
|--------|-----|-------------|
| Compteur entier | 60s | Nombre de recherches d'itinéraire dans la fenêtre |

Configuration globale :

```
cityflow:config:ratelimit:route  →  Hash { maxRequests: 10, windowSeconds: 60 }
```

**Pattern rate limit :**
1. `GET` le compteur
2. Si >= max → refuser
3. Sinon `INCR` + `EXPIRE` au premier appel

**Pourquoi String ?** Un simple compteur incrémental suffit ; le TTL gère la fenêtre glissante.

### US-R4 — Sessions utilisateur (Hash + TTL)

```
cityflow:session:{userId}
```

| Champ | Description |
|-------|-------------|
| lastTripId | Dernier trajet effectué |
| favoriteStation | Station favorite |
| lastLogin | Dernière connexion |
| activeVehicleId | Véhicule en cours d'utilisation (vide si aucun) |

**TTL : 3600 secondes** (1 heure d'inactivité).

### Cache métadonnées station (Hash, sans TTL)

```
cityflow:station:meta:{stationId}
```

Données de référence rarement modifiées : nom, coordonnées, lignes desservies.

### Compteur global (String)

```
cityflow:stats:api:requests:today  →  45892
```

Compteur journalier de requêtes API (sans TTL, reset manuel ou cron).

## Récapitulatif des types Redis utilisés

| Type Redis | Cas d'usage CityFlow |
|------------|---------------------|
| **Hash** | Positions véhicules, sessions, métadonnées |
| **Sorted Set** | Classement des stations |
| **String** | Rate limiting, compteurs |
| **TTL** | Positions (60s), sessions (3600s), rate limit (60s) |
