-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function pick_siset_seq2(_tbl regclass, ym varchar(6), sicode varchar[])
Returns setof varchar(51) AS $$
DECLARE
  q text;
  flatcode text;
BEGIN
  flatcode := concat_ws('', '', sicode);
  q := format('SELECT distinct seq2_no FROM %s WHERE prac_ym = ''%s'' AND prac_act_cd in (''%s'');', _tbl, ym, flatcode);
  RETURN QUERY EXECUTE q;
END;
$$ LANGUAGE plpgsql;
