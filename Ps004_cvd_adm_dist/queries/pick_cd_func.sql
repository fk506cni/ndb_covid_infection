-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function pick_cd_seq2(_tbl regclass, ym varchar(6), sicode varchar)
Returns setof varchar(51) AS $$
DECLARE
  q text;
BEGIN
  q := format('SELECT distinct seq2_no FROM %s WHERE prac_ym = ''%s'' AND rcpt_comp_sys_rec in (''%s'');', _tbl, ym, sicode);
  RETURN QUERY EXECUTE q;
END;
$$ LANGUAGE plpgsql;
