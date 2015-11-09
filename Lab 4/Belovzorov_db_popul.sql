-- CREATE USER old_db IDENTIFIED BY 12345;
-- GRANT CONNECT, RESOURCE TO old_db;
-- GRANT CREATE VIEW TO old_db;


--1.1.1 Создать представление, которое:
--- получает фамилию и имя сотрудников;
--- получает зарплату, начисленную каждому сотруднику за весь период его работы в компании с
--учетом комиссионных;
--- получает для каждого сотрудника количество лет работы в компании;
--- имя сотрудников представить как: первая буква в верхнем регистре, остальные - в нижнем;
--- количество месяцев округлить до ближайшего целого;
--- отсортировать сотрудников в порядке возрастания размера начисленной зарплаты.
--Выполните запрос к созданному представлению.

CREATE VIEW surandname
AS SELECT e.last_name, 
  INITCAP(e.first_name) AS name, 
  TRUNC(MONTHS_BETWEEN(sysdate, e.hire_date))*e.salary*e.commission_pct AS all_money,
  TRUNC(MONTHS_BETWEEN(sysdate, e.hire_date)/12) AS years_in_company
FROM employees e
ORDER BY all_money;

SELECT * FROM surandname;

--1.1.2. Создать представление, которое:
--- получает фамилии, имена сотрудников;
--- получает для сотрудников надбавку к зарплате "Tax", которая определяется как 4% за каждый
--год работы для Programmer, 3% за каждый год работы для Accountant, 2% за каждый год работы для
--Sales Manager и 0.1% за каждый год работы для Administration Assistant.
--Выполните запрос к созданному представлению

CREATE VIEW taxtable
AS SELECT e.last_name, e.first_name, 0.04 * TRUNC(MONTH_BETWEEN(sysdate, e.hire_date)/12) AS tax
FROM employees e, jobs j
WHERE e.job_id=j.job_id AND j.job_title='Programmer'
UNION
SELECT e.last_name, e.first_name, 0.03 * TRUNC(MONTH_BETWEEN(sysdate, e.hire_date)/12) AS tax
FROM employees e, jobs j
WHERE e.job_id=j.job_id AND j.job_title='Accountant'
UNION 
SELECT e.last_name, e.first_name, 0.02 * TRUNC(MONTH_BETWEEN(sysdate, e.hire_date)/12) AS tax
FROM employees e, jobs j
WHERE e.job_id=j.job_id AND j.job_title='Sales Manager'
UNION
SELECT e.last_name, e.first_name, 0.001 * TRUNC(MONTH_BETWEEN(sysdate, e.hire_date)/12) AS tax
FROM employees e, jobs j
WHERE e.job_id=j.job_id AND j.job_title='Administration Assistant';

SELECT * FROM taxtable;

--1.1.3. Создать представление, которое:
--- получает фамилии сотрудников
--- получает количество выходных дней (суббота, воскресенье) с момента их зачисления на
--работу, например, если сотрудник был зачислен в прошлую пятницу, а сегодня понедельник, то у него
--уже было 2 выходных дня, хотя всего прошло 3 дня с момента его зачисления.
--- сотрудники зачислены в июле 1998 года;
--- отсортировать сотрудников в порядке убывания количествв выходных дней.
--Выполните запрос к созданному представлению.

CREATE VIEW weekends
AS SELECT e.last_name AS surname, count(nd) AS weekend_days
FROM employees e, 
	(SELECT LEVEL AS nd FROM
	DUAL LEVEL < sysdate - e.hire_date)
WHERE to_char((e.hire_date + nd), 'd') in (6, 7)
AND to_char(e.hire_date, 'mm') = '07'
AND to_char(e.hire_date, 'yyyy') = '1998'
ORDER BY weekend_days DESC;

SELECT * FROM weekends;

-- CREATE USER new_db IDENTIFIED BY 12345;
-- GRANT CONNECT, RESOURCE TO new_db;

--2.1. Для всех таблиц новой БД создать генераторы последовательности, обеспечивающие
--автоматическое создание новых значений колонок, входящих в первичный ключ.

