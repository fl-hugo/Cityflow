// CityFlow — Initialisation MongoDB
// Collections : users, trips, vehicles

db = db.getSiblingDB("cityflow");

db.users.drop();
db.trips.drop();
db.vehicles.drop();

// ---------------------------------------------------------------------------
// Index
// ---------------------------------------------------------------------------
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex(
  { firstName: "text", lastName: "text", email: "text" },
  { name: "users_fulltext" }
);
db.users.createIndex({ "addresses.city": 1 });
db.users.createIndex({ tags: 1 });

db.trips.createIndex({ userId: 1, startedAt: -1 });
db.trips.createIndex({ status: 1 });
db.trips.createIndex({ "route.startStationId": 1 });

db.vehicles.createIndex({ type: 1, status: 1 });
db.vehicles.createIndex({ currentStationId: 1 });

// ---------------------------------------------------------------------------
// Véhicules (15)
// ---------------------------------------------------------------------------
const vehicles = [
  { _id: "VEH-B001", type: "bus", model: "Iveco Urbanway", capacity: 90, status: "available", currentStationId: "ST-PERRACHE", batteryLevel: null, licensePlate: "AA-123-BB" },
  { _id: "VEH-B002", type: "bus", model: "Mercedes Citaro", capacity: 85, status: "in_use", currentStationId: "ST-PART-DIEU", batteryLevel: null, licensePlate: "AB-456-CD" },
  { _id: "VEH-B003", type: "bus", model: "Iveco Urbanway", capacity: 90, status: "maintenance", currentStationId: "ST-CONFLUENCE", batteryLevel: null, licensePlate: "AC-789-EF" },
  { _id: "VEH-T001", type: "tram", model: "Alstom Citadis", capacity: 220, status: "available", currentStationId: "ST-GARE-LYON-PERRACHE", batteryLevel: null, licensePlate: null },
  { _id: "VEH-T002", type: "tram", model: "Alstom Citadis", capacity: 220, status: "in_use", currentStationId: "ST-HOTEL-VILLE", batteryLevel: null, licensePlate: null },
  { _id: "VEH-T003", type: "tram", model: "Alstom Citadis", capacity: 220, status: "available", currentStationId: "ST-CROIX-ROUSSE", batteryLevel: null, licensePlate: null },
  { _id: "VEH-M001", type: "metro", model: "MPL75", capacity: 400, status: "in_use", currentStationId: "ST-BELLECOUR", batteryLevel: null, licensePlate: null },
  { _id: "VEH-M002", type: "metro", model: "MPL75", capacity: 400, status: "available", currentStationId: "ST-VAULX", batteryLevel: null, licensePlate: null },
  { _id: "VEH-BK001", type: "bike", model: "Vélo'V Classique", capacity: 1, status: "available", currentStationId: "ST-PRESQUILE", batteryLevel: null, dockId: "DOCK-PRES-01" },
  { _id: "VEH-BK002", type: "bike", model: "Vélo'V Électrique", capacity: 1, status: "available", currentStationId: "ST-CONFLUENCE", batteryLevel: 85, dockId: "DOCK-CONF-03" },
  { _id: "VEH-BK003", type: "bike", model: "Vélo'V Classique", capacity: 1, status: "in_use", currentStationId: "ST-GERLAND", batteryLevel: null, dockId: null },
  { _id: "VEH-SC001", type: "scooter", model: "Lime Gen4", capacity: 1, status: "available", currentStationId: "ST-PART-DIEU", batteryLevel: 72, licensePlate: null },
  { _id: "VEH-SC002", type: "scooter", model: "Tier ES400", capacity: 1, status: "available", currentStationId: "ST-BELLECOUR", batteryLevel: 91, licensePlate: null },
  { _id: "VEH-SC003", type: "scooter", model: "Lime Gen4", capacity: 1, status: "maintenance", currentStationId: "ST-VAULX", batteryLevel: 12, licensePlate: null },
  { _id: "VEH-B004", type: "bus", model: "Mercedes Citaro", capacity: 85, status: "available", currentStationId: "ST-GERLAND", batteryLevel: null, licensePlate: "AD-321-GH" }
];

db.vehicles.insertMany(vehicles);

// ---------------------------------------------------------------------------
// Utilisateurs (20)
// ---------------------------------------------------------------------------
const now = new Date();
const daysAgo = (n) => new Date(now.getTime() - n * 24 * 60 * 60 * 1000);

