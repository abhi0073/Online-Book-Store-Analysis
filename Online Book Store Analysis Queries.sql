CREATE DATABASE ONLINE_BOOK_STORE;

USE ONLINE_BOOK_STORE;

--- BOOKS TABLES ---

DROP TABLE IF EXISTS BOOKS;
CREATE TABLE BOOKS (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100),
    AUTHOR VARCHAR(100),
    GENRE VARCHAR(50),
    PUBLISHED_YEAR INT,
    PRICE DECIMAL(10,2),
    STOCK INT
);

SELECT * FROM BOOKS;

--- CUSTOMERS TABLES ---

DROP TABLE IF EXISTS CUSTOMERS;
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    PHONE VARCHAR(15),
    CITY VARCHAR(100),
    COUNTRY VARCHAR(100)
);

SELECT * FROM CUSTOMERS;

--- ORDERS TABLES ---

DROP TABLE IF EXISTS ORDERS;
CREATE TABLE ORDERS (
    ORDER_ID INT PRIMARY KEY,
    CUSTOMER_ID INT,
    BOOK_ID INT,
    ORDER_DATE DATE,
    QUANTITY INT,
    TOTAL_AMOUNT DECIMAL(10,2),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES BOOKS(BOOK_ID)
);

SELECT * FROM ORDERS;

                                              /* || BASIC QUERIES ON ONLINE BOOK STORE || */

/* || 1) Retrieve all books in the "Fiction" genre || */

SELECT TITLE FROM BOOKS
WHERE GENRE = "FICTION";

/* || 2) Find books and published_year published after the year 1950 || */

SELECT PUBLISHED_YEAR, TITLE FROM BOOKS
WHERE PUBLISHED_YEAR > 1950;

/* || 3) List all customers Details from the Canada || */

SELECT * FROM CUSTOMERS
WHERE COUNTRY = "CANADA";

/* || 4) Show orders placed in November 2023 || */

SELECT * FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-01-01' AND '2023-12-31';

/* || 5) Retrieve the total stock for perilcular Book of books available || */

SELECT TITLE, STOCK FROM BOOKS;

/* || 6) Find the details of the most expensive book || */

SELECT * FROM BOOKS JOIN ORDERS
ON BOOKS.BOOK_ID = ORDERS.BOOK_ID
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1;

/* || 7) Show all customers who ordered more than 1 quantity of a book || */

SELECT * FROM CUSTOMERS JOIN ORDERS
ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
WHERE QUANTITY > 1;

/* || 8) Retrieve all orders where the total amount exceeds $200 */

SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT >= 200;

/* || 9) List all genres available in the Books table || */

SELECT DISTINCT GENRE FROM BOOKS;

/* || 10) Find the book with the lowest stock || */

SELECT * FROM BOOKS
ORDER BY STOCK ASC
LIMIT 1;

/* || 11) Calculate the total revenue generated from all orders || */

SELECT FORMAT(ROUND(SUM(TOTAL_AMOUNT),2), "#,##") AS TOTAL_REVENUE
FROM ORDERS;

                                              /* || ADVANCED QUERIES ON ONLINE BOOK STORE || */
                                              
/* || 1) Retrieve the total number of books sold for each genre  || */

SELECT 
  GENRE, 
  SUM(QUANTITY) AS TOTAL_BOOK_SOLD
FROM 
  BOOKS JOIN ORDERS
  ON BOOKS.BOOK_ID = ORDERS.BOOK_ID
GROUP BY 
  GENRE
ORDER BY 
  TOTAL_BOOK_SOLD DESC;

/* || 2) Find the average price of books in the "Fantasy" genre  || */

SELECT ROUND(AVG(PRICE),2) AS AVG_PRICE 
FROM BOOKS
WHERE GENRE = "FANTASY";

/* || 3) List customers who have placed at least 2 orders || */

SELECT 
  C.CUSTOMER_ID, 
  C.NAME 
FROM 
  CUSTOMERS C JOIN ORDERS O
  ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY 
  C.CUSTOMER_ID, C.NAME
HAVING 
  COUNT(O.ORDER_ID) >= 2;

/* || 4) Find the most frequently ordered book || */

SELECT 
  B.BOOK_ID, 
  B.TITLE,
  COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM 
  BOOKS B JOIN ORDERS O
  ON B.BOOK_ID = O.BOOK_ID
GROUP BY 
  B.BOOK_ID,
  B.TITLE
ORDER BY 
  ORDER_COUNT DESC
LIMIT 1;

/* || 5) Show the top 3 most expensive books of 'Fantasy' Genre || */

SELECT 
  * 
FROM
  BOOKS
WHERE 
  GENRE = "FANTASY"
ORDER BY 
  PRICE DESC
LIMIT 3;

/* || 6) Retrieve the total quantity of books sold by each author || */

SELECT 
  B.AUTHOR,
  SUM(O.QUANTITY) AS TOTAL_BOOK_SOLD
FROM 
  BOOKS B JOIN ORDERS O
  ON B.BOOK_ID = O.BOOK_ID
GROUP BY
  B.AUTHOR
ORDER BY
  TOTAL_BOOK_SOLD DESC;
  
/* || 7) List the cities where customers who spent over $300 are located || */

SELECT 
  DISTINCT C.CITY,
  O.TOTAL_AMOUNT
FROM 
  CUSTOMERS C JOIN ORDERS O
  ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE
  O.TOTAL_AMOUNT > 300;
  
/* || 8) Find the customer who spent the most on orders || */

SELECT
  C.CUSTOMER_ID,
  C.NAME,
  SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM 
  CUSTOMERS C JOIN ORDERS O
  ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY
  C.CUSTOMER_ID,
  C.NAME
ORDER BY
  TOTAL_SPENT DESC
LIMIT 1;

/* || 9) Calculate the stock remaining after fulfilling all order || */

SELECT
  B.BOOK_ID,
  B.TITLE,
  B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_STOCK
FROM 
  BOOKS B JOIN ORDERS O
  ON B.BOOK_ID = O.BOOK_ID
GROUP BY
  B.BOOK_ID,
  B.TITLE,
  B.STOCK;
  








