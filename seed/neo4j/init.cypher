// CityFlow — Initialisation Neo4j
// Nœuds : Station, Line
// Relations : CONNECTED_TO, ON_LINE, INTERCHANGE

// Nettoyage (idempotent au re-seed)
MATCH (n) DETACH DELETE n;

// ---------------------------------------------------------------------------
// Stations (10)
// ---------------------------------------------------------------------------
CREATE (s1:Station {id: 'ST-PART-DIEU', name: 'Part-Dieu', lat: 45.7606, lng: 4.8590, zone: '3'});
CREATE (s2:Station {id: 'ST-BELLECOUR', name: 'Bellecour', lat: 45.7578, lng: 4.8320, zone: '1'});
CREATE (s3:Station {id: 'ST-PERRACHE', name: 'Perrache', lat: 45.7485, lng: 4.8296, zone: '2'});
CREATE (s4:Station {id: 'ST-HOTEL-VILLE', name: 'Hôtel de Ville', lat: 45.7678, lng: 4.8342, zone: '1'});
CREATE (s5:Station {id: 'ST-CONFLUENCE', name: 'Confluence', lat: 45.7410, lng: 4.8180, zone: '2'});
CREATE (s6:Station {id: 'ST-CROIX-ROUSSE', name: 'Croix-Rousse', lat: 45.7765, lng: 4.8325, zone: '1'});
CREATE (s7:Station {id: 'ST-GARE-LYON-PERRACHE', name: 'Gare Lyon-Perrache', lat: 45.7494, lng: 4.8267, zone: '2'});
CREATE (s8:Station {id: 'ST-PRESQUILE', name: 'Presqu\'île', lat: 45.7620, lng: 4.8355, zone: '1'});
CREATE (s9:Station {id: 'ST-GERLAND', name: 'Gerland', lat: 45.7234, lng: 4.8328, zone: '2'});
CREATE (s10:Station {id: 'ST-VAULX', name: 'Vaulx-en-Velin La Soie', lat: 45.7672, lng: 4.9201, zone: '3'});

// ---------------------------------------------------------------------------
// Lignes (5)
// ---------------------------------------------------------------------------
CREATE (l1:Line {id: 'LINE-T1', name: 'Tramway T1', mode: 'tram', color: '#0072BC'});
CREATE (l2:Line {id: 'LINE-T2', name: 'Tramway T2', mode: 'tram', color: '#E2001A'});
CREATE (l3:Line {id: 'LINE-MA', name: 'Métro A', mode: 'metro', color: '#E2001A'});
CREATE (l4:Line {id: 'LINE-C1', name: 'Bus C1', mode: 'bus', color: '#F7941D'});
CREATE (l5:Line {id: 'LINE-C3', name: 'Bus C3', mode: 'bus', color: '#00A651'});

