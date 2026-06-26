# Requêtes Neo4j — CityFlow

Connexion : [http://localhost:7474](http://localhost:7474) (neo4j / cityflow2024)

---

## US-N1 — Itinéraire le plus court entre deux stations (shortest path)

**Besoin :** Trouver le chemin piéton le plus court de Perrache à Part-Dieu.

**Requête :**

```cypher
MATCH (start:Station {id: 'ST-PERRACHE'}),
      (end:Station {id: 'ST-PART-DIEU'}),
      path = shortestPath((start)-[:CONNECTED_TO*]-(end))
RETURN [n IN nodes(path) | n.name] AS stations,
       reduce(d = 0, r IN relationships(path) | d + r.distanceM) AS totalDistanceM,
       reduce(w = 0, r IN relationships(path) | w + r.walkMin) AS totalWalkMin,
       length(path) AS hops
```

**Résultat attendu :**

```
stations: ["Perrache", "Bellecour", "Part-Dieu"]
totalDistanceM: 4700
totalWalkMin: 57
hops: 2
```

**Concept démontré :** Algorithme `shortestPath` de Neo4j sur relations pondérées — traversée de graphe optimale.

---

## US-N2 — Stations voisines directes (recherche de voisinage)

**Besoin :** Lister toutes les stations accessibles à pied depuis Bellecour.

**Requête :**

```cypher
MATCH (s:Station {id: 'ST-BELLECOUR'})-[r:CONNECTED_TO]-(neighbor:Station)
RETURN neighbor.id AS stationId,
       neighbor.name AS name,
       r.distanceM AS distanceM,
       r.walkMin AS walkMin,
       r.accessible AS accessible
ORDER BY r.walkMin
```

**Résultat attendu :**

```
ST-PRESQUILE    | Presqu'île    | 500m  | 7 min  | true
ST-HOTEL-VILLE  | Hôtel de Ville| 800m  | 10 min | true
ST-PERRACHE     | Perrache      | 1200m | 15 min | true
ST-PART-DIEU    | Part-Dieu     | 3500m | 42 min | true
```

**Concept démontré :** Requête de voisinage 1-hop — pattern `(n)-[r]-(m)` pour explorer les connexions directes.

---

## US-N3 — Identifier les hubs (stations les plus connectées)

**Besoin :** Trouver les stations avec le plus de connexions (hubs de correspondance).

**Requête :**

```cypher
MATCH (s:Station)-[:CONNECTED_TO]-()
WITH s, count(*) AS degree
RETURN s.id AS stationId, s.name AS name, degree
ORDER BY degree DESC
LIMIT 5
```

**Résultat attendu :**

```
ST-BELLECOUR  | Bellecour  | 4
ST-PERRACHE   | Perrache   | 4
ST-PART-DIEU  | Part-Dieu  | 3
ST-HOTEL-VILLE| Hôtel de Ville | 3
ST-CONFLUENCE | Confluence | 3
```

**Concept démontré :** Calcul de degré (centralité) — les nœuds à haut degré sont des hubs naturels du réseau.

**Variante — hubs inter-lignes :**

```cypher
MATCH (l1:Line)-[:INTERCHANGE]->(l2:Line)
WITH l1, count(DISTINCT l2) AS interchangeCount
RETURN l1.id AS lineId, l1.name AS name, interchangeCount
ORDER BY interchangeCount DESC
```

---

## US-N4 — Traversée d'une ligne (stations dans l'ordre)

**Besoin :** Lister toutes les stations du Tramway T1 dans l'ordre de passage.

**Requête :**

```cypher
MATCH (s:Station)-[r:ON_LINE]->(l:Line {id: 'LINE-T1'})
RETURN s.id AS stationId, s.name AS name, r.order AS stopOrder, r.direction AS direction
ORDER BY r.order
```

**Résultat attendu :**

```
ST-PERRACHE           | Perrache            | 1 | north
ST-GARE-LYON-PERRACHE | Gare Lyon-Perrache  | 2 | north
ST-BELLECOUR          | Bellecour           | 3 | north
ST-HOTEL-VILLE        | Hôtel de Ville      | 4 | north
ST-CROIX-ROUSSE       | Croix-Rousse        | 5 | north
ST-CONFLUENCE         | Confluence          | 6 | south
ST-PART-DIEU          | Part-Dieu           | 7 | north
```

**Concept démontré :** Traversée de relation typée `ON_LINE` avec propriété d'ordre — modélisation du parcours d'une ligne de transport.

---

## Requête bonus — Correspondances possibles à Bellecour

```cypher
MATCH (l1:Line)-[i:INTERCHANGE {at: 'ST-BELLECOUR'}]->(l2:Line)
RETURN l1.name AS fromLine, l2.name AS toLine, i.avgWaitMin AS avgWaitMin
ORDER BY i.avgWaitMin
```

**Résultat :**

```
Tramway T1 ↔ Métro A     | 4 min
Tramway T1 ↔ Tramway T2  | 5 min
```
