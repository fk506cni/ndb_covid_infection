-- !preview conn=con
-- 当該年月のSY
-- EXPLAIN 
With 

-- 当該年月のRE
dpc_re_lim as (
  SELECT 
    -- seq1_no,
    seq2_no
    ,id1n
    --id2,
    ,sex_div
    ,age_hier_cd1
    ,cast(age_hier_cd1 as integer) as age_hier_cd1_int
    ,1 as schema_org
    --prac_ym,
    
    --covid
    ,pick_dis_seq2_dual('dpc', {ym}::varchar, array[{covid_codes*}], array[pick_disset_seq2_tbl('dpc', {ym}::varchar, array[{covid_codes*}])]) as covid_codes
    
    --sars
    --,pick_dis_seq2_dual('dpc', {ym}::varchar, array[{sars_codes*}]) as sars_codes
    

    FROM tnds_t_rcp_dpc_re
    WHERE prac_ym = {ym}
    --limit 1000000
)

--SELECT * from dpc_sy_sub_dist;    

--SELECT * from dpc_syb;
--SELECT * from dpc_re_lim;
--SELECT * from re_smr;
--SELECT * from re_lim;
--SELECT * from med_re_lim;
--SELECT * from re_smr;
SELECT * from dpc_re_lim;