// ---------------------------------------------------------------------------
// CONNECTED_TO — réseau de correspondances (graphe non orienté, distance en m, durée en min)
// ---------------------------------------------------------------------------
MATCH (a:Station {id: 'ST-PERRACHE'}), (b:Station {id: 'ST-BELLECOUR'})
CREATE (a)-[:CONNECTED_TO {distanceM: 1200, walkMin: 15, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 1200, walkMin: 15, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-BELLECOUR'}), (b:Station {id: 'ST-HOTEL-VILLE'})
CREATE (a)-[:CONNECTED_TO {distanceM: 800, walkMin: 10, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 800, walkMin: 10, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-HOTEL-VILLE'}), (b:Station {id: 'ST-CROIX-ROUSSE'})
CREATE (a)-[:CONNECTED_TO {distanceM: 1500, walkMin: 20, accessible: false}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 1500, walkMin: 20, accessible: false}]->(a);

MATCH (a:Station {id: 'ST-HOTEL-VILLE'}), (b:Station {id: 'ST-PRESQUILE'})
CREATE (a)-[:CONNECTED_TO {distanceM: 600, walkMin: 8, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 600, walkMin: 8, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-PRESQUILE'}), (b:Station {id: 'ST-BELLECOUR'})
CREATE (a)-[:CONNECTED_TO {distanceM: 500, walkMin: 7, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 500, walkMin: 7, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-PERRACHE'}), (b:Station {id: 'ST-GARE-LYON-PERRACHE'})
CREATE (a)-[:CONNECTED_TO {distanceM: 400, walkMin: 5, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 400, walkMin: 5, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-GARE-LYON-PERRACHE'}), (b:Station {id: 'ST-CONFLUENCE'})
CREATE (a)-[:CONNECTED_TO {distanceM: 1800, walkMin: 23, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 1800, walkMin: 23, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-CONFLUENCE'}), (b:Station {id: 'ST-PERRACHE'})
CREATE (a)-[:CONNECTED_TO {distanceM: 2000, walkMin: 25, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 2000, walkMin: 25, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-BELLECOUR'}), (b:Station {id: 'ST-PART-DIEU'})
CREATE (a)-[:CONNECTED_TO {distanceM: 3500, walkMin: 42, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 3500, walkMin: 42, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-PART-DIEU'}), (b:Station {id: 'ST-VAULX'})
CREATE (a)-[:CONNECTED_TO {distanceM: 5500, walkMin: 65, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 5500, walkMin: 65, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-PERRACHE'}), (b:Station {id: 'ST-GERLAND'})
CREATE (a)-[:CONNECTED_TO {distanceM: 3200, walkMin: 38, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 3200, walkMin: 38, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-GERLAND'}), (b:Station {id: 'ST-VAULX'})
CREATE (a)-[:CONNECTED_TO {distanceM: 4800, walkMin: 58, accessible: false}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 4800, walkMin: 58, accessible: false}]->(a);

MATCH (a:Station {id: 'ST-CROIX-ROUSSE'}), (b:Station {id: 'ST-PART-DIEU'})
CREATE (a)-[:CONNECTED_TO {distanceM: 2800, walkMin: 35, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 2800, walkMin: 35, accessible: true}]->(a);

MATCH (a:Station {id: 'ST-HOTEL-VILLE'}), (b:Station {id: 'ST-PART-DIEU'})
CREATE (a)-[:CONNECTED_TO {distanceM: 2200, walkMin: 28, accessible: true}]->(b),
       (b)-[:CONNECTED_TO {distanceM: 2200, walkMin: 28, accessible: true}]->(a);

// ---------------------------------------------------------------------------
// ON_LINE — stations desservies par chaque ligne (ordre de passage)
// ---------------------------------------------------------------------------
MATCH (s:Station {id: 'ST-PERRACHE'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 1, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-GARE-LYON-PERRACHE'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 2, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-BELLECOUR'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 3, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-HOTEL-VILLE'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 4, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-CROIX-ROUSSE'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 5, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-CONFLUENCE'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 6, direction: 'south'}]->(l);

MATCH (s:Station {id: 'ST-PART-DIEU'}), (l:Line {id: 'LINE-T1'})
CREATE (s)-[:ON_LINE {order: 7, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-PERRACHE'}), (l:Line {id: 'LINE-T2'})
CREATE (s)-[:ON_LINE {order: 1, direction: 'east'}]->(l);

MATCH (s:Station {id: 'ST-GARE-LYON-PERRACHE'}), (l:Line {id: 'LINE-T2'})
CREATE (s)-[:ON_LINE {order: 2, direction: 'east'}]->(l);

MATCH (s:Station {id: 'ST-BELLECOUR'}), (l:Line {id: 'LINE-T2'})
CREATE (s)-[:ON_LINE {order: 3, direction: 'east'}]->(l);

MATCH (s:Station {id: 'ST-PRESQUILE'}), (l:Line {id: 'LINE-T2'})
CREATE (s)-[:ON_LINE {order: 4, direction: 'east'}]->(l);

MATCH (s:Station {id: 'ST-BELLECOUR'}), (l:Line {id: 'LINE-MA'})
CREATE (s)-[:ON_LINE {order: 1, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-PERRACHE'}), (l:Line {id: 'LINE-MA'})
CREATE (s)-[:ON_LINE {order: 2, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-VAULX'}), (l:Line {id: 'LINE-MA'})
CREATE (s)-[:ON_LINE {order: 3, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-GERLAND'}), (l:Line {id: 'LINE-C3'})
CREATE (s)-[:ON_LINE {order: 1, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-PERRACHE'}), (l:Line {id: 'LINE-C3'})
CREATE (s)-[:ON_LINE {order: 2, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-CONFLUENCE'}), (l:Line {id: 'LINE-C3'})
CREATE (s)-[:ON_LINE {order: 3, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-PART-DIEU'}), (l:Line {id: 'LINE-C3'})
CREATE (s)-[:ON_LINE {order: 4, direction: 'north'}]->(l);

MATCH (s:Station {id: 'ST-GERLAND'}), (l:Line {id: 'LINE-C1'})
CREATE (s)-[:ON_LINE {order: 1, direction: 'west'}]->(l);

MATCH (s:Station {id: 'ST-VAULX'}), (l:Line {id: 'LINE-C1'})
CREATE (s)-[:ON_LINE {order: 2, direction: 'west'}]->(l);

MATCH (s:Station {id: 'ST-PART-DIEU'}), (l:Line {id: 'LINE-C1'})
CREATE (s)-[:ON_LINE {order: 3, direction: 'west'}]->(l);

// ---------------------------------------------------------------------------
// INTERCHANGE — correspondances directes entre lignes à une station
// ---------------------------------------------------------------------------
MATCH (l1:Line {id: 'LINE-T1'}), (l2:Line {id: 'LINE-T2'}), (s:Station {id: 'ST-BELLECOUR'})
CREATE (l1)-[:INTERCHANGE {at: s.id, avgWaitMin: 5}]->(l2),
       (l2)-[:INTERCHANGE {at: s.id, avgWaitMin: 5}]->(l1);

MATCH (l1:Line {id: 'LINE-T1'}), (l2:Line {id: 'LINE-MA'}), (s:Station {id: 'ST-BELLECOUR'})
CREATE (l1)-[:INTERCHANGE {at: s.id, avgWaitMin: 4}]->(l2),
       (l2)-[:INTERCHANGE {at: s.id, avgWaitMin: 4}]->(l1);

MATCH (l1:Line {id: 'LINE-T1'}), (l2:Line {id: 'LINE-C3'}), (s:Station {id: 'ST-PERRACHE'})
CREATE (l1)-[:INTERCHANGE {at: s.id, avgWaitMin: 6}]->(l2),
       (l2)-[:INTERCHANGE {at: s.id, avgWaitMin: 6}]->(l1);

MATCH (l1:Line {id: 'LINE-C1'}), (l2:Line {id: 'LINE-T1'}), (s:Station {id: 'ST-PART-DIEU'})
CREATE (l1)-[:INTERCHANGE {at: s.id, avgWaitMin: 7}]->(l2),
       (l2)-[:INTERCHANGE {at: s.id, avgWaitMin: 7}]->(l1);
