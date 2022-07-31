/* REFERENCE CURSORS

Reference cursors are Pointers. Through ref cursors, one can send info to other platform such as a java code or oracle forms.
 Note that we cannot do the following with ref cursors - 
 1. assign null values
 2. use them in table or view create statements
 3. store them in collections
 4. use them for comparisons
 
 Types - 
 1. Strong(restrictive) - has a return type - less flexible but less error-prone as compiler know what data-type is to be returned
 2. Weak(non-restrictive) - no return type - more flexible but more error-prone. You can't pass this type of ref cursor to a sub-program. 
							You either need to declare the weak ref cursor at schema level or use the in-built SYS_REFCURSOR

*/

declare
 type t_emps is ref cursor return employees%rowtype;
 rc_emps t_emps;
 r_emps employees%rowtype;
begin
  open rc_emps for select * from employees;
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
	end loop;
  close rc_emps;
end;
--------------- in two different queries
declare
 type t_emps is ref cursor return employees%rowtype;
 rc_emps t_emps;
 r_emps employees%rowtype;
begin
  open rc_emps for select * from retired_employees;
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
	end loop;
  close rc_emps;
  
  dbms_output.put_line('--------------');
  
  open rc_emps for select * from employees where job_id = 'IT_PROG';
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
	end loop;
  close rc_emps;
end;
---------------Example of using with %type when declaring records first
declare
  r_emps employees%rowtype;
 type t_emps is ref cursor return r_emps%type;
 rc_emps t_emps;
 --type t_emps2 is ref cursor return rc_emps%rowtype;
begin
  open rc_emps for select * from retired_employees;
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
	end loop;
  close rc_emps;
  
  dbms_output.put_line('--------------');
  
  open rc_emps for select * from employees where job_id = 'IT_PROG';
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
	end loop;
  close rc_emps;
end;
---------------manually declared record type with cursors example
declare
  type ty_emps is record (e_id number, 
						 first_name employees.last_name%type, 
						 last_name employees.last_name%type,
						 department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor return ty_emps;
 rc_emps t_emps;
begin
  open rc_emps for select employee_id,first_name,last_name,department_name 
					  from employees join departments using (department_id);
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
			' is at the department of : '|| r_emps.department_name );
	end loop;
  close rc_emps;
end;
---------------first example of weak ref cursors
declare
  type ty_emps is record (e_id number, 
						 first_name employees.last_name%type, 
						 last_name employees.last_name%type,
						 department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor;
 rc_emps t_emps;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
					  from employees join departments using (department_id)';
  open rc_emps for q;
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
			' is at the department of : '|| r_emps.department_name );
	end loop;
  close rc_emps;
end;
--------------- bind variables with cursors example
declare
  type ty_emps is record (e_id number, 
						 first_name employees.last_name%type, 
						 last_name employees.last_name%type,
						 department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor;
 rc_emps t_emps;
 r_depts departments%rowtype;
 --r t_emps%rowtype;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
					  from employees join departments using (department_id)
					  where department_id = :t';
  open rc_emps for q using '50';
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
			' is at the department of : '|| r_emps.department_name );
	end loop;
  close rc_emps;
  
  open rc_emps for select * from departments;
	loop
	  fetch rc_emps into r_depts;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
	end loop;
  close rc_emps;
end;
---------------sys_refcursor example
declare
  type ty_emps is record (e_id number, 
						 first_name employees.last_name%type, 
						 last_name employees.last_name%type,
						 department_name departments.department_name%type);
 r_emps ty_emps;
-- type t_emps is ref cursor;
 rc_emps sys_refcursor;
 r_depts departments%rowtype;
 --r t_emps%rowtype;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
					  from employees join departments using (department_id)
					  where department_id = :t';
  open rc_emps for q using '50';
	loop
	  fetch rc_emps into r_emps;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
			' is at the department of : '|| r_emps.department_name );
	end loop;
  close rc_emps;
  
  open rc_emps for select * from departments;
	loop
	  fetch rc_emps into r_depts;
	  exit when rc_emps%notfound;
	  dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
	end loop;
  close rc_emps;
end;
