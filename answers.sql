CREATE DATABASE bookstore;
USE bookstore;
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
