-- !preview conn=con

-- EXPLAIN 
With 

re_with_cov_smr as (
  SELECT
    min_ym
    ,sex_mean
    ,age_hier_cd1_int_min
    ,had_covid_bool
    ,count(id1n) as id1n_count
  FROM
    tnds_t_rcp_whole_id1n
  GROUP BY min_ym, sex_mean, age_hier_cd1_int_min, had_covid_bool
)

--select * from re_with_cov;
--select * from med_iy_with;
--select * from iycz_pha;
--select * from pha_iycz_with;
--select * from re_lim;
--select * from re_with_cov ;
select * from re_with_cov_smr;