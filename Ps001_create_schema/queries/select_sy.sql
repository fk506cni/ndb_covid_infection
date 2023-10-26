-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    seq1_no
    ,seq2_no
    ,skwd_name_cd 
    ,modif_cd
    ,sspct_dss_flg
    ,main_skwd
    ,prac_ym
    FROM {`schm`}.{`tbl`}
    WHERE prac_ym = {ym}
    --limit 10000
)

select * from tbltmp;