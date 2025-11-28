-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



--importing data

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Program Files\PostgreSQL\18\data\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Program Files\PostgreSQL\18\data\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Program Files\PostgreSQL\18\data\Orders.csv' 
CSV HEADER;


-- 1)retrive all the query from fiction genre

select * from books
where genre = 'Fiction';

-- 2) Find books published after the year 1950:

 SELECT * FROM Books
 WHERE published_year >1950;


-- 3) List all customers from the Canada:

SELECT * FROM customers
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:

SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_Stock
from books;


-- 6) Find the details of the most expensive book:

SELECT * FROM  books 
ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT customer_id,quantity FROM orders
WHERE quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table:

SELECT DISTINCT genre FROM books;

-- 10) Find the book with the lowest stock:

SELECT * FROM  books 
ORDER BY stock ASC LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(total_amount) as Total_Revenue 
FROM orders;


--Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT genre,SUM(quantity) AS Total_Quantity_Sold
FROM 
  ( SELECT*FROM books AS B
   JOIN orders AS O
    ON O.Book_ID = B.Book_ID)
GROUP BY genre;


-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(price) AS Avg_Price
FROM books
WHERE genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:

SELECT customer_id,COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)>=2;


-- 4) Find the most frequently ordered book:

SELECT book_id,COUNT(order_id) AS order_count
FROM orders
GROUP BY book_id
ORDER BY order_count DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT book_id,price 
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT B.author, sum(O.quantity) AS books_per_author
FROM orders AS O
JOIN books AS B
ON O.book_id = B.book_id
GROUP BY B.author;


-- 7) List the cities where customers who spent over $30 are located:

SELECT C.city,C.customer_id,O.total_amount AS spendings
FROM orders AS O
JOIN customers AS C
ON O.customer_id = C.customer_id
WHERE  O.total_amounT> 30;


-- 8) Find the customer who spent the most on orders:


SELECT CUSTOMER_ID ,SUM(TOTAL_AMOUNT) AS SPENDINGS
FROM ORDERS
GROUP BY CUSTOMER_ID
ORDER BY SPENDINGS DESC LIMIT 1;



-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.Book_ID, b.Title, b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID;


SELECT b.Book_ID, b.Title, b.Stock, COALESCE(SUM(o.Quantity), 0) AS order_quantity, 
		b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID;

