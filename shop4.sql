
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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # при обновлении записи новая дата и время.
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




/*______________________________________________________________________________________________________
/* Подсчитайте средний возраст пользователей в таблице users */
truncate table users;
insert ignore into users values
	(default, 'Василий', '1987.05.13', default, default),
	(default, 'Петр', '1944.01.25', default, default),
	(default, 'Сергей', '1944.01.25', default, default),
	(default, 'Марина', '1944.01.25', default, default),
	(default, 'Екатерина', '1944.01.25', default, default),
	(default, 'Августина', '1944.01.25', default, default),
	(default, 'Петр', '1944.01.25', default, default),
	(default, 'Алексей', '1923.12.23', default, default),
	(default, 'Владимир', '1986.10.17', default, default);
select avg(year(current_date)-year(birthday_at)) as avg_years from users;

/*______________________________________________________________________________________________________
/* Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 */
#select name, birthday_at, dayname(birthday_at) as name_of_day from users; # таблица для проверки.
update users set birthday_at = concat(year(curdate()),'.',date_format(birthday_at,'%m.%d')); # меняем год рождения на текущий
select dayname(birthday_at) as name_of_day, count(birthday_at) from users group by name_of_day; # целевой запрос.

/*______________________________________________________________________________________________________
/* (по желанию) Подсчитайте произведение чисел в столбце таблицы
*/
truncate table storehouses_products;
insert into storehouses_products values
	(default, 220, 650, 45, default, default),
	(default, 320, 250, 0, default, default),
	(default, 240, 870, 12, default, default),
	(default, 260, 270, 7, default, default);

# запрос с учетом нуля. отрицательные значения заносить нельзя, т.к. полю установлен атрибут unsigned
select 
	case
		when min(value)=0 then 0
		else exp(sum(ln(value)))
	end as multiply
from storehouses_products;	