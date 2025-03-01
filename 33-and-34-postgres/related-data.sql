
-- stationary store demo
DROP TABLE IF EXISTS suppliers, items;

CREATE TABLE suppliers (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  supplier_name TEXT NOT NULL,
  phone TEXT,
  city TEXT
);


CREATE TABLE items (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  item_name TEXT NOT NULL,
  unit TEXT,
  unit_cost numeric,
  supplier_id INTEGER REFERENCES suppliers(id) NOT NULL
);

	
CREATE TABLE orders (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  created_at TIMESTAMPTZ DEFAULT now(),
  item_id INTEGER REFERENCES items(id) NOT NULL,
  amount numeric,
  total_cost numeric,
  shipping_status TEXT
);

-- first remove any data that may be present
TRUNCATE  suppliers, items, orders RESTART IDENTITY CASCADE;

-- insert some suppliers
INSERT INTO suppliers
  (supplier_name, phone, city)
  VALUES 
    ('Arnold Grummers Papermaking', '920-840-6056', 'Appleton'),
    ('Glatfelter', '49 (0) 3 39 86 / 69-0', 'Falkenhagen'),
    ('Blumfeld Paper', '555-6789', 'Moscow');

-- insert some items
INSERT INTO items
  (item_name, unit, unit_cost, supplier_id)
  VALUES
    ('Paper Additives', 'LBS', '3.85', 1),
    ('G-Colors Envelope Papers', 'LBS', '0.62', 2),    
    ('Abaca Sheet Pulp', 'LBS', '11.20', 1),    
    ('Unbleached Abaca', 'LBS', '1499.00', 1),    
    ('Wood pulp', 'LBS', '0.20', 3),
    ('White Envelope Papers', 'LBS', '0.52', 2);

-- insert some orders
INSERT INTO orders 
  (item_id, amount, total_cost, shipping_status)
  VALUES
    (1, 10, 38.5, 'Delivered'),
    (2, 2000, 1240, 'Shipped'),
    (3, 50, 560, 'Shipped'),
    (4, 1, 1499, 'Shipped'),
    (5, 2000, 400, 'Preparing'),
    (2, 1000, 620, 'Preparing');    
    
-- insertions etc that will not work
INSERT INTO items (item_name, unit, unit_cost)
	VALUES ('pens', 'each', .26);
	
INSERT INTO items (item_name, unit, unit_cost, supplier_id)
	VALUES ('pens', 'each', .26, 7);
	
-- this one works
INSERT INTO items (item_name, unit, unit_cost, supplier_id)
	VALUES ('pens', 'each', .26, 2);

DELETE FROM orders WHERE item_id = 2;
DELETE FROM items WHERE supplier_id = 2;
DELETE FROM suppliers WHERE supplier_name = 'Glatfelter';

SELECT orders.id, total_cost, item_name, supplier_name FROM orders 
	JOIN items ON orders.item_id = items.id
	JOIN suppliers ON items.supplier_id = suppliers.id;

SELECT item_name, amount FROM orders
	JOIN items ON orders.item_id = items.id 
	WHERE total_cost < 600;
  
  -- many to many adventures
  ALTER TABLE items DROP COLUMN supplier_id;
CREATE TABLE suppliers_items (
  supplier_id INTEGER REFERENCES suppliers(id) NOT NULL,
  item_id INTEGER REFERENCES items(id) NOT NULL,
  PRIMARY KEY (supplier_id, item_id)
);

	
INSERT INTO suppliers_items
    (supplier_id, item_id)
VALUES
    (1, 1),
    (1, 3),
    (1, 4);
INSERT INTO suppliers_items
    (supplier_id, item_id)
VALUES
    (2, 4),
    (3, 4);

SELECT * FROM suppliers
	JOIN suppliers_items on suppliers.id = suppliers_items.supplier_id 
	JOIN items ON suppliers_items.item_id = items.id
	JOIN orders ON items.id = orders.item_id ;
	
-- this will break because of the primary key constraint
INSERT INTO suppliers_items (supplier_id, item_id) VALUES (1, 1);

-- candy
CREATE TABLE candies (
	id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
	candy_name TEXT
);

CREATE TABLE colors (
	id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
	color_name TEXT
);

CREATE TABLE candies_colors(
	candy_id INTEGER REFERENCES candies(id),
	color_id INTEGER REFERENCES colors(id),
	PRIMARY KEY (candy_id, color_id)
);

INSERT INTO candies (candy_name) VALUES
	('skittles'),
	('twizzlers'),
	('airheads');
	
INSERT INTO colors (color_name) VALUES
	('red'),
	('green'),
	('orange'),
	('yellow'),
	('purple'),
	('black'),
	('brown'),
	('white');

INSERT INTO candies_colors(candy_id, color_id) VALUES
	(1,1),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(2, 1),
	(3, 1),
	(3,2),
	(3,3),
	(3,4),
	(3,5),
	(3,6),
	(3,7),
	(3,8);
	
-- Write a SELECT statement to tell me what colors skittles are
SELECT color_name FROM colors 
	JOIN candies_colors ON colors.id = candies_colors.color_id
	JOIN candies ON candies_colors.candy_id = candies.id
	WHERE candy_name = 'skittles';
	