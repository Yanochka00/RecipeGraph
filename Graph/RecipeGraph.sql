USE master;
GO
DROP DATABASE IF EXISTS RecipeGraph;
GO
CREATE DATABASE RecipeGraph;
GO

USE RecipeGraph;
GO

-- Создание таблиц узлов
DROP TABLE IF EXISTS Recipes;
CREATE TABLE Recipes (
    ID INT PRIMARY KEY,
    Title VARCHAR(100),
    CookingTime INT,
    Instructions TEXT
) AS NODE;

DROP TABLE IF EXISTS Ingredients;
CREATE TABLE Ingredients (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Quantity VARCHAR(50)
) AS NODE;

DROP TABLE IF EXISTS CookingMethods;
CREATE TABLE CookingMethods (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
) AS NODE;

-- Вставка данных в таблицы узлов
INSERT INTO Recipes (ID, Title, CookingTime, Instructions)
VALUES 
(1, 'Паста карбонара', 30, 'Смешать ингредиенты и готовить на среднем огне.'),
(2, 'Цезарь салат', 15, 'Смешать ингредиенты и подавать с соусом.'),
(3, 'Шоколадный торт', 60, 'Приготовить тесто, выпекать и остудить.'),
(4, 'Омлет', 10, 'Взбить яйца и жарить на сковороде.'),
(5, 'Курица терияки', 45, 'Запечь курицу с соусом терияки.'),
(6, 'Тайский карри', 40, 'Приготовить все ингредиенты в кастрюле.'),
(7, 'Ризотто', 30, 'Медленно варить рис с бульоном.'),
(8, 'Бургер', 25, 'Собрать все ингредиенты и жарить на гриле.'),
(9, 'Суп минестроне', 50, 'Смешать овощи и варить до готовности.'),
(10, 'Печенье', 20, 'Смешать тесто и выпекать.');

INSERT INTO Ingredients (ID, Name, Quantity)
VALUES 
(1, 'Спагетти', '200 г'),
(2, 'Яйца', '2 шт.'),
(3, 'Бекон', '100 г'),
(4, 'Салат', '1 шт.'),
(5, 'Куриное филе', '300 г'),
(6, 'Соус терияки', '50 мл'),
(7, 'Шоколад', '200 г'),
(8, 'Мука', '300 г'),
(9, 'Грибы', '150 г'),
(10, 'Лук', '1 шт.');

INSERT INTO CookingMethods (ID, Name)
VALUES 
(1, 'Варка'),
(2, 'Жарка'),
(3, 'Запекание'),
(4, 'Тушение'),
(5, 'Запаривание'),
(6, 'Приготовление на пару'),
(7, 'Гриль'),
(8, 'Запекание в микроволновке'),
(9, 'Смешивание'),
(10, 'Копчение');

-- Создание таблиц рёбер
DROP TABLE IF EXISTS RecipesOfIngredients;
CREATE TABLE RecipesOfIngredients AS EDGE;

DROP TABLE IF EXISTS RecipesOfCookingMethods;
CREATE TABLE RecipesOfCookingMethods AS EDGE;

DROP TABLE IF EXISTS IngredientsPreparationMethods;
CREATE TABLE IngredientsPreparationMethods AS EDGE;

-- Ингредиенты
INSERT INTO RecipesOfIngredients
VALUES ((SELECT $node_id FROM Recipes WHERE ID = 1), (SELECT $node_id FROM Ingredients WHERE ID = 1)),
       ((SELECT $node_id FROM Recipes WHERE ID = 1), (SELECT $node_id FROM Ingredients WHERE ID = 2)),
       ((SELECT $node_id FROM Recipes WHERE ID = 1), (SELECT $node_id FROM Ingredients WHERE ID = 3)),
       ((SELECT $node_id FROM Recipes WHERE ID = 2), (SELECT $node_id FROM Ingredients WHERE ID = 4)),
       ((SELECT $node_id FROM Recipes WHERE ID = 5), (SELECT $node_id FROM Ingredients WHERE ID = 5)),
       ((SELECT $node_id FROM Recipes WHERE ID = 6), (SELECT $node_id FROM Ingredients WHERE ID = 6)),
       ((SELECT $node_id FROM Recipes WHERE ID = 3), (SELECT $node_id FROM Ingredients WHERE ID = 7)),
       ((SELECT $node_id FROM Recipes WHERE ID = 3), (SELECT $node_id FROM Ingredients WHERE ID = 8)),
       ((SELECT $node_id FROM Recipes WHERE ID = 4), (SELECT $node_id FROM Ingredients WHERE ID = 2)),
       ((SELECT $node_id FROM Recipes WHERE ID = 8), (SELECT $node_id FROM Ingredients WHERE ID = 9));

