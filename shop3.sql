
/* ������� ��������� */
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY, # ����� ��������� (������ ��������)
  name VARCHAR(255) COMMENT '�������� �������'
  #UNIQUE unique_name(name(10)) # ��������� �������� ��������, ��� ����������� � ������� � ����������� ������ ������ 10 ��������
) COMMENT = '������� ��������-��������';

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
/* ������� �������� ����������� */
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY, # ����� ���������� (������ ��������)
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� �������� ����������',
  created_at VARCHAR(255), #default CURRENT_TIMESTAMP,
  updated_at VARCHAR(255) #default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # ��� ���������� ������ ����� ���� � �����.
  #key index_of_dob (birthday_at),
  #key index_of_name (name)
) COMMENT = '����������';

/* ������� �������� ������� */
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY, # ����� �������� ������� (������ ��������)
  name VARCHAR(255) COMMENT '��������',
  desription TEXT COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id) 
) COMMENT = '�������� �������';

/* ������� ������� (��� ��������) */
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY, # ����� ������ (������ ��������)
  user_id INT UNSIGNED, # ����� ���������� (����� �����������)
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������';

/* ������� �������� ������� */
DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY, 
  order_id INT UNSIGNED, # ����� ������
  product_id INT UNSIGNED, # ����� �������� �������
  total INT UNSIGNED DEFAULT 1 COMMENT '���������� ���������� �������� �������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ ������';

/* ������� ������ */
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY, 
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
  started_at DATETIME, # ��� not null, ����� ������� �������������� �� ������� ������.
  finished_at DATETIME, # ��� not null, ����� ������� �������������� �� ������� ������.
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = '������';

/* ������� ������� */
DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses ( 
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  #key index_of_storehouse (name)
) COMMENT = '������';

/* ������� �������� �������� �� ������� */
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  #key index_of_sth_id (storehouse_id),
  #key index_of_product_id (product_id)
) COMMENT = '������ �� ������';


/*_________________________________________________________________________________________________________________________

/* ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.*/

insert ignore into users values
	(default, '�������', '1987.05.13', default, default),
	(default, '����', '1944.01.25', default, default),
	(default, '�������', '1923.12.23', default, default),
	(default, '��������', '1986.10.17', default, default);

update users set
	created_at = current_timestamp,
	updated_at = current_timestamp;

select * from users;

/*_________________________________________________________________________________________________________________________
/*������� users ���� �������� ��������������. 
 * ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� "20.10.2017 8:10". 
 * ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.*/
truncate table users;
insert ignore into users values
	(default, '�������', '1987.05.13', '20.10.2017 8:10', '20.10.2017 8:10'),
	(default, '����', '1944.01.25', '25.12.2017 8:10', '20.10.2017 8:10'),
	(default, '�������', '1923.12.23', '14.06.2017 8:10', '20.10.2017 8:19'),
	(default, '�����', '1998.08.24', '14.06.2017 8:10', '20.10.2017 8:19'),
	(default, '��������', '1986.10.17', '13.09.2017 8:10', '20.10.2017 8:10');

update users set
	created_at = str_to_date(created_at, '%d.%m.%Y %h:%i:%s'),
	updated_at = str_to_date(updated_at, '%d.%m.%Y %h:%i:%s');

select * from users;

/*_________________________________________________________________________________________________________________________
/*� ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 
 * 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, 
 * ����� ��� ���������� � ������� ���������� �������� value. ������, ������� ������ ������ ���������� � �����, 
 * ����� ���� �������.*/
truncate table storehouses_products;
insert into storehouses_products values
	(default, 220, 650, 45, default, default),
	(default, 320, 250, 0, default, default),
	(default, 240, 870, 12, default, default),
	(default, 260, 270, 7, default, default);

select * from storehouses_products order by case when value = 0 then '65535' end, value;

/*_________________________________________________________________________________________________________________________
/*�� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
 * ������ ������ � ���� ������ ���������� �������� ('may', 'august')*/
 
select * from users
where monthname(birthday_at) in ('may', 'august');

/*�� ������� catalogs ����������� ������ ��� ������ �������. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.*/

truncate table catalogs;
insert into catalogs values
	(default, '��������'),
	(default, '��������� �����'),
	(default, '����������'),
	(default, '��������'),
	(default, '����������'),
	(default, '���.�����'),
	(default, '����������'),
	(default, '������');

# ��� �������� �������
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id, 5,1,2);
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by find_in_set(id, '5,1,2');