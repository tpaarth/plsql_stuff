------------------------VARIABLE SCOPE--------------------------
begin <<outer>>
DECLARE
  --v_outer VARCHAR2(50) := 'Outer Variable!';
  v_text  VARCHAR2(20) := 'Out-text';
BEGIN 
  DECLARE
	v_text  VARCHAR2(20) := 'In-text';
	v_inner VARCHAR2(30) := 'Inner Variable';
  BEGIN
	--dbms_output.put_line('inside -> ' || v_outer);
	--dbms_output.put_line('inside -> ' || v_inner);
	  dbms_output.put_line('inner -> ' || v_text);
	  dbms_output.put_line('outer -> ' || outer.v_text);
  END;
  --dbms_output.put_line('inside -> ' || v_inner);
  --dbms_output.put_line(v_outer);
  dbms_output.put_line(v_text);
END;
END outer;
----------------------------------------------------------------
--------------------------BIND VARIABLES--------------------------
set serveroutput on;
set autoprint on;
/
variable var_text varchar2(30);
/
variable var_number NUMBER;
/
variable var_date DATE;
/
declare
v_text varchar2(30);
begin
:var_text := 'Hello SQL';
:var_number := 20;
v_text := :var_text;
--dbms_output.put_line(v_text);
--dbms_output.put_line(:var_text);
end;
/
print var_text;
/
variable var_sql number;
/
begin 
  :var_sql := 100;
end;
/
select * from employees where employee_id = :var_sql;
 
-----NOTE: When you run a bind variable creation and select statement together, SQL Developer may return an error. But when you execute them separately, there will be no problem--------
------------------------------------------------------------------

------------------------------IF STATEMENTS--------------------------------
set serveroutput on;
declare
v_number number := 30;
begin
  if v_number < 10 then
	dbms_output.put_line('I am smaller than 10');
  elsif v_number < 20 then
	dbms_output.put_line('I am smaller than 20');
  elsif v_number < 30 then
	dbms_output.put_line('I am smaller than 30');
  else
	dbms_output.put_line('I am equal or greater than 30');
  end if;
end;
---------------------------------------------------------------------------
declare
v_number number := 5;
v_name varchar2(30) := 'Adam';
begin
  if v_number < 10 or v_name = 'Carol' then
	dbms_output.put_line('HI');
	dbms_output.put_line('I am smaller than 10');
  elsif v_number < 20 then
	dbms_output.put_line('I am smaller than 20');
  elsif v_number < 30 then
	dbms_output.put_line('I am smaller than 30');
  else
	if v_number is null then 
	  dbms_output.put_line('The number is null..');
	else
	  dbms_output.put_line('I am equal or greater than 30');
	end if;
  end if;
end;
---------------------------------------------------------------------------

----------------------------CASE EXPRESSIONS--------------------------------
declare
  v_job_code varchar2(10) := 'SA_MAN';
  v_salary_increase number;
begin
  v_salary_increase := case v_job_code 
	when 'SA_MAN' then 0.2
	when 'SA_REP' then 0.3
	else 0
  end; ---note the no 'END CASE' keyword 
  dbms_output.put_line('Your salary increase is : '|| v_salary_increase);
end;
-------------------------SEARCHED CASE EXPRESSION----------------------------
declare
  v_job_code varchar2(10) := 'IT_PROG';
  v_department varchar2(10) := 'IT';
  v_salary_increase number;
begin
  v_salary_increase := case  
	when v_job_code = 'SA_MAN' then 0.2
	when v_department = 'IT' and v_job_code = 'IT_PROG' then 0.3 ---note you can add extra filter condition in this case
	else 0
  end; ---note the no 'END CASE' keyword 
  dbms_output.put_line('Your salary increase is : '|| v_salary_increase);
end;
---------------------------CASE STATEMENTS------------------------------------
declare
  v_job_code varchar2(10) := 'IT_PROG';
  v_department varchar2(10) := 'IT';
  v_salary_increase number;
begin
  case  
	when v_job_code = 'SA_MAN' then 
	  v_salary_increase := 0.2;
	  dbms_output.put_line('The salary increase for a Sales Manager is : '|| v_salary_increase);
	when v_department = 'IT' and v_job_code = 'IT_PROG' then 
	  v_salary_increase := 0.2;
	  dbms_output.put_line('The salary increase for a Sales Manager is : '|| v_salary_increase);
	else 
	  v_salary_increase := 0;
	  dbms_output.put_line('The salary increase for this job code is : '|| v_salary_increase);
  end CASE;
