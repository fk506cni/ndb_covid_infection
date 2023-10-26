-- !preview conn=con
-- EXPLAIN 
With 

dpcho as (
  SELECT
    seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_dpc_ho
    WHERE prac_ym = {ym}
),

dpcko as (
  SELECT
    seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_dpc_ko
    WHERE prac_ym = {ym}
),

dpckh as (
  SELECT * FROM dpcho
  UNION ALL
  SELECT * FROM dpcko
),

dpcre as (
  SELECT
    distinct 
      seq2_no
      ,id1n
      ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_dpc_re
    WHERE prac_ym = {ym}
),

dpc as (
  SELECT
    dpcre.seq2_no
    ,dpcre.id1n
    ,coalesce(dpckh.total_score,0) as total_score
    FROM dpcre
    LEFT JOIN dpckh ON dpcre.seq2_no = dpckh.seq2_no
    --limit 1000
),

medho as (
  SELECT
    seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_med_ho
    WHERE prac_ym = {ym}
),

medko as (
  SELECT
    seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_med_ko
    WHERE prac_ym = {ym}
),

medkh as (
  SELECT * FROM medho
  UNION ALL
  SELECT * FROM medko
),

medre as (
  SELECT
    distinct 
      seq2_no
      ,id1n
      ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_med_re
    WHERE prac_ym = {ym}
),

med as (
  SELECT
    medre.seq2_no
    ,medre.id1n
    ,coalesce(medkh.total_score,0) as total_score
    FROM medre
    LEFT JOIN medkh ON medre.seq2_no = medkh.seq2_no
    --limit 1000
),

phaho as (
  SELECT
    seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_pha_ho
    WHERE prac_ym = {ym}
),

phako as (
  SELECT
    seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_pha_ko
    WHERE prac_ym = {ym}
),

phakh as (
  SELECT * FROM phaho
  UNION ALL
  SELECT * FROM phako
),

phare as (
  SELECT
    distinct 
      seq2_no
      ,id1n
      ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_pha_re
    WHERE prac_ym = {ym}
),

pha as (
  SELECT
    phare.seq2_no
    ,phare.id1n
    ,coalesce(phakh.total_score,0) as total_score
    FROM phare
    LEFT JOIN phakh ON phare.seq2_no = phakh.seq2_no
    --limit 1000
),

hk_bind as (
  SELECT
    *
    FROM dpc
  UNION ALL
  SELECT
    *
    FROM med
  UNION ALL
  SELECT
    *
    FROM pha
),

ho as (
  SELECT
  id1n
  ,sum(total_score) as sum_total_score
  , {ym} as prac_ym
  FROM hk_bind
  GROUP BY id1n
  --limit 1000
)


select * from ho;