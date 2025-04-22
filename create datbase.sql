----Creating DataBase Library Management------
Create TABLE branch(
branch_id varchar(20) primary key,
manager_id varchar(20),
branch_address varchar(55),
contact_no varchar(20)
);

DROP table if exists employees;
Create TABLE employees(
emp_id varchar(20) primary key,
emp_name varchar(25),	
position varchar(20),	
salary int,
branch_id varchar(20)
);
ALTER TABLE employees 
ALTER COLUMN salary TYPE numeric(10,2);

CREATE TABLE books(
isbn varchar(20) primary key,
book_title varchar(75),
category varchar(20),	
rental_price float ,
status varchar(10),	
author varchar(25),
publisher varchar(50)
);

create TABLE members(
member_id varchar(20) primary key,
member_name	varchar(30),
member_address varchar(25),
reg_date date
);

create TABLE issued_status(
issued_id varchar(25) primary key,
issued_member_id varchar(25), fk
issued_book_name varchar(75),
issued_date date,
issued_book_isbn varchar (30),fk
issued_emp_id varchar(10)fk
);
drop table if exists return_status;
create TABLE return_status(
return_id varchar(20) primary key,
issued_id varchar(20),
return_book_name varchar(75),	
return_date date,	
return_book_isbn varchar(20)
);

---foreign keys------
ALTER Table issued_status
add constraint fk_members
FOREIGN KEY (issued_member_id)
references members(member_id);

ALTER Table issued_status
add constraint fk_books
FOREIGN KEY (issued_book_isbn)
references books(isbn);

ALTER Table issued_status
add constraint fk_employees
FOREIGN KEY (issued_emp_id)
references employees(emp_id);

ALTER Table employees
add constraint fk_branch
FOREIGN KEY (branch_id)
references branch(branch_id);

ALTER Table return_status
add constraint fk_issued_status
FOREIGN KEY (issued_id)
references issued_status(issued_id);


INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES

('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');


select* from return_status;
select* from books;
select* from branch;
select* from employees;
select* from issued_status;
select* from members;


-------------Project questions----------
------- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
update members
set member_address='127 MainSt'
where member_id='C101'

- --Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE from issued_status
WHERE issued_id='IS121'

--- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issued_emp_id,issued_book_name from issued_status
where issued_emp_id ='E101'

---Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT  issued_emp_id,count(*) from issued_status
group by issued_emp_id
having count(*)>1;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS    
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;


SELECT * FROM
book_cnts;



-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic'

    
-- Task 8: Find Total Rental Income by Category:


SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

-- List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '1080 days' 

-- task 10 List Employees with Their Branch Manager's Name and their branch details:
select e1.*,b.manager_id,e2.emp_name as manager
from employees as e1
join branch as b on b.branch_id=e1.branch_id
join employees as e2 on b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

create table Books_with_Rental_price
as
select *from books
where rental_price>7
select *from Books_with_Rental_price


-- Task 12: Retrieve the List of Books Not Yet Returned
select distinct i1.issued_book_name from issued_status as i1
left join return_status as rs on i1.issued_id=rs.issued_id
where rs.return_id is null
select * from return_status
select * from issued_status