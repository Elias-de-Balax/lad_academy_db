/*
Добавить в каждую таблицу по несколько строк через INSERT (2–3 тега в tags, и для каждого поста — назначить 
один-два тега в post_tags). После этого выполнить SELECT * FROM post_tags; и убедиться, что связи заполнены.
 */

INSERT INTO posts 
VALUES(1, 'Введение в PostgreSQL', 'Текст 1');

INSERT INTO posts 
VALUES(2, 'Введение в Python', 'Текст 2');

INSERT INTO posts 
VALUES(3, 'Введение в Django"', 'Текст 3');

INSERT INTO tags VALUES (1, 'Python', 'python');
INSERT INTO tags VALUES (2, 'PostgreSQL', 'postgresql');
INSERT INTO tags VALUES (3, 'Web', 'web');
INSERT INTO tags VALUES (4, 'Django', 'django');

INSERT INTO post_tags VALUES (1, 2);
INSERT INTO post_tags VALUES (2, 1);
INSERT INTO post_tags VALUES (2, 3);
INSERT INTO post_tags VALUES (3, 3);
INSERT INTO post_tags VALUES (3, 4);



