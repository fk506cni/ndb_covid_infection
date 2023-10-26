-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,prac_act_cd varchar(9)
    ,times integer
    ,prac_ym varchar(6)
) partition by list(prac_ym);