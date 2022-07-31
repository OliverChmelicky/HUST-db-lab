DROP MATERIALIZED VIEW IF EXISTS product_detail_mv CASCADE;

CREATE MATERIALIZED VIEW product_detail_mv 
AS
	SELECT p.id,
		c.title AS category,
		p.name,
		p.price,
		p.description,
		COALESCE(sum(s.quantity_remain), 0) AS stock_remain
	FROM ((products p
     	JOIN categories c ON ((c.id = p.category_id)))
     	FULL JOIN product_stocks s ON ((p.id = s.product_id)))
	GROUP BY p.id, c.id
	ORDER BY c.id
WITH NO DATA;

REFRESH MATERIALIZED VIEW product_detail_mv;
