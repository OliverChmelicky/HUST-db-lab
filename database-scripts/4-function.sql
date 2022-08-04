CREATE OR REPLACE FUNCTION get_order_total_price_fnc(_order_id bigint)
	RETURNS BIGINT
	LANGUAGE plpgsql
AS $$
DECLARE
    _voucher record;
    _total_price BIGINT;
BEGIN
	_total_price := (SELECT COALESCE(SUM(purchase_price * quantity), 0) FROM product_ordereds WHERE order_id = _order_id);
	
	SELECT v.value, v.type INTO _voucher FROM vouchers v, orders o WHERE _order_id = o.id AND o.voucher_id = v.id;
	
	IF _voucher IS NOT NULL
	THEN
		IF _voucher.type = 'Discount'
		THEN
			_total_price := _total_price * (100 - _voucher.value) / 100;
		END IF;
		
		IF _voucher.type = 'Cash'
		THEN
			_total_price := _total_price - _voucher.value;
		END IF;
		
		raise info 'NEW PRICE discount: %', _total_price;
	END IF;
	
	IF _total_price < 0 THEN _total_price := 0; END IF;	
	RETURN _total_price;
END;
$$;

-------------------------------------------------------------
-- product price changes THEN purchase_price changes --
CREATE OR REPLACE FUNCTION update_purchase_price()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	UPDATE product_ordereds
	SET purchase_price = NEW.price
	FROM product_stocks ps
	WHERE stock_id = ps.id
	  AND ps.product_id = NEW.id;

	RETURN NEW;	
END;
$function$;

DROP TRIGGER IF EXISTS tr_product_price_changes ON products CASCADE;
CREATE TRIGGER tr_product_price_changes
AFTER UPDATE ON products
FOR EACH ROW EXECUTE PROCEDURE update_purchase_price();

-------------------------------------------------------------
-- purchase_price, quantity changes THEN total price changes--
CREATE OR REPLACE FUNCTION update_total_price()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	UPDATE orders
	SET total_price = get_order_total_price_fnc(NEW.order_id) 
	WHERE id = NEW.order_id;
	
	NEW.purchase_price := (SELECT COALESCE(price, 0) FROM products p, product_stocks s WHERE p.id = s.product_id AND s.id = NEW.stock_id);
	
	RETURN NEW;	
END;
$function$;

DROP TRIGGER IF EXISTS tr_purchase_price_changes ON product_ordereds CASCADE;
CREATE TRIGGER tr_purchase_price_changes
AFTER UPDATE OR INSERT ON product_ordereds
FOR EACH ROW EXECUTE PROCEDURE update_total_price();

-------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_product_ordereds_update()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	IF (SELECT status FROM orders WHERE id = NEW.order_id) = 'ToPay'
	AND (SELECT status FROM orders WHERE id = OLD.order_id) = 'ToPay'
	THEN RETURN NEW;
	END IF;
	RETURN OLD;
END;
$function$;

DROP TRIGGER IF EXISTS tr_check_product_ordereds_update ON product_ordereds CASCADE;
CREATE TRIGGER tr_check_product_ordereds_update
BEFORE UPDATE ON product_ordereds
FOR EACH ROW EXECUTE PROCEDURE check_product_ordereds_update();
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_product_ordereds_insert()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	IF (SELECT status FROM orders WHERE id = NEW.order_id) = 'ToPay'
	THEN
		IF NEW.quantity > (SELECT quantity_remain FROM product_stocks WHERE id = NEW.stock_id)
		THEN NEW.quantity := (SELECT quantity_remain FROM product_stocks WHERE id = NEW.stock_id);
		END IF;
		NEW.purchase_price := (SELECT price FROM products p, product_stocks s WHERE p.id = s.product_id AND s.id = NEW.stock_id);
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$function$;

DROP TRIGGER IF EXISTS tr_check_product_ordereds_insert ON product_ordereds CASCADE;
CREATE TRIGGER tr_check_product_ordereds_insert
BEFORE INSERT or UPDATE ON product_ordereds
FOR EACH ROW EXECUTE PROCEDURE check_product_ordereds_insert();
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_update_order()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	IF NEW.status != 'ToPay' --AND OLD.status = 'ToPay'
	THEN
		OLD.status := NEW.status;
		IF NEW.shipping_address IS NULL
		THEN OLD.shipping_address :=(SELECT address FROM users WHERE id = NEW.user_id);
		END IF;
		NEW.total_price := get_order_total_price_fnc(NEW.id);
		RETURN OLD;
	END IF;
	
	RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS tr_check_update_order ON orders CASCADE;
CREATE TRIGGER tr_check_update_order
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE PROCEDURE check_update_order();

-------------------------------------------------------------
-- status change then -> quantity remain 
CREATE OR REPLACE FUNCTION reduce_quantity_remain()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	IF NEW.status = 'ToShip'
	THEN 
		UPDATE product_stocks
		SET quantity_remain = quantity_remain - quantity
		FROM product_ordereds po
		WHERE NEW.id = po.order_id
		  AND po.stock_id = product_stocks.id;
	END IF;
	RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS tr_reduce_quantity_remain ON orders CASCADE;
CREATE TRIGGER tr_reduce_quantity_remain
AFTER UPDATE ON orders
FOR EACH ROW EXECUTE PROCEDURE reduce_quantity_remain();

