-- !preview conn=con

-- disnametable, ym, code -> seq2no

--, discode varchar(7)[], ym  varchar(6)
--_tbl regclass
  --EXECUTE format("SELECT distinct seq2_no FROM ", _tbl ," WHERE prac_ym = {", ym, "} AND skwd_name_cd in (", discode, ") AND sspct_dss_flg != 1)")
Create or Replace Function testfnc(_tbl regclass, ym varchar(6), discode varchar)
Returns setof varchar(51) AS $$
DECLARE
  q text;
BEGIN
  --EXECUTE format("SELECT distinct seq2_no FROM %s WHERE prac_ym = '202203' AND skwd_name_cd in ('8850104','8850613', '8850701','8850640') AND sspct_dss_flg != 1)", _tbl)
  q := format('SELECT distinct seq2_no FROM %s WHERE prac_ym = ''%s'' AND skwd_name_cd in (''%s'') AND sspct_dss_flg != 1;', _tbl, ym, discode);
  RETURN QUERY EXECUTE q;
END;
$$ LANGUAGE plpgsql;
