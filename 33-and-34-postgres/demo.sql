-- SQL
CREATE TABLE items (
-- column name
--    data type
--             extras??
	id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
	item_name TEXT NOT NULL,
	description TEXT,
	completed BOOLEAN DEFAULT false,
	created TIMESTAMPTZ DEFAULT now()
);

INSERT INTO items (item_name, description)
    VALUES ('avocado', 'delicious and green');
   
INSERT INTO items (item_name) VALUES ('box fan');

-- this one breaks - we said that item_name couldn't be null
INSERT INTO items(description) VALUES ('this is a description');

	
INSERT INTO items 
  (item_name, description)
VALUES 
  ('Avocados', 'avocado mash'),
  ('Orange juice', 'not just for breakfast'),
  ('Ice Cream', 'Ben & Jerry''s'),
  ('Oil Change', 'stop at dealership'),
  ('Cat Food', null),
  ('Sun Glasses', 'for vacation'),
  ('Dark roast', 'nectar of the gods'),
  ('Running Shoes', null),
  ('Espresso', 'nectar of the gods'),
  ('Merlot', 'for dinner');
  
 DELETE FROM items WHERE id = 15;
 DELETE FROM items WHERE id > 15;
 
UPDATE items 
	SET description = 'it makes a breeze happen' 
	WHERE item_name = 'box fan';
	
-- DANGER WARNING, this will delete everything because we haven't limited it with a WHERE clause
DELETE FROM items;

-- reading data: the fun stuff
SELECT * FROM items;
-- only get specific columns: list those columns instead of the *
SELECT description, id FROM items;
-- only get specific rows: use a WHERE clause
SELECT * FROM items WHERE id > 30;
SELECT * FROM items WHERE description IS NOT NULL;
SELECT * FROM items WHERE id > 30 AND id < 36;
-- only get things whose name contains "ca"
SELECT * FROM items WHERE item_name LIKE 'R%';
SELECT * FROM items WHERE item_name ILIKE '%ca%o%';

-- using the products data from https://raw.githubusercontent.com/Thinkful-Ed/starter-postgresql/main/products.sql
SELECT * FROM products WHERE aisle = 'coffee';

SELECT DISTINCT aisle FROM products;

SELECT COUNT(*) from products;
SELECT COUNT(DISTINCT aisle) FROM products;

SELECT * FROM products WHERE aisle = 'tea' AND price <= 30 AND price >= 20;

SELECT * FROM products WHERE aisle = 'tea' 
	AND price BETWEEN 20 AND 30
	AND product_name LIKE '%Herbal%';

SELECT * FROM products WHERE department = 'pets' ORDER BY price DESC;

SELECT COUNT(*), department FROM products GROUP BY department;

--What's the average cost of all products by dept (rounded to 2 decimals), sorted from lowest to highest?
SELECT ROUND(AVG(price), 2) AS average_price, department 
	FROM products 
	GROUP BY department 
	ORDER BY average_price;