-- !preview conn=con
-- 当該年月のSY
-- EXPLAIN 
With 

dpc_si_lim as (
  SELECT 
    -- seq1_no,
    seq2_no
    ,prac_act_cd
    ,times
    FROM tnds_t_rcp_dpc_si
    WHERE prac_ym = {ym}
    AND prac_act_cd in ({testcodes*})
    --limit 1000000
),

med_si_lim as (
  SELECT 
    -- seq1_no,
    seq2_no
    ,prac_act_cd
    ,times
    FROM tnds_t_rcp_med_si
    WHERE prac_ym = {ym}
    AND prac_act_cd in ({testcodes*})
    --limit 1000000
),

si_lim as (
  SELECT * 
  FROM dpc_si_lim
  UNION ALL
  SELECT *
  FROM med_si_lim
),

si_smr as (
  SELECT
    prac_act_cd
    ,count(seq2_no) as seq2no_count
    ,sum(times) as total_assay_times
    FROM si_lim
    GROUP BY prac_act_cd
)



--SELECT * from dpc_sy_sub_dist;    

--SELECT * from dpc_syb;
--SELECT * from dpc_re_lim;
--SELECT * from re_smr;
--SELECT * from re_lim;
--SELECT * from med_re_lim;
--SELECT * from re_smr;
SELECT * from si_smr;
