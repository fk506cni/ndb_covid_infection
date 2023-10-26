-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,id1n varchar(64)
    ,id2 varchar(64)
    ,sex_div varchar(1)
    ,age_hier_cd1 varchar(3)
    ,prac_ym varchar(6)
) partition by list(prac_ym);