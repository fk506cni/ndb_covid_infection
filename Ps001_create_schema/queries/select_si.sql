-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    seq1_no
    ,seq2_no
    ,prac_act_cd
    ,times
    ,prac_ym
    FROM {`schm`}.{`tbl`}
    WHERE prac_ym = {ym}
    --limit 10000
)

select * from tbltmp;