DROP VIEW IF EXISTS product_detail CASCADE;

CREATE VIEW product_detail
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
	ORDER BY c.id;

DROP VIEW IF EXISTS order_products CASCADE;

CREATE VIEW order_products
AS
    SELECT
        o.user_id,
        o.created_at,
        o.status,
        o.shipping_address,
        po.purchase_price,
        po.quantity,
        ps.size,
        ps.color,
        p.name,
        c.title
        FROM orders o
            JOIN product_ordereds po ON (o.id = po.order_id)
            JOIN product_stocks ps ON (po.stock_id = ps.id)
            JOIN products p ON (ps.product_id = p.id)
            JOIN categories c ON (p.category_id = c.id)
        order by created_at;


DROP FUNCTION IF EXISTS user_vouchers_list(bigint);
CREATE OR REPLACE FUNCTION user_vouchers_list(a bigint)
RETURNS SETOF vouchers
AS $function$
BEGIN
RETURN Query SELECT * FROM vouchers v
    where id NOT IN (SELECT v.id FROM vouchers v JOIN orders o ON v.id = o.voucher_id WHERE o.user_id = a);
END;
$function$
LANGUAGE plpgsql;