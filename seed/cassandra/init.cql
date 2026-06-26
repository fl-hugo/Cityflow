-- CityFlow — Initialisation Cassandra
-- Tables : station_passages, user_connections
-- ~520 événements de démonstration

CREATE KEYSPACE IF NOT EXISTS cityflow
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE cityflow;

DROP TABLE IF EXISTS station_passages;
DROP TABLE IF EXISTS user_connections;

-- US-C1/C3/C4 : lectures par station et plage temporelle
-- Partition : (station_id, event_date) — une partition par station/jour
-- Clustering : event_time DESC — passages les plus récents en premier
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

-- US-C2 : historique des correspondances par utilisateur
-- Partition : user_id — toutes les connexions d'un utilisateur
-- Clustering : connection_date DESC, event_time DESC
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

-- ---------------------------------------------------------------------------
-- station_passages — 2026-06-24 (lundi)
-- ---------------------------------------------------------------------------
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:05:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:12:00', 'USR-005', 'LINE-C1', 'east', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:18:00', 'USR-013', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:25:00', 'USR-002', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:32:00', 'USR-018', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:40:00', 'USR-009', 'LINE-C1', 'west', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '07:48:00', 'USR-014', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:00:00', 'USR-007', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:08:00', 'USR-020', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:15:00', 'USR-004', 'LINE-C1', 'east', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:22:00', 'USR-011', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:30:00', 'USR-016', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:38:00', 'USR-003', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:45:00', 'USR-010', 'LINE-C1', 'west', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '08:52:00', 'USR-015', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '09:00:00', 'USR-006', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '09:08:00', 'USR-019', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '09:15:00', 'USR-012', 'LINE-C1', 'east', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '09:22:00', 'USR-008', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '09:30:00', 'USR-017', 'LINE-C3', 'south', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '12:00:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '12:08:00', 'USR-005', 'LINE-C1', 'east', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '12:15:00', 'USR-013', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '12:22:00', 'USR-002', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '12:30:00', 'USR-018', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:00:00', 'USR-009', 'LINE-C1', 'west', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:08:00', 'USR-014', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:15:00', 'USR-007', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:22:00', 'USR-020', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:30:00', 'USR-004', 'LINE-C1', 'east', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:38:00', 'USR-011', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:45:00', 'USR-016', 'LINE-C3', 'south', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '17:52:00', 'USR-003', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:00:00', 'USR-010', 'LINE-C1', 'west', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:08:00', 'USR-015', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:15:00', 'USR-006', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:22:00', 'USR-019', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:30:00', 'USR-012', 'LINE-C1', 'east', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:38:00', 'USR-008', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-24', '18:45:00', 'USR-017', 'LINE-C3', 'south', 'VEH-B001');

-- ST-BELLECOUR — 2026-06-24
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '07:10:00', 'USR-004', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '07:18:00', 'USR-009', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '07:25:00', 'USR-011', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '07:32:00', 'USR-016', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '07:40:00', 'USR-020', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '07:48:00', 'USR-001', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:00:00', 'USR-014', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:08:00', 'USR-006', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:15:00', 'USR-018', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:22:00', 'USR-003', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:30:00', 'USR-010', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:38:00', 'USR-015', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:45:00', 'USR-002', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '08:52:00', 'USR-007', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '09:00:00', 'USR-012', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '12:05:00', 'USR-004', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '12:12:00', 'USR-009', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '12:20:00', 'USR-011', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:05:00', 'USR-016', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:12:00', 'USR-020', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:20:00', 'USR-001', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:28:00', 'USR-014', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:35:00', 'USR-006', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:42:00', 'USR-018', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:50:00', 'USR-003', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '17:58:00', 'USR-010', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '18:05:00', 'USR-015', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '18:12:00', 'USR-002', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '18:20:00', 'USR-007', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-24', '18:28:00', 'USR-012', 'LINE-T2', 'east', 'VEH-T003');

