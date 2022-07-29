-- Creating tables for PH-EmployeeDB
-- creating department table
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
-- creating employees table
CREATE TABLE employees (     
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
-- creating manager table
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
-- creating salaries table
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
-- creating dept_emp table
CREATE TABLE dept_emp (
 	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
 	to_date DATE NOT NULL,
 	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
-- creating titles table
CREATE TABLE titles (
	emp_no INT NOT NULL,
 	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
 	PRIMARY KEY (emp_no, title, from_date)
);
-- "querying the database."
SELECT * FROM dept_manager;

-- the first and last names of employees 
-- born between January 1, 1952, and December 31, 1955.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- how many employees were born in 1952.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- how many employees were born in 1953.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- how many employees were born in 1954.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- how many employees were born in 1955.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- save the data as a new table.
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- querying the table.
SELECT * FROM retirement_info;

-- Recreate the retirement_info Table with the emp_no Column
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- create a new table containing only the current employees 
-- who are eligible for retirement will be returned.
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee count by department number changed
-- to add new table that was saved as csv file.
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_counts
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

 -- Employee Information: A list of employees containing their 
 -- unique employee number, their last name, first name, gender, and salary
SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- create a table with the following info for sales.
-- Employee numbers, Employee first name, Employee last name, Employee department name.
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name	
INTO sales_info
FROM retirement_info as ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');


-- create a table with the following info for the Sales and Development teams.
-- Employee numbers, Employee first name, Employee last name, Employee department name.
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name	
INTO mentor_info
FROM retirement_info as ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales','Development');

-- create counts for equality table on gender for mentoring program 
SELECT COUNT (eme.gender), eme.gender
INTO equality_mentor_counts
FROM equality_mentorship_eligibilty AS eme
GROUP BY eme.gender
ORDER BY COUNT DESC;

-- create counts for equality table on gender on current employees 
SELECT COUNT (ece.gender), ece.gender
INTO equality_current_emp_counts
FROM equality_current_emp AS ece
GROUP BY ece.gender
ORDER BY COUNT DESC;

-- create a new table containing only the current employees 
-- who are eligible for retirement plus gender column.
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date,
	e.gender
INTO equality_current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
LEFT JOIN employees AS e
ON (e.emp_no = de.emp_no)
WHERE de.to_date = ('9999-01-01');

 -- equality mentorship eligibilty table, 
 -- The Employees Eligible for the Mentorship Program plus gender column.
SELECT DISTINCT ON (e.emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
e.gender,
de.from_date,
de.to_date,
t.title
INTO equality_mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE de.to_date = '9999-01-01'
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no, de.to_date DESC;


