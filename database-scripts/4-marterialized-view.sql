CREATE MATERIALIZED VIEW product_detail AS
	SELECT p.id,
		c.title AS category,
		p.name,
		p.price,
		p.description,
		sum(s.quantity_remain) AS stock_ramain
	FROM ((product_stocks s
		JOIN products p ON ((s.product_id = p.id)))
		JOIN categories c ON ((p.category_id = c.id)))
	GROUP BY p.id, c.id
	ORDER BY c.id;
WITH NO DATA;

REFRESH MATERIALIZED VIEW product_detail;