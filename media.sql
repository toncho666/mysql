/*�������������� ���� ������, ������� ��������� �� ������� �����-����� ����������� ������������� (����, �����, �����).
 * ���� ����� ����� ��������� � �������� ���������, ���� ������ ������������� ��� �������� ���� � �����, ��������,
 * ��������, �������� ���� � �������������� ������������. */

/* ������� �������� �������� �� ������� */
DROP TABLE IF EXISTS records;
CREATE TABLE records (
	id SERIAL PRIMARY KEY, # ���������� ������ ������.
	user_id INT UNSIGNED, #id'���� ������������, ������������ ����.
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, # ���� � ����� ���������� ������
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, # ���� � ����� ����������, � ������ ������������� �����.
  	KEY index_user (user_id),
  	KEY index_id (id)
) COMMENT '������ ������';

/* ������� �������� ������ */
DROP TABLE IF EXISTS file_content;
CREATE TABLE file_content (
	id SERIAL PRIMARY KEY, # ���������� ������ ������.
	types ENUM ('foto', 'video', 'audio') NOT NULL, # ��� �����������.
	name VARCHAR(255) NOT NULL, # ������� �������� �����.
	description TEXT NOT NULL, # ������ �������� �����.
	key_words VARCHAR(255) NOT NULL, # �������� �����, ���������� �����
	KEY index_types (types),
	KEY index_name (name),
	KEY index_key_w (key_words)
) COMMENT '�������� ������';

/* ������� ���� � ����� */
DROP TABLE IF EXISTS links;
CREATE TABLE links (
	id SERIAL PRIMARY KEY, # ���������� ������ ������.
	link VARCHAR(255) NOT NULL # ������ �� ����� � ���� ������
) COMMENT '������ �� �����';

/* ��������� ������ � ������� file_content */
insert ignore into file_content values #��������� ������ ignore, ����� ��������� ��� type, name � description �� ��������� null
	(default, 'foto', '�������', '�������� ������� � ������', '������, ����, ������, ������'),
	(default, 'video', '�������', '������� �������� � �����', '����, �������'),
	(default, 'audio', '����� �������', '���� ����� ������� ��������', '���������, ����, ������'),
	(default, 'video', '�������� �������', '10 ������� �� �������', '��������, ����������'),
	(default, NULL, NULL, NULL, NULL);

select * from file_content;