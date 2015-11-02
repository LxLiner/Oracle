-- 1. ��������� ������, ������� �������� ������� ����������� � �� E-mail ������ �
-- ������ �������: �������� �������� E-mail + "@Netcracker.com" 

SELECT last_name, email||'@Netcracker.com' 
FROM employees;

-- 2. ��������� ������, �������:
-- - �������� ������� ����������� � �� ��������;
-- - �������� ��������� 15000$. 

SELECT last_name, salary 
FROM employees 
WHERE salary > 15000;

-- 3. ��������� ������, ������� �������� ������� �����������, ��������, ������������,
-- �� �������� �� ��� � ������ ������������. 

SELECT last_name, salary, commission_pct, (salary+commission_pct)*12 
FROM employees;

-- 1. ��������� ������, �������:
-- - �������� ��� ������� ���������� c����� � �������
-- 'Dear '+A+ ' ' + B + �! ' + � Your salary = � + C,
-- ��� A = {�Mr.�,�Mrs.�} � ����������� ������� ��������� � ������� ��� �������
-- (������������, ��� �������� �������� ��� ����������, ��� ������� ������������� �� �����
-- �a� ��� �e�)
-- B � ������� ����������;
-- C � ������� �������� � ������ ������������ ���������� 

SELECT 'Dear '+'Mrs.'+' '+last_name+'! '+'Your salary = '+(salary+commission_pct)*12 
FROM employees 
WHERE first_name LIKE '%a' AND first_name LIKE '%e'
UNION
SELECT 'Dear '+'Mr.'+' '+last_name+'! '+'Your salary = '+(salary+commission_pct)*12
FROM employees
WHERE first_name NOT LIKE '%a' AND first_name NOT LIKE '%e';

-- 1. ��������� ������, �������:
-- - �������� �������� �������������;
-- - ������������� ����������� � ������ Seattle. 

SELECT d.departments_name 
FROM departments d, location l 
WHERE d.location_id=l.location_id AND l.city='Seattle';

-- 2. ��������� ������, �������:
-- - �������� �������, ���������, ����� ������������� �����������
-- - ���������� �������� � ������ Toronto. 

SELECT e.last_name, j.job_title, d.department_name 
FROM employees e, jobs j, departments d, locations l 
WHERE e.job_id = j.job_id AND e.department_id = d.department_id AND d.location_id = l.location_id AND l.city = 'Toronto';

-- 3. ��������� ������, �������:
-- - �������� ����� � ������� ����������, ����� � ������� ��� ���������
-- - ��� ����������� ��� ���������� �������� ������� ��������� � ���� �No manager�. 

SELECT e.employee_id, e.last_name, m.employee_id, NVL(m.last_name,'No manager') 
FROM employee e, employee m 
WHERE e.manager_id=m.employee_id;

-- 4. ��������� ������, �������:
-- - �������� ����� � �������� �������������;
-- - ������������� ����������� � ������ UNITED STATES OF AMERICA
-- - � �������������� �� ������ ���� �����������. 

SELECT d.department_id, d.department_name 
FROM department d LEFT JOIN employees e ON (d.department_id=e.department_id), location l, country c 
WHERE d.location_id=l.location_id AND l.country_id=c.country_id AND c.country_name='UNITED STATES OF AMERICA' AND e.employee_id IS NULL;

-- 1. ��������� ������, �������:
-- - �������� ���-�� ����������� � ������ �������������;
-- - ���-�� ����������� �� ������ ���� ������ 2; 

SELECT d.department_id, COUNT(e.employee_id) 
FROM employees e, department d 
WHERE e.department_id=d.department_id
GROUP BY department
HAVING COUNT(e.employee_id)>=2;

-- 2. ��������� ������, �������:
-- - �������� �������� ���������� � ������� �������� �� ���������;
-- - ��������� ������ ���� ������� � �����������, �.�. ��������� ����� Manager;
-- - ������� �������� �� ������ ���� ����� 10 �����. 

SELECT j.job_title, AVG (e.salary) 
FROM employees e, jobs j
WHERE e.job_id=j.job_id
GROUP BY job
HAVING AVG(e.salary)>=10000;

-- 3. ��������� ������, �������:
-- - �������� ���-�� ����������� � ������ �������������;
-- - ��������� ������� ������ �� ������ ������ ���� ����� ���-�� �����������. 

SELECT d.department_name, COUNT(e.employee_id)
FROM employees e, department d
WHERE e.department_id=d.department_id
GROUP BY ROLLUP(department);