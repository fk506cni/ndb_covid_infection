-- !preview conn=con
-- %1$s is ym
-- %2$s is discode

With 
dpc_sy as (
SELECT pick_dis_seq2('tnds_t_rcp_dpc_sy', %1$s, %2$s) as seq2_no),

dpc_sb as (
SELECT pick_dis_seq2('tnds_t_rcp_dpc_sb', %1$s, %2$s) as seq2_no),

dis_code as (
  select 
    seq2_no FROM dpc_sy
    union 
  select 
    seq2_no FROM dpc_sb),
    
select 
  case when seq2_no in (select seq2_no from dis_code) THEN 1 
       else 0
  end
  FROM tnds_t_rcp_dpc_sb
  WHERE prac_ym = %1$s
;
  