-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,oprtn_ymd varchar(8)
    ,prac_ident varchar(2)
    ,order_no integer
    ,rcpt_comp_sys_rec varchar(9)
    ,use_amnt decimal(10,5)
    ,qnt_dat integer
    ,unit_cd varchar(3)
    ,times integer
    ,rcpt_gnrlz_div varchar(1)
    ,rcpt_gnrlz_div_no integer
    ,dup_flg integer
    ,prac_ym varchar(6)
    ,groupind integer
    ,tag varchar(125)
    ,dup_flg_2 integer
) partition by list(prac_ym);