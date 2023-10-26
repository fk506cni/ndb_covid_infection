-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function pick_disset_seq2(_tbl regclass, ym varchar(6), discode varchar[])
Returns setof varchar(51) AS $$
DECLARE
  q text;
  flatcode text;
BEGIN
  flatcode := concat_ws('', '', discode);
  q := format('SELECT distinct seq2_no FROM %1$s WHERE prac_ym = ''%2$s'' AND skwd_name_cd in (''%3$s'') AND sspct_dss_flg != 1;', _tbl, ym, flatcode);
  RETURN QUERY EXECUTE q;
END;
$$ LANGUAGE plpgsql;
