/*Question 1: Create a table called employees with the following structure:
 emp_id (integer, should not be NULL and should be a primary key)
 emp_name (text, should not be NULL)
 age (integer, should have a check constraint to ensure the age is at least 18)
 email (text, should be unique for each employee)
 salary (decimal, with a default value of 30,000).
 Write the SQL query to create the above table with all constraints
*/
-- Ans 1: 
CREATE TABLE IF NOT EXISTS employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL(10 , 2 ) DEFAULT 30000.00
);
-- Select * from employees;
/*
2. Explain the purpose of constraints and how they help maintain data integrity in a database. 
Provide examples of common types of constraints.
*/

/* 
Ans: Constraints in a database are rules applied to columns or tables to enforce standards, 
prevent invalid data, and ensure consistency over time. They're like gatekeepers that help the 
database maintain its internal logic—even when multiple users or applications are interacting with it.

Purpose of Constraints:
- Data Integrity: Prevents incorrect or inconsistent data entries (e.g., no negative age values).
- Accuracy: Ensures inputs follow predefined logic (like uniqueness or valid references).
- Reliability: Helps applications depend on consistent structure and predictable outcomes.
- Validation: Acts as a first-line check before data enters deeper application logic.
- Efficiency: Reduces the need for manual error-checking or cleanup processes.

 Common Types of Constraints (with examples)
| Constraint Type 	| Description 														| Example Usage 												| 
| PRIMARY KEY 		| Uniquely identifies each record in a table 						| emp_id INT PRIMARY KEY 										| 
| NOT NULL 			| Ensures a column always contains a value 							| emp_name VARCHAR(255) NOT NULL 								| 
| UNIQUE 			| Guarantees all values in a column are different 					| email VARCHAR(255) UNIQUE 									| 
| CHECK 			| Validates that values meet a specific condition 					| age INT CHECK (age >= 18) 									| 
| DEFAULT 			| Assigns a default value if no explicit value is provided 			| salary DECIMAL(10,2) DEFAULT 30000.00 						| 
| FOREIGN KEY 		| Links to a key in another table to maintain relational integrity 	| dept_id INT, FOREIGN KEY (dept_id) REFERENCES departments(id) | 

-- 3. Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.
-- Ans: The NOT NULL constraint ensures that a column must always have a value — it cannot be left blank during insert or update operations.
Purpose
- Enforces mandatory fields (like emp_name or email).
- Preserves data completeness — avoids partial or meaningless records.
- Helps prevent logic bugs in applications that depend on full data.

CREATE TABLE employees (
  emp_id INT NOT NULL PRIMARY KEY,
  emp_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);

In this case, every employee must have a name and email, and no row can be saved with NULL in those columns.
Can a PRIMARY KEY Contain NULL?
Short answer: Absolutely not. In MySQL — and most relational databases — a PRIMARY KEY cannot contain NULL values.
Justification:
- A PRIMARY KEY must uniquely identify each row.
- NULL represents an unknown or missing value, which contradicts the idea of uniqueness.
- In MySQL, trying to insert a NULL into a primary key column will result in an error.
*/

#  4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an 
# example for both adding and removing a constraint.

#1. Adding a Constraint:
# To add a constraint to an existing table, you typically use the ALTER TABLE statement.
-- ALTER TABLE <table_name>
-- ADD CONSTRAINT <constraint_name> <constraint_type> (<column_name>);
ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);
-- This ensures no two employees can have the same email.
-- Types You Can Add
-- - NOT NULL (on some DBMSs, but limited post-creation)
-- - UNIQUE
-- - CHECK
-- - DEFAULT
-- - FOREIGN KEY
--  Note: Adding NOT NULL after table creation may require column updates if NULLs already exist.

-- 2. Removing a Constraint
-- Use the ALTER TABLE statement with DROP CONSTRAINT. However, syntax varies between database systems.

-- Example: Removing UNIQUE Constraint Syntax
-- ALTER TABLE table_name
-- DROP INDEX constraint_name;

ALTER TABLE employees
DROP INDEX unique_email;
#Dropping Foreign keys constraint:
-- ALTER TABLE orders
-- DROP FOREIGN KEY fk_customer_id;

# 5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. 
# 	Provide an example of an error message that might occur when violating a constraint

