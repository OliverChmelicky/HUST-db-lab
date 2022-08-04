---SCENARIOS
--1. When order is ToShip Order cannot be changed as well as
UPDATE orders SET status = 'ToShip' WHERE id = 1;
UPDATE orders SET voucher_id = 2 WHERE id = 1;
UPDATE product_ordereds SET quantity = 2 WHERE order_id = 1;

-- 2. Showing product_order trigger change in price-- it also calculates total price
UPDATE products SET price = 1 WHERE id = 1;
-- show that product_price in product_order does not change for order ToShip and changes for ToPay

-- 3. Changing quantity remain
-- a changing in product_orders
UPDATE product_ordereds SET quantity = 999999 WHERE id = 1;
-- b
UPDATE product_ordereds SET quantity = 999999 WHERE id = 5;
-- b
UPDATE product_stocks set quantity_remain = 10 where id = 1;

-- decrease product stock and update the shipping_address if null
UPDATE orders set status = 'ToShip' WHERE id = 3;

--4. Vouchers checks
-- a
UPDATE vouchers SET date_expire = '1111-12-12' WHERE id = 1;
UPDATE orders SET voucher_id = 1 WHERE id = 2;

--b
UPDATE vouchers SET condition = 999999999 WHERE id = 2;
UPDATE orders SET voucher_id = 2 WHERE id = 2;

-- 5
-- Calculation of discount - firstly does not show
UPDATE vouchers SET condition = 20 WHERE id = 2;
UPDATE orders SET voucher_id = 2 WHERE id = 2;
--show it finally calculates the price
UPDATE orders SET voucher_id = 3 WHERE id = 2;


SELECT * FROM user_vouchers_list(1);
SELECT * FROM order_products WHERE user_id = 1;
SELECT * FROM product_detail where id = 1;

DELETE FROM users WHERE id=1;