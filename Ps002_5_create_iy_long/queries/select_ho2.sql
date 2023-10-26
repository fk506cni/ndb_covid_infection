-- !preview conn=con
-- EXPLAIN 
With 

dpcre as (
  SELECT
    distinct
      seq1_no
      ,seq2_no
      ,id1n
      ,rcp_cls
      ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_dpc_re
    WHERE prac_ym = {ym}
),

dpcre_4H as (
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,rcp_cls
    ,prac_ym
  FROM dpcre
  WHERE rcp_cls not in ('1211', '1221', '1231', '1241')
),

dpcre_4K as (
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,rcp_cls
    ,prac_ym
  FROM dpcre
  WHERE rcp_cls in ('1211', '1221', '1231', '1241')
),

dpcHO as (
  SELECT
    seq1_no
    ,seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_dpc_ho
    WHERE prac_ym = {ym}
),

dpcKO as (
  SELECT
    seq1_no
    ,seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_dpc_ko
    WHERE prac_ym = {ym}
),

--HO, KOにreをLEFT JOINしている。
dpcHOR as (
  SELECT
    dpcHO.seq1_no
    ,dpcHO.seq2_no
    ,dpcHO.total_score
    ,dpcHO.prac_ym
    ,dpcre_4H.id1n
  FROM dpcHO
  LEFT JOIN dpcre_4H
    ON dpcHO.seq2_no = dpcre_4H.seq2_no
),

dpcKOR as (
  SELECT
    dpcKO.seq1_no
    ,dpcKO.seq2_no
    ,dpcKO.total_score
    ,dpcKO.prac_ym
    ,dpcre_4K.id1n
  FROM dpcKO
  LEFT JOIN dpcre_4K
    ON dpcre_4K.seq2_no = dpcKO.seq2_no
),

dpcKOR_f as (
  SELECT *
  FROM dpcKOR
  WHERE id1n = id1n
),

dpckh as (
  SELECT * FROM dpcHOR
  UNION ALL
  SELECT * FROM dpcKOR_f
),

--MED
medre as (
  SELECT
    distinct
      seq1_no
      ,seq2_no
      ,id1n
      ,rcp_cls
      ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_med_re
    WHERE prac_ym = {ym}
),

medre_4H as (
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,rcp_cls
    ,prac_ym
  FROM medre
  WHERE rcp_cls not in ('1211','1212', '1221', '1222', '1231', '1232', '1241', '1242')
),

medre_4K as (
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,rcp_cls
    ,prac_ym
  FROM medre
  WHERE rcp_cls in ('1211','1212', '1221', '1222', '1231', '1232', '1241', '1242')
),

medHO as (
  SELECT
    seq1_no
    ,seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_med_ho
    WHERE prac_ym = {ym}
),

medKO as (
  SELECT
    seq1_no
    ,seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_med_ko
    WHERE prac_ym = {ym}
),

--HO, KOにreをLEFT JOINしている。
medHOR as (
  SELECT
    medHO.seq1_no
    ,medHO.seq2_no
    ,medHO.total_score
    ,medHO.prac_ym
    ,medre_4H.id1n
  FROM medHO
  LEFT JOIN medre_4H
    ON medHO.seq2_no = medre_4H.seq2_no
),

medKOR as (
  SELECT
    medKO.seq1_no
    ,medKO.seq2_no
    ,medKO.total_score
    ,medKO.prac_ym
    ,medre_4K.id1n
  FROM medKO
  LEFT JOIN medre_4K
    ON medre_4K.seq2_no = medKO.seq2_no
),

medKOR_f as (
  SELECT *
  FROM medKOR
  WHERE id1n = id1n
),

medkh as (
  SELECT * FROM medHOR
  UNION ALL
  SELECT * FROM medKOR_f
),

--PHA
phare as (
  SELECT
    distinct
      seq1_no
      ,seq2_no
      ,id1n
      ,rcp_cls
      ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_pha_re
    WHERE prac_ym = {ym}
),

phare_4H as (
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,rcp_cls
    ,prac_ym
  FROM phare
  WHERE rcp_cls not in ('4212', '4222', '4232', '4242')
),

phare_4K as (
  SELECT
    seq1_no
    ,seq2_no
    ,id1n
    ,rcp_cls
    ,prac_ym
  FROM phare
  WHERE rcp_cls in ('4212', '4222', '4232', '4242')
),

phaHO as (
  SELECT
    seq1_no
    ,seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_pha_ho
    WHERE prac_ym = {ym}
),

phaKO as (
  SELECT
    seq1_no
    ,seq2_no
    ,total_score
    ,prac_ym
    FROM osr_ndb_user.tnds_t_rcp_pha_ko
    WHERE prac_ym = {ym}
),

--HO, KOにreをLEFT JOINしている。
phaHOR as (
  SELECT
    phaHO.seq1_no
    ,phaHO.seq2_no
    ,phaHO.total_score
    ,phaHO.prac_ym
    ,phare_4H.id1n
  FROM phaHO
  LEFT JOIN phare_4H
    ON phaHO.seq2_no = phare_4H.seq2_no
),

phaKOR as (
  SELECT
    phaKO.seq1_no
    ,phaKO.seq2_no
    ,phaKO.total_score
    ,phaKO.prac_ym
    ,phare_4K.id1n
  FROM phaKO
  LEFT JOIN phare_4K
    ON phare_4K.seq2_no = phaKO.seq2_no
),

phaKOR_f as (
  SELECT *
  FROM phaKOR
  WHERE id1n = id1n
),

phakh as (
  SELECT * FROM phaHOR
  UNION ALL
  SELECT * FROM phaKOR_f
),


hk_bind as (
  SELECT
    *
    FROM dpckh
      UNION ALL
  SELECT
    *
    FROM medkh
  UNION ALL
  SELECT
    *
    FROM phakh
),

hk_smr as (
  SELECT
  id1n
  ,sum(total_score) as sum_total_score
  , {ym} as prac_ym
  FROM hk_bind
  GROUP BY id1n
  --limit 100000
)


--select * from dpcre;
--select * from dpcre_4H;
--select * from dpcre_4K;

--select * from dpcHOR;
--select * from dpcKOR;
--select * from dpcKOR_f;
--select * from dpckh;
select * from hk_smr;
--select * from dpcre;