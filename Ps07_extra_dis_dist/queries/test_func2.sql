-- !preview conn=con

-- EXPLAIN 
--SELECT testfnc('tnds_t_rcp_dpc_iy');
--SELECT testfnc('tnds_t_rcp_dpc_sy', '202203', '8850104,8850613,8850701,8850640'::varchar(7)) as seq2no;

With 
dpc_sy as (SELECT testfnc({tbl}, {ym}, {discode}) as seq2_no)

select * from dpc_sy
;


