
/* таблица каталогов */
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY, # номер категории (всегда уникален)
  name VARCHAR(255) COMMENT 'Название раздела'
  #UNIQUE unique_name(name(10)) # запрещаем выставку разделов, уже добавленных в таблицу и индексируем только первые 10 символов
) COMMENT = 'Разделы интернет-магазина';

#-----------------------------------------------------------------------
 
DROP TABLE IF EXISTS cat;
CREATE TABLE cat (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

#-----------------------------------------------------------------------
/*INSERT INTO
  cat
SELECT
  *
FROM
  catalogs;
SELECT * FROM cat;
*/

#-----------------------------------------------------------------------
/* таблица товарных покупателей */
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY, # номер покупателя (всегда уникален)
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения покупателя',
  created_at VARCHAR(255), #default CURRENT_TIMESTAMP,
  updated_at VARCHAR(255) #default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # при обновлении записи новая дата и время.
  #key index_of_dob (birthday_at),
  #key index_of_name (name)
) COMMENT = 'Покупатели';

/* таблица товарных позиций */
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY, # номер товарной позиции (всегда уникален)
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id) 
) COMMENT = 'Товарные позиции';

/* таблица заказов (без описания) */
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY, # номер заказа (всегда уникален)
  user_id INT UNSIGNED, # номер покупателя (может повторяться)
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

/* таблица описания заказов */
DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY, 
  order_id INT UNSIGNED, # номер заказа
  product_id INT UNSIGNED, # номер товарной позиции
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

/* таблица скидок */
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY, 
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME, # без not null, чтобы вводить неограниченные по времени скидки.
  finished_at DATETIME, # без not null, чтобы вводить неограниченные по времени скидки.
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

/* таблица складов */
DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses ( 
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  #key index_of_storehouse (name)
) COMMENT = 'Склады';

/* таблица описания остатков на складах */
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  #key index_of_sth_id (storehouse_id),
  #key index_of_product_id (product_id)
) COMMENT = 'Запасы на складе';


/*_________________________________________________________________________________________________________________________

/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.*/

insert ignore into users values
	(default, 'Василий', '1987.05.13', default, default),
	(default, 'Петр', '1944.01.25', default, default),
	(default, 'Алексей', '1923.12.23', default, default),
	(default, 'Владимир', '1986.10.17', default, default);

update users set
	created_at = current_timestamp,
	updated_at = current_timestamp;

select * from users;

/*_________________________________________________________________________________________________________________________
/*Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
 * Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.*/
truncate table users;
insert ignore into users values
	(default, 'Василий', '1987.05.13', '20.10.2017 8:10', '20.10.2017 8:10'),
	(default, 'Петр', '1944.01.25', '25.12.2017 8:10', '20.10.2017 8:10'),
	(default, 'Алексей', '1923.12.23', '14.06.2017 8:10', '20.10.2017 8:19'),
	(default, 'Федор', '1998.08.24', '14.06.2017 8:10', '20.10.2017 8:19'),
	(default, 'Владимир', '1986.10.17', '13.09.2017 8:10', '20.10.2017 8:10');

update users set
	created_at = str_to_date(created_at, '%d.%m.%Y %h:%i:%s'),
	updated_at = str_to_date(updated_at, '%d.%m.%Y %h:%i:%s');

select * from users;

/*_________________________________________________________________________________________________________________________
/*В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 * 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
 * чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, 
 * после всех записей.*/
truncate table storehouses_products;
insert into storehouses_products values
	(default, 220, 650, 45, default, default),
	(default, 320, 250, 0, default, default),
	(default, 240, 870, 12, default, default),
	(default, 260, 270, 7, default, default);

select * from storehouses_products order by case when value = 0 then '65535' end, value;

/*_________________________________________________________________________________________________________________________
/*Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий ('may', 'august')*/
 
select * from users
where monthname(birthday_at) in ('may', 'august');

/*Из таблицы catalogs извлекаются записи при помощи запроса. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.*/

truncate table catalogs;
insert into catalogs values
	(default, 'Мониторы'),
	(default, 'Системные блоки'),
	(default, 'Накопители'),
	(default, 'Принтеры'),
	(default, 'Видеокарты'),
	(default, 'Мат.платы'),
	(default, 'Процессоры'),
	(default, 'Другое');

# два варианта выборки
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id, 5,1,2);
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by find_in_set(id, '5,1,2');