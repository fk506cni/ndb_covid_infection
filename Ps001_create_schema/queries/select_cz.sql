-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    seq1_no
    ,seq2_no
    ,prspt_rcptn_time
    ,dspng_amnt
    ,prspt_no
    ,prspt_sub_no
    ,prac_ym
    FROM {`schm`}.{`tbl`}
    WHERE prac_ym = {ym}
    --limit 10000
)

select * from tbltmp;