-- Вставка методов приготовления
INSERT INTO RecipesOfCookingMethods
VALUES ((SELECT $node_id FROM Recipes WHERE ID = 1), (SELECT $node_id FROM CookingMethods WHERE ID = 2)),
       ((SELECT $node_id FROM Recipes WHERE ID = 2), (SELECT $node_id FROM CookingMethods WHERE ID = 1)),
       ((SELECT $node_id FROM Recipes WHERE ID = 3), (SELECT $node_id FROM CookingMethods WHERE ID = 3)),
       ((SELECT $node_id FROM Recipes WHERE ID = 4), (SELECT $node_id FROM CookingMethods WHERE ID = 2)),
       ((SELECT $node_id FROM Recipes WHERE ID = 5), (SELECT $node_id FROM CookingMethods WHERE ID = 4)),
       ((SELECT $node_id FROM Recipes WHERE ID = 6), (SELECT $node_id FROM CookingMethods WHERE ID = 4)),
       ((SELECT $node_id FROM Recipes WHERE ID = 7), (SELECT $node_id FROM CookingMethods WHERE ID = 5)),
       ((SELECT $node_id FROM Recipes WHERE ID = 8), (SELECT $node_id FROM CookingMethods WHERE ID = 5)),
       ((SELECT $node_id FROM Recipes WHERE ID = 9), (SELECT $node_id FROM CookingMethods WHERE ID = 1)),
       ((SELECT $node_id FROM Recipes WHERE ID = 10), (SELECT $node_id FROM CookingMethods WHERE ID = 3));

-- Вставка методов приготовления для ингредиентов
INSERT INTO IngredientsPreparationMethods
VALUES ((SELECT $node_id FROM Ingredients WHERE ID = 1), (SELECT $node_id FROM CookingMethods WHERE ID = 1)),
       ((SELECT $node_id FROM Ingredients WHERE ID = 2), (SELECT $node_id FROM CookingMethods WHERE ID = 2)),
       ((SELECT $node_id FROM Ingredients WHERE ID = 3), (SELECT $node_id FROM CookingMethods WHERE ID = 3)),
       ((SELECT $node_id FROM Ingredients WHERE ID = 4), (SELECT $node_id FROM CookingMethods WHERE ID = 2)),
       ((SELECT $node_id FROM Ingredients WHERE ID = 5), (SELECT $node_id FROM CookingMethods WHERE ID = 4)), 
       ((SELECT $node_id FROM Ingredients WHERE ID = 6), (SELECT $node_id FROM CookingMethods WHERE ID = 5)), 
       ((SELECT $node_id FROM Ingredients WHERE ID = 7), (SELECT $node_id FROM CookingMethods WHERE ID = 3)), 
       ((SELECT $node_id FROM Ingredients WHERE ID = 8), (SELECT $node_id FROM CookingMethods WHERE ID = 9)), 
       ((SELECT $node_id FROM Ingredients WHERE ID = 9), (SELECT $node_id FROM CookingMethods WHERE ID = 5)), 
       ((SELECT $node_id FROM Ingredients WHERE ID = 10), (SELECT $node_id FROM CookingMethods WHERE ID = 2)); 

-------------------------------- Match ---------------------

-- 1. Найти все рецепты, содержащие спагетти
SELECT R.Title, R.CookingTime
FROM Recipes R,
     RecipesOfIngredients RI,
     Ingredients I