const users = [
  { _id: "USR-001", firstName: "Alice", lastName: "Martin", email: "alice.martin@cityflow.fr", age: 28, isVerified: true, tags: ["premium", "eco-friendly"], createdAt: daysAgo(120), addresses: [{ type: "home", city: "Lyon", street: "12 rue de la République", zipCode: "69002" }], preferences: { favoriteMode: "tram", notifications: true, language: "fr" } },
  { _id: "USR-002", firstName: "Bruno", lastName: "Dupont", email: "bruno.dupont@example.com", age: 34, isVerified: true, tags: ["regular"], createdAt: daysAgo(90), addresses: [{ type: "home", city: "Lyon", street: "5 avenue Jean Jaurès", zipCode: "69007" }, { type: "work", city: "Villeurbanne", street: "20 rue du 8 Mai 1945", zipCode: "69100" }] },
  { _id: "USR-003", firstName: "Claire", lastName: "Bernard", email: "claire.bernard@cityflow.fr", age: 22, isVerified: false, tags: ["student"], createdAt: daysAgo(45), addresses: [{ type: "home", city: "Lyon", street: "8 rue Garibaldi", zipCode: "69003" }] },
  { _id: "USR-004", firstName: "David", lastName: "Petit", email: "david.petit@example.com", age: 41, isVerified: true, tags: ["premium", "business"], createdAt: daysAgo(200), addresses: [{ type: "home", city: "Lyon", street: "3 place Bellecour", zipCode: "69002" }] },
  { _id: "USR-005", firstName: "Emma", lastName: "Leroy", email: "emma.leroy@cityflow.fr", age: 31, isVerified: true, tags: ["eco-friendly"], createdAt: daysAgo(60), addresses: [{ type: "home", city: "Villeurbanne", street: "14 cours Émile Zola", zipCode: "69100" }] },
  { _id: "USR-006", firstName: "François", lastName: "Moreau", email: "francois.moreau@example.com", age: 55, isVerified: true, tags: ["senior"], createdAt: daysAgo(300), addresses: [{ type: "home", city: "Lyon", street: "22 montée de la Grande-Côte", zipCode: "69001" }] },
  { _id: "USR-007", firstName: "Gabrielle", lastName: "Simon", email: "gabrielle.simon@cityflow.fr", age: 26, isVerified: true, tags: ["premium", "eco-friendly"], createdAt: daysAgo(30), addresses: [{ type: "home", city: "Lyon", street: "9 quai Rambaud", zipCode: "69002" }, { type: "work", city: "Lyon", street: "25 rue de la Part-Dieu", zipCode: "69003" }] },
  { _id: "USR-008", firstName: "Hugo", lastName: "Laurent", email: "hugo.laurent@example.com", age: 19, isVerified: false, tags: ["student"], createdAt: daysAgo(15), addresses: [{ type: "home", city: "Lyon", street: "1 rue Université", zipCode: "69007" }] },
  { _id: "USR-009", firstName: "Isabelle", lastName: "Roux", email: "isabelle.roux@cityflow.fr", age: 37, isVerified: true, tags: ["regular", "premium"], createdAt: daysAgo(180), addresses: [{ type: "home", city: "Lyon", street: "7 rue Victor Hugo", zipCode: "69006" }] },
  { _id: "USR-010", firstName: "Julien", lastName: "Fournier", email: "julien.fournier@example.com", age: 29, isVerified: true, tags: ["eco-friendly"], createdAt: daysAgo(75), addresses: [{ type: "home", city: "Villeurbanne", street: "11 rue Paul Verlaine", zipCode: "69100" }] },
  { _id: "USR-011", firstName: "Karine", lastName: "Girard", email: "karine.girard@cityflow.fr", age: 33, isVerified: false, tags: ["regular"], createdAt: daysAgo(50), addresses: [{ type: "home", city: "Lyon", street: "18 rue de Cuire", zipCode: "69004" }] },
  { _id: "USR-012", firstName: "Lucas", lastName: "Bonnet", email: "lucas.bonnet@example.com", age: 24, isVerified: true, tags: ["student", "eco-friendly"], createdAt: daysAgo(20), addresses: [{ type: "home", city: "Lyon", street: "4 rue de Gerland", zipCode: "69007" }] },
  { _id: "USR-013", firstName: "Marie", lastName: "Fontaine", email: "marie.fontaine@cityflow.fr", age: 45, isVerified: true, tags: ["business"], createdAt: daysAgo(250), addresses: [{ type: "home", city: "Lyon", street: "2 place des Terreaux", zipCode: "69001" }, { type: "work", city: "Lyon", street: "30 rue de la Part-Dieu", zipCode: "69003" }] },
  { _id: "USR-014", firstName: "Nicolas", lastName: "Chevalier", email: "nicolas.chevalier@example.com", age: 38, isVerified: true, tags: ["premium"], createdAt: daysAgo(100), addresses: [{ type: "home", city: "Lyon", street: "6 avenue Berthelot", zipCode: "69007" }] },
  { _id: "USR-015", firstName: "Olivia", lastName: "Renard", email: "olivia.renard@cityflow.fr", age: 27, isVerified: true, tags: ["eco-friendly", "regular"], createdAt: daysAgo(40), addresses: [{ type: "home", city: "Villeurbanne", street: "3 rue Henri Barbusse", zipCode: "69100" }] },
  { _id: "USR-016", firstName: "Pierre", lastName: "Mercier", email: "pierre.mercier@example.com", age: 52, isVerified: true, tags: ["senior", "premium"], createdAt: daysAgo(400), addresses: [{ type: "home", city: "Lyon", street: "15 rue de la Charité", zipCode: "69002" }] },
  { _id: "USR-017", firstName: "Quentin", lastName: "Blanc", email: "quentin.blanc@cityflow.fr", age: 21, isVerified: false, tags: ["student"], createdAt: daysAgo(10), addresses: [{ type: "home", city: "Lyon", street: "10 rue de la Guillotière", zipCode: "69007" }] },
  { _id: "USR-018", firstName: "Sophie", lastName: "Garnier", email: "sophie.garnier@cityflow.fr", age: 36, isVerified: true, tags: ["premium", "business"], createdAt: daysAgo(150), addresses: [{ type: "home", city: "Lyon", street: "21 rue Pasteur", zipCode: "69007" }] },
  { _id: "USR-019", firstName: "Thomas", lastName: "Lemaire", email: "thomas.lemaire@example.com", age: 30, isVerified: true, tags: ["regular"], createdAt: daysAgo(85), addresses: [{ type: "home", city: "Lyon", street: "8 rue Moncey", zipCode: "69009" }] },
  { _id: "USR-020", firstName: "Valérie", lastName: "Colin", email: "valerie.colin@cityflow.fr", age: 43, isVerified: true, tags: ["eco-friendly", "premium"], createdAt: daysAgo(220), addresses: [{ type: "home", city: "Lyon", street: "5 rue de la Bourse", zipCode: "69002" }, { type: "work", city: "Lyon", street: "50 cours Vitton", zipCode: "69006" }] }
];