-- ST-PERRACHE — 2026-06-24 et 2026-06-25
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:00:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:08:00', 'USR-006', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:15:00', 'USR-011', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:22:00', 'USR-016', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:30:00', 'USR-002', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:38:00', 'USR-013', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '07:45:00', 'USR-017', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '08:00:00', 'USR-008', 'LINE-C3', 'south', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '08:08:00', 'USR-019', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '08:15:00', 'USR-005', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '17:00:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '17:08:00', 'USR-006', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '17:15:00', 'USR-011', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '17:22:00', 'USR-016', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-24', '17:30:00', 'USR-002', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '07:05:00', 'USR-003', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '07:12:00', 'USR-009', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '07:20:00', 'USR-014', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '07:28:00', 'USR-020', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '07:35:00', 'USR-004', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '17:05:00', 'USR-007', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '17:12:00', 'USR-012', 'LINE-C3', 'south', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '17:20:00', 'USR-018', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '17:28:00', 'USR-010', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PERRACHE', '2026-06-25', '17:35:00', 'USR-015', 'LINE-C3', 'south', 'VEH-B001');

-- Autres stations — 2026-06-25 (volume supplémentaire)
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '07:10:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '07:18:00', 'USR-005', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '07:25:00', 'USR-013', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '07:32:00', 'USR-016', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '07:40:00', 'USR-002', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '17:10:00', 'USR-004', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '17:18:00', 'USR-009', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '17:25:00', 'USR-011', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '17:32:00', 'USR-014', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-HOTEL-VILLE', '2026-06-25', '17:40:00', 'USR-019', 'LINE-T1', 'south', 'VEH-T001');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '07:15:00', 'USR-003', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '07:22:00', 'USR-007', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '07:30:00', 'USR-012', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '07:38:00', 'USR-015', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '17:15:00', 'USR-008', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '17:22:00', 'USR-017', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '17:30:00', 'USR-006', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CONFLUENCE', '2026-06-25', '17:38:00', 'USR-010', 'LINE-T1', 'south', 'VEH-T001');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CROIX-ROUSSE', '2026-06-25', '07:20:00', 'USR-011', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CROIX-ROUSSE', '2026-06-25', '07:28:00', 'USR-001', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CROIX-ROUSSE', '2026-06-25', '07:35:00', 'USR-018', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CROIX-ROUSSE', '2026-06-25', '17:20:00', 'USR-003', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CROIX-ROUSSE', '2026-06-25', '17:28:00', 'USR-013', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-CROIX-ROUSSE', '2026-06-25', '17:35:00', 'USR-019', 'LINE-T1', 'south', 'VEH-T003');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GERLAND', '2026-06-25', '07:25:00', 'USR-012', 'LINE-C3', 'north', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GERLAND', '2026-06-25', '07:32:00', 'USR-002', 'LINE-C3', 'north', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GERLAND', '2026-06-25', '07:40:00', 'USR-014', 'LINE-C1', 'west', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GERLAND', '2026-06-25', '17:25:00', 'USR-015', 'LINE-C3', 'north', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GERLAND', '2026-06-25', '17:32:00', 'USR-020', 'LINE-C1', 'west', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GERLAND', '2026-06-25', '17:40:00', 'USR-005', 'LINE-C3', 'north', 'VEH-B004');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-VAULX', '2026-06-25', '07:30:00', 'USR-019', 'LINE-MA', 'south', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-VAULX', '2026-06-25', '07:38:00', 'USR-010', 'LINE-C1', 'east', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-VAULX', '2026-06-25', '07:45:00', 'USR-014', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-VAULX', '2026-06-25', '17:30:00', 'USR-011', 'LINE-MA', 'south', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-VAULX', '2026-06-25', '17:38:00', 'USR-016', 'LINE-C1', 'east', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-VAULX', '2026-06-25', '17:45:00', 'USR-009', 'LINE-MA', 'south', 'VEH-M002');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GARE-LYON-PERRACHE', '2026-06-25', '07:35:00', 'USR-008', 'LINE-T2', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GARE-LYON-PERRACHE', '2026-06-25', '07:42:00', 'USR-017', 'LINE-T2', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GARE-LYON-PERRACHE', '2026-06-25', '07:50:00', 'USR-004', 'LINE-T2', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GARE-LYON-PERRACHE', '2026-06-25', '17:35:00', 'USR-018', 'LINE-T2', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GARE-LYON-PERRACHE', '2026-06-25', '17:42:00', 'USR-007', 'LINE-T2', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-GARE-LYON-PERRACHE', '2026-06-25', '17:50:00', 'USR-013', 'LINE-T2', 'north', 'VEH-T002');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PRESQUILE', '2026-06-25', '07:40:00', 'USR-006', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PRESQUILE', '2026-06-25', '07:48:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PRESQUILE', '2026-06-25', '07:55:00', 'USR-020', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PRESQUILE', '2026-06-25', '17:40:00', 'USR-002', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PRESQUILE', '2026-06-25', '17:48:00', 'USR-005', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PRESQUILE', '2026-06-25', '17:55:00', 'USR-009', 'LINE-T1', 'north', 'VEH-T003');

