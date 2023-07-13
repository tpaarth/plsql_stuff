
/*https://blogs.oracle.com/sql/post/split-comma-separated-values-into-rows-in-oracle-database*/

select  distinct WAPID_PROGRAMID  
from DI_IDH.ods_f4801_workorder 
where 1=1
and WAPID_PROGRAMID in 
(with rws 
    as (select replace(RETURNEDVAL,'''') RETURNEDVAL
        from di_idh.odi_param_table 
        where CATEGORY='PAYROLL_WO_WAPID'
        )
  select regexp_substr (RETURNEDVAL,'[^,]+', 1,level) value
  from   rws
  connect by level <= length ( RETURNEDVAL ) - length ( replace ( RETURNEDVAL, ',' ) ) + 1)
;