/* Consequences of Violating Constraints
1. Insertion Violation
Trying to insert a value that breaches constraints like NOT NULL, UNIQUE, or FOREIGN KEY will result in rejection.
- NOT NULL violation: Inserting a NULL into a column that must have a value.
- UNIQUE violation: Trying to insert a duplicate value into a column that requires uniqueness.
- PRIMARY KEY violation: Inserting a duplicate key or a NULL value.
- FOREIGN KEY violation: Inserting a value that doesn't match the referenced table.
2. Update Violation
Similar issues arise when updating existing records:
- Changing a value to one that conflicts with a UNIQUE or FOREIGN KEY constraint.
- Updating a NOT NULL column to NULL.
3. Deletion Violation
- Attempting to delete a referenced row in a parent table when a FOREIGN KEY constraint is in place and no cascading rule exists.
*/

CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(100) UNIQUE
);
CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100) NOT NULL,
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
#Example: Inserting a NULL into a NOT NULL colum
INSERT INTO employees (emp_id, emp_name, dept_id)
VALUES (1, NULL, 101);
# ERROR: 
-- ERROR 1048 (23000): Column 'emp_name' cannot be null
-- Example 2: Violating a FOREIGN KEY constrain
INSERT INTO employees (emp_id, emp_name, dept_id)
VALUES (2, 'Shyam', 999);  -- 999 does not exist in departments
-- ERROR: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
-- These Errors protect against:
-- - Orphaned rows
-- - Duplicate identifiers
-- - Incomplete or unreliable records

-- 6. You created a products table without constraints as follows:
 CREATE TABLE products (
 product_id INT,
 product_name VARCHAR(50),
 price DECIMAL(10, 2));
 
/* Now, you realise that
--  The product_id should be a primary key
--  The price should have a default value of 50.00 */
 
 # Ans: This ensures each product has a unique, non-NULL ID.
ALTER TABLE products
ADD PRIMARY KEY (product_id);

# This ensures that if no price is provided during insertion, it will default to ₹50.00.
ALTER TABLE products
MODIFY COLUMN price DECIMAL(10, 2) DEFAULT 50.00;

# 7. You have two tables:
/* Table: Students
|student_id |student_name 	| class_id	|
|1			|Alice			|101		|
|2			|Bob			|102		|
|3			|Charlie		|101		|

Table: Classes:
|class_id	|class_name	|
|101		|Math		|
|102		|Science	|
|103		|History	|

#Write a query to fetch the student_name and class_name for each student using an INNER JOIN. */
--  Ans:
CREATE TABLE classes (
  class_id INT PRIMARY KEY,
  class_name VARCHAR(100) UNIQUE
);
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(100) NOT NULL,
  class_id INT,
  FOREIGN KEY (class_id) REFERENCES classes(class_id)
);
Insert into classes (class_id, class_name) values
(101, 'Math'),
(102, 'Science'),
(103, 'History');

Insert into students 
(student_id,student_name,class_id) values
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

SELECT s.student_name, c.class_name
FROM students s INNER JOIN classes c 
ON C.class_id = s.class_id;
 
-- 8. Consider the following three tables:
-- Orders: (Order_id, Order_date, Customer_id)
-- (1, '2024-01-01', 101)
-- (2, '2024-01-03', 102)

-- Customers: (Customer_id, Customer_name)
-- (101, 'Alice')
-- (102, 'Bob')

-- Products: (Product_id, Product_name, Order_id)
-- (1, 'Laptop', 1)
-- (2, 'Phone', NULL)

-- Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are 
-- listed even if they are not associated with an order  -- Hint: (use INNER JOIN and LEFT JOIN)

SELECT 
    p.Order_id,
    c.Customer_name,
    p.Product_name
FROM 
    Products p
LEFT JOIN 
    Orders o ON p.Order_id = o.Order_id
INNER JOIN 
    Customers c ON o.Customer_id = c.Customer_id;

-- 9. Given the following tables:
-- Sales: (Sale_id, product_id, amount)
-- (1, 101, 500)
-- (2, 102, 300)
-- (3, 101, 700)
-- Products: (product_id, product_name)
-- (101, 'Laptop')
-- (102, 'Phone')
# Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.
# Ans: 
SELECT 
    p.product_name,
    p.product_id,
    SUM(s.amount) AS total_sales
FROM 
    sales s
INNER JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_sales DESC;	# results sorted by total sales in descending order:
    
