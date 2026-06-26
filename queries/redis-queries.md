# Requêtes Redis — CityFlow

Connexion : `redis-cli -h localhost -p 6379`

---

## US-R1 — Lire la position temps réel d'un véhicule (Hash + TTL)

**Besoin :** Afficher la position du tram T001 sur la carte.

**Requête :**

```bash
HGETALL cityflow:vehicle:position:VEH-T001
TTL cityflow:vehicle:position:VEH-T001
```

**Résultat attendu :**

```
1) "lat"
2) "45.7485"
3) "lng"
4) "4.8296"
5) "speed"
6) "22"
7) "heading"
8) "180"
9) "updatedAt"
10) "2026-06-26T08:15:00Z"

TTL → entier entre 1 et 60 (secondes restantes)
```

**Concept démontré :** Hash Redis pour regrouper les attributs d'une entité + TTL pour l'expiration automatique des données obsolètes.

**Mise à jour simulée :**

```bash
HSET cityflow:vehicle:position:VEH-T001 lat 45.7500 lng 4.8300 speed 25 heading 90 updatedAt "2026-06-26T08:16:00Z"
EXPIRE cityflow:vehicle:position:VEH-T001 60
```

---

## US-R2 — Top 5 des stations les plus fréquentées (Sorted Set)

**Besoin :** Afficher le classement des stations du jour.

**Requête :**

```bash
ZREVRANGE cityflow:station:ranking:daily 0 4 WITHSCORES
```

**Résultat attendu :**

```
1) "ST-PART-DIEU"
2) "1247"
3) "ST-BELLECOUR"
4) "982"
5) "ST-PERRACHE"
6) "876"
7) "ST-HOTEL-VILLE"
8) "654"
9) "ST-CONFLUENCE"
10) "521"
```

**Concept démontré :** Sorted Set — classement natif par score avec complexité logarithmique.

**Requêtes complémentaires :**

```bash
# Score d'une station précise
ZSCORE cityflow:station:ranking:daily ST-BELLECOUR

# Rang (0 = 1er)
ZREVRANK cityflow:station:ranking:daily ST-BELLECOUR
```

---

## US-R3 — Rate limiting sur la recherche d'itinéraire (String + TTL)

**Besoin :** Vérifier si l'utilisateur USR-008 peut encore lancer une recherche (limite : 10/min).

**Requête :**

```bash
GET cityflow:ratelimit:route:USR-008
TTL cityflow:ratelimit:route:USR-008
HGETALL cityflow:config:ratelimit:route
```

**Résultat attendu :**

```
"7"                          ← 7 requêtes déjà consommées
TTL → ~45                    ← fenêtre restante en secondes
maxRequests → "10"
windowSeconds → "60"
```

**Concept démontré :** Compteur String avec TTL comme rate limiter fixe par fenêtre.

**Simulation d'un appel :**

```bash
# Incrémenter le compteur
INCR cityflow:ratelimit:route:USR-008
# Si la clé vient d'être créée, définir le TTL
EXPIRE cityflow:ratelimit:route:USR-008 60
```

**Vérification de blocage (USR-003 à la limite) :**

```bash
GET cityflow:ratelimit:route:USR-003
# → "10" → requête refusée
```

---

## US-R4 — Session utilisateur active (Hash + TTL)

**Besoin :** Restaurer la session de USR-012 avec son trajet en cours.

**Requête :**

```bash
HGETALL cityflow:session:USR-012
TTL cityflow:session:USR-012
```

**Résultat attendu :**

```
1) "lastTripId"
2) "TRP-013"
3) "favoriteStation"
4) "ST-GERLAND"
5) "lastLogin"
6) "2026-06-26T08:00:00Z"
7) "activeVehicleId"
8) "VEH-BK003"
```

**Concept démontré :** Hash de session avec TTL — cache de données utilisateur fréquemment accédées, invalidé après inactivité.

**Lecture d'un champ spécifique :**

```bash
HGET cityflow:session:USR-001 favoriteStation
# → "ST-PART-DIEU"
```

---

## Requête bonus — Métadonnées station (Hash persistant)

```bash
HGETALL cityflow:station:meta:ST-BELLECOUR
```

**Résultat :**

```
name → "Bellecour"
city → "Lyon"
lat → "45.7578"
lng → "4.8320"
lines → "MA,T1,T2"
```
