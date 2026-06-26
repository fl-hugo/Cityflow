#!/bin/sh
# CityFlow — Initialisation Redis
# Cas d'usage : positions véhicules, classement stations, rate limiting, sessions

set -e

REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"

redis_cmd() {
  redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" "$@"
}

echo "Attente de Redis..."
until redis_cmd ping | grep -q PONG; do
  sleep 1
done

echo "Nettoyage des clés CityFlow existantes..."
redis_cmd --scan --pattern 'cityflow:*' | while read -r key; do
  redis_cmd DEL "$key" > /dev/null
done

# ---------------------------------------------------------------------------
# US-R1 — Positions temps réel des véhicules (Hash + TTL 60s)
# Clé : cityflow:vehicle:position:{vehicleId}
# ---------------------------------------------------------------------------
redis_cmd HSET cityflow:vehicle:position:VEH-T001 lat 45.7485 lng 4.8296 speed 22 heading 180 updatedAt "2026-06-26T08:15:00Z"
redis_cmd EXPIRE cityflow:vehicle:position:VEH-T001 60

redis_cmd HSET cityflow:vehicle:position:VEH-B001 lat 45.7397 lng 4.8357 speed 18 heading 90 updatedAt "2026-06-26T08:15:00Z"
redis_cmd EXPIRE cityflow:vehicle:position:VEH-B001 60

redis_cmd HSET cityflow:vehicle:position:VEH-M001 lat 45.7578 lng 4.8320 speed 45 heading 270 updatedAt "2026-06-26T08:15:00Z"
redis_cmd EXPIRE cityflow:vehicle:position:VEH-M001 60

redis_cmd HSET cityflow:vehicle:position:VEH-SC001 lat 45.7606 lng 4.8590 speed 12 heading 45 updatedAt "2026-06-26T08:15:00Z"
redis_cmd EXPIRE cityflow:vehicle:position:VEH-SC001 60

redis_cmd HSET cityflow:vehicle:position:VEH-BK002 lat 45.7410 lng 4.8180 speed 8 heading 120 updatedAt "2026-06-26T08:15:00Z"
redis_cmd EXPIRE cityflow:vehicle:position:VEH-BK002 60

# ---------------------------------------------------------------------------
# US-R2 — Classement des stations les plus fréquentées (Sorted Set)
# Clé : cityflow:station:ranking:daily
# Score = nombre de passages du jour
# ---------------------------------------------------------------------------
redis_cmd ZADD cityflow:station:ranking:daily 1247 ST-PART-DIEU 982 ST-BELLECOUR 876 ST-PERRACHE 654 ST-HOTEL-VILLE 521 ST-CONFLUENCE 489 ST-CROIX-ROUSSE 412 ST-GARE-LYON-PERRACHE 387 ST-PRESQUILE 298 ST-GERLAND 245 ST-VAULX

# Classement hebdomadaire (historique sans TTL)
redis_cmd ZADD cityflow:station:ranking:weekly 8234 ST-PART-DIEU 7102 ST-BELLECOUR 6890 ST-PERRACHE 5432 ST-HOTEL-VILLE 4987 ST-CONFLUENCE

# ---------------------------------------------------------------------------
# US-R3 — Rate limiting recherche d'itinéraire (String compteur + TTL)
# Clé : cityflow:ratelimit:route:{userId}
# Limite : 10 requêtes / 60 secondes
# ---------------------------------------------------------------------------
redis_cmd SET cityflow:ratelimit:route:USR-008 7 EX 60
redis_cmd SET cityflow:ratelimit:route:USR-017 3 EX 60
redis_cmd SET cityflow:ratelimit:route:USR-003 10 EX 60

# Configuration globale du rate limit (Hash)
redis_cmd HSET cityflow:config:ratelimit:route maxRequests 10 windowSeconds 60 description "Limite de recherches d'itinéraire par utilisateur"

# ---------------------------------------------------------------------------
# US-R4 — Sessions utilisateur / cache dernier trajet (Hash + TTL 3600s)
# Clé : cityflow:session:{userId}
# ---------------------------------------------------------------------------
redis_cmd HSET cityflow:session:USR-001 lastTripId TRP-006 favoriteStation ST-PART-DIEU lastLogin "2026-06-26T07:30:00Z" activeVehicleId ""
redis_cmd EXPIRE cityflow:session:USR-001 3600

redis_cmd HSET cityflow:session:USR-012 lastTripId TRP-013 favoriteStation ST-GERLAND lastLogin "2026-06-26T08:00:00Z" activeVehicleId VEH-BK003
redis_cmd EXPIRE cityflow:session:USR-012 3600

redis_cmd HSET cityflow:session:USR-007 lastTripId TRP-024 favoriteStation ST-CONFLUENCE lastLogin "2026-06-26T07:45:00Z" activeVehicleId ""
redis_cmd EXPIRE cityflow:session:USR-007 3600

# Cache métadonnées station (Hash, sans TTL — données de référence)
redis_cmd HSET cityflow:station:meta:ST-PART-DIEU name "Part-Dieu" city Lyon lat 45.7606 lng 4.8590 lines "T1,C1,C3"
redis_cmd HSET cityflow:station:meta:ST-BELLECOUR name "Bellecour" city Lyon lat 45.7578 lng 4.8320 lines "MA,T1,T2"
redis_cmd HSET cityflow:station:meta:ST-PERRACHE name "Perrache" city Lyon lat 45.7485 lng 4.8296 lines "T1,T2,C3"

# Compteur global de requêtes API (String)
redis_cmd SET cityflow:stats:api:requests:today 45892

echo "CityFlow Redis initialisé avec succès."