-- 10. You are given three tables:
-- Orders: (Order_id, Order_date, Customer_id)
-- (1, '2024-01-02', 1)
-- (2, '2024-01-05', 2)

-- Customers: (Customer_id, Customer_name)
-- (1, 'Alice')
-- (2, 'Bob')

-- Order_details: (Order_id, product_id, quantity)
-- (1, 101, 2)
-- (1, 102, 1)
-- (2, 101, 3)

-- Write a query to display the order_id, customer_name, and the quantity of products ordered by each 
-- customer using an INNER JOIN between all three tables.
SELECT o.order_id, c.customer_name, od.quantity
FROM orders o  
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
ORDER BY c.customer_name;

-- 	________________________________________________
-- |												|
-- |		SQL COMMANDS (Maven Movies db			|
-- |________________________________________________|
Use mavenmovies;
 -- 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences
SELECT 
    TABLE_NAME, 
    COLUMN_NAME 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
    CONSTRAINT_NAME = 'PRIMARY' 
    AND TABLE_SCHEMA = 'mavenmovies';
-- |Table_Name	| Column_Name|
-- |actor		|actor_id|
-- |actor_award	|actor_award_id|
-- |address		|address_id|
-- |advisor		|advisor_id|
-- |category	|category_id|
-- |city		|city_id|
-- |country		|country_id|
-- |customer	|customer_id|
-- |film		|film_id|
-- |film_actor	|actor_id|
-- |film_actor	|film_id|
-- |film_category	|film_id + category_id|
-- |film_text	|film_id|
-- |inventory	|inventory_id|
-- |investor	|investor_id|
-- |language	|language_id|
-- |payment		|payment_id|
-- |rental		|rental_id|
-- |staff		|staff_id|
-- |store		|store_id|

SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME, 
    REFERENCED_COLUMN_NAME 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
    REFERENCED_TABLE_NAME IS NOT NULL 
    AND TABLE_SCHEMA = 'mavenmovies';
    
-- TABLE_NAME	COLUMN_NAME				CONSTRAINT_NAME				REFERENCED_TABLE_NAME	REFERENCED_COLUMN_NAME
-- address		city_id					fk_address_city				city				city_id
-- city		country_id				fk_city_country				country				country_id
-- customer	address_id				fk_customer_address			address				address_id
-- customer	store_id				fk_customer_store			store				store_id
-- film		language_id				fk_film_language			language			language_id
-- film		original_language_id	fk_film_language_original	language			language_id
-- film_actor	actor_id				fk_film_actor_actor			actor				actor_id
-- film_actor	film_id					fk_film_actor_film			film				film_id
-- film_category	category_id			fk_film_category_category	category			category_id
-- film_category	film_id				fk_film_category_film		film				film_id
-- inventory		film_id				fk_inventory_film			film				film_id
-- inventory		store_id			fk_inventory_store			store				store_id
-- payment			customer_id			fk_payment_customer			customer			customer_id
-- payment			rental_id			fk_payment_rental			rental				rental_id
-- payment			staff_id			fk_payment_staff			staff				staff_id
-- rental			customer_id			fk_rental_customer			customer			customer_id
-- rental			inventory_id		fk_rental_inventory			inventory			inventory_id
-- rental			staff_id			fk_rental_staff				staff				staff_id
-- staff			address_id			fk_staff_address			address				address_id
-- staff			store_id			fk_staff_store				store				store_id
-- store			address_id			fk_store_address			address				address_id
-- store			manager_staff_id	fk_store_staff				staff				staff_id

-- Differences: Primary Key vs Foreign Key
-- | Feature 			| Primary Key 					| Foreign Key | 
-- | Purpose 			| Uniquely identifies a row 	| Links one table to another | 
-- | Uniqueness 		| Must be unique 				| Can be repeated | 
-- | NULL Allowed 		| ❌ No NULLs 					| ✅ Can be NULL (unless restricted) | 
-- | Reference 			| Exists within the same table 	| References a column in another table | 
-- | Enforces 			| Entity integrity 				| Referential integrity | 

-- Primary keys = each row’s identity
-- Foreign keys = connections across tables 
 
--  2- List all details of actors
SELECT 
    *
FROM
    actor;

--  3 -List all customer information from DB.
SELECT 
    *
FROM
    customer;

--  4 -List different countries.
SELECT 
    *
FROM
    country;

--  5 -Display all active customers.
SELECT 
    *
FROM
    customer
WHERE
    active = 1;

--  6 -List of all rental IDs for customer with ID 1.
SELECT 
    rental_id
FROM
    rental
WHERE
    customer_id = 1;

--  7 - Display all the films whose rental duration is greater than 5 .
SELECT 
    *
FROM
    film
WHERE
    rental_duration > 5;

--  8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT 
    COUNT(*)
FROM
    film
WHERE
    replacement_cost > 15
        AND replacement_cost < 20
ORDER BY replacement_cost;

--  9 - Display the count of unique first names of actors.
SELECT 
    COUNT(DISTINCT first_name) Count_Unique_First_Names
FROM
    actor;

--  10- Display the first 10 records from the customer table .
SELECT 
    *
FROM
    customer
LIMIT 10;

--  11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE 'b%'
LIMIT 3;

--  12 -Display the names of the first 5 movies which are rated as ‘G’.
SELECT 
    *
FROM
    film
WHERE
    rating = 'G'
LIMIT 5;

--  13-Find all customers whose first name starts with "a".
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE 'a%';

--  14- Find all customers whose first name ends with "a".
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE '%a';

--  15- Display the list of first 4 cities which start and end with ‘a’ .
SELECT 
    *
FROM
    city
WHERE
    city LIKE 'a%a'
LIMIT 4;

--  16- Find all customers whose first name have "NI" in any position.
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE '%NI%';

--  17- Find all customers whose first name have "r" in the second position .
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE '_r%';

--  18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE 'a____%';

--  19- Find all customers whose first name starts with "a" and ends with "o".
SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE 'a%o';

--  20 - Get the films with pg and pg-13 rating using IN operator.
SELECT *
FROM
    film
WHERE
    rating IN ('pg' , 'pg-13');

--  21 - Get the films with length between 50 to 100 using between operator.
SELECT 
    *
FROM
    film
WHERE
    length BETWEEN 50 AND 100
ORDER BY length;

--  22 - Get the top 50 actors using limit operator.
SELECT 
    *
FROM
    actor
LIMIT 50;

--  23 - Get the distinct film ids from inventory table.
SELECT DISTINCT
    film_id
FROM
    inventory;


-- 	________________________________________________
-- |												|
-- |		Functions (Basic Agg. Functions)		|
-- |________________________________________________|
 -- Question 1:
--  Retrieve the total number of rentals made in the Sakila database.
--  Hint: Use the COUNT() function.
SELECT 
    COUNT(*)
FROM
    rental;

--  Question 2:
--  Find the average rental duration (in days) of movies rented from the Sakila database.
--  Hint: Utilize the AVG() function.

SELECT 
    AVG(rental_duration) 'AvgRentalDuration(in days)'
FROM
    film; 

-- OR -- could be the below one as well.. 

SELECT 
    AVG(DATEDIFF(return_date, rental_date)) Avg_Rental_Duration
FROM
    rental;

--  String Functions:

--  Question 3:
--  Display the first name and last name of customers in uppercase.
--  Hint: Use the UPPER () function.
SELECT 
    UPPER(first_name) First_Name, UPPER(last_name) Last_Name
FROM
    customer;

--  Question 4:
--  Extract the month from the rental date and display it alongside the rental ID.
--  Hint: Employ the MONTH() function.
SELECT 
    rental_id, MONTH(rental_date) rental_month
FROM
    rental;

--  GROUP BY:

--  Question 5:
--  Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
--  Hint: Use COUNT () in conjunction with GROUP BY.
SELECT 
    customer_id, COUNT(rental_id) count_of_rentals
FROM
    rental
GROUP BY customer_id;

--  Question 6:
--  Find the total revenue generated by each store.
--  Hint: Combine SUM() and GROUP BY.
SELECT 
    s.store_id, SUM(p.amount) AS total_revenue
FROM
    store s
        INNER JOIN
    staff st ON s.store_id = st.store_id
        INNER JOIN
    payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

--  Question 7:
--  Determine the total number of rentals for each category of movies.
--  Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.

SELECT 
    C.NAME AS CATEGORY_NAME,
    COUNT(R.RENTAL_ID) TOTAL_RENTALS_PER_CAT
FROM
    FILM_CATEGORY FC
        JOIN
    CATEGORY C ON C.CATEGORY_ID = FC.CATEGORY_ID
        JOIN
    FILM F ON FC.FILM_ID = F.FILM_ID
        JOIN
    INVENTORY I ON I.FILM_ID = F.FILM_ID
        JOIN
    RENTAL R ON R.INVENTORY_ID = I.INVENTORY_ID
GROUP BY C.NAME;

--  Question 8:
--  Find the average rental rate of movies in each language.
--  Hint: JOIN film and language tables, then use AVG () and GROUP BY.

# This query is for languages that's in film table. (Only English)
SELECT 
    l.name AS Language,
    ROUND(AVG(f.rental_rate), 2) AS Avg_Rental_Rate
FROM
    film f
        RIGHT JOIN
    Language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY Avg_Rental_Rate DESC;
 
 -- OR -- 
 
 # If its Avg Rental rate in each language. then the right join on language.
SELECT 
    l.name AS Language,
    ROUND(AVG(IFNULL(f.rental_rate, 0)), 2) AS Avg_Rental_Rate
FROM
    film f
        RIGHT JOIN
    Language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY Avg_Rental_Rate DESC;

-- 	________________________________________________
-- |												|
-- |					Joins						|
-- |________________________________________________|
--  Questions 9 -
--  Display the title of the movie, customer s first name, and last name who rented it.
--  Hint: Use JOIN between the film, inventory, rental, and customer tables.
SELECT 
    f.title, c.first_name, c.last_name
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
        INNER JOIN
    rental r ON i.inventory_id = r.inventory_id
        INNER JOIN
    customer c ON c.customer_id = r.customer_id;

--  Question 10:
--  Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
--  Hint: Use JOIN between the film actor, film, and actor tables.

SELECT 
    a.first_name, a.last_name
FROM
    actor a
        INNER JOIN
    film_actor fa ON a.actor_id = fa.actor_id
        INNER JOIN
    film f ON f.film_id = fa.film_id
WHERE
    f.title LIKE 'Gone with the Wind.';
-- No records found.

--  Question 11:
--  Retrieve the customer names along with the total amount they've spent on rentals.
--  Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.

SELECT 
    C.First_Name, c.Last_Name, SUM(p.amount) Total_amount
FROM
    payment p
        INNER JOIN
    customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id , c.first_name , c.last_name;

--  Question 12:
--  List the titles of movies rented by each customer in a particular city (e.g., 'London').
--  Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY
SELECT 
    c.first_name,
    c.last_name,
    ci.city,
    f.title AS movie_title
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    ci.city = 'London'
GROUP BY 
    c.customer_id, f.title, c.first_name, c.last_name, ci.city
ORDER BY 
    c.last_name, c.first_name, f.title;

-- 	________________________________________________
-- |												|
-- |			Advanced Joins and GROUP BY:		|
-- |________________________________________________|
--  Question 13:
--  Display the top 5 rented movies along with the number of times they've been rented.
--  Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.
SELECT 
    f.title, COUNT(rental_id) AS NoOfTimesRented
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id , f.title
ORDER BY NoOfTimesRented DESC
LIMIT 5;

--  Question 14:
--  Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
--  Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.

SELECT 
    c.first_name, 
    c.last_name
FROM 
    customer c
JOIN 
    rental r ON r.customer_id = c.customer_id
JOIN 
    inventory i ON i.inventory_id = r.inventory_id
JOIN 
    store s ON s.store_id = i.store_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(DISTINCT s.store_id) = 2;
    
-- OR -- A version with WHERE Clause to get only store_id in (1,2) just in case new stores get added and there are rentals from that store(s).

SELECT 
    c.first_name, 
    c.last_name
FROM 
    customer c
JOIN 
    rental r ON r.customer_id = c.customer_id
JOIN 
    inventory i ON i.inventory_id = r.inventory_id
JOIN 
    store s ON s.store_id = i.store_id
WHERE 	#- WHERE s.store_id IN (1, 2) acts as a guardrail, restricting analysis to the two original stores. 
		# It ensures that if Store 3 (or more) is added later, your logic remains accurate and won’t break or count unwanted rentals.
    s.store_id IN (1, 2)	# Futre-proofing  If there’s a chance that more stores could be added later.
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(DISTINCT s.store_id) = 2;


-- 	________________________________________________
-- |												|
-- |				Windows Function:				|
-- |________________________________________________|

## Row_number
--  1. Rank the customers based on the total amount they've spent on rentals.
SELECT 
    First_Name,
    Last_Name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS Spending_rank
FROM (
    SELECT 
        c.First_Name,
        c.Last_Name,
        SUM(p.amount) AS total_spent
    FROM 
        payment p
        INNER JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name
) AS ranked_customers;

--  2. Calculate the cumulative revenue generated by each film over time.
Select Title , Payment_Date,
sum(Amount) over (partition by title order by payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Cumulative_Revenue
FROM (SELECT 
    f.title Title,p.payment_date Payment_Date, p.amount Amount 
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
    INNER JOIN 
    payment p on p.rental_id = r.rental_id) as Film_revenue
ORDER BY f.title, payment_date;

--  3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT title, length,
Avg(rental_duration) over(partition by floor(length / 10) order by length Rows between Unbounded Preceding and Unbounded following) as Average_Rental_Duration
FROM film;

--  4. Identify the top 3 films in each category based on their rental counts.
Select Category, Film_name, Rental_Count,
row_num
From 
(Select cat.name Category, f.title Film_Name, 
count(r.rental_id) Rental_Count, 
(row_number() over (partition by cat.name order by count(r.rental_id) desc)) as row_num
from category cat
inner join film_category fc on fc.category_id = cat.category_id
inner join film f on f.film_id = fc.film_id
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by cat.name,f.title) as CatWiseRental 
where row_num <=3;

--  5. Calculate the difference in rental counts between each customer's total rentals and the average rentals
--  across all customers.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals,
    AVG(COUNT(r.rental_id)) OVER () AS avg_rentals,
    COUNT(r.rental_id) - AVG(COUNT(r.rental_id)) OVER () AS rental_diff
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name;
    
--  6. Find the monthly revenue trend for the entire rental store over time.
SELECT 
    DATE_FORMAT(p.payment_date, '%Y-%m') AS month,
    SUM(p.amount) AS monthly_revenue,
    AVG(SUM(p.amount)) OVER () AS avg_monthly_revenue,
    SUM(SUM(p.amount)) OVER (ORDER BY DATE_FORMAT(p.payment_date, '%Y-%m')) AS cumulative_revenue
FROM 
    payment p
GROUP BY 
    DATE_FORMAT(p.payment_date, '%Y-%m')
ORDER BY 
    month;
    
--  7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
SELECT 
    customer_id,
    first_name,
    last_name,
    total_spent,
    round(percentage_rank *100,2) as Percentage_rank
FROM 
( SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(p.amount) AS total_spent,
        PERCENT_RANK() OVER (
            ORDER BY SUM(p.amount) DESC
        ) AS percentage_rank
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name
) AS ranked_customers
WHERE 
    percentage_rank <= 0.2
ORDER BY 
    total_spent DESC;
    
--  8. Calculate the running total of rentals per category, ordered by rental count.
SELECT 
    category_name,
    title,
    rental_count,
    SUM(rental_count) OVER (
        PARTITION BY category_name 
        ORDER BY rental_count DESC
    ) AS running_total
FROM (
    SELECT 
        c.name AS category_name,
        f.title,
        COUNT(r.rental_id) AS rental_count
    FROM 
        film f
    JOIN 
        film_category fc ON f.film_id = fc.film_id
    JOIN 
        category c ON fc.category_id = c.category_id
    JOIN 
        inventory i ON f.film_id = i.film_id
    JOIN 
        rental r ON i.inventory_id = r.inventory_id
    GROUP BY 
        c.name, f.film_id, f.title
) AS category_rentals
ORDER BY 
    category_name, rental_count DESC;

--  9. Find the films that have been rented less than the average rental count for their respective categories.
SELECT
    fr.film_id,
    fr.title,
    fr.film_rental_count,
    fr.avg_rental_count
FROM (
    SELECT
        f.film_id,
        f.title,
        c.category_id,
        COUNT(r.rental_id) AS film_rental_count,
        AVG(COUNT(r.rental_id)) OVER (PARTITION BY c.category_id) AS avg_rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY f.film_id, f.title, c.category_id
) AS fr
WHERE fr.film_rental_count < fr.avg_rental_count order by film_rental_count desc;

--  10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT month_name, monthly_revenue
FROM (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') AS month_name,
        SUM(amount) AS monthly_revenue,
        RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
    FROM payment
    GROUP BY month_name
) AS ranked_months
WHERE revenue_rank <= 5;

-- 	________________________________________________
-- |												|
-- |			Normalisation & CTE					|
-- |________________________________________________|

--  1. First Normal Form (1NF):
--     a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.

-- Ans: The table that violates the 1NF is actor_award.
-- Violation: The table actor_award has redundant columns: first_name, last_name of actors that must only in actor table.
-- It contains a column named awards that holds multiple values in a single cell — for example, "Best Actor, Lifetime Achievement".
-- This breaks the 1NF rule that every column must contain atomic (indivisible) values.
-- Storing comma-separated values or lists in a single field makes querying, filtering, and indexing inefficient and error-prone.

-- How to Normalize It to 1NF
-- You have two clean options:
-- 1. - Split into multiple rows:
-- - Each award should be stored in a separate row for the same actor.
-- actor_id | award
-- ---------|---------------------
-- 101      | Best Actor
-- 101      | Lifetime Achievement

-- 2. Create a separate awards table:
-- Normalize by creating a new table:
CREATE TABLE actor_awards (
    actor_id INT,
    award VARCHAR(255)
);
-- This allows for a proper one-to-many relationship between actors and awards.

--  2. Second Normal Form (2NF):
--     a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
--     If it violates 2NF, explain the steps to normalize it.

-- Ans. Taking the same Actor_award table after normalizing it into 1NF as stated above. 
-- After 1NF Normalization
-- Suppose we’ve transformed the original actor_award table like this:
-- | actor_id | award | first_name | last_name | 
-- | 101 | Best Actor | Tom | Hanks | 
-- | 101 | Lifetime Ach. | Tom | Hanks | 
-- Now:
-- - The awards column is atomic 
-- - Each row represents a single actor-award pair 
-- So yes, it’s in 1NF.
-- But It Still Violates 2NF
-- Here’s the key issue:
-- - The composite key is likely (actor_id, award) — because each actor can win multiple awards.
-- - However, first_name and last_name depend only on actor_id, not on the full composite key.
-- This is a partial dependency, which violates 2NF.
-- Normalization: We can safely remove the First_name and Last_Name from actor_award table and the table will be in 2NF.
-- also actor_id - award will be primary_key and Actor_id will be fk with reference to actor.actor_id.
-- Now:
-- - All non-key attributes in each table depend fully on the primary key.
-- - No partial dependencies.
-- - 2NF achieved.

--  3. Third Normal Form (3NF):
--                a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 
--                present and outline the steps to normalize the table to 3NF.
-- Ans: 
-- 3NF Violation: Transitive Dependencies
-- - Primary key: actor_award_id
-- - Non-key attributes: actor_id, first_name, last_name, awards
-- - first_name and last_name depend on actor_id, not directly on actor_award_id
-- - So we have a transitive dependency:
-- actor_award_id → actor_id → first_name, last_name

-- This violates 3NF because first_name and last_name are non-prime attributes that depend on another non-prime attribute (actor_id), not directly on the primary key.
-- Since actor's first_name and last_name are already present in actor table and are not needed in Actor_award table, we can drop it.
-- actor_award now contains only attributes that depend directly on its primary key.
-- first_name and last_name are stored in the actor table, where they depend directly on actor_id.
-- Transitive dependencies are eliminated.
-- The schema is now in Third Normal Form (3NF).

--  4. Normalization Process:
--                a. Take a specific table in Sakila and guide through the process of normalizing it from the initial  
--             unnormalized form up to at least 2NF.
--  5. CTE Basics:
--                 a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 
--                 have acted in from the actor and film_actor tables.
WITH actor_film_counts AS (
    SELECT 
        a.actor_id,
        a.first_name,
        a.last_name,
        COUNT(fa.film_id) AS number_of_films
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT DISTINCT
    first_name,
    last_name,
    number_of_films
FROM actor_film_counts
ORDER BY number_of_films DESC;

-- 6. CTE with Joins:
--                 a. Create a CTE that combines information from the film and language tables to display the film title, 
--                  language name, and rental rate.
with film_language_info as (
Select f.film_id, f.title title, l.name language_name, f.rental_rate 
from film f inner join language l on f.language_id = l.language_id)
Select title, language_name, rental_rate
from film_language_info 
order by title;

-- 7. CTE for Aggregation:
--                a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
--                 from the customer and payment tables.
With total_revenue_by_customer as (
Select c.customer_id, c.first_name, c.last_name, sum(p.amount) total_revenue 
from customer c 
inner join payment p on c.customer_id = p.customer_id
group by c.customer_id,c.first_name, c.last_name
)
Select First_name, Last_name, Total_Revenue 
from total_revenue_by_customer
order by total_revenue desc;

-- 8. CTE with Window Functions:
--                a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.
WITH film_ranks AS (
    SELECT 
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM film
)
SELECT 
    film_id,
    title,
    rental_duration,
    duration_rank
FROM film_ranks
ORDER BY duration_rank;

-- 9. CTE and Filtering:
--                a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
--             customer table to retrieve additional customer details.
WITH customer_rental_above2 AS (
    SELECT 
        c.customer_id, 
        COUNT(r.rental_id) AS rental_count
    FROM customer c 
    INNER JOIN rental r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id
    HAVING COUNT(r.rental_id) > 2
)
SELECT 
    c.*
FROM customer c
INNER JOIN customer_rental_above2 cra ON c.customer_id = cra.customer_id;

-- 10. CTE for Date Calculations:
--  a. Write a query using a CTE to find the total number of rentals made each month, considering the 
-- rental_date from the rental table
# Since there can be many entries for a given month across many years, we will  group by month+year combination.
WITH rental_per_month AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY rental_month
)
SELECT 
    rental_month,
    rental_count
FROM rental_per_month
ORDER BY rental_month;

-- 11. CTE and Self-Join:
--  a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 
-- together, using the film_actor table.
WITH actor_pairs AS (
    SELECT 
        fa1.film_id,
        fa1.actor_id AS actor_1,
        fa2.actor_id AS actor_2
    FROM film_actor fa1
    JOIN film_actor fa2 
        ON fa1.film_id = fa2.film_id
       AND fa1.actor_id < fa2.actor_id  -- avoids duplicates and self-pairs like A,B and B,A
)
SELECT 
    ap.film_id,
    a1.first_name AS actor_1_first_name,
    a1.last_name AS actor_1_last_name,
    a2.first_name AS actor_2_first_name,
    a2.last_name AS actor_2_last_name
FROM actor_pairs ap
JOIN actor a1 ON ap.actor_1 = a1.actor_id
JOIN actor a2 ON ap.actor_2 = a2.actor_id
ORDER BY ap.film_id, actor_1_first_name, actor_2_first_name;
--  
-- 12. CTE for Recursive Search:
--  a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 
-- considering the reports_to column
#Since the reports_to column is not there in the staff table. the below query gets all staff and their reporting managers per store_id.(1,2 ) only..
WITH manager_stores AS (
    SELECT store_id, manager_staff_id
    FROM store
)
SELECT 
    s.staff_id,
    s.first_name,
    s.last_name,
    s.store_id,
    ms.manager_staff_id Reporting_Manager_ID
FROM staff s
inner JOIN manager_stores ms ON s.store_id = ms.store_id
WHERE s.staff_id != manager_staff_id
ORDER BY s.store_id, s.staff_id;

#In order to show the recusiveness using CTE.. we must add the reports_to column into the staff table. and then update the data in the reports_to column 
# to show the recursive search. This is not clear in the question hence I have done both ways.

-- ALTER TABLE staff ADD COLUMN reports_to INT;
-- -- Top-level managers for both stores.
-- UPDATE staff SET reports_to = NULL WHERE staff_id (1,2);

-- -- Direct reports to staff_id = 1
-- UPDATE staff SET reports_to = 1 WHERE staff_id IN (3);

-- -- Reports to staff_id = 2
-- UPDATE staff SET reports_to = 2 WHERE staff_id IN (4, 5);

-- -- Reports to staff_id = 3
-- UPDATE staff SET reports_to = 3 WHERE staff_id in (6,7);


-- -- Reports to staff_id = 4
-- UPDATE staff SET reports_to = 4 WHERE staff_id in (8);

WITH RECURSIVE staff_hierarchy AS (
    -- Anchor: all top-level managers (no one to report to)
    SELECT 
        staff_id,
        first_name,
        last_name,
        reports_to,
        1 AS level
    FROM staff
    WHERE reports_to IS NULL

    UNION ALL

    -- Recursive: find all indirect reports
    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        s.reports_to,
        sh.level + 1
    FROM staff s
    JOIN staff_hierarchy sh ON s.reports_to = sh.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name,
    reports_to,
    level
FROM staff_hierarchy
ORDER BY level, staff_id;