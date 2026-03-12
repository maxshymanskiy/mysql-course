START TRANSACTION;

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (1, 1, 1, "Corolla", 2020);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (2, 6, 2, 'X5', 2021);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (3, 3, 99, 'Transit', 2019);

COMMIT;

-- Use ROLLBACK if needed

INSERT INTO vehicle_types (type_name) VALUES ('Camper');

START TRANSACTION;

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (1, 1, 1, 'Corolla', 2020);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (2, 6, 2, 'X5', 2021);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (3, 3, 11, 'Transit', 2019);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (4, 10, 11, 'Jumper', 2022);

COMMIT;