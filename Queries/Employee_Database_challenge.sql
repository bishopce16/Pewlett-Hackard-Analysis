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
  PRIMARY KEY (emp_no, from_date)
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

-- deliverable 1, The Number of Retiring Employees by Title.
SELECT e.emp_no,
e.first_name,
e.last_name,
t.title, 
t.from_date,
t.to_date,
FROM employees AS e
INNER JOIN titles AS t
ON (e.emp_no = t.title)
WHERE (e.birth_date BETWEEN '1951-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- step 8 use starter code. 
-- Use Dictinct with Orderby to remove duplicate rows
-- SELECT DISTINCT ON (______) _____,
-- ______,
-- ______,
-- ______

-- INTO nameyourtable
-- FROM _______
-- WHERE _______
-- ORDER BY _____, _____ DESC;

-- step 8 use starter code. 
-- Use Dictinct with Orderby to remove duplicate rows
-- emp_no, first_name, last_name, title columns 
-- from the retirement_info table.
SELECT DISTINCT ON (ri.emp_no) ri.emp_no,
ri.first_name,
ri.last_name,
ri.title
INTO unique_titles
FROM retirement_info AS ri
ORDER BY ri.emp_no, ri.to_date DESC;

-- create retiring titles table
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT DESC;

-- deliverable 2, The Employees Eligible for the Mentorship Program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE de.to_date = '9999-01-01'
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no, de.to_date DESC;

-- 1 of 2 additional tables for analysis
-- questions about gender gap in hiring for future equality
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

-- 2 of 2 additional tables for analysis
-- questions about gender gap in hiring for future equality.
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




