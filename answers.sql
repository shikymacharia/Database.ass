CREATE DATABASE  bookstore_db;
USE bookstore_db;
-- Create core lookup tables (no foreign key dependencies)
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE);
    
    CREATE TABLE address_status (
    address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL UNIQUE,
    cost DECIMAL(5, 2) NOT NULL
);
CREATE TABLE order_status (
    order_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
-- Create main entity tables
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    region VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    publication_year SMALLINT,
    genre VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);
-- Create relationship tables (many-to-many)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);

CREATE TABLE customer_address (
    customer_address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    address_status_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- Create order related tables
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_address_id INT,
    billing_address_id INT,
    shipping_method_id INT,
    order_status_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES address(address_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

CREATE TABLE order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    order_status_id INT NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

-- Insert data into lookup tables
INSERT INTO country (country_name) VALUES
('United States'), ('Canada'), ('United Kingdom'),
 ('Australia'), ('Germany');

INSERT INTO address_status (status_name) VALUES
('Current'), ('Old'), ('Billing');

INSERT INTO book_language (language_name) VALUES
('English'), ('French'), ('Spanish'),
 ('Swahili'), ('German'), ('Italian'), 
('Chinese'), ('Japanese'), ('Russian'), ('Arabic');
INSERT INTO publisher (name, location) VALUES
('Penguin Random House', 'New York'),
 ('HarperCollins', 'New York'), 
 ('Simon & Schuster', 'New York'),
 ('Hachette Book Group', 'New York'),
 ('Macmillan Publishers', 'New York'), 
 ('Scholastic Corporation', 'New York'), 
 ('Wiley', 'Hoboken, NJ'),
 ('Springer Nature', 'Berlin'), 
 ('Elsevier', 'Amsterdam'),
 ('Oxford University Press', 'Oxford');

INSERT INTO author (first_name, last_name) VALUES
('J.K', 'Rowling'),
 ('Ngugi', 'Thiongo'),
 ('F. Scott', 'Fitzgerald'),
 ('Alex', 'Michaelides'), 
 ('Paulo', 'Coelho'), 
 ('Dan', 'Brown'), 
 ('Suzanne', 'Collins'),
 ('Harper', 'Lee'),
 ('Jane', 'Austen'),
 ('George', 'Orwell');

INSERT INTO shipping_method (method_name, cost) VALUES
('Standard', 5.99),
 ('Express', 12.99), 
 ('Next Day', 19.99);

INSERT INTO order_status (status_name) VALUES
('Pending'),
 ('Processing'), 
 ('Shipped'),
 ('Delivered'),
 ('Cancelled'),
 ('Returned');

-- Insert data into main entity tables
INSERT INTO customer (first_name, last_name, email, phone_number) VALUES
('Alice', 'Johnson', 'alice.j@email.com', '123-456-7890'),
('Bob', 'Smith', 'bob.s@email.com', '987-654-3210'),
('Charlie', 'Brown', 'charlie.b@email.com', '555-123-4567'),
('Diana', 'Prince', 'diana.p@email.com', '777-888-9999'),
('Ethan', 'Hunt', 'ethan.h@email.com', '111-222-3333');

INSERT INTO address (street_address, city, region, postal_code, country_id) VALUES
('123 Maple Street', 'Springfield', 'IL', '62704', 1),
('456 Oak Avenue', 'Toronto', 'ON', 'M4B 1B4', 2),
('789 Pine Road', 'London', NULL, 'SW1A 1AA', 3),
('321 Elm Street', 'Sydney', 'NSW', '2000', 4),
('654 Birch Lane', 'Berlin', NULL, '10115', 5),
('987 Willow Drive', 'Springfield', 'IL', '62704', 1),
('234 Cedar Boulevard', 'Toronto', 'ON', 'M5V 2S9', 2);

INSERT INTO customer_address (customer_id, address_id, address_status_id) VALUES
(1, 1, 1), -- Alice's current address
(1, 6, 2), -- Alice's old address
(2, 2, 1), -- Bob's current address
(3, 3, 1), -- Charlie's current address
(4, 4, 1), -- Diana's current address
(5, 5, 1), -- Ethan's current address
(1, 1, 3),  -- Alice's billing address (same as current for now)
(2, 7, 3);  -- Bob's billing address

INSERT INTO book (isbn, title, publisher_id, language_id, publication_year, genre, price, stock_quantity) VALUES
('978-0747532699', 'Harry Potter and the Philosopher\'s Stone', 1, 1, 1997, 'Fantasy', 20.00, 100),
('978-0435919784', 'A Grain of Wheat', 2, 4, 1967, 'Historical Fiction', 15.00, 50),
('978-0743273565', 'The Great Gatsby', 3, 1, 1925, 'Classic', 10.00, 75),
('978-1250122292', 'The Silent Patient', 4, 1, 2019, 'Thriller', 25.00, 60),
('978-0061122415', 'The Alchemist', 5, 1, 1988, 'Fiction', 18.00, 80),
('978-0307277671', 'The Da Vinci Code', 6, 1, 2003, 'Mystery', 22.00, 45),
('978-0439023481', 'The Hunger Games', 7, 1, 2008, 'Young Adult', 20.00, 90),
('978-0061120084', 'To Kill a Mockingbird', 8, 1, 1960, 'Classic', 12.00, 120),
('978-0141439518', 'Pride and Prejudice', 9, 1, 1813, 'Romance', 14.00, 110),
('978-0451524935', '1984', 10, 1, 1949, 'Dystopian', 16.00, 70);

INSERT INTO book_author (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), 
    (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insert data into order related tables
INSERT INTO cust_order (customer_id, shipping_address_id, billing_address_id, shipping_method_id, order_status_id) VALUES
(1, 1, 1, 1, 1), -- Alice's first order (Pending)
(2, 2, 7, 2, 3), -- Bob's order (Shipped)
(3, 3, 3, 1, 4), -- Charlie's order (Delivered)
(1, 6, 1, 3, 5), -- Alice's second order (Cancelled)
(4, 4, 4, 2, 2); -- Diana's order (Processing)

INSERT INTO order_line (order_id, book_id, quantity, unit_price) VALUES
(1, 1, 1, 20.00),
(1, 3, 2, 10.00),
(2, 2, 1, 15.00),
(2, 4, 1, 25.00),
(3, 8, 1, 12.00),
(4, 7, 2, 20.00),
(5, 5, 1, 18.00),
(5, 9, 1, 14.00);

INSERT INTO order_history (order_id, order_status_id) VALUES
(1, 1), -- Order 1: Pending
(2, 1), -- Order 2: Pending
(2, 2), -- Order 2: Processing
(2, 3), -- Order 2: Shipped
(3, 1), -- Order 3: Pending
(3, 2), -- Order 3: Processing
(3, 3), -- Order 3: Shipped
(3, 4), -- Order 3: Delivered
(4, 1), -- Order 4: Pending
(4, 5), -- Order 4: Cancelled
(5, 1), -- Order 5: Pending
(5, 2); -- Order 5: Processing

-- More Comprehensive TEST CASES

-- 4. Find all books with a price greater than $15.00:
SELECT title, price FROM book WHERE price > 15.00;

-- 5. Find customers who have placed orders:
SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN cust_order co ON c.customer_id = co.customer_id;

-- 6. List all orders with customer names and order statuses:
SELECT co.order_id, cu.first_name, cu.last_name, os.status_name
FROM cust_order co
JOIN customer cu ON co.customer_id = cu.customer_id
JOIN order_status os ON co.order_status_id = os.order_status_id;

-- 7. Find the total number of books in each order:
SELECT ol.order_id, COUNT(*) AS total_books
FROM order_line ol
GROUP BY ol.order_id;

-- 8. Calculate the total price of each order:
SELECT ol.order_id, SUM(ol.quantity * ol.unit_price) AS total_price
FROM order_line ol
GROUP BY ol.order_id;

-- 9. Find books published in a specific year (e.g., 1997):
SELECT title, publication_year FROM book WHERE publication_year = 1997;

-- 10. List authors and the books they have written:
SELECT a.first_name, a.last_name, b.title
FROM author a
JOIN book_author ba ON a.author_id = ba.author_id
JOIN book b ON ba.book_id = b.book_id
ORDER BY a.last_name, a.first_name, b.title;

-- 11. Find customers with a specific address status (e.g., 'Billing'):
SELECT c.first_name, c.last_name, a.street_address, as_s.status_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN address_status as_s ON ca.address_status_id = as_s.address_status_id
WHERE as_s.status_name = 'Billing';

-- 12. Find orders shipped using a specific shipping method (e.g., 'Express'):
SELECT o.order_id, c.first_name, c.last_name, sm.method_name
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN shipping_method sm ON o.shipping_method_id = sm.shipping_method_id
WHERE sm.method_name = 'Express';

-- 13. Find the latest status of each order:
SELECT o.order_id, os.status_name, MAX(oh.change_date)
 AS latest_change_date
FROM cust_order o
JOIN order_history oh ON o.order_id = oh.order_id
JOIN order_status os ON oh.order_status_id = os.order_status_id
GROUP BY o.order_id
ORDER BY latest_change_date DESC;

-- 14. Find books that have a stock quantity less than a certain amount (e.g., 60):
SELECT title, stock_quantity 
FROM book WHERE stock_quantity < 60;

-- 15. List all publishers and the number of books they have published:
SELECT p.name AS publisher_name, COUNT(b.book_id) 
AS number_of_books
FROM publisher p
LEFT JOIN book b ON p.publisher_id = b.publisher_id
GROUP BY p.publisher_id, p.name
ORDER BY number_of_books DESC;
