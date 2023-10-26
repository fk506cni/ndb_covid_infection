-- !preview conn=con

-- disnametable, ym, code -> seq2no
Create or Replace Function pick_dis_seq2_dual(schm varchar, ym varchar(6), discode text[], seq2_no_in varchar, positive_seq2 varchar[] )
Returns setof integer AS $$
DECLARE
  q text;
  flatcode text;
  --positive_seq2 varchar[] := pick_disset_seq2_tbl(schm, ym, discode);
BEGIN
  IF seq2_no_in in positive_seq2 THEN
    RETURN 1;
  ELSE
    RETURN 0;
END;
$$ LANGUAGE plpgsql;


