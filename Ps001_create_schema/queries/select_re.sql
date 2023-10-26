-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,id2
    ,sex_div
    ,age_hier_cd1
    ,prac_ym
    FROM {`schm`}.{`tbl`}
    WHERE prac_ym = {ym}
    --limit 10000
)

select * from tbltmp;