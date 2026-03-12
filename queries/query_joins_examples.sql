-- Simple select
SELECT *
FROM payments
WHERE payment_id = 2;

-- Select clients and their cars
SELECT c.client_id, c.first_name, c.last_name, ro.order_id, ro.order_status, ro.order_date
FROM clients AS c
LEFT JOIN repair_orders AS ro
	ON c.client_id = ro.client_id;

-- Check order status of the car
SELECT c.first_name, c.last_name, v.model, ro.order_status
FROM clients AS c
LEFT JOIN repair_orders AS ro
	ON c.client_id = ro.client_id 
LEFT JOIN vehicles AS v
	ON c.client_id = v.client_id;
    
 -- Using `NATURAL` join
SELECT position_name, first_name, last_name, pay_type, pay_rate
FROM employees
NATURAL JOIN positions;

-- Select with condition
SELECT e.first_name, e.last_name, ros.order_description, ros.price
FROM employees AS e
INNER JOIN repair_order_services AS ros
ON e.employee_id = ros.mechanic_id
WHERE ros.price > 150;
    
-- Selcet all services with employee and specific `category_name`
SELECT e.first_name, e.last_name, sc.category_name, ros.order_description, ros.price
FROM (employees AS e
		INNER JOIN repair_order_services ros)
LEFT JOIN service_categories AS sc
	ON e.employee_id = ros.mechanic_id
    AND ros.category_id = sc.category_id
WHERE sc.category_name IN ("Engine", "Transmission");