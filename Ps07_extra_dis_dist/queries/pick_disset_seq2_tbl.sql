-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function pick_disset_seq2_tbl(schm varchar, ym varchar(6), discode text[])
Returns setof varchar(51) AS $$
DECLARE
  q text;
  flatcode text;
BEGIN
  flatcode := concat_ws('', '', discode);

  --dpc section
  IF schm = 'dpc' THEN
    q := '
With 
dpc_sy as (
SELECT pick_disset_seq2(''tnds_t_rcp_dpc_sy'', ''%1$s''::varchar, array[''%2$s'']) as seq2_no),

dpc_sb as (
SELECT pick_disset_seq2(''tnds_t_rcp_dpc_sb'', ''%1$s''::varchar, array[''%2$s'']) as seq2_no),

dis_seq2 as (
  Select 
    seq2_no FROM dpc_sy
    union 
  select 
    seq2_no FROM dpc_sb)
    
select 
  case when seq2_no in (select seq2_no from dis_seq2) THEN 1 
       else 0
  end as isinx
  FROM tnds_t_rcp_dpc_sb
  WHERE prac_ym = %1$s::varchar
;';
    q := format(q, ym, flatcode);
    
  --med section
  ELSIF schm == 'med' THEN
        q := '
With 
med_sy as (
SELECT pick_disset_seq2(''tnds_t_rcp_med_sy'', ''%1$s''::varchar, array[''%2$s'']) as seq2_no),

select 
  case when seq2_no in (select seq2_no from med_sy) THEN 1 
       else 0
  end as isinx
  FROM tnds_t_rcp_dpc_sb
  WHERE prac_ym = %1$s::varchar
;';
    q := format(q, ym, flatcode);
    
  ELSE
    q := 'SELECT 0';
  END IF;

  RETURN QUERY EXECUTE q;
END;
$$ LANGUAGE plpgsql;