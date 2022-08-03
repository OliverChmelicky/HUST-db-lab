-- -- trigger insert new voucher -> create its title --
-- CREATE OR REPLACE FUNCTION public.voucher_insert_tgr_fnc()
-- 	RETURNS trigger
--  	LANGUAGE plpgsql
-- AS $function$
-- BEGIN
-- 	IF NEW.type = 'Cash' THEN NEW.title := to_char(NEW.value,'FM999G999G999G999') || 'vnd off total bill for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
-- 	END IF;
-- 	IF NEW.type = 'Discount' THEN NEW.title := NEW.value || '% off total bill for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
-- 	END IF;
-- 	IF NEW.type = 'FreeShip' THEN NEW.title := 'FreeShip for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
-- 	END IF;
-- RETURN NEW;
-- END;
-- $function$;
--
-- DROP TRIGGER IF EXISTS voucher_insert_tgr
-- ON vouchers CASCADE;
--
-- CREATE TRIGGER voucher_insert_tgr
-- BEFORE INSERT ON vouchers
-- FOR EACH ROW EXECUTE PROCEDURE voucher_insert_tgr_fnc();
--
-- -- update order status -> update purchase price, total price, stock remain, shipping address if null--
-- CREATE OR REPLACE FUNCTION public.order_status_update_tgr_fnc()
-- 	RETURNS trigger
--  	LANGUAGE plpgsql
-- AS $function$
-- BEGIN
-- 	IF NEW.status = 'ToShip'
-- 	THEN
-- 		UPDATE product_ordereds
-- 		SET purchase_price = products.price,
-- 			total_price = products.price*quantity
-- 		FROM product_stocks, products
-- 		WHERE NEW.id = cart_id
-- 		  AND stock_id = product_stocks.id
-- 		  AND product_stocks.id = products.id;
--
-- 		UPDATE product_stocks
-- 		SET quantity_remain = quantity_remain - product_ordereds.quantity
-- 		FROM product_ordereds
-- 		WHERE NEW.id = product_ordereds.cart_id
-- 		  AND product_ordereds.stock_id = product_stocks.id;
--
-- 		IF coalesce(TRIM(NEW.shipping_address), '') = ''
-- 		THEN
-- 			NEW.shipping_address := (SELECT address FROM users WHERE users.id = NEW.user_id);
-- 		END IF;
--
-- 	END IF;
-- RETURN NEW;
-- END;
-- $function$;
--
-- DROP TRIGGER IF EXISTS order_status_update_tgr
-- ON orders CASCADE;
--
-- CREATE TRIGGER order_status_update_tgr
-- BEFORE UPDATE ON orders
-- FOR EACH ROW EXECUTE PROCEDURE order_status_update_tgr_fnc();
--
-- -- update product_ordered to notPaid_status cart -> update total_price --
--
-- CREATE OR REPLACE FUNCTION public.product_ordered_insert_tgr_fnc()
-- 	RETURNS trigger
--  	LANGUAGE plpgsql
-- AS $function$
-- BEGIN
-- 	PERFORM * FROM orders
-- 	WHERE NEW.cart_id = orders.id
-- 	  AND orders.status = 'ToPay';
-- 	IF NOT FOUND THEN RETURN NULL;
-- 	END IF;
--
-- 	NEW.purchase_price := (SELECT price FROM products p, product_stocks s
-- 		WHERE NEW.stock_id    = s.id
-- 	  	AND s.product_id  = p.id);
-- 	NEW.total_price := COALESCE(NEW.purchase_price * NEW.quantity, 0);
--
-- 	UPDATE orders
-- 	SET total_price = (SELECT COALESCE(SUM(total_price), 0) FROM product_ordereds WHERE product_ordereds.cart_id = NEW.cart_id);
--
-- 	RETURN NEW;
-- END;
-- $function$;
--
-- DROP TRIGGER IF EXISTS product_ordered_insert_tgr
-- ON product_ordereds CASCADE;
--
-- CREATE TRIGGER product_ordered_insert_tgr
-- BEFORE INSERT ON product_ordereds
-- FOR EACH ROW EXECUTE PROCEDURE product_ordered_insert_tgr_fnc();
--
-- CREATE TRIGGER product_ordered_update_tgr
-- BEFORE UPDATE ON product_ordereds
-- FOR EACH ROW EXECUTE PROCEDURE product_ordered_insert_tgr_fnc();
--
-- -----------------------
--
-- CREATE OR REPLACE FUNCTION product_price_update_trg_fnc()
-- 	RETURNS trigger
--  	LANGUAGE plpgsql
-- AS $function$
-- BEGIN
-- 	UPDATE product_ordereds
-- 	SET purchase_price = NEW.price,
-- 		total_price    = NEW.price * quantity
-- 	FROM products p, product_stocks s, orders
-- 	WHERE cart_id       = orders.id
-- 	  AND stock_id      = s.id
-- 	  AND s.product_id  = NEW.id
-- 	  AND orders.status = 'ToPay';
--
-- 	RETURN NEW;
-- END;
-- $function$;
--
-- DROP TRIGGER IF EXISTS product_price_update_trg
-- ON products CASCADE;
--
-- CREATE TRIGGER product_price_update_trg
-- AFTER UPDATE ON products
-- FOR EACH ROW EXECUTE PROCEDURE product_price_update_trg_fnc();
--
--
--









-- Check if voucher is valid when assigning to order
CREATE OR REPLACE FUNCTION assign_voucher_to_order_trg_fnc()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$

BEGIN
-- TODO new total price has to be calculated before this trigger runs and check the condition
raise notice 'START: %', NEW;
IF NEW.voucher_id IS NULL
    THEN
        raise notice 'RETURNING: %', NEW.voucher_id;
RETURN NEW;
ELSE
        raise notice 'WHY: %', NEW.voucher_id;
END IF;

    IF NEW.voucher_id IS NOT NULL and EXISTS(
        SELECT * from vouchers where id = NEW.voucher_id and date_expire >= (SELECT CURRENT_TIMESTAMP)
        )
        THEN
            raise notice 'OK';
RETURN NEW; -- ok
ELSE
            raise notice 'INTEGRITY ERR';
            RAISE EXCEPTION integrity_constraint_violation;
end IF;
raise notice 'END';
END;
$function$;

DROP TRIGGER IF EXISTS assign_voucher_to_order_trg_insert
ON orders CASCADE;

CREATE TRIGGER assign_voucher_to_order_trg_insert
    BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE PROCEDURE assign_voucher_to_order_trg_fnc();

DROP TRIGGER IF EXISTS assign_voucher_to_order_trg_update
    ON orders CASCADE;
CREATE TRIGGER assign_voucher_to_order_trg_update
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE PROCEDURE assign_voucher_to_order_trg_fnc();

UPDATE public.orders SET voucher_id = 1 WHERE id = 2