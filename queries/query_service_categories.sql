-- Select all clinets that have `a` in their names 
SELECT client_id, first_name, last_name
FROM clients
WHERE first_name LIKE '%a'
	OR last_name LIKE "a%"
ORDER BY last_name ASC;

-- Select payments by date
SELECT payment_id, order_id, amount, payment_method, payment_date
FROM payments
ORDER BY payment_date DESC LIMIT 6;

-- Sort by category name
SELECT sc.category_name, ros.order_description, ros.order_id, ros.price
FROM repair_order_services AS ros
INNER JOIN service_categories AS sc
	ON ros.category_id = sc.category_id
ORDER BY sc.category_name ASC, price DESC;

-- Calculate count and avg of each service, group by `category_name`
SELECT 
	sc.category_name, 
	COUNT(ros.order_id),
    AVG(ros.price)
FROM repair_order_services AS ros
INNER JOIN service_categories AS sc
	ON ros.category_id = sc.category_id
GROUP BY sc.category_name;
