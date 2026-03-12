UPDATE clients SET middle_name ="Junior"
	WHERE first_name LIKE "m%";

DELETE FROM employees 
	WHERE (pay_type="hourly" AND pay_rate < 23.00);