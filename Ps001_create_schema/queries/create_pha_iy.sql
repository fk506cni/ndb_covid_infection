-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,medicine_cd varchar(51)
    ,use_amnt decimal(10,5)
    ,prspt_no integer
    ,times integer
    ,dose decimal(10,5)
    ,prac_ym varchar(6)
) partition by list(prac_ym);