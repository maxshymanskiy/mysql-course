-- ============================================================
-- Reference data
-- ============================================================

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/service_categories.csv"
INTO TABLE service_categories
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(category_name);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/vehicle_makes.csv"
INTO TABLE vehicle_makes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(make_name);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/vehicle_types.csv"
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(type_name);

-- ============================================================
-- Core entities
-- ============================================================

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/clients.csv"
INTO TABLE clients
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(first_name, last_name, phone_number, email);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/employees.csv"
INTO TABLE employees
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(position_id, first_name, last_name, phone_number, email, pay_type, pay_rate);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/vehicles.csv"
INTO TABLE vehicles
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(client_id, make_id, vehicle_type_id, model, production_year, vin_number, license_plate);

-- ============================================================
-- Transactional tables
-- ============================================================

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/repair_orders.csv"
INTO TABLE repair_orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(client_id, vehicle_id, order_status, payment_status, due_date, total_amount, notes);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/repair_order_parts.csv"
INTO TABLE repair_order_parts
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, part_name, part_number, quantity_used, unit_price, is_client_provided, mechanic_id);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/repair_order_services.csv"
INTO TABLE repair_order_services
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, category_id, order_description, mechanic_id, actual_hours, price);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/invoices.csv"
INTO TABLE invoices
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, invoice_number, issued_date, discount_amount, notes);

LOAD DATA LOCAL INFILE "D:/Labs/Database/seeds/csv/payments.csv"
INTO TABLE payments
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, amount, payment_method, payment_date);
