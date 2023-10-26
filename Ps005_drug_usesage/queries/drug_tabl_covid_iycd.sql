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
      ELSE 0 END as had_covid_sb
      
    FROM tnds_t_rcp_dpc_re
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
    0 as had_covid_sb

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

re_with_cov as (
  SELECT
      id1n,
      sum(had_covid_sy) + sum(had_covid_sb) as sum_had_covid
    FROM re_lim
    GROUP BY id1n
    HAVING sum(had_covid_sy) + sum(had_covid_sb) > 0
    --limit 1000000
),

--dpc section
re_dpc_rec as (
  SELECT
  seq2_no,
  id1n,
  CASE 
    WHEN id1n in (SELECT id1n FROM re_with_cov) THEN 1
    ELSE 0 END as had_covid_rec
  FROM tnds_t_rcp_dpc_re
  WHERE prac_ym = {ym}
    AND id1n in (SELECT id1n FROM re_with_cov)
    --limit 1000000
),

dpc_iy_with as (
  SELECT 
    iy.seq2_no,
    iy.medicine_cd,
    iy.use_amnt,
    CASE 
      WHEN iy.medicine_cd in ({drug_inj*}) THEN ceil(iy.use_amnt) * iy.times
      WHEN iy.medicine_cd in ({drug_prs*}) THEN ceil(iy.use_amnt * iy.times)
    ELSE 0 END as total_amnt,
    iy.times,
    iy.prac_ym,
    CASE WHEN iy.seq2_no in (
      SELECT rec.seq2_no
      FROM re_dpc_rec as rec
    ) THEN 1
    ELSE 0 END as had_covid,
    1 as schema_from
    
    FROM tnds_t_rcp_dpc_iy as iy
    WHERE prac_ym = {ym}
),

--重複のないcd
dpc_cd_with as (
  SELECT 
    cd.seq2_no,
    cd.rcpt_comp_sys_rec,
    cd.use_amnt,
    CASE 
      WHEN cd.rcpt_comp_sys_rec in ({drug_inj*}) THEN ceil(cd.use_amnt) * cd.times
      WHEN cd.rcpt_comp_sys_rec in ({drug_prs*}) THEN ceil(cd.use_amnt * cd.times)
    ELSE 0 END as total_amnt,
    cd.times,
    cd.prac_ym,
    CASE WHEN cd.seq2_no in (
      SELECT rec.seq2_no
      FROM re_dpc_rec as rec
    ) THEN 1
    ELSE 0 END as had_covid,
    1 as schema_from
    
    FROM tnds_t_rcp_dpc_cd as cd
    WHERE prac_ym = {ym}
    AND dup_flg_2 != 1
    AND rcpt_comp_sys_rec in ({drugcode*})
),



--med section
re_med_rec as (
  SELECT
  seq2_no,
  id1n,
  CASE 
    WHEN id1n in (SELECT id1n FROM re_with_cov) THEN 1
    ELSE 0 END as had_covid_rec
  FROM tnds_t_rcp_med_re
  WHERE prac_ym = {ym}
    AND id1n in (SELECT id1n FROM re_with_cov)
    --limit 1000000
),

med_iy_with as (
  SELECT 
    iy.seq2_no,
    iy.medicine_cd,
    iy.use_amnt,
    CASE 
      WHEN iy.medicine_cd in ({drug_inj*}) THEN ceil(iy.use_amnt) * iy.times
      WHEN iy.medicine_cd in ({drug_prs*}) THEN ceil(iy.use_amnt * iy.times)
    ELSE 0 END as total_amnt,
    iy.times,
    iy.prac_ym,
    CASE WHEN iy.seq2_no in (
      SELECT rec.seq2_no FROM re_med_rec as rec
    ) THEN 1
      ELSE 0 END as had_covid,
    2 as schema_from
    
    FROM tnds_t_rcp_med_iy as iy
    WHERE prac_ym = {ym}
),

re_pha_rec as (
  SELECT
  seq2_no,
  id1n,
  CASE 
    WHEN id1n in (SELECT id1n FROM re_with_cov) THEN 1
    ELSE 0 END as had_covid_rec
  FROM tnds_t_rcp_pha_re
  WHERE prac_ym = {ym}
    AND id1n in (SELECT id1n FROM re_with_cov)
    --limit 1000000
),
--pha section
pha_iy as (
  SELECT 
    seq2_no,
    medicine_cd,
    use_amnt,
    dose, 
    prspt_no,
    --prspt_sub_no,
    prac_ym
    
    FROM tnds_t_rcp_pha_iy
    WHERE prac_ym = {ym}
    --limit 1000000
),

pha_cz as (
  SELECT 
    seq2_no,
    dspng_amnt,
    prspt_no
    FROM tnds_t_rcp_pha_cz
    WHERE prac_ym = {ym}
),

pha_iycz_with as (
SELECT
    iy.seq2_no,
    iy.medicine_cd,
    iy.use_amnt,
    CASE 
        WHEN iy.medicine_cd in ({drug_inj*}) THEN ceil(iy.use_amnt) * cz.dspng_amnt
        WHEN iy.medicine_cd in ({drug_prs*}) THEN ceil(iy.use_amnt * cz.dspng_amnt)
      ELSE 0 END as total_amnt,
    cz.dspng_amnt as times,
    iy.prac_ym,
    CASE WHEN iy.seq2_no in (
      SELECT rec.seq2_no FROM re_pha_rec as rec
    ) THEN 1
      ELSE 0 END as had_covid,
    3 as sheme_from
  FROM pha_iy as iy
  LEFT JOIN pha_cz as cz 
    ON iy.seq2_no = cz.seq2_no
    --同じprspt_noが複数あればrowが増える
    AND iy.prspt_no = cz.prspt_no),
    
iy_tri as (
  SELECT *
  FROM dpc_iy_with
  UNION ALL
  SELECT *
  FROM dpc_cd_with
  UNION ALL
  SELECT *
  FROM med_iy_with
  UNION ALL
  SELECT *
  FROM pha_iycz_with
),

iy_tri_smr as (
  SELECT
    medicine_cd,
    had_covid,
    sum(total_amnt) as sum_total_amnt
  FROM
    iy_tri
  GROUP BY  
    medicine_cd,
    had_covid
)



--select * from dpc_cd_with;
--select * from re_with_cov;
--select * from dpc_iy_with;
--select * from pha_iycz_with;
--select * from iycz_pha;
--select * from pha_iycz_with;
select * from iy_tri_smr;
