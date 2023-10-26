-- !preview conn=con
-- EXPLAIN 
With 

tbltmp as (
  --DPC SY
  SELECT
    *
    --FROM {`schm`}.{`tbl`}
    FROM osr_ndb_user.tnds_t_rcp_dpc_iy
    WHERE prac_ym = {ym}
    --limit 12500000
)

select * from tbltmp;