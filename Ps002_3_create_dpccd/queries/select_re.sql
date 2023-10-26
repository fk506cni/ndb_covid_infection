-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    seq1_no
    ,seq2_no
    ,rcpt_gnrlz_div
    ,rcpt_gnrlz_div_no
    ,dup_flg
    ,prac_ym
    FROM {`schm`}.{`tbl`}
    WHERE prac_ym = {ym}
    limit 2500000
)

select * from tbltmp;