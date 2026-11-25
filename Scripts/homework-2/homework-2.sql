/*
Выборка + фильтрация + сортировка (в одном запросе). Выведите title и views всех опубликованных статей категории 2
(«Базы данных»), отсортированных по views по убыванию.
*/

SELECT title, views
FROM posts
WHERE category_id = 2
  AND published
ORDER BY views DESC;

/*
Пагинация. Выведите 3 самые «свежие» (по created_at) неопубликованные статьи — title и created_at. Отсортируйте по
created_at DESC и возьмите LIMIT 3.
*/

SELECT title, created_at
FROM posts
WHERE NOT published
ORDER BY created_at DESC
LIMIT 3;

/*
Правка данных + RETURNING. Добавьте нового автора и одну его статью (сначала INSERT автора с RETURNING id, затем INSERT
поста, используя полученный author_id). После этого увеличьте просмотры этой статьи на 1 (UPDATE ... RETURNING) и
удалите другой пост (DELETE ... RETURNING).
*/

DO $$
DECLARE
    new_author_id INTEGER;
    new_post_id   INTEGER;
    updated_views INTEGER;
    deleted_id    INTEGER;
BEGIN
    INSERT INTO authors (name, email)
    VALUES ('Джон Доу', 'john@blog.dev')
    RETURNING id INTO new_author_id;

    INSERT INTO posts (title, author_id, category_id, content, published)
    VALUES ('Новый пост', new_author_id, 4, 'Новый контент', TRUE)
    RETURNING id INTO new_post_id;

    UPDATE posts
    SET views = views + 1
    WHERE id = new_post_id
    RETURNING views INTO updated_views;

    DELETE FROM posts WHERE id = (SELECT MIN(id) FROM posts)
    RETURNING id INTO deleted_id;
END $$;

/*
Список без дубликатов. Выведите уникальные пары (author_id, category_id) из таблицы posts, отсортированные по author_id,
затем по category_id.
*/

SELECT DISTINCT author_id, category_id -- в качестве кортежа даже интереснее будет DISTINCT (author_id, category_id)
FROM posts
ORDER BY author_id, category_id; -- при DISTINCT (author_id, category_id) -> ORDER BY (author_id, category_id)

/*
⭐ Звёздочка (самостоятельное изучение): RETURNING и ON CONFLICT. Разберитесь с UPSERT: напишите
INSERT INTO authors (name, email) VALUES (...) ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name RETURNING id, name;.
Объясните своими словами в комментарии к запросу: что делает ON CONFLICT (email) и DO UPDATE, и при чём тут EXCLUDED.
Подсказка: посмотрите главу про INSERT ... ON CONFLICT в словаре PostgreSQL.
*/

INSERT INTO authors (name, email)
VALUES ('Джон Доу', 'john@blog.dev')
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
RETURNING id, name;

/*
ON CONFLICT проверяет, нет ли уже записи с таким email. Если email уже существует, вместо ошибки выполняется обновление
записи. DO UPDATE обновляет имя существующего автора. EXCLUDED.name — это новое значение name, которое пытались
добавить через INSERT, но оно не было вставлено из-за конфликта.
*/

/*
⭐ Звёздочка (сложное условие WHERE с AND/OR/IS NULL). Выведите title, published, views, category_id для статей, которые
удовлетворяют такому условию: (опубликована и имеет более 100 просмотров) ИЛИ (не опубликована и не имеет категории).
Используйте скобки и IS NULL, чтобы условие читалось однозначно. Проверьте себя: какой из запросов — A OR B AND C — даст
«неожиданный» результат, и почему? Опишите разницу в комментарии.
 */

SELECT title, published, views, category_id
FROM posts
WHERE (published AND views > 100)
   OR (NOT published AND category_id IS NULL);

/*
A OR B AND C — первая часть условия A будет выполнена независимо от C.
PostgreSQL воспринимает A OR B AND C как A OR (B AND C)
*/
