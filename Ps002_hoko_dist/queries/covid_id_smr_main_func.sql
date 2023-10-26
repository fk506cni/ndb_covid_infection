-- !preview conn=con

Create or Replace Function pick_seq2_dis(_tbl regclass, OUT result varchar) $$
  LANGUAGE plpgsql AS
$func$
BEGIN
  EXECUTE format('SELECT
    distinct  seq2_no
    FROM ', _tbl, '
    WHERE prac_ym = {ym}
    AND skwd_name_cd in ({discode*})
    AND sspct_dss_flg != '1')
  INTO result
END
$func$;
