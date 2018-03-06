DROP KEYSPACE IF EXISTS labs;

CREATE KEYSPACE labs WITH REPLICATION = { 'class':'SimpleStrategy', 'replication_factor':1 };

use labs;

CREATE TABLE items(
	category TEXT,
	name TEXT,
	price DOUBLE,
	producer TEXT,
	PRIMARY KEY((category), price, name)
);


CREATE INDEX items_name ON items(name);
CREATE INDEX items_producer ON items(producer);

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "iPhone 6",
	"producer" : "Apple",
	"price" : 600
}';

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "iPhone X",
	"producer" : "Apple",
	"price" : 1200
}';

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "Galaxy",
	"producer" : "Samsung",
	"price" : 800
}';

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "S8",
	"producer" : "Samsung",
	"price" : 900
}';

INSERT INTO items JSON '{
	"category" : "Laptop",
	"name" : "Macbook Pro",
	"producer" : "Apple",
	"price" : 2500
}';

INSERT INTO items JSON '{
	"category" : "Laptop",
	"name" : "Think Pad",
	"producer" : "Lenovo",
	"price" : 1500
}';

-- Напишіть запит, який показує структуру створеної таблиці (команда DESCRIBE)

DESCRIBE items;

-- Напишіть запит, який виведe усі товари в певній категорії відсортовані за ціною

SELECT * FROM items WHERE category='Laptop' ORDER BY price;

-- Напишіть запити, які вибирають товари за різними критеріями в межах певної категорії: a) назва; b) ціна (в проміжку); c) ціна та виробник

SELECT * FROM items WHERE category='Phone' AND name='Galaxy';
SELECT * FROM items WHERE category='Laptop' AND price > 700 AND price < 1700;
SELECT * FROM items WHERE category='Phone' AND producer = 'Apple' AND price > 1000;

-- I've forgot to add characteristics for my database, and as far as I see, I will need them later
-- So I will add them to my items table now:) (See screenshot: mod1)

ALTER TABLE items ADD props map<text, text>;

-- To make it easier, I will remove all rows from the table and add a new ones

TRUNCATE items;

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "iPhone 6",
	"producer" : "Apple",
	"price" : 600,
	"props": {"color": "space_gray", "used": "true"}
}';

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "iPhone X",
	"producer" : "Apple",
	"price" : 1200,
	"props": {"color": "black", "pre_order": "true"}
}';

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "Galaxy",
	"producer" : "Samsung",
	"price" : 800,
	"props": {"warranty_months": "24", "color": "black"}
}';

INSERT INTO items JSON '{
	"category" : "Phone",
	"name" : "S8",
	"producer" : "Samsung",
	"price" : 900,
	"props": {"warranty_months": "24"}
}';

INSERT INTO items JSON '{
	"category" : "Laptop",
	"name" : "Macbook Pro",
	"producer" : "Apple",
	"price" : 2500,
	"props": {"warranty_months": "12"}
}';

INSERT INTO items JSON '{
	"category" : "Laptop",
	"name" : "Think Pad",
	"producer" : "Lenovo",
	"price" : 1500,
	"props": {"with_windows": "true"}
}';

-- Yay! Let's go on with other tasks:

-- Оновить опис товару: a) змінить існуючі значення певної характеристики; b) додайте нові властивості (характеристики) товару; c) видалить характеристику товару

UPDATE items set props['warranty_months']='12' WHERE category='Phone' AND price IN (900, 800) AND name IN ('Galaxy', 'S8');

UPDATE items set props = props + {'used':'true'} WHERE category='Phone' AND price = 800 AND name='Galaxy';

UPDATE items set props = props - {'used'} WHERE category='Phone' AND price = 600 AND name='iPhone 6';

-- Частина 2

CREATE TABLE orders(
	name text,
	id text,
	total double,
	date timestamp,
	items set<text>,
	PRIMARY KEY((name), id));

	-- Напишіть запит, який показує структуру створеної таблиці (команда DESCRIBE)

	DESCRIBE orders;

	-- Let's populate our table with appropriate data

	INSERT INTO orders(id, name, date, total, items) VALUES ('order1', 'Volodymyr Lut', '2018-01-02', 2500, {'Macbook Pro'});
	INSERT INTO orders(id, name, date, total, items) VALUES ('order2', 'Andryi Rodionov', '2018-01-01', 3700, {'Macbook Pro', 'iPhone X'});
	INSERT INTO orders(id, name, date, total, items) VALUES ('order3', 'Volodymyr Lut', '2018-01-01', 1500, {'Think Pad'});
	INSERT INTO orders(id, name, date, total, items) VALUES ('order4', 'Andryi Rodionov', '2017-12-31', 2300, {'Think Pad', 'Galaxy'});

	-- Для замовника виведіть всі його замовлення відсортовані за часом коли вони були зроблені
	-- To do so we will need to add date to our PRIMARY KEY; Let's do so.
 -- Unfortunately we are not able to ALTER table and change PRIMARY KEY (because it determines the way how our data is physically stored)
 -- I will DROP the table, create a new one, and populate it with our data.

 DROP TABLE orders;

 CREATE TABLE orders(
	name text,
	id text,
	total double,
	date timestamp,
	items set<text>,
	PRIMARY KEY((name), date));

-- Now I can ORDER_BY date, since it's a part of my new primary key

SELECT * FROM orders WHERE name='Volodymyr Lut' ORDER BY date;

-- Для замовника знайдіть замовлення з певним товаром
-- I can't get it done:(
-- Для замовника знайдіть замовлення за певний період і їх кількість

SELECT * FROM orders WHERE name='Volodymyr Lut' AND date < '2018-02-01' AND date > '2017-02-10';

-- Для кожного замовників визначте середню вартість замовлення

SELECT AVG(total) FROM orders WHERE name='Volodymyr Lut';
SELECT AVG(total) FROM orders WHERE name='Andryi Rodionov';

-- Для кожного замовників визначте суму на яку були зроблені усі його замовлення

SELECT SUM(total) FROM orders WHERE name='Volodymyr Lut';
SELECT SUM(total) FROM orders WHERE name='Andryi Rodionov';

-- Для кожного замовників визначте замовлення з максимальною вартістю

SELECT MAX(total) FROM orders WHERE name='Volodymyr Lut';
SELECT MAX(total) FROM orders WHERE name='Andryi Rodionov';

