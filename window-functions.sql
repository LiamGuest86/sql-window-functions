-- Window Functions
CREATE DATABASE window_functions;

USE window_functions;

CREATE TABLE employees (
    emp_no INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(20),
    salary INT
);
 
INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);




-- OVER()
SELECT * FROM employees;

SELECT department, AVG(salary) FROM employees
GROUP BY department;

SELECT AVG(salary) OVER() FROM employees; -- Empty() includes all rows. averages all salleries per row

SELECT emp_no, department, salary, AVG(salary) OVER() FROM employees;

SELECT emp_no, department, salary, MIN(salary) OVER(), MAX(salary) OVER() FROM employees;


-- PARTITION BY - unsed inside of the OVER(), use this to form rows into groups of row
SELECT emp_no, department, salary, AVG(salary) OVER (PARTITION BY department) AS dept_avg FROM employees;

SELECT emp_no, department, salary, AVG(salary) OVER (PARTITION BY department) AS dept_avg, AVG(salary) OVER () AS comp_avg FROM employees;

SELECT emp_no, department, salary, COUNT(*) OVER(PARTITION BY department) as dept_count FROM employees;

SELECT emp_no, department, salary, SUM(salary) OVER(PARTITION BY department) AS dept_payroll, SUM(salary) OVER() AS total_payroll FROM employees;




-- ORDER BY with windows
SELECT
	emp_no,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department) AS dept_salary
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rol_dept_salary,
    SUM(salary) OVER(PARTITION BY department) AS dept_salary
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    MIN(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rol_min
FROM employees;



-- RANK()
SELECT
	emp_no,
    department,
    salary,
    RANK() OVER(ORDER BY salary DESC) AS sal_rank
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dep_sal_rank,
    RANK() OVER(ORDER BY salary DESC) AS sal_rank
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dep_sal_rank,
    RANK() OVER(ORDER BY salary DESC) AS sal_rank
FROM employees
ORDER BY department;




-- DENSE_RANK & ROW_NUMBER()
SELECT
	emp_no,
    department,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS dep_Sal_row,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dep_sal_rank,
    RANK() OVER(ORDER BY salary DESC) AS sal_rank
FROM employees
ORDER BY department;

SELECT
	emp_no,
    department,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS dep_Sal_row,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dep_sal_rank,
    RANK() OVER(ORDER BY salary DESC) AS sal_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS ovrl_sal_drank
FROM employees
ORDER BY department;

SELECT
	emp_no,
    department,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS dep_Sal_row,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dep_sal_rank,
    RANK() OVER(ORDER BY salary DESC) AS sal_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS ovrl_sal_drank,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS ovrl_num
FROM employees
ORDER BY sal_rank;



-- NTILE() - Break a window into different "buckets"
SELECT
	emp_no,
    department,
    salary,
    NTILE(4) OVER(PARTITION BY department ORDER BY salary DESC) AS dep_salary_quart,
    NTILE(4) OVER(ORDER BY salary DESC) AS salary_quart
FROM employees;



-- FIRST_VALUE - returns value from first row of window frame
SELECT
	emp_no,
    department,
    salary,
    FIRST_VALUE(emp_no) OVER(ORDER BY salary DESC)
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_paid_dep,
    FIRST_VALUE(emp_no) OVER(ORDER BY salary DESC) AS highest_paid_ovrl
FROM employees;




-- LEAD & LAG - Often used to look at difference between perceeding and folowing row
SELECT
	emp_no,
    department,
    salary,
    LAG(salary) OVER(ORDER BY salary DESC)
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    salary - LAG(salary) OVER(ORDER BY salary DESC) AS salary_dif
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    salary - LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS salary_dif
FROM employees;

SELECT
	emp_no,
    department,
    salary,
    LEAD(salary) OVER(ORDER BY salary DESC)
FROM employees;
