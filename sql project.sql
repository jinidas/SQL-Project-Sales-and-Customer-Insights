/*This project involves designing a relational database to store and analyze sales transactions, 
customer behavior, and product performance. 
It includes customer details, products, orders, employees, and order details, 
ensuring data integrity and optimization. 
We will generate random data using RAND() to create a real-world SQL project.
*/

-- Creating the Databases and Tables

create database sales_db;
use sales_db;
-- Creating Tables-> 
-- 1.Customers Table

create table customers (
customer_id int primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100) not null,
phone_no varchar(20) not null,
address text,
created_at timestamp default current_timestamp
);

-- Insert data.
INSERT INTO Customers (first_name, last_name, email, phone_no, address)
SELECT 
    CASE FLOOR(RAND() * 5)
        WHEN 0 THEN 'Arun'
        WHEN 1 THEN 'Varun'
        WHEN 2 THEN 'Rashi'
        WHEN 3 THEN 'Shoumily'
        ELSE 'David'
    END AS FirstName,
    CASE FLOOR(RAND() * 5)
        WHEN 0 THEN 'Smith'
        WHEN 1 THEN 'Ambani'
        WHEN 2 THEN 'Adani'
        WHEN 3 THEN 'Roy'
        ELSE 'Miller'
    END AS LastName,
    CONCAT(
        LOWER(
            CASE FLOOR(RAND() * 5)
                WHEN 0 THEN 'Arun'
                WHEN 1 THEN 'Varun'
                WHEN 2 THEN 'Rashi'
                WHEN 3 THEN 'Shoumily'
                ELSE 'David'
            END
        ),
        FLOOR(RAND() * 1000), 
        '@email.com'
    ),
    FLOOR(RAND() * 9000000000 + 1000000000), 
    CONCAT(FLOOR(RAND() * 1000), ' Main St')
FROM (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
      UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS numbers;

select * from customers;

-- 2. Product table

create table products
(
product_id int primary key auto_increment,
product_name varchar(100),
category varchar(50),
price decimal(10,2) ,
stock_quantity int check(stock_quantity>0)
);

-- Inserting random data
INSERT INTO products (product_name, category, price, stock_quantity)
SELECT 
    CASE FLOOR(RAND() * 5)
        WHEN 0 THEN 'Laptop'
        WHEN 1 THEN 'Smartphone'
        WHEN 2 THEN 'Headphones'
        WHEN 3 THEN 'Tablet'
        ELSE 'Smartwatch'
    END,
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Accessories'
        ELSE 'Gadgets'
    END,
    ROUND(RAND() * 900 + 100, 2),  -- Prices between $100 and $1000
    FLOOR(RAND() * 50 + 10)  -- Stock between 10 and 50
FROM (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
      UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS numbers;

select * from products;


-- 3. Employees table

create table employees
(
employee_id int primary key auto_increment,
fname varchar(50),
lname varchar(50),
role varchar(50),
hire_date date
);

-- Inserting random data

INSERT INTO employees (fname, lname, role, hire_date)
SELECT 
    CASE FLOOR(RAND() * 5)
        WHEN 0 THEN 'Emma'
        WHEN 1 THEN 'Michael'
        WHEN 2 THEN 'Sophia'
        WHEN 3 THEN 'Daniel'
        ELSE 'Olivia'
    END AS FirstName,
    CASE FLOOR(RAND() * 5)
        WHEN 0 THEN 'Harris'
        WHEN 1 THEN 'Clark'
        WHEN 2 THEN 'Walker'
        WHEN 3 THEN 'Lewis'
        ELSE 'Young'
    END AS LastName,
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'Sales Manager'
        WHEN 1 THEN 'Sales Executive'
        ELSE 'Customer Representative'
    END AS Role,
    DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 1500) DAY)  -- Random dates from 2020 to ~2024
FROM (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) AS numbers;

select * from employees;



-- 4. Order table

create table orders
(
orderid int primary key auto_increment,
customer_id int,
orderdate timestamp default current_timestamp,
employee_id int,
totalamt decimal(10,2),
foreign key (customer_id) references customers(customer_id),
foreign key (employee_id) references employees(employee_id)
);

-- Inserting random values
INSERT INTO orders (customer_id, employee_id, totalamt)
SELECT 
    FLOOR(RAND() * 10 + 1), 
    FLOOR(RAND() * 5 + 1),   
    ROUND(RAND() * 1500 + 50, 2) 
