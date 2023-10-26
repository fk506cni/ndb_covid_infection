-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,skwd_name_cd varchar(7)
    ,modif_cd varchar(80)
    ,sspct_dss_flg integer
    ,main_skwd_decis_flg integer
    ,prac_ym varchar(6)
) partition by list(prac_ym);