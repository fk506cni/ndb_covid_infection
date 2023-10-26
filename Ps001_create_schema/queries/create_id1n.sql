-- !preview conn=con
-- EXPLAIN 
-- id1n sex_mean age_hier_cd1_int_min had_covid_bool min_ym
Create Table {`tbl`}(
    --seq1_no varchar(10)
    --,
    id1n varchar(64)
    ,sex_mean decimal(4,2)
    ,age_hier_cd1_int_min integer
    ,had_covid_bool integer
    --,prac_ym varchar(6)
    ,min_ym integer
) 
partition by list(min_ym)
--partition by list(prac_ym)
;