
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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # ��� ���������� ������ ����� ���� � �����.
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

/*����� � ������� catalogs ���� ������ shop � ������ name ����� ���������� ������ ������ � ����, ����������� �������� NULL.
 * �������� ������, ������� �������� ��� ����� ���� �� ������ 'empty'*/

# ��� ���������� ������� �������� ���������������� ����� UNIQUE, ����� �� ���������� empty ����� 1 ����.
INSERT INTO catalogs VALUES
  (DEFAULT, '����������� �����'),
  (DEFAULT, '����������'),
  (DEFAULT, '����������'),
  (DEFAULT, NULL),
  (DEFAULT, '');

UPDATE catalogs SET name = 'empty' WHERE name IS NULL OR name = '';
SELECT * FROM catalogs;

