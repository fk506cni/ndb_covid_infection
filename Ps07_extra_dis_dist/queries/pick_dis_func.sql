-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function pick_dis_seq2(_tbl regclass, ym varchar(6), discode varchar)
Returns setof varchar(51) AS $$
DECLARE
  q text;
BEGIN
  q := format('SELECT distinct seq2_no FROM %s WHERE prac_ym = ''%s'' AND skwd_name_cd in (''%s'') AND sspct_dss_flg != 1;', _tbl, ym, discode);
  RETURN QUERY EXECUTE q;
END;
$$ LANGUAGE plpgsql;
