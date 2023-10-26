-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    seq1_no varchar(10)
    ,seq2_no varchar(51)
    ,medicine_cd varchar(9)
    ,use_amnt decimal(10,5)
    ,times integer
    --,dose decimal(10,5)
    ,oprtn_ymd varchar(8)
    ,aft_splmt_prac_ident integer
    ,aft_splmt_score integer
    --,ymd_val integer
    ,prac_ym varchar(6)
    ,groupind integer
    ,tag varchar(125)
) partition by list(prac_ym);