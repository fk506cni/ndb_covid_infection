-- !preview conn=con

Create or Replace Function f_test()
  returns varchar
stable AS $$
select 'aiueo' as a
$$ language sql;
