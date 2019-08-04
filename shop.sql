
/* таблица каталогов */
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY, # номер категории (всегда уникален)
  name VARCHAR(255) COMMENT 'Ќазвание раздела'
  #UNIQUE unique_name(name(10)) # запрещаем выставку разделов, уже добавленных в таблицу и индексируем только первые 10 символов
) COMMENT = '–азделы интернет-магазина';

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
  id SERIAL PRIMARY KEY, # номер покупател€ (всегда уникален)
  name VARCHAR(255) COMMENT '»м€ покупател€',
  birthday_at DATE COMMENT 'ƒата рождени€ покупател€',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # при обновлении записи нова€ дата и врем€.
  #key index_of_dob (birthday_at),
  #key index_of_name (name)
) COMMENT = 'ѕокупатели';

/* таблица товарных позиций */
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY, # номер товарной позиции (всегда уникален)
  name VARCHAR(255) COMMENT 'Ќазвание',
  desription TEXT COMMENT 'ќписание',
  price DECIMAL (11,2) COMMENT '÷ена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id) 
) COMMENT = '“оварные позиции';

/* таблица заказов (без описани€) */
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY, # номер заказа (всегда уникален)
  user_id INT UNSIGNED, # номер покупател€ (может повтор€тьс€)
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '«аказы';

/* таблица описани€ заказов */
DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY, 
  order_id INT UNSIGNED, # номер заказа
  product_id INT UNSIGNED, # номер товарной позиции
  total INT UNSIGNED DEFAULT 1 COMMENT ' оличество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '—остав заказа';

/* таблица скидок */
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY, 
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT '¬еличина скидки от 0.0 до 1.0',
  started_at DATETIME, # без not null, чтобы вводить неограниченные по времени скидки.
  finished_at DATETIME, # без not null, чтобы вводить неограниченные по времени скидки.
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = '—кидки';

/* таблица складов */
DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses ( 
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Ќазвание',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  #key index_of_storehouse (name)
) COMMENT = '—клады';

/* таблица описани€ остатков на складах */
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '«апас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  #key index_of_sth_id (storehouse_id),
  #key index_of_product_id (product_id)
) COMMENT = '«апасы на складе';


/*_________________________________________________________________________________________________________________________

/*ѕусть в таблице catalogs базы данных shop в строке name могут находитьс€ пустые строки и пол€, принимающие значение NULL.
 * Ќаписать запрос, который замен€ет все такие пол€ на строку 'empty'*/

# дл€ выполнени€ запроса пришлось закомментировать опцию UNIQUE, иначе не указыветс€ empty более 1 раза.
INSERT INTO catalogs VALUES
  (DEFAULT, 'ћатеринские платы'),
  (DEFAULT, 'ѕроцессоры'),
  (DEFAULT, '¬идеокарты'),
  (DEFAULT, NULL),
  (DEFAULT, '');

UPDATE catalogs SET name = 'empty' WHERE name IS NULL OR name = '';
SELECT * FROM catalogs;

