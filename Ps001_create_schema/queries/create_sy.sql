-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,skwd_name_cd varchar(7)
    ,modif_cd varchar(80)
    ,sspct_dss_flg integer
    ,main_skwd varchar(2)
    ,prac_ym varchar(6)
) partition by list(prac_ym);