-- !preview conn=con
-- EXPLAIN 
With 

df as (
  SELECT
    id1n
    ,age_hier_cd1_int_min
    ,sex_mean
    ,had_covid_bool
    ,cast(prac_ym as integer) prac_ym
    FROM tnds_t_rcp_whole_id1n
),

df_ex as (
  SELECT
    id1n
    ,min(age_hier_cd1_int_min) as age_hier_cd1_int_min
    ,min(prac_ym) as prac_ym
    ,CASE WHEN avg(sex_mean) < 1.5 THEN 1
      ELSE 2 END as sex_mean
    ,sum(had_covid_bool) as had_covid_bool
    FROM df
    GROUP BY
    id1n
),

df_smr as (
  SELECT
    had_covid_bool as count_of_covid
    ,prac_ym as first_presense
    ,sex_mean as gender
    ,age_hier_cd1_int_min as age_at_first
    ,count(*) as n
  FROM df_ex
  GROUP BY
    had_covid_bool
    ,prac_ym
    ,sex_mean
    ,age_hier_cd1_int_min
)

select * from df_smr;