CREATE SEQUENCE dep_seq START WITH 1;
CREATE SEQUENCE boss_seq START WITH 1;
CREATE SEQUENCE pos_seq START WITH 1;
CREATE SEQUENCE emp_seq START WITH 1;
CREATE SEQUENCE prod_seq START WITH 1;
CREATE SEQUENCE cus_t_seq START WITH 1;
CREATE SEQUENCE cus_seq START WITH 1;
CREATE SEQUENCE sale_seq START WITH 1;
CREATE SEQUENCE pur_seq START WITH 1;

--2.2. Для каждой таблицы новой БД создать 2 команды на внесение данных (внести две строки).

INSERT INTO department VALUES (dep_seq,NEXTVAL, 'OCPD', 'Odessa', 1234567);

INSERT INTO department VALUES (dep_seq.NEXTVAL, 'GCPD', 'Gotham', 7777777);

INSERT INTO boss VALUES (boss_seq.NEXTVAL, 1);

INSERT INTO boss VALUES (boss_seq.NEXTVAL, 2);

INSERT INTO position VALUES (pos_seq.NEXTVAL, 'Police detective');

INSERT INTO position VALUES (pos_seq.NEXTVAL, 'Simple human');

INSERT INTO employee VALUES (emp_seq.NEXTVAL, 'James Gordon', 1, DATE '2014-09-22', 2000, 2, NULL);

INSERT INTO employee VALUES (emp_seq.NEXTVAL, 'Aleksey Belovzorov', 2, DATE '2011-09-01', 910, 1, NULL);

INSERT INTO production VALUES (prod_seq.NEXTVAL, 'Whiskey', 100, 150);

INSERT INTO production VALUES (prod_seq.NEXTVAL, 'Rum', 99, 140); 

INSERT INTO customer_type VALUES (cus_t_seq.NEXTVAL, 'Seller');

INSERT INTO customer_type VALUES (cus_t_seq.NEXTVAL, 'Buyer');

INSERT INTO customer VALUES (cus_seq.NEXTVAL, 'Van Helsing', '777-777-777', 'Hell avenue, 7', 2);

INSERT INTO customer VALUES (cus_seq.NEXTVAL, 'Josh Bush', '123-456-789', 'White house', 1);

INSERT INTO sale VALUES (sale_seq.NEXTVAL, 1, 1, 1, 7);

INSERT INTO sale VALUES (sale_seq.NEXTVAL, 2, 2, 1, 5);

INSERT INTO purchase VALUES (pur_seq.NEXTVAL, 1, 1, 1, 4);

INSERT INTO purchase VALUES (pur_seq.NEXTVAL, 2, 1, 2, 9);

--2.3. Выполнить команду по фиксации всех изменений в БД

COMMIT;

--2.4. Для одной из таблиц, содержащей ограничение целостности внешнего ключа, выполнить
--команду по изменению значения колонки внешнего ключа на значение, отсутствующее в колонке
--первичного ключа соответствующей таблицы. Проверить реакцию СУБД на подобное изменение.

UPDATE sale SET dep_id = 4 WHERE sale_id = 1;

--Error starting at line : 41 in command -
--UPDATE sale SET dep_id = 4 WHERE sale_id = 1
--Error report -
--SQL Error: ORA-02291: integrity constraint (NEW_DB.FK_DEP_ID_2) violated - parent key not found
--02291. 00000 - "integrity constraint (%s.%s) violated - parent key not found"
--*Cause:    A foreign key value has no matching primary key value.
--*Action:   Delete the foreign key or add a matching primary key.

--2.5. Для одной из таблиц, содержащей ограничение целостности первичного ключа, выполнить
--команду по изменению значения колонки первичного ключа на значение, отсутствующее в колонке
--внешнего ключа соответствующей таблицы. Проверить реакцию СУБД на подобное изменение.

UPDATE customer SET customer_id = 3 WHERE customer_id = 1;