end;
-------------------------------------------------------------------------------

-------------------------BASIC LOOPS--------------------------iterates at least once
declare
v_counter number(2) := 1;
begin
  loop
    dbms_output.put_line('My counter is : '|| v_counter);
    v_counter := v_counter + 1;
    --if v_counter = 10 then
    --  dbms_output.put_line('Now I reached : '|| v_counter);
    --  exit;
    --end if;
    exit when v_counter > 10;
  end loop;
end;

------------------------------WHILE LOOPS--------------------------unlike basic loop, it's not necessary to run atleast once.
declare
v_counter number(2) := 1;
begin
  while v_counter <= 10 loop
	dbms_output.put_line('My counter is : '|| v_counter);
	v_counter := v_counter + 1;
   -- exit when v_counter > 3;
  end loop;
end;
-------------------------------------------------------------------------
-----------------------------FOR LOOPS-----------------------------
begin
  for i in REVERSE 1..3 loop
	dbms_output.put_line('My counter is : '|| i);
  end loop;
end;
-------------------------------------------------------------------
-------------------------------NESTED LOOPS-----------------------------------
declare
 v_inner number := 1;
begin
 for v_outer in 1..5 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
	v_inner := 1;
	loop
	  v_inner := v_inner+1;
	  dbms_output.put_line('  My inner value is : ' || v_inner );
	  exit when v_inner*v_outer >= 15;
	end loop;
 end loop;
end;
-------------------------NESTED LOOPS WITH LABELS or NAMED LOOPS------------------------------
declare
 v_inner number := 1;
begin
<<outer_loop>>
 for v_outer in 1..5 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
	v_inner := 1;
	<<inner_loop>>
	loop
	  v_inner := v_inner+1;
	  dbms_output.put_line('  My inner value is : ' || v_inner );
	  exit outer_loop when v_inner*v_outer >= 16;
	  exit when v_inner*v_outer >= 15;
	end loop inner_loop;
 end loop outer_loop;
end;
--------------------------------------------------------------------------------
----------------------------CONTINUE STATEMENT----------------------------------
declare
 v_inner number := 1;
begin
 for v_outer in 1..10 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
	v_inner := 1;
	while v_inner*v_outer < 15 loop
	  v_inner := v_inner+1;
	  continue when mod(v_inner*v_outer,3) = 0;
	  dbms_output.put_line('  My inner value is : ' || v_inner );
	end loop;
 end loop;
end;
---------------------------------------------------------------------------------
declare
 v_inner number := 1;
begin
<<outer_loop>>
 for v_outer in 1..10 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
	v_inner := 1;
	<<inner_loop>>
	loop
	  v_inner := v_inner+1;
	  continue outer_loop when v_inner = 10;
	  dbms_output.put_line('  My inner value is : ' || v_inner );
	end loop inner_loop;
 end loop outer_loop;
end;
----------------------------------------------------------------------------------
------------------------------GOTO STATEMENT----------------------------------
DECLARE
  v_searched_number NUMBER := 22;
  v_is_prime boolean := true;
BEGIN
  FOR x in 2..v_searched_number-1 LOOP
	IF v_searched_number MOD x = 0 THEN
	  dbms_output.put_line(v_searched_number|| ' is not a prime number..');
	  v_is_prime := false;
	  GOTO end_point;
	END IF;
  END LOOP;
  if v_is_prime then
	dbms_output.put_line(v_searched_number|| ' is a prime number..');
  end if;
<<end_point>>
  dbms_output.put_line('Check complete..');
END;
-------------------------------------------------------------------------------
DECLARE
  v_searched_number NUMBER := 32457;
  v_is_prime boolean := true;
  x number := 2;
BEGIN
  <<start_point>>
	IF v_searched_number MOD x = 0 THEN
	  dbms_output.put_line(v_searched_number|| ' is not a prime number..');
	  v_is_prime := false;
	  GOTO end_point;
	END IF;
  x := x+1;
  if x = v_searched_number then
   goto prime_point;
  end if;
  goto start_point;
  <<prime_point>>
  if v_is_prime then
	dbms_output.put_line(v_searched_number|| ' is a prime number..');
  end if;
<<end_point>>
  dbms_output.put_line('Check complete..');
END;
---------------------------------------------------------------------------------

------------------------------OPERATING WITH SELECTED QUERIES--------------------------------
declare
 v_name varchar2(50);
 v_salary employees.salary%type;