-- 2026-06-26 — journée courante (pic matinal)
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:00:00', 'USR-001', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:02:00', 'USR-002', 'LINE-C1', 'east', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:04:00', 'USR-003', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:06:00', 'USR-004', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:08:00', 'USR-005', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:10:00', 'USR-006', 'LINE-C1', 'west', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:12:00', 'USR-007', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:14:00', 'USR-008', 'LINE-C3', 'south', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:16:00', 'USR-009', 'LINE-T1', 'north', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:18:00', 'USR-010', 'LINE-C1', 'east', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:20:00', 'USR-011', 'LINE-T1', 'south', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:22:00', 'USR-012', 'LINE-C3', 'south', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:24:00', 'USR-013', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:26:00', 'USR-014', 'LINE-C1', 'west', 'VEH-B004');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:28:00', 'USR-015', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:30:00', 'USR-016', 'LINE-C3', 'south', 'VEH-B001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:32:00', 'USR-017', 'LINE-T1', 'north', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:34:00', 'USR-018', 'LINE-C1', 'east', 'VEH-B002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:36:00', 'USR-019', 'LINE-T1', 'south', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-PART-DIEU', '2026-06-26', '07:38:00', 'USR-020', 'LINE-C3', 'south', 'VEH-B004');

INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:01:00', 'USR-004', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:03:00', 'USR-009', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:05:00', 'USR-014', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:07:00', 'USR-001', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:09:00', 'USR-016', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:11:00', 'USR-020', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:13:00', 'USR-006', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:15:00', 'USR-011', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:17:00', 'USR-018', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:19:00', 'USR-003', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:21:00', 'USR-010', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:23:00', 'USR-015', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:25:00', 'USR-002', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:27:00', 'USR-007', 'LINE-T1', 'north', 'VEH-T001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:29:00', 'USR-012', 'LINE-MA', 'south', 'VEH-M002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:31:00', 'USR-017', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:33:00', 'USR-005', 'LINE-T1', 'south', 'VEH-T002');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:35:00', 'USR-013', 'LINE-MA', 'north', 'VEH-M001');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:37:00', 'USR-008', 'LINE-T2', 'east', 'VEH-T003');
INSERT INTO station_passages (station_id, event_date, event_time, user_id, line_id, direction, vehicle_id) VALUES ('ST-BELLECOUR', '2026-06-26', '07:39:00', 'USR-019', 'LINE-T1', 'north', 'VEH-T001');

