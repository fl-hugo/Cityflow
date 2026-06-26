# Requêtes MongoDB — CityFlow

Base : `cityflow`  
Connexion : `mongosh -u admin -p password --authenticationDatabase admin`

```javascript
use cityflow
```

---

## US-M1 — Rechercher un utilisateur par nom ou email (full-text)

**Besoin :** Un opérateur saisit « Martin » ou « cityflow.fr » et obtient les profils correspondants.

**Requête :**

```javascript
db.users.find(
  { $text: { $search: "Martin" } },
  { score: { $meta: "textScore" }, firstName: 1, lastName: 1, email: 1 }
).sort({ score: { $meta: "textScore" } })
```

**Résultat attendu :**

```json
[
  { "_id": "USR-001", "firstName": "Alice", "lastName": "Martin", "email": "alice.martin@cityflow.fr", "score": 1.5 }
]
```

**Concept démontré :** Index textuel MongoDB (`users_fulltext`) avec scoring de pertinence.

---

## US-M2 — Consulter le profil complet d'un utilisateur (documents imbriqués)

**Besoin :** Afficher le profil détaillé d'Alice Martin incluant adresses et préférences.

**Requête :**

```javascript
db.users.findOne(
  { _id: "USR-001" },
  { firstName: 1, lastName: 1, email: 1, age: 1, isVerified: 1, tags: 1, addresses: 1, preferences: 1 }
)
```

**Résultat attendu :**

```json
{
  "_id": "USR-001",
  "firstName": "Alice",
  "lastName": "Martin",
  "email": "alice.martin@cityflow.fr",
  "age": 28,
  "isVerified": true,
  "tags": ["premium", "eco-friendly"],
  "addresses": [{ "type": "home", "city": "Lyon", "street": "12 rue de la République", "zipCode": "69002" }],
  "preferences": { "favoriteMode": "tram", "notifications": true, "language": "fr" }
}
```

**Concept démontré :** Documents imbriqués (embed) — adresses et préférences lues en une seule requête sans jointure.

---

## US-M3 — Statistiques des trajets par mode de transport (agrégation)

**Besoin :** Tableau de bord affichant le nombre de trajets, la distance totale et la durée moyenne par mode.

**Requête :**

```javascript
db.trips.aggregate([
  { $match: { status: "completed" } },
  {
    $group: {
      _id: "$mode",
      tripCount: { $sum: 1 },
      totalDistanceKm: { $sum: "$distanceKm" },
      avgDurationMin: { $avg: "$durationMin" },
      avgRating: { $avg: "$rating" }
    }
  },
  { $sort: { tripCount: -1 } }
])
```

**Résultat attendu :**

```json
[
  { "_id": "tram", "tripCount": 12, "totalDistanceKm": 44.1, "avgDurationMin": 19.5, "avgRating": 4.42 },
  { "_id": "bus", "tripCount": 7, "totalDistanceKm": 35.8, "avgDurationMin": 27.1, "avgRating": 3.71 },
  { "_id": "metro", "tripCount": 6, "totalDistanceKm": 25.6, "avgDurationMin": 12.8, "avgRating": 4.5 },
  { "_id": "bike", "tripCount": 5, "totalDistanceKm": 12.1, "avgDurationMin": 14.4, "avgRating": 5 },
  { "_id": "scooter", "tripCount": 4, "totalDistanceKm": 5.7, "avgDurationMin": 7.75, "avgRating": 3.25 }
]
```

**Concept démontré :** Pipeline d'agrégation MongoDB avec `$match`, `$group` et `$sort`.

---

## US-M4 — Trouver les véhicules disponibles par type et station

**Besoin :** L'utilisateur cherche un vélo disponible à la station Confluence.

**Requête :**

```javascript
db.vehicles.find(
  {
    type: "bike",
    status: "available",
    currentStationId: "ST-CONFLUENCE"
  },
  { _id: 1, model: 1, batteryLevel: 1, dockId: 1 }
)
```

**Résultat attendu :**

```json
[
  {
    "_id": "VEH-BK002",
    "model": "Vélo'V Électrique",
    "batteryLevel": 85,
    "dockId": "DOCK-CONF-03"
  }
]
```

**Concept démontré :** Requête composée sur index `{ type: 1, status: 1 }` — filtrage multi-critères sur collection de référence.

---

## Requêtes bonus (inspirées du cours)

### Utilisateurs premium éco-friendly à Lyon

```javascript
db.users.find({
  tags: { $all: ["premium", "eco-friendly"] },
  "addresses.city": "Lyon"
})
```

### Top 3 utilisateurs les plus âgés

```javascript
db.users.find({}, { _id: 0, firstName: 1, age: 1, email: 1 }).sort({ age: -1 }).limit(3)
```

### Distance totale parcourue par utilisateur

```javascript
db.trips.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$userId", totalKm: { $sum: "$distanceKm" }, trips: { $sum: 1 } } },
  { $sort: { totalKm: -1 } },
  { $limit: 5 }
])
```