db.users.insertMany(users);

// ---------------------------------------------------------------------------
// Trajets (35)
// ---------------------------------------------------------------------------
const hoursAgo = (h) => new Date(now.getTime() - h * 60 * 60 * 1000);

const trips = [
  { _id: "TRP-001", userId: "USR-001", vehicleId: "VEH-T001", mode: "tram", status: "completed", startedAt: hoursAgo(72), endedAt: hoursAgo(71.5), distanceKm: 3.2, durationMin: 18, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-PERRACHE", endStationId: "ST-PART-DIEU", lineId: "LINE-T1" }, rating: 5 },
  { _id: "TRP-002", userId: "USR-002", vehicleId: "VEH-B001", mode: "bus", status: "completed", startedAt: hoursAgo(48), endedAt: hoursAgo(47.3), distanceKm: 5.1, durationMin: 25, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-GERLAND", endStationId: "ST-PART-DIEU", lineId: "LINE-C3" }, rating: 4 },
  { _id: "TRP-003", userId: "USR-003", vehicleId: "VEH-BK001", mode: "bike", status: "completed", startedAt: hoursAgo(24), endedAt: hoursAgo(23.7), distanceKm: 2.0, durationMin: 12, fare: { amount: 0, currency: "EUR", paymentMethod: "subscription" }, route: { startStationId: "ST-PRESQUILE", endStationId: "ST-CONFLUENCE", lineId: null }, rating: 5 },
  { _id: "TRP-004", userId: "USR-004", vehicleId: "VEH-M001", mode: "metro", status: "completed", startedAt: hoursAgo(96), endedAt: hoursAgo(95.5), distanceKm: 4.8, durationMin: 14, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-BELLECOUR", endStationId: "ST-VAULX", lineId: "LINE-MA" }, rating: 4 },
  { _id: "TRP-005", userId: "USR-005", vehicleId: "VEH-SC001", mode: "scooter", status: "completed", startedAt: hoursAgo(12), endedAt: hoursAgo(11.8), distanceKm: 1.5, durationMin: 8, fare: { amount: 2.50, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-PART-DIEU", endStationId: "ST-HOTEL-VILLE", lineId: null }, rating: 3 },
  { _id: "TRP-006", userId: "USR-001", vehicleId: "VEH-T002", mode: "tram", status: "completed", startedAt: hoursAgo(36), endedAt: hoursAgo(35.6), distanceKm: 2.8, durationMin: 15, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-HOTEL-VILLE", endStationId: "ST-CROIX-ROUSSE", lineId: "LINE-T1" }, rating: 5 },
  { _id: "TRP-007", userId: "USR-006", vehicleId: "VEH-B002", mode: "bus", status: "completed", startedAt: hoursAgo(60), endedAt: hoursAgo(59.2), distanceKm: 6.3, durationMin: 32, fare: { amount: 1.90, currency: "EUR", paymentMethod: "cash" }, route: { startStationId: "ST-PERRACHE", endStationId: "ST-GERLAND", lineId: "LINE-C3" }, rating: 3 },
  { _id: "TRP-008", userId: "USR-007", vehicleId: "VEH-BK002", mode: "bike", status: "completed", startedAt: hoursAgo(8), endedAt: hoursAgo(7.7), distanceKm: 3.5, durationMin: 20, fare: { amount: 0, currency: "EUR", paymentMethod: "subscription" }, route: { startStationId: "ST-CONFLUENCE", endStationId: "ST-PRESQUILE", lineId: null }, rating: 5 },
  { _id: "TRP-009", userId: "USR-008", vehicleId: "VEH-T003", mode: "tram", status: "cancelled", startedAt: hoursAgo(4), endedAt: null, distanceKm: 0, durationMin: 0, fare: { amount: 0, currency: "EUR", paymentMethod: null }, route: { startStationId: "ST-GARE-LYON-PERRACHE", endStationId: "ST-BELLECOUR", lineId: "LINE-T2" }, rating: null },
  { _id: "TRP-010", userId: "USR-009", vehicleId: "VEH-M001", mode: "metro", status: "completed", startedAt: hoursAgo(120), endedAt: hoursAgo(119.4), distanceKm: 3.0, durationMin: 10, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-BELLECOUR", endStationId: "ST-PERRACHE", lineId: "LINE-MA" }, rating: 4 },
  { _id: "TRP-011", userId: "USR-010", vehicleId: "VEH-SC002", mode: "scooter", status: "completed", startedAt: hoursAgo(20), endedAt: hoursAgo(19.85), distanceKm: 0.9, durationMin: 5, fare: { amount: 1.80, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-BELLECOUR", endStationId: "ST-PRESQUILE", lineId: null }, rating: 4 },
  { _id: "TRP-012", userId: "USR-011", vehicleId: "VEH-T001", mode: "tram", status: "completed", startedAt: hoursAgo(55), endedAt: hoursAgo(54.5), distanceKm: 4.0, durationMin: 22, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-CROIX-ROUSSE", endStationId: "ST-PERRACHE", lineId: "LINE-T1" }, rating: 4 },
  { _id: "TRP-013", userId: "USR-012", vehicleId: "VEH-BK003", mode: "bike", status: "in_progress", startedAt: hoursAgo(0.5), endedAt: null, distanceKm: 0, durationMin: 0, fare: { amount: 0, currency: "EUR", paymentMethod: "subscription" }, route: { startStationId: "ST-GERLAND", endStationId: "ST-CONFLUENCE", lineId: null }, rating: null },
  { _id: "TRP-014", userId: "USR-013", vehicleId: "VEH-B004", mode: "bus", status: "completed", startedAt: hoursAgo(80), endedAt: hoursAgo(79.1), distanceKm: 7.2, durationMin: 35, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-PART-DIEU", endStationId: "ST-VAULX", lineId: "LINE-C1" }, rating: 3 },
  { _id: "TRP-015", userId: "USR-014", vehicleId: "VEH-M002", mode: "metro", status: "completed", startedAt: hoursAgo(44), endedAt: hoursAgo(43.6), distanceKm: 5.5, durationMin: 16, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-VAULX", endStationId: "ST-BELLECOUR", lineId: "LINE-MA" }, rating: 5 },
  { _id: "TRP-016", userId: "USR-015", vehicleId: "VEH-T002", mode: "tram", status: "completed", startedAt: hoursAgo(28), endedAt: hoursAgo(27.5), distanceKm: 3.8, durationMin: 19, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-HOTEL-VILLE", endStationId: "ST-PART-DIEU", lineId: "LINE-T1" }, rating: 4 },
  { _id: "TRP-017", userId: "USR-016", vehicleId: "VEH-B001", mode: "bus", status: "completed", startedAt: hoursAgo(100), endedAt: hoursAgo(99.3), distanceKm: 4.5, durationMin: 28, fare: { amount: 1.90, currency: "EUR", paymentMethod: "cash" }, route: { startStationId: "ST-PERRACHE", endStationId: "ST-HOTEL-VILLE", lineId: "LINE-C3" }, rating: 4 },
  { _id: "TRP-018", userId: "USR-017", vehicleId: "VEH-SC001", mode: "scooter", status: "completed", startedAt: hoursAgo(6), endedAt: hoursAgo(5.85), distanceKm: 1.2, durationMin: 7, fare: { amount: 2.00, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-PART-DIEU", endStationId: "ST-GERLAND", lineId: null }, rating: 3 },
  { _id: "TRP-019", userId: "USR-018", vehicleId: "VEH-T003", mode: "tram", status: "completed", startedAt: hoursAgo(65), endedAt: hoursAgo(64.4), distanceKm: 5.0, durationMin: 24, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-GARE-LYON-PERRACHE", endStationId: "ST-CROIX-ROUSSE", lineId: "LINE-T2" }, rating: 5 },
  { _id: "TRP-020", userId: "USR-019", vehicleId: "VEH-B002", mode: "bus", status: "completed", startedAt: hoursAgo(40), endedAt: hoursAgo(39.4), distanceKm: 3.9, durationMin: 22, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-VAULX", endStationId: "ST-PART-DIEU", lineId: "LINE-C1" }, rating: 4 },
  { _id: "TRP-021", userId: "USR-020", vehicleId: "VEH-M001", mode: "metro", status: "completed", startedAt: hoursAgo(52), endedAt: hoursAgo(51.5), distanceKm: 2.5, durationMin: 8, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-BELLECOUR", endStationId: "ST-PERRACHE", lineId: "LINE-MA" }, rating: 5 },
  { _id: "TRP-022", userId: "USR-002", vehicleId: "VEH-BK001", mode: "bike", status: "completed", startedAt: hoursAgo(16), endedAt: hoursAgo(15.75), distanceKm: 2.3, durationMin: 14, fare: { amount: 0, currency: "EUR", paymentMethod: "subscription" }, route: { startStationId: "ST-PRESQUILE", endStationId: "ST-BELLECOUR", lineId: null }, rating: 5 },
  { _id: "TRP-023", userId: "USR-004", vehicleId: "VEH-T001", mode: "tram", status: "completed", startedAt: hoursAgo(88), endedAt: hoursAgo(87.4), distanceKm: 4.2, durationMin: 21, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-PERRACHE", endStationId: "ST-HOTEL-VILLE", lineId: "LINE-T1" }, rating: 4 },
  { _id: "TRP-024", userId: "USR-007", vehicleId: "VEH-SC002", mode: "scooter", status: "completed", startedAt: hoursAgo(32), endedAt: hoursAgo(31.85), distanceKm: 1.8, durationMin: 9, fare: { amount: 2.20, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-BELLECOUR", endStationId: "ST-CONFLUENCE", lineId: null }, rating: 4 },
  { _id: "TRP-025", userId: "USR-001", vehicleId: "VEH-M002", mode: "metro", status: "completed", startedAt: hoursAgo(140), endedAt: hoursAgo(139.5), distanceKm: 6.0, durationMin: 18, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-PERRACHE", endStationId: "ST-VAULX", lineId: "LINE-MA" }, rating: 5 },
  { _id: "TRP-026", userId: "USR-005", vehicleId: "VEH-T002", mode: "tram", status: "completed", startedAt: hoursAgo(70), endedAt: hoursAgo(69.5), distanceKm: 3.1, durationMin: 17, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-PART-DIEU", endStationId: "ST-HOTEL-VILLE", lineId: "LINE-T1" }, rating: 4 },
  { _id: "TRP-027", userId: "USR-010", vehicleId: "VEH-B004", mode: "bus", status: "completed", startedAt: hoursAgo(56), endedAt: hoursAgo(55.3), distanceKm: 5.8, durationMin: 30, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-GERLAND", endStationId: "ST-VAULX", lineId: "LINE-C1" }, rating: 3 },
  { _id: "TRP-028", userId: "USR-013", vehicleId: "VEH-T003", mode: "tram", status: "completed", startedAt: hoursAgo(92), endedAt: hoursAgo(91.3), distanceKm: 6.5, durationMin: 28, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-CROIX-ROUSSE", endStationId: "ST-GARE-LYON-PERRACHE", lineId: "LINE-T2" }, rating: 5 },
  { _id: "TRP-029", userId: "USR-015", vehicleId: "VEH-BK002", mode: "bike", status: "completed", startedAt: hoursAgo(18), endedAt: hoursAgo(17.7), distanceKm: 2.7, durationMin: 16, fare: { amount: 0, currency: "EUR", paymentMethod: "subscription" }, route: { startStationId: "ST-CONFLUENCE", endStationId: "ST-GERLAND", lineId: null }, rating: 5 },
  { _id: "TRP-030", userId: "USR-018", vehicleId: "VEH-B001", mode: "bus", status: "completed", startedAt: hoursAgo(74), endedAt: hoursAgo(73.2), distanceKm: 4.0, durationMin: 26, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-HOTEL-VILLE", endStationId: "ST-GERLAND", lineId: "LINE-C3" }, rating: 4 },
  { _id: "TRP-031", userId: "USR-003", vehicleId: "VEH-T001", mode: "tram", status: "completed", startedAt: hoursAgo(30), endedAt: hoursAgo(29.5), distanceKm: 2.9, durationMin: 16, fare: { amount: 1.90, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-PERRACHE", endStationId: "ST-CROIX-ROUSSE", lineId: "LINE-T1" }, rating: 4 },
  { _id: "TRP-032", userId: "USR-009", vehicleId: "VEH-SC001", mode: "scooter", status: "completed", startedAt: hoursAgo(22), endedAt: hoursAgo(21.8), distanceKm: 2.1, durationMin: 11, fare: { amount: 2.80, currency: "EUR", paymentMethod: "app" }, route: { startStationId: "ST-PART-DIEU", endStationId: "ST-PRESQUILE", lineId: null }, rating: 3 },
  { _id: "TRP-033", userId: "USR-011", vehicleId: "VEH-M002", mode: "metro", status: "completed", startedAt: hoursAgo(68), endedAt: hoursAgo(67.5), distanceKm: 4.3, durationMin: 13, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-VAULX", endStationId: "ST-PERRACHE", lineId: "LINE-MA" }, rating: 4 },
  { _id: "TRP-034", userId: "USR-006", vehicleId: "VEH-BK001", mode: "bike", status: "completed", startedAt: hoursAgo(14), endedAt: hoursAgo(13.8), distanceKm: 1.6, durationMin: 10, fare: { amount: 0, currency: "EUR", paymentMethod: "subscription" }, route: { startStationId: "ST-PRESQUILE", endStationId: "ST-HOTEL-VILLE", lineId: null }, rating: 5 },
  { _id: "TRP-035", userId: "USR-014", vehicleId: "VEH-T002", mode: "tram", status: "completed", startedAt: hoursAgo(46), endedAt: hoursAgo(45.5), distanceKm: 3.4, durationMin: 18, fare: { amount: 1.90, currency: "EUR", paymentMethod: "card" }, route: { startStationId: "ST-HOTEL-VILLE", endStationId: "ST-PERRACHE", lineId: "LINE-T1" }, rating: 4 }
];

db.trips.insertMany(trips);

print("CityFlow MongoDB initialisé :");
print("  - " + db.users.countDocuments() + " utilisateurs");
print("  - " + db.trips.countDocuments() + " trajets");
print("  - " + db.vehicles.countDocuments() + " véhicules");
