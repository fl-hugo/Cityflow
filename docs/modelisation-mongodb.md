# Modélisation MongoDB — CityFlow

Base : `cityflow`  
Collections : `users`, `trips`, `vehicles`

## Collection `users`

Document type :

```json
{
  "_id": "USR-001",
  "firstName": "Alice",
  "lastName": "Martin",
  "email": "alice.martin@cityflow.fr",
  "age": 28,
  "isVerified": true,
  "tags": ["premium", "eco-friendly"],
  "createdAt": ISODate("..."),
  "addresses": [
    { "type": "home", "city": "Lyon", "street": "...", "zipCode": "69002" }
  ],
  "preferences": {
    "favoriteMode": "tram",
    "notifications": true,
    "language": "fr"
  }
}
```

### Choix embed vs reference

| Donnée | Stratégie | Justification |
|--------|-----------|---------------|
| `addresses[]` | **Embed** | Toujours lues avec le profil ; cardinalité faible (1-2 adresses) |
| `preferences` | **Embed** | Configuration personnelle, pas partagée entre utilisateurs |
| `tags[]` | **Embed** | Liste courte, filtrage fréquent |
| Trajets (`trips`) | **Reference** (`userId`) | Volume élevé, cycle de vie différent, requêtes indépendantes |

### Index

- `{ email: 1 }` unique — authentification / recherche exacte
- Text index sur `firstName`, `lastName`, `email` — US-M1 full-text
- `{ "addresses.city": 1 }` — filtrage géographique
- `{ tags: 1 }` — filtrage par tag

## Collection `trips`

Document type :

```json
{
  "_id": "TRP-001",
  "userId": "USR-001",
  "vehicleId": "VEH-T001",
  "mode": "tram",
  "status": "completed",
  "startedAt": ISODate("..."),
  "endedAt": ISODate("..."),
  "distanceKm": 3.2,
  "durationMin": 18,
  "fare": { "amount": 1.90, "currency": "EUR", "paymentMethod": "card" },
  "route": {
    "startStationId": "ST-PERRACHE",
    "endStationId": "ST-PART-DIEU",
    "lineId": "LINE-T1"
  },
  "rating": 5
}
```

### Choix embed vs reference

| Donnée | Stratégie | Justification |
|--------|-----------|---------------|
| `fare` | **Embed** | Snapshot au moment du trajet (le tarif peut changer) |
| `route` | **Embed** | Contexte du trajet, lu atomiquement |
| `userId`, `vehicleId` | **Reference** | Entités indépendantes avec leurs propres collections |

## Collection `vehicles`

Document type :

```json
{
  "_id": "VEH-T001",
  "type": "tram",
  "model": "Alstom Citadis",
  "capacity": 220,
  "status": "available",
  "currentStationId": "ST-GARE-LYON-PERRACHE",
  "batteryLevel": null,
  "licensePlate": null
}
```

Les vélos et trottinettes utilisent `batteryLevel` ; les bus ont `licensePlate`.

### Index

- `{ type: 1, status: 1 }` — US-M4 recherche véhicules disponibles
- `{ currentStationId: 1 }` — localisation par station

## Volumes de données

| Collection | Quantité |
|------------|----------|
| users | 20 |
| trips | 35 |
| vehicles | 15 |
