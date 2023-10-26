-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,prac_act_cd varchar(9)
    ,rcpt_gnrlz_div varchar(1)
    ,rcpt_gnrlz_div_no integer
    ,prac_ym varchar(6)
) partition by list(prac_ym);