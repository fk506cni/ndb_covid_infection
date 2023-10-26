-- !preview conn=con
-- EXPLAIN 
Create Table {`tbl`}(
    --seq1_no varchar(10)
    --,
    id1n varchar(64)
    ,seq2_no varchar(51)
    ,sum_total_score integer
    ,prac_ym varchar(6)
) partition by list(prac_ym);