FROM (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 
      UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS t;

select * from orders;

-- 5. Order details table
create table orderdetails
(
orderdetails_id int primary key auto_increment,
orderid int,
product_id int,
quantity int check(quantity>0),
price decimal(10,2),
foreign key (orderid) references orders(orderid),
foreign key (product_id) references products(product_id)
);

-- Inserting random values

INSERT INTO orderdetails (orderid, product_id, quantity, price)
SELECT 
    (SELECT orderid FROM Orders ORDER BY RAND() LIMIT 1),  -- Random valid order ID
    (SELECT product_id FROM Products ORDER BY RAND() LIMIT 1),  -- Random valid product ID
    FLOOR(RAND() * 5 + 1),  -- Random quantity between 1 and 5
    (SELECT price FROM Products WHERE product_id = product_id ORDER BY RAND() LIMIT 1)  -- Matching product price
FROM (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 
      UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS t;

select * from orderdetails;

/* Fetching Data with Queries
1. Get All Orders with Customer and Employee Details */

SELECT 
    orders.orderid, 
    Customers.first_name AS Customer, 
    Employees.fname AS Employee, 
    orders.totalamt
FROM Orders
JOIN Customers ON orders.customer_id = customers.customer_id
JOIN Employees ON orders.employee_id = employees.employee_id;

-- 2. Find the Total Sales per Product

SELECT 
    Products.Product_name, 
    SUM(orderdetails.Quantity) AS TotalSold
FROM OrderDetails
JOIN Products ON OrderDetails.Product_id = Products.Product_id
GROUP BY Products.Product_name
ORDER BY TotalSold DESC;

-- 3. Find the Top 3 Customers by Total Spending

SELECT 
	customers.customer_id,
    Customers.first_name, 
    SUM(Orders.totalamt) AS TotalSpent
FROM Orders
JOIN Customers ON Orders.Customer_id = Customers.Customer_id
group by customers.customer_id
ORDER BY TotalSpent DESC
LIMIT 3;

-- 4. Show Products That Are High in Stock

SELECT Product_name, Stock_quantity
FROM Products
WHERE Stock_quantity > 30;

-- 5.Stored Procedure: Generate Monthly Sales Report

DELIMITER //
CREATE PROCEDURE MonthlySalesReport(IN month INT, IN year INT)
BEGIN
    SELECT DATE(OrderDate) AS Date, SUM(totalamt) AS Sales
    FROM Orders
    WHERE MONTH(Orderdate) = month AND YEAR(Orderdate) = year
    GROUP BY Date;
END //
DELIMITER ;

CALL MonthlySalesReport(3, 2025);


-- 6. Total Number of Orders Per Customer. 

SELECT 
    customers.customer_id,
    customers.first_name, 
    COUNT(orders.orderid) AS total_orders
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_id
ORDER BY total_orders DESC;

-- 7. Customers Who Have Never Placed an Order

SELECT * 
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- 8. Most Frequently Ordered Product

SELECT 
    products.product_name, 
    COUNT(orderdetails.orderdetails_id) AS order_count
FROM orderdetails
JOIN products ON orderdetails.product_id = products.product_id
GROUP BY products.product_name
ORDER BY order_count DESC
LIMIT 1;

-- 9. Total Revenue Per Category

SELECT 
    products.category, 
    SUM(orderdetails.price * orderdetails.quantity) AS total_revenue
FROM orderdetails
JOIN products ON orderdetails.product_id = products.product_id
GROUP BY products.category
ORDER BY total_revenue DESC;

-- 10. Month with the Highest Sales

SELECT 
    MONTH(orderdate) AS sales_month, 
    YEAR(orderdate) AS sales_year, 
    SUM(totalamt) AS total_sales
FROM orders
GROUP BY sales_year, sales_month
ORDER BY total_sales DESC
LIMIT 1;

-- 11. Products That Are Almost Out of Stock (Less Than 10 Remaining)

SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 30;

-- 12. Customers Who Spent More Than the Average Order Amount

SELECT customers.customer_id, customers.first_name, SUM(orders.totalamt) AS total_spent
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_id
HAVING total_spent > (SELECT AVG(totalamt) FROM orders);

-- 13. Stored Procedure to Get Total Sales for a Given Employee

DELIMITER //
CREATE PROCEDURE EmployeeSales(IN emp_id INT)
BEGIN
    SELECT 
        employees.fname AS employee_name, 
        COUNT(orders.orderid) AS total_orders, 
        SUM(orders.totalamt) AS total_sales
    FROM orders
    JOIN employees ON orders.employee_id = employees.employee_id
    WHERE employees.employee_id = emp_id
    GROUP BY employees.employee_id;
END //
DELIMITER ;

CALL EmployeeSales(2);

/* This SQL project successfully demonstrates the design and implementation of a relational database for sales and customer insights. 
By structuring data across multiple interconnected tables—Customers, Products, Employees, Orders, 
and OrderDetails—we ensure data integrity, optimization, and efficient retrieval of business insights.*/















