# Modélisation Neo4j — CityFlow

Neo4j modélise le **réseau de transport** de CityFlow : stations, lignes et leurs interconnexions.

## Nœuds

### `:Station`

```cypher
(:Station {
  id: 'ST-BELLECOUR',
  name: 'Bellecour',
  lat: 45.7578,
  lng: 4.8320,
  zone: '1'
})
```

10 stations du réseau lyonnais simplifié.

### `:Line`

```cypher
(:Line {
  id: 'LINE-T1',
  name: 'Tramway T1',
  mode: 'tram',
  color: '#0072BC'
})
```

5 lignes : T1, T2, Métro A, Bus C1, Bus C3.

## Relations

### `:CONNECTED_TO` (Station → Station)

Connexion piétonne ou correspondance directe entre deux stations.

```cypher
(:Station)-[:CONNECTED_TO {
  distanceM: 1200,
  walkMin: 15,
  accessible: true
}]->(:Station)
```

**Bidirectionnelle** — le réseau est non orienté pour le calcul de plus court chemin.

**Pourquoi ?** US-N1 (shortest path) et US-N2 (voisinage) opèrent sur cette relation.

### `:ON_LINE` (Station → Line)

Indique qu'une station est desservie par une ligne, avec l'ordre de passage.

```cypher
(:Station)-[:ON_LINE {
  order: 3,
  direction: 'north'
}]->(:Line)
```

**Pourquoi ?** US-N4 (traversée de ligne) — lister les stations d'une ligne dans l'ordre.

### `:INTERCHANGE` (Line → Line)

Correspondance possible entre deux lignes à une station donnée.

```cypher
(:Line)-[:INTERCHANGE {
  at: 'ST-BELLECOUR',
  avgWaitMin: 5
}]->(:Line)
```

**Pourquoi ?** Modélise les hubs de correspondance inter-lignes (complète US-N3).

## Choix de modélisation

| Décision | Alternative écartée | Raison |
|----------|---------------------|--------|
| Stations comme nœuds, lignes comme nœuds séparés | Tout en nœuds `:Stop` | Sépare la topologie physique (CONNECTED_TO) de la logique de service (ON_LINE) |
| CONNECTED_TO bidirectionnel | Relation unidirectionnelle | Simplifie shortestPath sans dupliquer la logique |
| Propriétés sur les relations | Nœuds intermédiaires `:Segment` | Suffisant pour 10 stations ; évite la sur-modélisation |

## Requêtes supportées

| User Story | Pattern Cypher |
|------------|----------------|
| US-N1 Shortest path | `shortestPath((a)-[:CONNECTED_TO*]-(b))` |
| US-N2 Voisinage | `(s)-[:CONNECTED_TO]-(neighbor)` |
| US-N3 Hubs | `ORDER BY degree DESC` |
| US-N4 Traversée ligne | `(s)-[:ON_LINE]->(l)<-[:ON_LINE]-(other)` |
