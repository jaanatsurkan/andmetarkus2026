-- Leia müügisummad toodete kaupa – toote ID ja müügisumma
SELECT product_id, ROUND(SUM(sale_sum),2) AS muugisumma
FROM sales_table
GROUP BY product_id
ORDER BY product_id;

-- ‣Leia müügisummad klientide kaupa – kliendi ID ja müügisumma
SELECT customer_id, ROUND(SUM(sale_sum),2) AS muugisumma
FROM sales_table 
GROUP BY customer_id
ORDER BY customer_id;

-- ‣Leia müügisummad müügiesindajate kaupa – kliendiesindaja ID ja müügisumma
SELECT sales_rep_id,
ROUND(SUM(sale_sum),2) AS muugisumma
FROM sales_table
GROUP BY sales_rep_id
ORDER BY sales_rep_id;

-- ‣Leia müügisummad aastate kaupa – aasta ja müügisumma
SELECT
EXTRACT(YEAR FROM sale_date::DATE) AS aasta,
ROUND(SUM(sale_sum), 2) AS muugisumma
FROM sales_table
GROUP BY EXTRACT(YEAR FROM sale_date::DATE)
ORDER BY aasta;

-- ‣Lisa müükidele müügisumma kategooriad

SELECT
CASE
    WHEN sale_sum < 250 THEN 'Small_Sale'
    WHEN sale_sum BETWEEN 250 AND 500 THEN 'Medium_Sale'
    WHEN sale_sum > 500 THEN 'Large_Sale'
ELSE 'ERROR' END AS sale_category
FROM sales_table;

-- Lisa see tulp müügitabelisse.
ALTER TABLE sales_table ADD COLUMN sale_category VARCHAR (50);

UPDATE sales_table SET sale_category = 
CASE  WHEN sale_sum < 250 THEN 'Small_Sale'
    WHEN sale_sum BETWEEN 250 AND 500 THEN 'Medium_Sale'
    WHEN sale_sum > 500 THEN 'Large_Sale'
ELSE 'ERROR' END;


SELECT * from sales_table;
-- ‣Leia müükide arv ja müügisumma müügisumma kategooriate kaupa - Müügisumma kategooria, müükide arv, müügisumma
SELECT
CASE
    WHEN sale_sum > 500 THEN 'Large_Sale'
    WHEN sale_sum BETWEEN 250 AND 500 THEN 'Medium_Sale'
    WHEN sale_sum < 250 THEN 'Small_Sale'
END AS kategooria,
COUNT(*) AS muukide_arv,
SUM(sale_sum) AS muugisumma
FROM sales_table
GROUP BY
CASE
    WHEN sale_sum > 500 THEN 'Large_Sale'
    WHEN sale_sum BETWEEN 250 AND 500 THEN 'Medium_Sale'
    WHEN sale_sum < 250 THEN 'Small_Sale'
END;

--Alternatiivne lahendus.
SELECT sale_category, COUNT(*) AS nr_of_sales, SUM(sale_sum) AS total_sum
FROM sales_table
GROUP BY sale_category 
ORDER BY sale_category;

-- Alternatiivne lahendus ajutise päringu abil.
WITH sales_per_category AS (
SELECT *,
CASE WHEN sale_sum < 250 THEN 'Small_Sale'
    WHEN sale_sum BETWEEN 250 AND 500 THEN 'Medium_Sale'
    WHEN sale_sum > 500 THEN 'Large_Sale'
   ELSE 'ERROR' END AS sale_category_new
FROM sales_table)
SELECT sale_category_new, SUM(sale sum), count(*)
FROM sales_per_category 
GROUP BY sale_category_new;

select
	case
		when st.sales_sum > 500 then 'Large Sale'
		when st.sales_sum <= 500 and st.sales_sum >= 250 then 'Medium Sale'
		when st.sales_sum < 250 then 'Small Sale'
		else 'ERROR'
	end as sale_category
	,count(st.sale_id) as sales_count
	,sum(st.sales_sum) as sales_sum
from sales_table st 
group by sale_category;


‣Mida veel võiks leida?

SELECT sales_rep_id, AVG(DISCOUNT) AS avg_discount_per_sales_rep,
(SELECT AVG(discount) AS avg_dicpunt_in_company FROM sales_table),
AVG(DISCOUNT) - (SELECT AVG(discount) AS avg_dicpunt_in_company FROM sales_table) AS difference_from_company_average
FROM sales_table st 
GROUP BY sales_rep_id;

-- ‣Leia müügisummad klientide kaupa – kliendi ID ja müügisumma
SELECT region_id, ROUND(SUM(sale_sum),2) AS muugisumma
FROM sales_table 
GROUP BY region_id
ORDER BY region_id;