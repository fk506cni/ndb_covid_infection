-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    seq1_no
    ,seq2_no
    ,oprtn_ymd
    ,prac_ident
    ,order_no
    ,rcpt_comp_sys_rec
    ,use_amnt
    ,qnt_dat
    ,unit_cd
    ,times
    ,rcpt_gnrlz_div
    ,rcpt_gnrlz_div_no
    ,dup_flg
    ,prac_ym
    FROM {`schm`}.{`tbl`}
    WHERE prac_ym = {ym}
    --limit 25000000
)

select * from tbltmp;