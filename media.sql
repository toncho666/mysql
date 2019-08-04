/*Спроектировать базу данных, которая позволяла бы хранить медиа-файлы загружаемые пользователем (фото, аудио, видео).
 * Сами файлы будут храниться в файловом хранилище, база данных предназначена для хранения пути к файлу, названия,
 * описания, ключевых слов и принадлежности пользователю. */

/* таблица описания остатков на складах */
DROP TABLE IF EXISTS records;
CREATE TABLE records (
	id SERIAL PRIMARY KEY, # уникальный индекс записи.
	user_id INT UNSIGNED, #id'шник пользователя, загрузившего файл.
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, # дата и время добавления ссылки
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, # дата и время обновления, в случае перезаливания файла.
  	KEY index_user (user_id),
  	KEY index_id (id)
) COMMENT 'Записи файлов';

/* таблица описания файлов */
DROP TABLE IF EXISTS file_content;
CREATE TABLE file_content (
	id SERIAL PRIMARY KEY, # уникальный индекс записи.
	types ENUM ('foto', 'video', 'audio') NOT NULL, # тип содержимого.
	name VARCHAR(255) NOT NULL, # краткое название файла.
	description TEXT NOT NULL, # полное описание файла.
	key_words VARCHAR(255) NOT NULL, # ключевые слова, касательно файла
	KEY index_types (types),
	KEY index_name (name),
	KEY index_key_w (key_words)
) COMMENT 'Описания файлов';

/* таблица пути к файлу */
DROP TABLE IF EXISTS links;
CREATE TABLE links (
	id SERIAL PRIMARY KEY, # уникальный индекс записи.
	link VARCHAR(255) NOT NULL # ссылки на место в базе данных
) COMMENT 'Ссылки на файлы';

/* добавляем данные в таблица file_content */
insert ignore into file_content values #намеренно указал ignore, чтобы убедиться что type, name и description не принимают null
	(default, 'foto', 'природа', 'Описание природы в Африке', 'Африка, львы, пальмы, бананы'),
	(default, 'video', 'природа', 'Красота водопада в горах', 'Горы, водопад'),
	(default, 'audio', 'звуки природы', 'Этой ночью слушали сверчков', 'Насекомые, ночь, звезды'),
	(default, 'video', 'дорожные события', '10 подстав на дорогах', 'Вождение, автомобиль'),
	(default, NULL, NULL, NULL, NULL);

select * from file_content;