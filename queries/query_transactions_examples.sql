START TRANSACTION;

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (1, 1, 1, "Corolla", 2020);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (2, 6, 2, 'X5', 2021);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (3, 3, 99, 'Transit', 2019);

-- Use COMMIT if you want to save whatever goes successful
COMMIT;

-- Use ROLLBACK if you need to discard changes in transaction
ROLLBACK;

INSERT INTO vehicle_types (type_name) VALUES ('Camper');

START TRANSACTION;

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (1, 1, 1, 'Corolla', 2020);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (2, 6, 2, 'X5', 2021);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (3, 3, 16, 'Transit', 2019);

INSERT INTO vehicles (client_id, make_id, vehicle_type_id, model, production_year)
VALUES (4, 10, 16, 'Jumper', 2022);

COMMIT;