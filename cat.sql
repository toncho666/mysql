
/*� ������� ���� ������ shop ������������ ������� catalogs. ����� � ���� ������ sample ������� ������� cat, � �������
 * ����� �������������� ������ � ������ �� ���������� �������. �������� ������, ������� �������� ������ �� �������
 * catalogs � ������� cat, ��� ���� ��� ������� � �������������� ���������� ������� � ������� cat ������ �������������
 * ������ ���������� �� ������� catalogs. ��������� ����� SQL ��������*/


drop table if exists cat;
create table cat (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
	#UNIQUE unique_name(name(10))
) ;

INSERT INTO cat VALUES
	(default, '������� ����������'),
	(default, '��������'),
	(default, '�����'),
	(default, '����������'),
	(default, '��������'),
	(default, '��������');

select * from cat;

replace into cat select * from shop.catalogs;
select * from cat;
select * from shop.catalogs;
#select * from shop.catalogs where shop.catalogs.id = cat.id;
