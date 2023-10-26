-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function dis2seq2no(_tbl regclass, discode varchar(7)[], ym  varchar(6))
  returns varchar(51)[]

stable AS $$
  SELECT
      distinct  seq2_no
    FROM _tbl
    WHERE prac_ym = ym
    AND skwd_name_cd in (discode)
    --AND main_skwd = '01'
    AND sspct_dss_flg != 1
    --limit 1000000
$func$

$$ language plpgsql;