-------------------------------------------------------------
-- quantity remain change -> reduce quantity ordered
CREATE OR REPLACE FUNCTION reduce_quantity_ordered()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	UPDATE product_ordereds
	SET quantity = NEW.quantity_remain
	WHERE stock_id = NEW.id
	  AND quantity > NEW.quantity_remain;
	  
	RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS tr_reduce_quantity_ordered ON product_stocks CASCADE;
CREATE TRIGGER tr_reduce_quantity_ordered
AFTER UPDATE ON product_stocks
FOR EACH ROW EXECUTE PROCEDURE reduce_quantity_ordered();

------------------------------------------------------------
-- trigger insert new voucher -> create its title --
CREATE OR REPLACE FUNCTION public.voucher_insert_tgr_fnc()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	IF NEW.type = 'Cash' THEN NEW.title := to_char(NEW.value,'FM999G999G999G999') || 'vnd off total bill for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
	END IF;
	IF NEW.type = 'Discount' THEN NEW.title := NEW.value || '% off total bill for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
	END IF;
RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS voucher_insert_tgr
ON vouchers CASCADE;

CREATE TRIGGER voucher_insert_tgr
BEFORE UPDATE OR INSERT ON vouchers
FOR EACH ROW EXECUTE PROCEDURE voucher_insert_tgr_fnc();

------------------------------------------------------------
-- Check if voucher is valid when assigning to order
CREATE OR REPLACE FUNCTION assign_voucher_to_order_trg_fnc()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
BEGIN
	IF NEW.voucher_id IS NULL OR NEW.voucher_id = OLD.voucher_id
   	THEN RETURN NEW;
	END IF;
    
    IF NOT EXISTS( SELECT * from vouchers where id = NEW.voucher_id and date_expire >= (SELECT CURRENT_TIMESTAMP))
	THEN
--         raise notice 'INTEGRITY ERR- VOUCHER EXPIRED';
--         RAISE EXCEPTION integrity_constraint_violation;
        RETURN OLD; 
    END IF;

    IF NEW.total_price < (SELECT condition from vouchers where id = NEW.voucher_id)   
    THEN 
--     	raise notice 'INTEGRITY ERR- VOUCHER condition';
--         RAISE EXCEPTION integrity_constraint_violation;
        RETURN OLD; 
    END IF;
    
-- 	raise notice 'applied voucher %', NEW.voucher_id;
	NEW.total_price := get_order_total_price_fnc(NEW.id);
	
    RETURN NEW;
END;
$function$;


DROP TRIGGER IF EXISTS assign_voucher_to_order_trg_update
    ON orders CASCADE;
CREATE TRIGGER assign_voucher_to_order_trg_update
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE PROCEDURE assign_voucher_to_order_trg_fnc();

------------------------------------------------------------
-- Check if voucher is valid when assigning to order
CREATE OR REPLACE FUNCTION calculate_total_price()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
BEGIN
	NEW.total_price := get_order_total_price_fnc(NEW.id);

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS tr_calculate_total_price
    ON orders CASCADE;
CREATE TRIGGER tr_calculate_total_price
    AFTER UPDATE ON orders
    FOR EACH ROW EXECUTE PROCEDURE calculate_total_price();

-- CREATE OR REPLACE FUNCTION update_prices_of_order_if_voucher_used_trg_fnc()
--     RETURNS trigger
--     LANGUAGE plpgsql
-- AS $function$
-- DECLARE
--     _voucher_type text := '';
--     _voucher_value integer := 0;
-- BEGIN

--     IF NEW.voucher_id IS NULL
--     THEN
--         RETURN NEW;
--     END IF;

--     IF NEW.status != 'ToShip'
--     THEN
--         RETURN NEW;
--     END IF;

--     _voucher_type := (select type from vouchers where id = NEW.voucher_id);
--     _voucher_value:= (select value from vouchers where id = NEW.voucher_id);
--     raise notice 'VOUCHER TYPE %', _voucher_type;
--     raise notice 'VOUCHER VALUE %', _voucher_value;

--     IF _voucher_type = 'Cash'
--         THEN NEW.total_price := (
--                         select sum(product_price) from (
--                             select (po.quantity*p.price) as product_price from orders o
--                             join product_ordereds po on po.order_id = o.id
--                             join product_stocks ps on ps.id = po.stock_id
--                             join products p on ps.product_id = p.id
--                             where o.id = NEW.id
--                             ) as TotalPrice) - _voucher_value;
--         raise notice 'NEW PRICE cash: %', NEW.total_price;
--         ELSIF _voucher_type = 'Discount'
--         THEN NEW.total_price := (
--                 select sum(product_price) from (
--                 select (po.quantity*p.price) as product_price from orders o
--                      join product_ordereds po on po.order_id = o.id
--                      join product_stocks ps on ps.id = po.stock_id
--                      join products p on ps.product_id = p.id
--                         where o.id = NEW.id) as TotalPrice);
--                 NEW.total_price = NEW.total_price - NEW.total_price/100 * _voucher_value;
--         raise notice 'NEW PRICE discount: %', NEW.total_price;
--         END IF;

--     RETURN NEW;
-- END;
-- $function$;

-- DROP TRIGGER IF EXISTS update_prices_of_order_if_voucher_used_trg
--     ON orders CASCADE;
-- CREATE TRIGGER update_prices_of_order_if_voucher_used_trg
--     BEFORE UPDATE ON orders
--     FOR EACH ROW EXECUTE PROCEDURE update_prices_of_order_if_voucher_used_trg_fnc();