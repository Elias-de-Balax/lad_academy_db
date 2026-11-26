/*
JOIN-запрос: выведите список постов с именем автора, названием категории и числом просмотров. Отсортируйте по просмотрам
по убыванию (ORDER BY views DESC).
*/

SELECT p.title, a.name, c.name, p.views
FROM posts p
    INNER JOIN categories c ON p.category_id = c.id
    INNER JOIN authors a ON p.author_id = a.id
ORDER BY p.views DESC;

SELECT p.title, a.name, c.name, p.views
FROM posts p
    LEFT JOIN categories c ON p.category_id = c.id
    LEFT JOIN authors a ON p.author_id = a.id
ORDER BY p.views DESC;

/*
Агрегация: посчитайте количество постов у каждого автора (author) — используйте LEFT JOIN авторов с постами и GROUP BY,
чтобы не потерять авторов без постов. Подсказка: рядом выведите и COUNT(p.id), чтобы сравнить с COUNT(*).
*/

SELECT a.name, COUNT(*) AS all_posts_count, COUNT(p.id) AS posts_count
FROM authors a
    LEFT JOIN posts p ON a.id = p.author_id
GROUP BY a.name;

/*
Группировка: посчитайте количество постов в каждой категории и среднее число просмотров по категории. Подсказка:
GROUP BY c.name + AVG(p.views).
*/

SELECT
    c.name,
    COUNT(p.id) AS posts_count,
    COALESCE(ROUND(AVG(p.views), 2), 0) AS avg_views
FROM categories c
    LEFT JOIN posts p ON c.id = p.category_id
GROUP BY c.name;

/*
⭐ Звёздочка: изучите и примените FULL JOIN и CROSS JOIN. Напишите и выполните по одному запросу каждого типа на
таблицах authors и posts. Объясните: что покажет CROSS JOIN (сколько строк в результате и почему) и чем
FULL JOIN отличается от LEFT/RIGHT. Запишите выводы комментарием к SQL.
*/

SELECT a.name, p.title, p.views
FROM authors a
    FULL JOIN posts p ON a.id = p.author_id;

-- FULL JOIN - объединение таблиц authors и posts (отображает и пустые строки в обеих таблицах)

SELECT a.name, p.title, p.views
FROM authors a
    CROSS JOIN posts p;

-- CROSS JOIN - декартово произведение таблиц authors и posts, n*m строк

/*
⭐⭐ Звёздочка: выполните две мини-задачи:
посчитайте количество уникальных авторов, у которых есть посты, через COUNT(DISTINCT author_id) (пользуясь тем же JOIN);
найдите топ категории по числу постов — категорию с наибольшим количеством постов (для одной категории — через
ORDER BY ... DESC LIMIT 1, для всех с ранжированием — через GROUP BY + HAVING/ORDER BY).
 */

-- количество уникальных авторов
SELECT COUNT(DISTINCT p.author_id) AS authors_with_posts
FROM authors a
    LEFT JOIN posts p ON a.id = p.author_id;

-- одна топ-категория
SELECT c.name, COUNT(p.id) AS posts_count
FROM categories c
    LEFT JOIN posts p ON c.id = p.category_id
GROUP BY c.name
ORDER BY posts_count DESC
LIMIT 1;

-- все категории с ранжированием
SELECT c.name, COUNT(p.id) AS posts_count
FROM categories c
    LEFT JOIN posts p ON c.id = p.category_id
GROUP BY c.name
HAVING COUNT(p.id) > 0
ORDER BY posts_count DESC;