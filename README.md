# Pewlett-Hackard-Analysis

---

## Overview of Pewlett Hackard Analysis

The purpose of this project was to analyze human resources data for a large company (Pewlett-Hackard) to help the company prepare for the future hiring demands. The project began with six csv files and the columns headers and relationships were diagrammed in the ERD (Entity Relationship Diagram) using [QuickDBD](website https://app.quickdatabasediagrams.com/#/).
The ERD diagram is below.
![ EmployeeDB](https://github.com/bishopce16/Pewlett-Hackard-Analysis/blob/main/Image/EmployeeDB.png)
Using the mapped-out ERD to create the databases and gather and organize the key elements from various data tables. The data was imported by means of postgres and the pgAdmin interface. The SQL queries were written and saved in the queries folder, the results were exported to their own CSV files. The main objective of this analysis is to determine how many employees are in a position to retire and how many employees could be eligible to participate in the mentorship program. 


---

## Resource:

Data Sources: 

CSV Files:

Software: 

departments.csv 

dept_emp.csv 

dept_manager.csv 

employees.csv 

salaries.csv 

titles.csv

---

## Results: 

To determine the answers to Pewlett-Hackard questions, they were first broken up into smaller sub questions. 

* Determine how many employees are able to retire and their titles
    * Create a retirement_titles table which holds all the titles of current employees that were born between January 1, 1952, and December 31, 1955. 

    ‘-- deliverable 1, The Number of Retiring Employees by Title.
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
    ORDER BY e.emp_no;’

    * The code below is the SQL script provided in the challenge starter code.

    ‘-- Use Dictinct with Order by to remove duplicate rows
    -- SELECT DISTINCT ON (______) _____,
    ______,
    ______,
    ______

    INTO nameyourtable
    FROM _______
    WHERE _______
    ORDER BY _____, _____ DESC;’

    ‘SELECT DISTINCT ON (ri.emp_no) ri.emp_no,
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
    ORDER BY COUNT DESC;’

    * The dataset has employees with multiple titles, that may be the result of promotions. Because of this a retiring_titles table was created that groups each employee’s most recent titles. 
    ![ retiring_titles]()


* Determine how many employees are eligible to participate in the mentorship program
    * A mentorship_eligibility  table was created that contains the current employees that were born between January 1, 1965 and December 31, 1965.

    ‘-- deliverable 2, The Employees Eligible for the Mentorship Program
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
    ORDER BY e.emp_no, de.to_date DESC;’


---

## Summary: 

Provide a high-level summary that addresses the following questions, and then provide two additional queries or tables that can be created that will provide more insight for the upcoming "silver tsunami".

How many roles will need to be filled as the "silver tsunami" begins to make an impact?

Are there enough retirement-ready employees in the departments that are qualified to mentor the next generation of Pewlett Hackard employees?

What is the current gender gap for Pewlett Hackard employees, and how would Pewlett Hackard hiring practices need to evolve to close the gender gap to improve gender equality?