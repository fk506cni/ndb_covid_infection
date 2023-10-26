
-- !preview conn=con

-- EXPLAIN 
With 

us as (
  --DPC SY
  SELECT 
    usename
    ,schemaname
    ,tablename
    ,has_schema_privilege(usename, schemaname, 'usage') as usage
    ,f_test() as testcol
    FROM pg_tables, pg_user
    
    WHERE usename = '2022ur002'
)


select * from us;