begin
  select first_name ||' '|| last_name, salary into v_name, v_salary  from employees where employee_id = 130;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary);
end;
------------------------------
declare
 v_name varchar2(50);
 sysdates employees.hire_date%type;
begin
  select first_name ||' '|| last_name, sysdates into v_name, sysdates from employees where employee_id = 130;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| sysdates);
end;
------------------------------
declare
 v_name varchar2(50);
 v_sysdate employees.hire_date%type;
 employee_id employees.employee_id%type := 130;
begin
  select first_name ||' '|| last_name, sysdate into v_name, v_sysdate from employees where employee_id = employee_id;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_sysdate );
end;
------------------------------
declare
 v_name varchar2(50);
 v_salary employees.salary%type;
 v_employee_id employees.employee_id%type := 130;
begin
  select first_name ||' '|| last_name, salary into v_name, v_salary from employees where employee_id = v_employee_id;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary );
end;

------------------------------ DML OPERATIONS WITH PL/SQL----------------------------------------
create table employees_copy as select * from employees;
DECLARE
  v_employee_id pls_integer := 0;
  v_salary_increase number := 400;
begin
  for i in 217..226 loop
		--insert into employees_copy 
	  --(employee_id,first_name,last_name,email,hire_date,job_id,salary)
	--values 
	  --(i, 'employee#'||i,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
   --update employees_copy 
	 --set salary = salary + v_salary_increase
	 --where employee_id = i;
	 delete from employees_copy
	 where employee_id = i;
  end loop;
end; 
    ------------------------------OPERATING WITH SELECTED QUERIES--------------------------------
    declare
     v_name varchar2(50);
     v_salary employees.salary%type;
    begin
      select first_name ||' '|| last_name, salary into v_name, v_salary  from employees where employee_id = 130;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary);
    end;
    ------------------------------
    declare
     v_name varchar2(50);
     sysdates employees.hire_date%type;
    begin
      select first_name ||' '|| last_name, sysdates into v_name, sysdates from employees where employee_id = 130;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| sysdates);
    end;
    ------------------------------
    declare
     v_name varchar2(50);
     v_sysdate employees.hire_date%type;
     employee_id employees.employee_id%type := 130;
    begin
      select first_name ||' '|| last_name, sysdate into v_name, v_sysdate from employees where employee_id = employee_id;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_sysdate );
    end;
    ------------------------------
    declare
     v_name varchar2(50);
     v_salary employees.salary%type;
     v_employee_id employees.employee_id%type := 130;
    begin
      select first_name ||' '|| last_name, salary into v_name, v_salary from employees where employee_id = v_employee_id;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary );
    end;
    ------------------------------ DML OPERATIONS WITH PL/SQL----------------------------------------
    create table employees_copy as select * from employees;
    DECLARE
      v_employee_id pls_integer := 0;
      v_salary_increase number := 400;
    begin
      for i in 217..226 loop
            --insert into employees_copy 
          --(employee_id,first_name,last_name,email,hire_date,job_id,salary)
        --values 
          --(i, 'employee#'||i,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
       --update employees_copy 
         --set salary = salary + v_salary_increase
         --where employee_id = i;
         delete from employees_copy
         where employee_id = i;
      end loop;
    end; 
----------------------------- USING SEQUENCES IN PL/SQL ----------------------------------------
create sequence employee_id_seq 
start with 207
increment by 1;
-----------------------------
begin
  for i in 1..10 loop
	insert into employees_copy 
	  (employee_id,first_name,last_name,email,hire_date,job_id,salary)
	values 
	  (employee_id_seq.nextval, 'employee#'||employee_id_seq.nextval,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
  end loop;
end; 
----------------------------
declare
  v_seq_num number;
begin
  select employee_id_seq.nextval into v_seq_num from dual;
  dbms_output.put_line(v_seq_num);
end;
----------------------------
declare
  v_seq_num number;
begin
  select employee_id_seq.nextval into v_seq_num from employees_copy where rownum = 1;
  dbms_output.put_line(v_seq_num);
end;
----------------------------
declare
  v_seq_num number;
begin
  v_seq_num := employee_id_seq.nextval; 
  dbms_output.put_line(v_seq_num);
end;
----------------------------
begin
  dbms_output.put_line(employee_id_seq.nextval);
end;
----------------------------
begin
  dbms_output.put_line(employee_id_seq.currval);
end;

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