--Error starting at line : 43 in command -
--UPDATE customer SET customer_id = 3 WHERE customer_id = 1
--Error report -
--SQL Error: ORA-02292: integrity constraint (NEW_DB.FK_CUSTOMER_ID) violated - child record found
--02292. 00000 - "integrity constraint (%s.%s) violated - child record found"
--*Cause:    attempted to delete a parent key value that had a foreign
--           dependency.
--*Action:   delete dependencies first then parent or disable constraint.

--2.6. Для одной из таблиц, содержащей ограничение целостности первичного ключа, выполнить
--одну команду по удалению строки со значением колонки первичного ключа, присутствующее в
--колонке внешнего ключа соответствующей таблицы. Проверить реакцию СУБД на изменение.

DELETE FROM customer WHERE customer_id = 1;

--DELETE FROM customer WHERE customer_id = 1
--Error report -
--SQL Error: ORA-02292: integrity constraint (NEW_DB.FK_CUSTOMER_ID) violated - child record found
--02292. 00000 - "integrity constraint (%s.%s) violated - child record found"
--*Cause:    attempted to delete a parent key value that had a foreign
--           dependency.
--*Action:   delete dependencies first then parent or disable constraint.

--2.7.  Для  одной  из  таблиц  изменить  ограничение  целостности  внешнего  ключа,
--обеспечивающее каскадное удаление. Повторить задание 6 для измененной таблицы.

ALTER TABLE sale DROP CONSTRAINT fk_customer_id;
ALTER TABLE sale ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;
ALTER TABLE purchase DROP CONSTRAINT fk_customer_id_2;
ALTER TABLE purchase ADD CONSTRAINT fk_customer_id_2 FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;

DELETE FROM customer WHERE customer_id = 1;

--1 row deleted.

--2.8. Выполнить команду по отмене (откату) всех операций изменений из пунктов 4-7.

ROLLBACK;

--3.1. Увеличить комиссионные на n% всем сотрудникам, которые находятся на должности
--«Administration Assistant», где n – количество лет, которые проработали сотрудники.

UPDATE employees
SET commission_pct=commission_pct+TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
WHERE job_id='AD_ASST';

--3.2. Уволить всех сотрудников (удалить из таблицы), которые проработали более 20 лет на
--должности Shipping Clerk. Перед удалением сохранить информацию об увольняемых сотрудниках в
--отдельную таблицу employee_drop, которая содержит такую же структуру, как и таблица employee.

CREATE TABLE employee_drop AS 
SELECT * FROM employees 
WHERE TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)>20 AND job_id='SH_CLERK';

DELETE FROM employees
WHERE TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)>20 AND job_id='SH_CLERK';

--Этап 4. Перенос данных о подразделениях и сотрудниках из старой БД в новую БД

GRANT SELECT ON old_db.employees TO new_db;

GRANT SELECT ON old_db.departments TO new_db;

GRANT SELECT ON old_db.locations TO new_db;

GRANT SELECT ON old_db.jobs TO new_db;

INSERT INTO department (dep_id, name, location, cash)
SELECT dep_seq.NEXTVAL AS dep_id,
  old_db.departments.department_name AS name,
  old_db.locations.city AS location,
  NULL AS cash
FROM old_db.departments JOIN old_db.locations ON old_db.departments.location_id = old_db.locations.location_id;

INSERT INTO position (position_id, name)
SELECT pos_seq.NEXTVAL AS position_id,
  old_db.jobs.job_id AS name
FROM old_db.jobs;

INSERT INTO employee (emp_id, name, position_id, hire_date, salary, dep_id, boss_id)
SELECT emp_seq.NEXTVAL AS emp_id,
  old_db.employees.first_name || ' ' || old_db.employees.last_name AS name,
  position.position_id AS position_id,
  old_db.employees.hire_date AS hire_date,
  old_db.employees.salary AS salary,
  department.dep_id AS dep_id,
  NULL AS boss_id
FROM old_db.employees JOIN position ON old_db.employees.job_id=position.name
  JOIN old_db.departments ON old_db.employees.department_id=old_db.departments.department_id
  JOIN department ON old_db.departments.department_name=department.name;
  






