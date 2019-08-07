#_________________________________________________________________________________________
/* ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������. */

truncate table orders; # ������� ������� �������.
insert into orders values  # ��������� ���������� ������.
		(default, 1, default, default),
		(default, 7, default, default),
		(default, 4, default, default),
		(default, 3, default, default);

# ��������� ������ �������������, ��� �������� ���� �� ���� �����.
select users.name, orders.id as '����� ������', orders.created_at as '���� ������������' 
from users right join orders 
on users.id=orders.user_id;


#_________________________________________________________________________________________
/* �������� ������ ������� products � �������� catalogs, ������� ������������� ������. */

truncate table catalogs; # ������� ������� ���������.
insert into catalogs values  # ��������� ��������.
		(default, '��������'),
		(default, '��������'),
		(default, '����������'),
		(default, '���.�����');

truncate table products; # ������� ����������� �������.
insert into products values  # ��������� ��������.
		(default, 'LaserJet6758', '������� �������', 860, 1, default, default),
		(default, 'Lexmark', '������� ������� hd', 800, 1, default, default),
		(default, 'Samsung', '������� hd', 1500, 2, default, default),
		(default, 'NEC', '������� fullHD', 2400, 2, default, default),
		(default, 'LG', '������� ������� ���������� ������������', 1980, 2, default, default),
		(default, 'SHARP', '��������', 1999, 2, default, default),
		(default, 'Core i3', '��������� ��� �����', 3400, 3, default, default),
		(default, 'Core i5', '��������� ��� ������', 1409, 3, default, default),
		(default, 'Core i7', '��������� ��� ���', 4500, 3, default, default),
		(default, '���.����� 1', '������� ����������� �����', 860, 4, default, default),
		(default, '���.����� 2', '������� ����������� �����', 870, 4, default, default),
		(default, '���.����� 3', '��, ��� �����!', 1000, 4, default, default),
		(default, 'Apple', '������� �������', 5000, 2, default, default),
		(default, 'Xiaomi', '������� ������� �� �����������', 890, 1, default, default),
		(default, 'Samsung', '������� �������', 790, 1, default, default),
		(default, 'LaserJet6689', '������� � ���������� � ���������', 880, 1, default, default);

# ����������� � ������� �������� ��������������� ��� ��������� � ��������.
select products.name as '��������', catalogs.name as '�������'  #�������� ����
from products join catalogs # �� �����������.
on products.catalog_id=catalogs.id # ��� ����� ���������.
order by catalogs.name, products.name; # � ��������� ������� �� ��������, ����� �� �������� � ������ ��������.


#_________________________________________________________________________________________
/* (�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name). 
 * ���� from, to � label �������� ���������� �������� �������, ���� name � �������. 
 * �������� ������ ������ flights � �������� ���������� �������.*/

drop table if exists flights;
create table flights(
		id INT unsigned NOT NULL AUTO_INCREMENT,
		city_from Varchar(100),
		city_to Varchar(100),
		PRIMARY KEY (`id`),
		UNIQUE KEY `id` (`id`)
		);

insert into flights values  # ��������� ������� flights.
		(default, 'moscow', 'omsk'),
		(default, 'novgorod', 'kazan'),
		(default, 'irkutsk', 'moscow'),
		(default, 'omsk', 'irkutsk'),
		(default, 'moscow', 'kazan');

drop table if exists cities;
create table cities(
		lable Varchar(100),
		name Varchar(100)
		);

insert into cities values  # ��������� ������� flights.
		('moscow', '������'),
		('irkutsk', '�������'),
		('novgorod', '��������'),
		('kazan', '������'),
		('omsk', '����');

# �������� ������� ������� �� �������
drop table if exists city_from;
create table city_from select flights.id, cities.name as out_fly from flights left join cities on flights.city_from = cities.lable;
# �������� ���������������� �� �������
drop table if exists city_to;
create table city_to select flights.id, cities.name as in_fly from flights left join cities on flights.city_to = cities.lable;
#���������� ��� ��� �������
select city_from.out_fly, city_to.in_fly from city_from left join city_to on city_from.id = city_to.id order by city_to.id;
