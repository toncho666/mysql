#---------------------------------------------------------------------------------------------------------------------------

/*� ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
 * ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.
*/

truncate table sample.users; # ������� ������� sample.users
select * from sample.users; # ���������� � ������� ������� sample.users

start transaction; # �������� ����������
insert into sample.users select * from shop.users where id = 1; #��������� � ������� sample.users ������ ������ shop.users
select * from sample.users; # ��������� ��� ������ ����������

rollback; # �������� ������������� ����������
select * from sample.users; # ��������� ��������� �� ���������� ������ ����������.

#---------------------------------------------------------------------------------------------------------------------------

/*�������� �������������, ������� ������� �������� name �������� ������� �� ������� products � 
 * ��������������� �������� �������� name �� ������� catalogs.
*/

use shop; # �������� ���� ������
drop view if exists view_of_prod;
create view view_of_prod as # ������� ������������� ....
select products.name '�������', catalogs.name '�������' # ... �� ����� ��������� �������
from products 
left join catalogs 
on products.catalog_id = catalogs.id 
order by catalogs.name, products.name;

select * from view_of_prod; # ������� �� ����� ���������� �������������

#---------------------------------------------------------------------------------------------------------------------------

/*(�� �������) ����� ������� ������� � ����������� ����� created_at. 
 * � ��� ��������� ���������� ����������� ������ �� ������ 2018 ���� '2018-08-01', '2018-08-04', '2018-08-16' � '2018-08-17'. 
 * ��������� ������, ������� ������� ������ ������ ��� �� ������, ��������� � �������� ���� �������� 1, 
 * ���� ���� ������������ � �������� ������� � 0, ���� ��� �����������.
*/

use sample; # �������� ���� ������
# ��������� �������� ������� � ��������� �� �������.
drop table if exists dates;
create table dates (
	id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	created_at datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY id (id)
	);

truncate table dates;
insert into dates values
	(default, '2018-08-01'),
	(default, '2018-08-04'),
	(default, '2018-08-16'),
	(default, '2018-08-17');

# ��������� ������� � �������� ���� 
drop table if exists day_of_month;
CREATE TEMPORARY TABLE day_of_month (
  day INT
);
INSERT INTO day_of_month
VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
       (11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
       (21), (22), (23), (24), (25), (26), (27), (28), (29), (30);


# ������� ����������, ��� ������������ ������� ����� ������ �� ������� (������ ������).
select @days := (select concat_ws('-', extract(year from (select dates.created_at from dates where dates.id=1)),
		extract(MONTH from (select dates.created_at from dates where dates.id=1)),
		'01'));
	
select  DATE(@days + INTERVAL day_of_month.day day) AS days_month, 
		case when date(dates.created_at) is null then 0 else 1 end as my_dates  # ������������� 0, ���� ����� ���� ���, 1 ���� ���� ���� ����.
		
		from day_of_month left join dates # �� �����������
		
		on DATE(@days + INTERVAL day_of_month.day day) = dates.created_at # ��� ���� �����
		
		order by days_month; #���������� �� ����� ����� ������


/*(�� �������) ����� ������� ����� ������� � ����������� ����� created_at. 
 *�������� ������, ������� ������� ���������� ������ �� �������, �������� ������ 5 ����� ������ �������.
*/

use sample;
# ������� ������� � ������
drop table if exists dates2;
create table dates2 (
	id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	created_at datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY id (id)
	);
# ��������� ������� �������
truncate table dates2;
insert into dates2 values
	(default, '2019-08-01'),
	(default, '2019-08-02'),
	(default, '2019-08-03'),
	(default, '2019-08-04'),
	(default, '2019-08-05'),
	(default, '2019-08-06'),
	(default, '2019-08-07'),
	(default, '2019-08-08'),
	(default, '2019-08-09'),
	(default, '2019-08-10'),
	(default, '2019-08-11'),
	(default, '2019-08-12');

# ������, ���������� ���� ID ����� ������ ��� (������� �����!)
#select id from dates2 order by created_at desc limit 5;
# ������, ��������� ��, ����� ���� ����� ������ ���.
delete from dates2 
where id not in (
	select id from (
		select id from dates2 order by created_at desc limit 5
					) qwerty);
				
select *from dates2 order by created_at desc;
