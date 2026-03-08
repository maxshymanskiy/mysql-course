-- Creating 'service_categories' for storing types of services provided by repair shop
CREATE TABLE IF NOT EXISTS service_categories (
	category_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);




ALTER TABLE repair_order_parts
	DROP FOREIGN KEY fk_repair_order_parts_to_orders,
	DROP FOREIGN KEY fk_repair_order_parts_to_parts,
	DROP FOREIGN KEY fk_repair_order_parts_to_mechanics,
    DROP INDEX order_id;
 
-- Adding fields from 'parts' table to here
ALTER TABLE repair_order_parts
	DROP COLUMN part_id,
    DROP COLUMN price_applied,
    ADD COLUMN part_name VARCHAR(50) NOT NULL AFTER order_id,
    ADD COLUMN part_number VARCHAR(50) DEFAULT NULL AFTER part_name,
    ADD COLUMN unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 AFTER quantity_used,
    ADD COLUMN is_client_provided BOOLEAN NOT NULL DEFAULT FALSE AFTER unit_price,
	ADD CONSTRAINT chk_rop_unit_price 
		CHECK (unit_price >= 0);
    
ALTER TABLE repair_order_parts
	ADD CONSTRAINT fk_repair_order_parts_to_orders
		FOREIGN KEY (order_id) REFERENCES repair_orders (order_id)
			ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT fk_repair_order_parts_to_mechanics
		FOREIGN KEY (mechanic_id) REFERENCES employees (employee_id)
			ON DELETE SET NULL ON UPDATE CASCADE;
    
    
ALTER TABLE repair_order_services
	DROP FOREIGN KEY fk_repair_order_services_to_orders,
	DROP FOREIGN KEY fk_repair_order_services_to_services,
	DROP FOREIGN KEY fk_repair_order_services_to_mechanics,
    DROP INDEX order_id;
    
ALTER TABLE repair_order_services
	DROP COLUMN service_id,
	DROP COLUMN service_price,
	ADD COLUMN category_id  INT UNSIGNED NOT NULL AFTER order_id,
	ADD COLUMN order_description VARCHAR(500) NOT NULL AFTER category_id,
	ADD COLUMN price DECIMAL(10,2) NOT NULL DEFAULT 0.00 AFTER actual_hours,
	ADD CONSTRAINT chk_ros_price 
		CHECK (price >= 0);

ALTER TABLE repair_order_services
  ADD CONSTRAINT fk_repair_order_services_to_orders
    FOREIGN KEY (order_id) REFERENCES repair_orders (order_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_repair_order_services_to_mechanics
    FOREIGN KEY (mechanic_id) REFERENCES employees (employee_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT fk_ros_to_categories
    FOREIGN KEY (category_id) REFERENCES service_categories (category_id)
    ON DELETE RESTRICT ON UPDATE CASCADE;
    
    
ALTER TABLE repair_orders
	DROP CHECK chk_repair_orders_payment_valid,
	DROP FOREIGN KEY fk_repair_orders_to_mechanics,
	DROP COLUMN assigned_mechanic_id,
	DROP COLUMN paid_amount;
    
    
DROP TABLE IF EXISTS parts;
DROP TABLE IF EXISTS services;


CREATE TABLE IF NOT EXISTS invoices (
	invoice_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNSIGNED NOT NULL UNIQUE,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
	issued_date DATE NOT NULL DEFAULT (CURRENT_DATE),
	discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
	notes TEXT DEFAULT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fk_invoices_to_orders
		FOREIGN KEY (order_id) REFERENCES repair_orders (order_id)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT chk_invoices_discount 
		CHECK (discount_amount >= 0)
);


CREATE TABLE IF NOT EXISTS payments (
	payment_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	order_id INT UNSIGNED NOT NULL,
	amount DECIMAL(10,2) NOT NULL,
	payment_method ENUM('cash', 'card', 'bank_transfer', 'other') NOT NULL DEFAULT 'cash',
	payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	notes VARCHAR(500) DEFAULT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fk_payments_to_orders
		FOREIGN KEY (order_id) REFERENCES repair_orders (order_id)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT chk_payments_amount 
		CHECK (amount > 0)
);
