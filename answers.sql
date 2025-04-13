CREATE DATABASE bookstore;
USE bookstore;
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);
CREATE TABLE address_status (
    address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL
);

CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    customer_id INT,
    address_status_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

CREATE TABLE customer_address (
    customer_address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    address_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    publisher_id INT,
    language_id INT,
    publication_year YEAR,
    price DECIMAL(10, 2),

    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);

CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
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
INSERT INTO country (country_name) VALUES 
('United States'), ('Canada'), ('United Kingdom'), ('Australia'), ('Germany');

INSERT INTO address_status (status_name) VALUES 
('Current'), ('Old');

INSERT INTO customer (customer_name) VALUES 
('Alice Johnson'), ('Bob Smith'), ('Charlie Brown'), ('Diana Prince'), ('Ethan Hunt');

INSERT INTO address (address_line, city, state, postal_code, country_id, customer_id, address_status_id) VALUES 
('123 Maple Street', 'Springfield', 'IL', '62704', 1, 1, 1),
('456 Oak Avenue', 'Toronto', 'ON', 'M4B 1B4', 2, 2, 1),
('789 Pine Road', 'London', '', 'SW1A 1AA', 3, 3, 1),
('321 Elm Street', 'Sydney', 'NSW', '2000', 4, 4, 2),
('654 Birch Lane', 'Berlin', '', '10115', 5, 5, 1);

INSERT INTO customer_address (customer_id, address_id) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
INSERT INTO book_language (language_name) VALUES 
('English'), ('French'), ('Spanish'), ('Swahili'), ('German'), ('Italian'), ('Chinese'), ('Japanese'), ('Russian'), ('Arabic');
INSERT INTO publisher (name, location) VALUES 
('Penguin Random House', 'New York'), ('HarperCollins', 'New York'), ('Simon & Schuster', 'New York'), ('Hachette Book Group', 'New York'), ('Macmillan Publishers', 'New York'), ('Scholastic Corporation', 'New York'), ('Wiley', 'Hoboken, NJ'), ('Springer Nature', 'Berlin'), ('Elsevier', 'Amsterdam'), ('Oxford University Press', 'Oxford');
INSERT INTO author (first_name, last_name) VALUES 
('J.K', 'Rollins'), ('Ngugi', 'Thiongo'), ('Emily', 'Johnson'), ('Graystone', 'Micheal'), ('Nora', 'Roberts'), ('David', 'Miller'), ('Laura', 'Wilson'), ('James', 'Taylor'), ('Linda', 'Anderson'), ('Robert', 'Thomas');
INSERT INTO book (title, publisher_id, language_id, publication_year, price) VALUES 
('Harry Potter and the Philosopher\'s Stone', 1, 1, 1997, 20.00), ('A Grain of Wheat', 2, 4, 1967, 15.00), ('The Great Gatsby', 3, 1, 1925, 10.00), ('The Silent Patient', 4, 1, 2019, 25.00), ('The Alchemist', 5, 1, 1988, 18.00), ('The Da Vinci Code', 6, 1, 2003, 22.00), ('The Hunger Games', 7, 1, 2008, 20.00), ('To Kill a Mockingbird', 8, 1, 1960, 12.00), ('Pride and Prejudice', 9, 1, 1813, 14.00), ('1984', 10, 1, 1949, 16.00);
INSERT INTO book_author (book_id, author_id) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- TEST CASES
-- 1. Find books published after 1950:
SELECT title, publication_year FROM book WHERE publication_year > 1950;

-- 2. Find customers with current addresses
SELECT customer_name, address_line, city, state, postal_code 
FROM customer 
JOIN address ON customer.customer_id = address.customer_id 
WHERE address_status_id = 1;

-- 3. List all books written by a specific author (e.g., J.K Rowling)
SELECT b.title, a.first_name, a.last_name 
FROM book b 
JOIN book_author ba ON b.book_id = ba.book_id 
JOIN author a ON ba.author_id = a.author_id 
WHERE a.first_name = 'J.K' AND a.last_name = 'Rowling';