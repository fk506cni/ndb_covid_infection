-- !preview conn=con

-- EXPLAIN 
With 
-- dpc当該SY確定診断
dpc_sy as (
SELECT pick_dis_seq2('tnds_t_rcp_dpc_sy', {ym}, {discode}) as seq2_no),

-- dpc当該SB確定診断
dpc_sb as (
SELECT pick_dis_seq2('tnds_t_rcp_dpc_sb', {ym}, {discode}) as seq2_no),


-- 当該年月のRE
dpc_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no
    ,id1n
    --id2,
    ,cast(sex_div as integer) as sex_div_int
    --age_hier_cd1,
    ,cast(age_hier_cd1 as integer) as age_hier_cd1_int
    ,1 as sheme_org
    --prac_ym,
    
    --dis感染の有無_SY
    ,CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_sy
      ) THEN 1
      ELSE 0 END as had_dis_sy
      
    --dis感染の有無_SB
    ,CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_sb
      ) THEN 1
      ELSE 0 END as had_dis_sb
    

    FROM tnds_t_rcp_dpc_re a
    WHERE prac_ym = {ym}
    --limit 1000000
),


-- MED当該SY確定診断
med_sy as (
SELECT pick_dis_seq2('tnds_t_rcp_med_sy', {ym}, {discode}) as seq2_no),

-- 当該年月のRE
med_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no
    ,id1n
    --id2,
    ,cast(sex_div as integer) as sex_div_int
    --age_hier_cd1,
    ,cast(age_hier_cd1 as integer) as age_hier_cd1_int
    ,0 as sheme_org
    --prac_ym,
    
    --dis感染の有無
    ,CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_sy
      ) THEN 1
      ELSE 0 END as had_dis_sy
      
    --dpcとの整合性担保
    ,0 as had_dis_sb
      
    FROM tnds_t_rcp_med_re
    WHERE prac_ym = {ym}
    --limit 1000000
),

-- 当該年月のRE
pha_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no
    ,id1n
    --id2,
    ,cast(sex_div as integer) as sex_div_int
    --age_hier_cd1,
    ,cast(age_hier_cd1 as integer) as age_hier_cd1_int
    ,2 as sheme_org
    --prac_ym,
    
    --dpcとの整合性担保
    ,0 as had_dis_sy
      
    --dpcとの整合性担保
    ,0 as had_dis_sb
      
    FROM tnds_t_rcp_pha_re
    WHERE prac_ym = {ym}
    --limit 1000000
),

re_lim as (
  SELECT 
    seq2_no
    ,id1n
    ,sex_div_int
    ,age_hier_cd1_int
    ,sheme_org
    ,had_dis_sy
    ,had_dis_sb
  FROM dpc_re_lim
  
  UNION ALL
  SELECT
    seq2_no
    ,id1n
    ,sex_div_int
    ,age_hier_cd1_int
    ,sheme_org
    ,had_dis_sy
    ,had_dis_sb
  FROM med_re_lim
  
  UNION ALL
  SELECT
    seq2_no
    ,id1n
    ,sex_div_int
    ,age_hier_cd1_int
    ,sheme_org
    ,had_dis_sy
    ,had_dis_sb
  FROM pha_re_lim
  --LIMIT 10000
),

re_with_cov as (
  SELECT
    id1n
    ,avg(sex_div_int) as sex_mean
    --,min(sex_div_int) as sex_div_int_min
    ,min(age_hier_cd1_int) as age_hier_cd1_int_min
    ,CASE WHEN sum(had_dis_sy) + sum(had_dis_sb) > 0 THEN 1
      ELSE 0 END as had_dis_bool
    FROM re_lim
    GROUP BY 
    id1n
    --LIMIT 1000000
),

re_with_cov_smr as (
  SELECT
    had_dis_bool
    ,age_hier_cd1_int_min
    ,sex_mean
    ,count(id1n) as unique_id1n_count
    ,{ym} as prac_ym
  FROM
    re_with_cov
  GROUP BY had_dis_bool
    ,age_hier_cd1_int_min
    ,sex_mean
)

--,

--select * from re_with_cov;
--select * from med_iy_with;
--select * from iycz_pha;
--select * from pha_iycz_with;
--select * from dpc_sb;
--select * from re_lim;
--select * from re_with_cov ;
select * from re_with_cov_smr;