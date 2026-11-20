/*
Создать в PostgreSQL (в контейнере blog_postgres, база blog) таблицу tags (теги). В ней должны быть колонки id, name 
(уникальное имя, не пустое), slug (текстовая метка для URL, не пустая). Обязательно задать SERIAL PRIMARY KEY для id.
Связать посты и теги связью многие-ко-многим через промежуточную таблицу post_tags. Она должна содержать два внешних 
ключа — на posts.id и на tags.id — и первичный ключ, собранный из обеих колонок (PRIMARY KEY (post_id, tag_id)). 
Подсказка: вспомните, что для связи M-N нужна отдельная таблица-«мост».
 */

DROP TABLE IF EXISTS post_tags;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS tags;

--CREATE SCHEMA IF NOT EXISTS db_homework_1

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(1000) NOT NULL
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL UNIQUE,
    content VARCHAR(1000) NOT NULL,
    create_at TIMESTAMP NOT NULL DEFAULT now()
);
    
CREATE TABLE post_tags (
    post_id INTEGER NOT NULL REFERENCES posts(id),
    tag_id INTEGER NOT NULL REFERENCES tags(id),

    CONSTRAINT pk_post_tags PRIMARY KEY (post_id, tag_id)
);