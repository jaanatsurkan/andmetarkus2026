-- 10. TABELITE ÜHENDAMINE

-- 10.1. Kõik eelarveread eelarve tabelist ja nendega seotud müügiesindaja nimi müügiesindajate tabelist.
SELECT *
FROM budget_table AS bt 
LEFT JOIN sales_rep_table AS srt 
ON bt.sales_rep_id = srt.sales_rep_id;

-- 10.3. Kõik müügiesindajad müügiesindajate tabelist ja nendega seotud eelarveread eelarve tabelist.
SELECT *
FROM sales_rep_table AS srt 
LEFT JOIN budget_table AS bt 
ON srt.sales_rep_id = bt.sales_rep_id;
-- 10.4. Näita ainult ridu, millel on müügiesindaja nii eelarve tabelis kui ka väärtus müügiesindajate tabelis.
SELECT *
FROM sales_rep_table AS srt 
INNER JOIN budget_table AS bt 
ON srt.sales_rep_id = bt.sales_rep_id;

-- 10.5. Näita kõiki ridu eelarve tabelist ja kõiki ridu müügiesindaja tabelist.
SELECT *
FROM budget_table AS bt 
FULL OUTER JOIN sales_rep_table AS srt 
ON bt.sales_rep_id  = srt.sales_rep_id;

-- 10.6. Näita ridu eelarve tabelist, millele pole müügiesindaja tabelis müügiesindajat kirjeldatud.
SELECT *
FROM budget_table AS bt 
LEFT JOIN sales_rep_table AS srt 
ON bt.sales_rep_id  = srt.sales_rep_id 
WHERE srt.sales_rep_id IS NULL;

-- 10.7. Näita ridu müügiesindaja tabelist, millele pole kirjeldatud ridu eelarve tabelis.
SELECT *
FROM sales_rep_table AS srt  
LEFT JOIN budget_table AS bt 
ON srt.sales_rep_id  = bt.sales_rep_id 
WHERE bt.sales_rep_id IS NULL;

-- 10.8. Näita müügiesindajaid, kellel on puudu eelarve või müügiesindaja tabelist rida.
SELECT bt.sales_rep_id, srt.sales_rep_id 
FROM budget_table bt 
FULL OUTER JOIN sales_rep_table srt 
ON srt.sales_rep_id = bt.sales_rep_id 
WHERE bt.sales_rep_id IS NULL or srt.sales_rep_id IS NULL;


-- 10.9. Näita ridu müügitabelist, millel on olemas müügiesindaja info eelarve ja müügiesindaja tabelis.
SELECT *
From sales_table st 
INNER JOIN sales_rep_table AS srt ON st.sales_rep_id = srt.sales_rep_id  
INNER JOIN budget_table AS bt ON st.sales_rep_id = Bt.sales_rep_id;