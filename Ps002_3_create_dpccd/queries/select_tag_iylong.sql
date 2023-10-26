-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    tag
    --*
    FROM tnds_t_rcp_dpc_iy_long
    --WHERE min_ym = {ym}
    WHERE prac_ym = {ym}
    --AND sum_total_score = 0
    --limit 1000000
)


select * from tbltmp;