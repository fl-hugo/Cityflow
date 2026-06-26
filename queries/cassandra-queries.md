# Requêtes Cassandra — CityFlow

Connexion : `docker exec -it cityflow-cassandra cqlsh`

```cql
USE cityflow;
```

---

## US-C1 — Historique des passages d'une station pour une date

**Besoin :** Afficher les passages à Part-Dieu le 26 juin 2026, du plus récent au plus ancien.

**Requête :**

```cql
SELECT event_time, user_id, line_id, direction, vehicle_id
FROM station_passages
WHERE station_id = 'ST-PART-DIEU'
  AND event_date = '2026-06-26'
LIMIT 10;
```

**Résultat attendu :**

```
 event_time | user_id  | line_id  | direction | vehicle_id
------------+----------+----------+-----------+------------
   07:38:00 | USR-020  | LINE-C3  |    south  |  VEH-B004
   07:36:00 | USR-019  | LINE-T1  |    south  |  VEH-T001
   07:34:00 | USR-018  | LINE-C1  |     east  |  VEH-B002
   07:32:00 | USR-017  | LINE-T1  |    north  |  VEH-T003
   ...
```

**Concept démontré :** Partition key `(station_id, event_date)` — une requête = une partition, clustering `event_time DESC` pour le tri temporel.

---

## US-C2 — Correspondances récentes d'un utilisateur

**Besoin :** Lister les dernières correspondances de USR-001.

**Requête :**

```cql
SELECT connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes
FROM user_connections
WHERE user_id = 'USR-001'
LIMIT 5;
```

**Résultat attendu :**

```
 connection_date | event_time | from_station  | to_station    | line_from | line_to  | wait_minutes
-----------------+------------+---------------+---------------+-----------+----------+--------------
      2026-06-25 |   07:35:00 | ST-BELLECOUR  | ST-PART-DIEU  | LINE-MA   | LINE-T1  |            6
      2026-06-24 |   08:20:00 | ST-PERRACHE   | ST-PART-DIEU  | LINE-T1   | LINE-C1  |            4
```

**Concept démontré :** Partition key `user_id` — accès direct à l'historique d'un utilisateur, trié par date/heure décroissante.

---

## US-C3 — Comptage horaire des passages (agrégation client)

**Besoin :** Compter les passages à Bellecour le 26/06 entre 07:00 et 08:00 (pic matinal).

**Requête :**

```cql
SELECT event_time, user_id, line_id
FROM station_passages
WHERE station_id = 'ST-BELLECOUR'
  AND event_date = '2026-06-26'
  AND event_time >= '07:00:00'
  AND event_time <= '08:00:00';
```

**Résultat attendu :**

```
~20 lignes (un passage toutes les ~2 minutes pendant le pic)
```

**Concept démontré :** Filtrage temporel via clustering column `event_time` — borne min/max dans une partition sans full scan.

> **Note pédagogique :** Cassandra n'a pas de `GROUP BY` natif performant. En production, on utiliserait une table pré-agrégée ou Spark pour les comptages horaires. Ici, le filtrage par plage horaire démontre l'optimisation de lecture temporelle.

---

## US-C4 — Détection de pic de fréquentation (comparaison inter-dates)

**Besoin :** Comparer le volume de passages à Part-Dieu entre le 24 et le 26 juin.

**Requête :**

```cql
-- Jour 1
SELECT COUNT(*) FROM station_passages
WHERE station_id = 'ST-PART-DIEU' AND event_date = '2026-06-24';

-- Jour 2
SELECT COUNT(*) FROM station_passages
WHERE station_id = 'ST-PART-DIEU' AND event_date = '2026-06-26';
```

**Résultat attendu :**

```
 2026-06-24 → ~40 passages
 2026-06-26 → ~20 passages (pic matinal concentré 07:00-07:38)
```

**Concept démontré :** Deux partitions distinctes `(station_id, event_date)` — chaque jour est une partition indépendante, lecture parallélisable en production.

**Alternative — compter côté client :**

```cql
SELECT event_time FROM station_passages
WHERE station_id = 'ST-PART-DIEU' AND event_date = '2026-06-26';
-- Compter les lignes retournées
```

---

## Requête bonus — Passages par ligne à une station

```cql
SELECT event_time, user_id, vehicle_id
FROM station_passages
WHERE station_id = 'ST-PERRACHE'
  AND event_date = '2026-06-25'
  AND line_id = 'LINE-T1'
ALLOW FILTERING;
```

> ⚠️ `ALLOW FILTERING` est coûteux — acceptable en démo, à éviter en production (table secondaire indexée par `line_id`).