WHERE MATCH(R-(RI)->I)
  AND I.Name = 'Спагетти';

-- 2. Найти все рецепты с указанием времени приготовления более 30 минут
SELECT R.Title, R.CookingTime
FROM Recipes R
WHERE R.CookingTime > 30;

-- 3. Найти все методы приготовления для рецепта 'Паста карбонара'
SELECT DISTINCT CM.Name
FROM Recipes R,
     RecipesOfCookingMethods RCM,
     CookingMethods CM
WHERE MATCH(R-(RCM)->CM)
  AND R.Title = 'Паста карбонара';

-- 4. Найти рецепты, которые требуют жарки и содержат куриное филе
SELECT R.Title
FROM Recipes R,
     RecipesOfIngredients RI,
     Ingredients I,
     RecipesOfCookingMethods RCM,
     CookingMethods CM
WHERE MATCH(R-(RI)->I) 
  AND MATCH(R-(RCM)->CM)
  AND I.Name = 'Куриное филе'
  AND CM.Name = 'Жарка';

-- 5. Найти все рецепты, которые требуют запекания
SELECT R.Title
FROM Recipes R,
     RecipesOfCookingMethods RCM,
     CookingMethods CM
WHERE MATCH(R-(RCM)->CM)
  AND CM.Name = 'Запекание';

-------------------- Shortest_path ------------------

-- Найти кратчайший путь от рецепта к ингредиентам для 'Паста карбонара'
SELECT 
    R1.Title AS StartRecipe,
    STRING_AGG(I.Name, ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToIngredients
FROM Recipes AS R1,
     RecipesOfIngredients FOR PATH AS ri,
     Ingredients FOR PATH AS I
WHERE MATCH(SHORTEST_PATH(R1(-(ri)->I)+))
  AND R1.Title = 'Паста карбонара';

-- Найти кратчайший путь от рецепта к ингредиентам с ограничением в 3
SELECT 
    R1.Title AS StartRecipe,
    STRING_AGG(I.Name, ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToIngredients
FROM Recipes AS R1,
     RecipesOfIngredients FOR PATH AS ri,
     Ingredients FOR PATH AS I
WHERE MATCH(SHORTEST_PATH(R1(-(ri)->I){1,3}))
  AND R1.Title = 'Курица терияки';

---- Для Power BI --

SELECT @@servername 

--- Название базы данных: RecipeGraph

-- Получить все рецепты и их ингредиенты
SELECT 
    R.ID AS IdFirst,
    R.Title AS First,
    R.CookingTime AS [Cooking Time],
    CONCAT(N'Recipes', R.id) AS [First image name],
    I.ID AS IdSecond,
    I.Name AS Second,
    I.Quantity AS [Quantity],
    CONCAT(N'Ingredients', I.id) AS [Second image name]
FROM Recipes AS R,
     RecipesOfIngredients RI,
     Ingredients AS I
WHERE MATCH(R-(RI)->I);

-- Получить все рецепты и их методы приготовления
SELECT 
    R.ID AS IdFirst,
    R.Title AS First,
    CONCAT(N'Recipes', R.id) AS [First image name],
    CM.ID AS IdSecond,
    CM.Name AS Second,
    CONCAT(N'CookingMethods', CM.id) AS [Second image name]
FROM Recipes AS R,
     RecipesOfCookingMethods AS RCM,
     CookingMethods AS CM
WHERE MATCH(R-(RCM)->CM);

-- Получить все ингредиенты и их методы приготовления
SELECT 
    I.ID AS IdFirst,
    I.Name AS First,
    I.Quantity AS [Quantity],
    CONCAT(N'Ingredients', I.id) AS [First image name],
    CM.ID AS IdSecond,
    CM.Name AS Second,
    CONCAT(N'CookingMethods', CM.id) AS [Second image name]
FROM Ingredients AS I,
     IngredientsPreparationMethods IPM,
     CookingMethods AS CM
WHERE MATCH(I-(IPM)->CM);