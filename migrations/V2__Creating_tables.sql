-- customer information with contact details and audit timestamps
CREATE TABLE IF NOT EXISTS clients (
  client_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) DEFAULT NULL,
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(255) UNIQUE DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- list of common vehicle makes
CREATE TABLE IF NOT EXISTS vehicle_makes (
  make_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  make_name VARCHAR(100) NOT NULL UNIQUE
);

-- list of common vehicle types
CREATE TABLE IF NOT EXISTS vehicle_types (
  vehicle_type_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  type_name VARCHAR(64) NOT NULL UNIQUE
);

-- client-owned vehicles with identification details and normalized make/type references
CREATE TABLE IF NOT EXISTS vehicles (
  vehicle_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  client_id INT UNSIGNED NOT NULL,
  make_id INT UNSIGNED NOT NULL,
  vehicle_type_id INT UNSIGNED NOT NULL,
  model VARCHAR(100) NOT NULL,
  production_year YEAR NOT NULL,
  vin_number VARCHAR(17) UNIQUE DEFAULT NULL,
  license_plate VARCHAR(20) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_vehicles_to_clients 
    FOREIGN KEY (client_id) REFERENCES clients (client_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vehicles_to_makes 
    FOREIGN KEY (make_id) REFERENCES vehicle_makes (make_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vehicles_to_types
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types (vehicle_type_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- list of common employee positions
CREATE TABLE IF NOT EXISTS positions (
  position_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  position_name VARCHAR(100) NOT NULL UNIQUE
);

-- employee records with flexible pay structure (hourly/salary/commission)
CREATE TABLE IF NOT EXISTS employees (
  employee_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  position_id INT UNSIGNED NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) DEFAULT NULL,
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(255) UNIQUE DEFAULT NULL,
  pay_type ENUM('hourly', 'salary', 'commission') NOT NULL DEFAULT 'hourly',
  pay_rate DECIMAL(10,2) NOT NULL,
  commission_percentage DECIMAL(5,2) DEFAULT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_employees_to_positions 
    FOREIGN KEY (position_id) REFERENCES positions (position_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_employees_pay_rate CHECK (pay_rate >= 0),
  CONSTRAINT chk_employees_commission CHECK (commission_percentage >= 0 AND commission_percentage <= 100)
);

-- inventory management for parts with reorder levels and pricing
CREATE TABLE IF NOT EXISTS parts (
  part_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  part_number VARCHAR(100) NOT NULL UNIQUE,
  part_name VARCHAR(255) NOT NULL,
  quantity_in_stock INT NOT NULL DEFAULT 0,
  reorder_level INT NOT NULL DEFAULT 0,
  unit_price DECIMAL(10,2) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_parts_quantity CHECK (quantity_in_stock >= 0),
  CONSTRAINT chk_parts_reorder_level CHECK (reorder_level >= 0),
  CONSTRAINT chk_parts_price CHECK (unit_price >= 0)
);

-- service catalog with estimated hours and pricing
CREATE TABLE IF NOT EXISTS services (
  service_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  service_name VARCHAR(255) NOT NULL UNIQUE,
  estimated_hours DECIMAL(5,2) NOT NULL,
  hourly_rate DECIMAL(10,2) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_services_hours CHECK (estimated_hours > 0),
  CONSTRAINT chk_services_rate CHECK (hourly_rate >= 0)
);

-- main repair order tracking with workflow status and payment tracking
-- ensures paid_amount never exceeds total_amount
CREATE TABLE IF NOT EXISTS repair_orders (
  order_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  client_id INT UNSIGNED NOT NULL,
  vehicle_id INT UNSIGNED NOT NULL,
  assigned_mechanic_id INT UNSIGNED NOT NULL,
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  order_status ENUM('pending', 'in_progress', 'completed', 'cancelled', 'on_hold') NOT NULL DEFAULT 'pending',
  payment_status ENUM('unpaid', 'partial', 'paid', 'refunded') NOT NULL DEFAULT 'unpaid',
  paid_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  due_date DATE DEFAULT NULL,
  completion_date DATETIME DEFAULT NULL,
  total_amount DECIMAL(10,2) DEFAULT NULL,
  notes TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_repair_orders_to_clients 
    FOREIGN KEY (client_id) REFERENCES clients (client_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_repair_orders_to_vehicles 
    FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_repair_orders_to_mechanics 
    FOREIGN KEY (assigned_mechanic_id) REFERENCES employees (employee_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_repair_orders_paid_amount CHECK (paid_amount >= 0),
  CONSTRAINT chk_repair_orders_total_amount CHECK (total_amount >= 0),
  CONSTRAINT chk_repair_orders_payment_valid CHECK (paid_amount <= COALESCE(total_amount, paid_amount))
);

-- parts used in repair orders with price snapshot at time of use
-- tracks which mechanic installed each part
CREATE TABLE IF NOT EXISTS repair_order_parts (
  order_part_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  order_id INT UNSIGNED NOT NULL,
  part_id INT UNSIGNED NOT NULL,
  mechanic_id INT UNSIGNED DEFAULT NULL,
  quantity_used INT UNSIGNED NOT NULL,
  price_applied DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (order_id, part_id),
  CONSTRAINT fk_repair_order_parts_to_orders 
    FOREIGN KEY (order_id) REFERENCES repair_orders (order_id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_repair_order_parts_to_parts 
    FOREIGN KEY (part_id) REFERENCES parts (part_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_repair_order_parts_to_mechanics 
    FOREIGN KEY (mechanic_id) REFERENCES employees (employee_id) 
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_repair_order_parts_quantity CHECK (quantity_used > 0),
  CONSTRAINT chk_repair_order_parts_price CHECK (price_applied >= 0)
);

-- services performed in repair orders with actual hours worked
-- allows tracking service pricing at time of order
CREATE TABLE IF NOT EXISTS repair_order_services (
  order_service_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  order_id INT UNSIGNED NOT NULL,
  service_id INT UNSIGNED NOT NULL,
  mechanic_id INT UNSIGNED NOT NULL,
  actual_hours DECIMAL(5,2) DEFAULT NULL,
  service_price DECIMAL(10,2) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (order_id, service_id),
  CONSTRAINT fk_repair_order_services_to_orders 
    FOREIGN KEY (order_id) REFERENCES repair_orders (order_id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_repair_order_services_to_services 
    FOREIGN KEY (service_id) REFERENCES services (service_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_repair_order_services_to_mechanics 
    FOREIGN KEY (mechanic_id) REFERENCES employees (employee_id) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_repair_order_services_hours CHECK (actual_hours >= 0),
  CONSTRAINT chk_repair_order_services_price CHECK (service_price >= 0)
);