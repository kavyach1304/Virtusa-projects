-- Reset database (so it runs clean every time)

CREATE DATABASE digital_library;
USE digital_library;

-- -----------------------------
-- TABLES
-- -----------------------------

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    author VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE IssuedBooks (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    student_id INT,
    issue_date DATE,
    return_date DATE,
    
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- -----------------------------
-- SAMPLE DATA (HUMAN-LIKE)
-- -----------------------------

-- Books (popular & familiar)
INSERT INTO Books (title, author, category) VALUES
('Harry Potter', 'J.K. Rowling', 'Fiction'),
('Wings of Fire', 'A.P.J Abdul Kalam', 'Biography'),
('The Alchemist', 'Paulo Coelho', 'Fiction'),
('Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance'),
('Ikigai', 'Hector Garcia', 'Self-help'),
('A Brief History of Time', 'Stephen Hawking', 'Science');

-- Students (simple names)
INSERT INTO Students (name, email, join_date) VALUES
('Ravi', 'ravi@gmail.com', '2021-06-10'),
('Sneha', 'sneha@gmail.com', '2022-01-15'),
('Raju', 'raju@gmail.com', '2019-08-20'),
('Priya', 'priya@gmail.com', '2020-03-12'),
('Kiran', 'kiran@gmail.com', '2018-05-01');

-- Issued Books
INSERT INTO IssuedBooks (book_id, student_id, issue_date, return_date) VALUES
(1, 1, CURDATE() - INTERVAL 20 DAY, NULL),   -- overdue
(2, 2, CURDATE() - INTERVAL 5 DAY, NULL),    -- not overdue
(3, 3, CURDATE() - INTERVAL 30 DAY, '2025-03-01'),
(4, 1, CURDATE() - INTERVAL 16 DAY, NULL),   -- overdue
(5, 4, CURDATE() - INTERVAL 10 DAY, NULL),
(6, 2, CURDATE() - INTERVAL 25 DAY, NULL);   -- overdue

-- -----------------------------
-- 1. OVERDUE BOOKS (14 DAYS)
-- -----------------------------

SELECT 
    s.name,
    b.title,
    ib.issue_date
FROM IssuedBooks ib
JOIN Students s ON ib.student_id = s.student_id
JOIN Books b ON ib.book_id = b.book_id
WHERE ib.return_date IS NULL
AND ib.issue_date < CURDATE() - INTERVAL 14 DAY;

-- -----------------------------
-- 2. POPULARITY INDEX
-- -----------------------------

SELECT 
    b.category,
    COUNT(*) AS total_borrows
FROM IssuedBooks ib
JOIN Books b ON ib.book_id = b.book_id
GROUP BY b.category
ORDER BY total_borrows DESC;

-- -----------------------------
-- 3. INACTIVE STUDENTS (3 YEARS)
-- -----------------------------

-- View first
SELECT s.student_id, s.name
FROM Students s
LEFT JOIN IssuedBooks ib ON s.student_id = ib.student_id
GROUP BY s.student_id
HAVING MAX(ib.issue_date) IS NULL 
   OR MAX(ib.issue_date) < CURDATE() - INTERVAL 3 YEAR;

-- Update instead of delete (better practice)
UPDATE Students s
JOIN (
    SELECT s.student_id
    FROM Students s
    LEFT JOIN IssuedBooks ib ON s.student_id = ib.student_id
    GROUP BY s.student_id
    HAVING MAX(ib.issue_date) IS NULL 
       OR MAX(ib.issue_date) < CURDATE() - INTERVAL 3 YEAR
) AS temp
ON s.student_id = temp.student_id
SET s.status = 'Inactive';

-- PENALTY 
SELECT 
    s.name,
    b.title,
    ib.issue_date,
    DATEDIFF(CURDATE(), ib.issue_date) - 14 AS overdue_days,
    (DATEDIFF(CURDATE(), ib.issue_date) - 14) * 5 AS fine_amount
FROM IssuedBooks ib
JOIN Students s ON ib.student_id = s.student_id
JOIN Books b ON ib.book_id = b.book_id
WHERE ib.return_date IS NULL
AND DATEDIFF(CURDATE(), ib.issue_date) > 14;