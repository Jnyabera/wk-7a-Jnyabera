
--Question 1 Achieving 1NF (First Normal Form)
--  Create a table variable to simulate the original data
WITH ProductDetail AS (
  SELECT 101 AS OrderID, 'John Doe' AS CustomerName, 'Laptop, Mouse' AS Products UNION ALL
  SELECT 102, 'Jane Smith', 'Tablet, Keyboard, Mouse' UNION ALL
  SELECT 103, 'Emily Clark', 'Phone'
)
SELECT
  OrderID,
  CustomerName,
  TRIM(product) AS Product
FROM
  ProductDetail,
  JSON_TABLE(
    CONCAT('["', REPLACE(Products, ', ', '","'), '"]'),
    '$[*]' COLUMNS(product VARCHAR(100) PATH '$')
  ) AS prod;


--Q2 Question 2 Achieving 2NF (Second Normal Form) 
-- Orders table (OrderID, CustomerName)
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);

-- Insert distinct orders
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- OrderItems table (OrderID, Product, Quantity)
CREATE TABLE OrderItems (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert order items
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