-- ---------------------------------------------------------------------------
-- user_connections — correspondances entre lignes
-- ---------------------------------------------------------------------------
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-001', '2026-06-24', '08:20:00', 'ST-PERRACHE', 'ST-PART-DIEU', 'LINE-T1', 'LINE-C1', 4);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-001', '2026-06-25', '07:35:00', 'ST-BELLECOUR', 'ST-PART-DIEU', 'LINE-MA', 'LINE-T1', 6);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-002', '2026-06-24', '08:10:00', 'ST-GERLAND', 'ST-PART-DIEU', 'LINE-C3', 'LINE-C1', 3);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-002', '2026-06-25', '17:40:00', 'ST-PRESQUILE', 'ST-PERRACHE', 'LINE-T1', 'LINE-C3', 5);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-004', '2026-06-24', '07:55:00', 'ST-BELLECOUR', 'ST-VAULX', 'LINE-MA', 'LINE-MA', 2);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-004', '2026-06-25', '08:05:00', 'ST-PERRACHE', 'ST-GARE-LYON-PERRACHE', 'LINE-T1', 'LINE-T2', 7);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-005', '2026-06-24', '12:30:00', 'ST-PART-DIEU', 'ST-HOTEL-VILLE', 'LINE-C1', 'LINE-T1', 4);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-007', '2026-06-24', '09:00:00', 'ST-CONFLUENCE', 'ST-PART-DIEU', 'LINE-T1', 'LINE-C3', 8);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-007', '2026-06-25', '17:50:00', 'ST-GARE-LYON-PERRACHE', 'ST-CROIX-ROUSSE', 'LINE-T2', 'LINE-T1', 5);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-009', '2026-06-24', '17:30:00', 'ST-BELLECOUR', 'ST-PART-DIEU', 'LINE-T1', 'LINE-C1', 3);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-010', '2026-06-24', '08:40:00', 'ST-VAULX', 'ST-PART-DIEU', 'LINE-C1', 'LINE-T1', 6);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-013', '2026-06-24', '07:50:00', 'ST-PART-DIEU', 'ST-BELLECOUR', 'LINE-T1', 'LINE-MA', 4);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-013', '2026-06-25', '17:55:00', 'ST-GARE-LYON-PERRACHE', 'ST-PART-DIEU', 'LINE-T2', 'LINE-C1', 9);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-014', '2026-06-24', '17:20:00', 'ST-VAULX', 'ST-BELLECOUR', 'LINE-MA', 'LINE-T2', 5);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-018', '2026-06-24', '08:30:00', 'ST-PART-DIEU', 'ST-CROIX-ROUSSE', 'LINE-T1', 'LINE-T1', 0);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-018', '2026-06-25', '07:55:00', 'ST-PERRACHE', 'ST-GARE-LYON-PERRACHE', 'LINE-C3', 'LINE-T2', 6);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-020', '2026-06-24', '17:35:00', 'ST-BELLECOUR', 'ST-PART-DIEU', 'LINE-MA', 'LINE-C3', 4);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-003', '2026-06-25', '07:45:00', 'ST-CROIX-ROUSSE', 'ST-PERRACHE', 'LINE-T1', 'LINE-T2', 7);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-006', '2026-06-24', '18:00:00', 'ST-PRESQUILE', 'ST-HOTEL-VILLE', 'LINE-T1', 'LINE-T1', 0);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-011', '2026-06-25', '17:45:00', 'ST-VAULX', 'ST-PERRACHE', 'LINE-MA', 'LINE-T1', 8);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-015', '2026-06-25', '07:42:00', 'ST-CONFLUENCE', 'ST-GERLAND', 'LINE-T1', 'LINE-C3', 5);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-016', '2026-06-24', '17:50:00', 'ST-PART-DIEU', 'ST-BELLECOUR', 'LINE-C3', 'LINE-MA', 3);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-012', '2026-06-26', '07:30:00', 'ST-GERLAND', 'ST-CONFLUENCE', 'LINE-C3', 'LINE-T1', 4);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-008', '2026-06-26', '07:20:00', 'ST-PART-DIEU', 'ST-GARE-LYON-PERRACHE', 'LINE-T1', 'LINE-T2', 6);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-017', '2026-06-26', '07:25:00', 'ST-PERRACHE', 'ST-BELLECOUR', 'LINE-C3', 'LINE-T1', 5);
INSERT INTO user_connections (user_id, connection_date, event_time, from_station, to_station, line_from, line_to, wait_minutes) VALUES ('USR-019', '2026-06-26', '07:40:00', 'ST-PRESQUILE', 'ST-PART-DIEU', 'LINE-T1', 'LINE-C1', 3);
