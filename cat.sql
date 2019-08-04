
/*в учебной базе данных shop присутствует таблица catalogs. Пусть в базе данных sample имеется таблица cat, в которой
 * могут присутствовать строки с такими же первичными ключами. Написать запрос, который копирует данные из таблицы
 * catalogs в таблицу cat, при этом для записей с конфликтующими первичными ключами в таблице cat должна производиться
 * замена значениями из таблица catalogs. Выполнить одним SQL запросом*/


drop table if exists cat;
create table cat (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
	#UNIQUE unique_name(name(10))
) ;

INSERT INTO cat VALUES
	(default, 'Внешние накопители'),
	(default, 'Мониторы'),
	(default, 'Мышки'),
	(default, 'Клавиатуры'),
	(default, 'Принтеры'),
	(default, 'Планшеты');

select * from cat;

replace into cat select * from shop.catalogs;
select * from cat;
select * from shop.catalogs;
#select * from shop.catalogs where shop.catalogs.id = cat.id;
