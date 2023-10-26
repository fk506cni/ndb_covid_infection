-- !preview conn=con
-- 当該年月のSY
-- EXPLAIN 
With 
-- dpc当該SY確定診断
--この条件は検討必要
dpc_sy as (
SELECT pick_dis_seq2('tnds_t_rcp_dpc_sy', {ym}, {discode}) as seq2_no),

-- dpc当該SB確定診断
--この条件は検討必要
dpc_sb as (
SELECT pick_dis_seq2('tnds_t_rcp_dpc_sb', {ym}, {discode}) as seq2_no),

--処置
-- general admin
dpc_si_adm_gen as (
SELECT pick_si_seq2('tnds_t_rcp_dpc_si', {ym}, {adm_gen}) as seq2_no),

-- men admin
dpc_si_adm_men as (
SELECT pick_si_seq2('tnds_t_rcp_dpc_si', {ym}, {adm_men}) as seq2_no),

-- unit admin adm
dpc_si_adm_unit_ad as (
SELECT pick_si_seq2('tnds_t_rcp_dpc_si', {ym}, {adm_unt_ad}) as seq2_no),

-- unit admin manege
dpc_si_adm_unit_man as (
SELECT pick_si_seq2('tnds_t_rcp_dpc_si', {ym}, {adm_unt_man}) as seq2_no),

-- 当該年月のRE
dpc_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no,
    id1n,
    --id2,
    sex_div,
    age_hier_cd1,
    cast(age_hier_cd1 as integer) as age_hier_cd1_int,
    1 as schema_org,
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
      
    --adm_gen
    CASE WHEN seq2_no in (
        SELECT seq2_no  FROM dpc_si_adm_gen
      ) THEN 1
      ELSE 0 END as had_adm_gen,
    
    --adm_men
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_si_adm_men
      ) THEN 1
      ELSE 0 END as had_adm_men,
    
    --adm_unit
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_si_adm_unit_ad
      ) THEN 1
      ELSE 0 END as had_adm_unit_ad,
      
    --adm_unit
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM dpc_si_adm_unit_man
      ) THEN 1
      ELSE 0 END as had_adm_unit_man
      
    FROM tnds_t_rcp_dpc_re
    WHERE prac_ym = {ym}
    --limit 1000000
),


-- MED当該SY確定診断
med_sy as (
SELECT pick_dis_seq2('tnds_t_rcp_med_sy', {ym}, {discode}) as seq2_no),

--処置
-- general admin
med_si_adm_gen as (
SELECT pick_si_seq2('tnds_t_rcp_med_si', {ym}, {adm_gen}) as seq2_no),

-- mental admin
med_si_adm_men as (
SELECT pick_si_seq2('tnds_t_rcp_med_si', {ym}, {adm_men}) as seq2_no),

-- unit admin
med_si_adm_unit_ad as (
SELECT pick_si_seq2('tnds_t_rcp_med_si', {ym}, {adm_unt_ad}) as seq2_no),

-- unit admin
med_si_adm_unit_man as (
SELECT pick_si_seq2('tnds_t_rcp_med_si', {ym}, {adm_unt_man}) as seq2_no),

-- 当該年月のRE
med_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no,
    id1n,
    --id2,
    sex_div,
    age_hier_cd1,
    cast(age_hier_cd1 as integer) as age_hier_cd1_int,
    0 as schema_org,
    --prac_ym,
    --covid感染の有無
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_sy
      ) THEN 1
      ELSE 0 END as had_covid_sy,
      
    --dpcとの整合性担保
    0 as had_covid_sb,
      
    --adm_gen
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_si_adm_gen
      ) THEN 1
      ELSE 0 END as had_adm_gen,
    
    --adm_men
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_si_adm_men
      ) THEN 1
      ELSE 0 END as had_adm_men,
    
    --adm_unit_ad
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_si_adm_unit_ad
      ) THEN 1
      ELSE 0 END as had_adm_unit_ad,
      
    --adm_unit_man
    CASE WHEN seq2_no in (
        SELECT seq2_no FROM med_si_adm_unit_man
      ) THEN 1
      ELSE 0 END as had_adm_unit_man

    FROM tnds_t_rcp_med_re
    WHERE prac_ym = {ym}
),

re_lim as (
  SELECT * 
  FROM dpc_re_lim
  UNION ALL
  SELECT *
  FROM med_re_lim
),

re_smr as (
  SELECT
      id1n,
      sex_div,
      age_hier_cd1_int,
      CASE 
        WHEN age_hier_cd1_int <= 102 THEN 'young'
        WHEN age_hier_cd1_int <= 112 THEN 'mid'
        WHEN age_hier_cd1_int <= 116 THEN 'elder'
        ELSE 'notmatch' END as age_grade,

      --sum(had_covid) as sum_had_covid,
      CASE 
        WHEN sum(had_covid_sy) + sum(had_covid_sb) > 0 THEN 1
        ELSE 0 END as had_covid_whole,
      
      --sum(had_adm_gen) as sum_had_adm_gen,
      CASE 
        WHEN sum(had_adm_gen) > 0 THEN 1
        ELSE 0 END as had_adm_gen_whole,
      
      --sum(had_adm_men) as sum_had_adm_men,
      CASE 
        WHEN sum(had_adm_men) > 0 THEN 1
        ELSE 0 END as had_adm_men_whole,
      
      --sum(had_adm_unit_ad) as sum_had_adm_unit_ad,
      CASE 
        WHEN sum(had_adm_unit_ad) > 0 THEN 1
        ELSE 0 END as had_adm_unit_ad_whole,
      
      --sum(had_adm_unit_man) as sum_had_adm_unit_man,
      CASE 
        WHEN sum(had_adm_unit_man) > 0 THEN 1
        ELSE 0 END as had_adm_unit_man_whole,
        
      CASE 
        WHEN sum(had_adm_unit_ad) + sum(had_adm_unit_man) > 0 THEN 1
        ELSE 0 END as had_adm_unit_whole
        
      --,count(seq2_no) as n_seq2_no
      
    FROM re_lim
    GROUP BY id1n, sex_div, age_hier_cd1_int
    --limit 1000000
)


, re_smr_tbl as (
  SELECT
      age_grade, 
      had_covid_whole, 
      had_adm_gen_whole,
      had_adm_men_whole,
      had_adm_unit_ad_whole,
      had_adm_unit_man_whole,
      had_adm_unit_whole,
    count(id1n) as n_id1n
    FROM re_smr
    GROUP BY 
      age_grade, 
      had_covid_whole, 
      had_adm_gen_whole,
      had_adm_men_whole,
      had_adm_unit_ad_whole,
      had_adm_unit_man_whole,
      had_adm_unit_whole
)


--SELECT * from dpc_sy_sub_dist;    

--SELECT * from dpc_syb;
--SELECT * from dpc_re_lim;
--SELECT * from re_smr;
--SELECT * from re_lim;
--SELECT * from med_re_lim;
--SELECT * from re_smr;
SELECT * from re_smr_tbl;
