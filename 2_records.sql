--------------------------------------------------------------------------------------------------------------------
----------------------------------------------PL/SQL RECORDS--------------------------------------------------------
------------------------------------note: records cannot be created at schema level use objects instead-------------
--------------------------------------------------------------------------------------------------------------------
declare
  r_emp employees%rowtype;
begin
  select * into r_emp from employees where employee_id = '101';
  --r_emp.salary := 2000;
  dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name|| ' earns '||r_emp.salary||
					   ' and hired at :' || r_emp.hire_date);
end;
------------------------------
declare
  --r_emp employees%rowtype;
  type t_emp is record (first_name varchar2(50),
						last_name employees.last_name%type,
						salary employees.salary%type,
						hire_date date);
  r_emp t_emp;
begin
  select first_name,last_name,salary,hire_date into r_emp 
		from employees where employee_id = '101';
 /* r_emp.first_name := 'Alex';
  r_emp.salary := 2000;
  r_emp.hire_date := '01-JAN-20'; */
  dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name|| ' earns '||r_emp.salary||
					   ' and hired at :' || r_emp.hire_date);
end;
-------------------------------
declare
  type t_edu is record (primary_school varchar2(100),
						high_school varchar2(100),
						university varchar2(100),
						uni_graduate_date date
						);
  type t_emp is record (first_name varchar2(50),
						last_name employees.last_name%type,
						salary employees.salary%type  NOT NULL DEFAULT 1000,
						hire_date date,
						dept_id employees.department_id%type,
						department departments%rowtype,
						education t_edu
						);
  r_emp t_emp;
begin
  select first_name,last_name,salary,hire_date,department_id 
		into r_emp.first_name,r_emp.last_name,r_emp.salary,r_emp.hire_date,r_emp.dept_id 
		from employees where employee_id = '146';
  select * into r_emp.department from departments where department_id = r_emp.dept_id;
  r_emp.education.high_school := 'Beverly Hills';
  r_emp.education.university := 'Oxford';
  r_emp.education.uni_graduate_date := '01-JAN-13'; 
  
  dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name|| ' earns '||r_emp.salary||
					   ' and hired at :' || r_emp.hire_date);
  dbms_output.put_line('She graduated from '|| r_emp.education.university|| ' at '||  r_emp.education.uni_graduate_date);
  dbms_output.put_line('Her Department Name is : '|| r_emp.department.department_name);
end;


--------------------------------------------------------------------------------------------------------------------
-----------------------------------------EASY DML WITH RECORDS------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
create table retired_employees as select * from employees where 1=2;
select * from retired_employees;
/
declare
	r_emp employees%rowtype;
begin
	select * into r_emp from employees where employee_id = 104;
 r_emp.salary := 0;
	r_emp.commission_pct := 0;
	insert into retired_employees values r_emp;
end;
-----------------------------------------
declare
	r_emp employees%rowtype;
begin
	select * into r_emp from employees where employee_id = 104;
	r_emp.salary := 10;
	r_emp.commission_pct := 0;
	--insert into retired_employees values r_emp;
	update retired_employees set row = r_emp where employee_id = 104;
end;
/
delete from retired_employees;
