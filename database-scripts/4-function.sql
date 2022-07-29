CREATE OR REPLACE FUNCTION public.order_status_update_tgr_fnc()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	UPDATE product_ordereds
	SET purchase_price = product_detail_mv.price
	WHERE 
		product_ordereds.id = product_detail_mv.id
		AND	orders.status = 'ToPay';
RETURN NEW;
END;
$function$;

CREATE TRIGGER order_status_update_tgr
AFTER UPDATE ON orders 
FOR EACH ROW EXECUTE PROCEDURE order_status_update_tgr_fnc();

--------------
CREATE OR REPLACE FUNCTION public.voucher_insert_tgr_fnc()
	RETURNS trigger
 	LANGUAGE plpgsql
AS $function$
BEGIN
	IF NEW.type = 'Cash' THEN NEW.title := to_char(NEW.value,'FM999G999G999G999') || 'vnd off total bill for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
	END IF;
	IF NEW.type = 'Discount' THEN NEW.title := NEW.value || '% off total bill for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
	END IF;
	IF NEW.type = 'FreeShip' THEN NEW.title := 'FreeShip for order from ' || to_char(NEW.condition,'FM999G999G999G999') || 'vnd.';
	END IF;
RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS voucher_insert_tgr 
ON vouchers CASCADE;

CREATE TRIGGER voucher_insert_tgr
BEFORE INSERT ON vouchers
FOR EACH ROW EXECUTE PROCEDURE voucher_insert_tgr_fnc()