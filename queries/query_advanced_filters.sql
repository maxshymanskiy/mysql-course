-- Select all orders from some categories
SELECT ro.order_id, ros.order_description, ros.price
FROM (repair_orders AS ro 
		INNER JOIN repair_order_services AS ros)
INNER JOIN service_categories AS sc
	ON ro.order_id = ros.order_id
	AND ros.category_id = sc.category_id
WHERE sc.category_name = 'Engine' OR sc.category_name = 'Brakes';


-- Select vehicels without any bill
SELECT v.model, v.production_year, vm.make_name
FROM vehicles AS v
INNER JOIN vehicle_makes AS  vm 
	ON v.make_id = vm.make_id
LEFT JOIN repair_orders AS ro 
	ON v.vehicle_id = ro.vehicle_id
LEFT JOIN invoices AS i 
	ON ro.order_id = i.order_id
WHERE i.invoice_id IS NULL;


-- Select mechanics who don't do any work and order any deatail
SELECT e.first_name, e.last_name 
FROM employees AS e
WHERE NOT EXISTS (
    SELECT * FROM repair_order_services AS ros
    WHERE ros.mechanic_id = e.employee_id
)
AND NOT EXISTS (
    SELECT * 
    FROM repair_order_parts AS rop
    WHERE rop.mechanic_id = e.employee_id
);

-- Select orders with parts price in specific range
SELECT ro.order_id, rop.part_name, rop.unit_price
FROM repair_orders AS ro
INNER JOIN repair_order_parts AS rop 
	ON ro.order_id = rop.order_id
WHERE rop.unit_price BETWEEN 50 AND 150;

SELECT client_id, first_name, last_name
FROM clients
WHERE first_name LIKE '%a'
	OR last_name LIKE "a%";