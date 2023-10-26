-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,prspt_rcptn_time integer
    ,dspng_amnt integer
    ,prspt_no integer
    ,prspt_sub_no integer
    ,prac_ym varchar(6)
) partition by list(prac_ym);