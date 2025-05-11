USE master;
GO
DROP DATABASE IF EXISTS RecipeGraph;
GO
CREATE DATABASE RecipeGraph;
GO

USE RecipeGraph;
GO

-- �������� ������ �����
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

-- ������� ������ � ������� �����
INSERT INTO Recipes (ID, Title, CookingTime, Instructions)
VALUES 
(1, '����� ���������', 30, '������� ����������� � �������� �� ������� ����.'),
(2, '������ �����', 15, '������� ����������� � �������� � ������.'),
(3, '���������� ����', 60, '����������� �����, �������� � ��������.'),
(4, '�����', 10, '������ ���� � ������ �� ���������.'),
(5, '������ �������', 45, '������ ������ � ������ �������.'),
(6, '������� �����', 40, '����������� ��� ����������� � ��������.'),
(7, '�������', 30, '�������� ������ ��� � ��������.'),
(8, '������', 25, '������� ��� ����������� � ������ �� �����.'),
(9, '��� ����������', 50, '������� ����� � ������ �� ����������.'),
(10, '�������', 20, '������� ����� � ��������.');

INSERT INTO Ingredients (ID, Name, Quantity)
VALUES 
(1, '��������', '200 �'),
(2, '����', '2 ��.'),
(3, '�����', '100 �'),
(4, '�����', '1 ��.'),
(5, '������� ����', '300 �'),
(6, '���� �������', '50 ��'),
(7, '�������', '200 �'),
(8, '����', '300 �'),
(9, '�����', '150 �'),
(10, '���', '1 ��.');

INSERT INTO CookingMethods (ID, Name)
VALUES 
(1, '�����'),
(2, '�����'),
(3, '���������'),
(4, '�������'),
(5, '�����������'),
(6, '������������� �� ����'),
(7, '�����'),
(8, '��������� � �������������'),
(9, '����������'),
(10, '��������');

-- �������� ������ ����
DROP TABLE IF EXISTS RecipesOfIngredients;
CREATE TABLE RecipesOfIngredients AS EDGE;

DROP TABLE IF EXISTS RecipesOfCookingMethods;
CREATE TABLE RecipesOfCookingMethods AS EDGE;

DROP TABLE IF EXISTS IngredientsPreparationMethods;
CREATE TABLE IngredientsPreparationMethods AS EDGE;

-- �����������
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

-- ������� ������� �������������
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

-- ������� ������� ������������� ��� ������������
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

-- 1. ����� ��� �������, ���������� ��������
SELECT R.Title, R.CookingTime
FROM Recipes R,
     RecipesOfIngredients RI,
     Ingredients I
WHERE MATCH(R-(RI)->I)
  AND I.Name = '��������';

-- 2. ����� ��� ������� � ��������� ������� ������������� ����� 30 �����
SELECT R.Title, R.CookingTime
FROM Recipes R
WHERE R.CookingTime > 30;

-- 3. ����� ��� ������ ������������� ��� ������� '����� ���������'
SELECT DISTINCT CM.Name
FROM Recipes R,
     RecipesOfCookingMethods RCM,
     CookingMethods CM
WHERE MATCH(R-(RCM)->CM)
  AND R.Title = '����� ���������';

-- 4. ����� �������, ������� ������� ����� � �������� ������� ����
SELECT R.Title
FROM Recipes R,
     RecipesOfIngredients RI,
     Ingredients I,
     RecipesOfCookingMethods RCM,
     CookingMethods CM
WHERE MATCH(R-(RI)->I) 
  AND MATCH(R-(RCM)->CM)
  AND I.Name = '������� ����'
  AND CM.Name = '�����';

-- 5. ����� ��� �������, ������� ������� ���������
SELECT R.Title
FROM Recipes R,
     RecipesOfCookingMethods RCM,
     CookingMethods CM
WHERE MATCH(R-(RCM)->CM)
  AND CM.Name = '���������';

-------------------- Shortest_path ------------------

-- ����� ���������� ���� �� ������� � ������������ ��� '����� ���������'
SELECT 
    R1.Title AS StartRecipe,
    STRING_AGG(I.Name, ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToIngredients
FROM Recipes AS R1,
     RecipesOfIngredients FOR PATH AS ri,
     Ingredients FOR PATH AS I
WHERE MATCH(SHORTEST_PATH(R1(-(ri)->I)+))
  AND R1.Title = '����� ���������';

-- ����� ���������� ���� �� ������� � ������������ � ������������ � 3
SELECT 
    R1.Title AS StartRecipe,
    STRING_AGG(I.Name, ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToIngredients
FROM Recipes AS R1,
     RecipesOfIngredients FOR PATH AS ri,
     Ingredients FOR PATH AS I
WHERE MATCH(SHORTEST_PATH(R1(-(ri)->I){1,3}))
  AND R1.Title = '������ �������';

---- ��� Power BI --

SELECT @@servername 

--- �������� ���� ������: RecipeGraph

-- �������� ��� ������� � �� �����������
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

-- �������� ��� ������� � �� ������ �������������
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

-- �������� ��� ����������� � �� ������ �������������
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