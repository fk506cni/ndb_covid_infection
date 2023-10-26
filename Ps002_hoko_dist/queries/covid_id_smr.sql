-- !preview conn=con

-- EXPLAIN 
With 
-- dpc当該SB確定診断
--この条件は検討必要
dpc_sy as (
  --DPC SY
  SELECT
    distinct  seq2_no
    FROM osr_ndb_user.tnds_t_rcp_dpc_sy
    WHERE prac_ym = {ym}
    AND skwd_name_cd in ({discode*})
    --AND main_skwd = '01'
    AND sspct_dss_flg != 1
    --limit 1000000
),

-- dpc当該SB確定診断
--この条件は検討必要
dpc_sb as (
  SELECT
      distinct seq2_no
    FROM osr_ndb_user.tnds_t_rcp_dpc_sb
    WHERE prac_ym = {ym}
    AND skwd_name_cd in ({discode*})
    --AND main_skwd_decis_flg = 1
    AND sspct_dss_flg != 1
    --limit 1000000
),

-- 当該年月のRE
dpc_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no,
    id1n,
    --id2,
    --sex_div,
    --age_hier_cd1,
    1 as sheme_org,
    --prac_ym,
    
    --covid感染の有無_SY
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_sy
      ) THEN 1
      ELSE 0 END as had_covid_sy,
      
    --covid感染の有無_SB
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_sb
      ) THEN 1
      ELSE 0 END as had_covid_sb,
      
    --covid感染の有無
    CASE 
      WHEN had_covid_sb != 0 or  had_covid_sy != 0
        THEN 1
      ELSE 0 END as had_covid
      
    FROM osr_ndb_user.tnds_t_rcp_dpc_re
    WHERE prac_ym = {ym}
    --limit 1000000
),

-- MED当該SY確定診断
med_sy as (
  SELECT 
      distinct seq2_no
      --,1 as had_covid
    FROM osr_ndb_user.tnds_t_rcp_med_sy
    WHERE prac_ym = {ym}
    AND skwd_name_cd in ({discode*})
    --AND main_skwd = '01'
    AND sspct_dss_flg != 1
    --limit 1000000
),

-- 当該年月のRE
med_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no,
    id1n,
    --id2,
    --sex_div,
    --age_hier_cd1,
    0 as sheme_org,
    --prac_ym,
    --dpcとの整合性担保
     0 as had_covid_sy,
     0 as had_covid_sb,
    --covid感染の有無
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_sy
      ) THEN 1
      ELSE 0 END as had_covid
      
    FROM osr_ndb_user.tnds_t_rcp_med_re
    WHERE prac_ym = {ym}
    --limit 1000000
),

re_lim as (
  SELECT 
    seq2_no,
    id1n,
    sheme_org,
    had_covid
  FROM dpc_re_lim
  UNION ALL
  SELECT
    seq2_no,
    id1n,
    sheme_org,
    had_covid
  FROM med_re_lim
),


re_with_cov as (
  SELECT
    id1n,
    CASE WHEN sum(had_covid) > 0 THEN 1
    ELSE 0 END as had_covid_any
    FROM re_lim
    GROUP BY id1n
),

re_with_cov_smr as (
  SELECT
    had_covid_any,
    count(id1n) as unique_id1n_count
  FROM
    re_with_cov
  GROUP BY had_covid_any
)



--select * from re_with_cov;
--select * from med_iy_with;
--select * from iycz_pha;
--select * from pha_iycz_with;
select * from re_with_cov_smr;