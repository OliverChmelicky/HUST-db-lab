-- ALTER SEQUENCE users_id_seq RESTART WITH 1;
-- ALTER SEQUENCE vouchers_id_seq RESTART WITH 1;

INSERT INTO users (name, password, phonenum, address) VALUES ('Bernie Durber', 'IZcgux48NGem', '082 375 6548', '62 Glendale Parkway');
INSERT INTO users (name, password, phonenum, address) VALUES ('Helenelizabeth McLane', 'noKAk44', '008 987 3714', '2379 Briar Crest Drive');
INSERT INTO users (name, password, phonenum, address) VALUES ('Janos Goricke', 'x3GrtAhLjR6i', '002 294 6913', '4 Mockingbird Lane');
INSERT INTO users (name, password, phonenum, address) VALUES ('Grazia Fagg', 'CxODMW1r4sMV', '070 783 4375', '83 American Ash Center');
INSERT INTO users (name, password, phonenum, address) VALUES ('Ursa Juanico', '114NTAyiakVn', '071 376 4776', '0281 North Road');
INSERT INTO users (name, password, phonenum, address) VALUES ('Zelda MacAlaster', 'zyRp43nbq', '047 217 7786', '2109 Lunder Drive');
INSERT INTO users (name, password, phonenum, address) VALUES ('Feodora Abrahm', 'V2OgkE', '000 421 9071', '5878 Buena Vista Park');
INSERT INTO users (name, password, phonenum, address) VALUES ('Anette Gippes', 'dy6hJUvD5p', '036 190 9019', '668 Veith Terrace');
INSERT INTO users (name, password, phonenum, address) VALUES ('Didi Tante', 'Z8lHtVYxez', '049 917 5366', '03 Meadow Ridge Point');
INSERT INTO users (name, password, phonenum, address) VALUES ('Ortensia Leeman', 'm4YPNK4aCh0', '061 772 9248', '746 Delladonna Trail');

INSERT INTO vouchers (type, condition, value, date_expire) VALUES ('FreeShip', 200000, 15000, '12/31/2044');
INSERT INTO vouchers (type, condition, value, date_expire) VALUES ('Discount', 500000, 15, '6/21/2022');
INSERT INTO vouchers (type, condition, value, date_expire) VALUES ('Discount', 700000, 20, '12/31/2021');
INSERT INTO vouchers (type, condition, value, date_expire) VALUES ('Discount', 1000000, 30, '10/26/2021');
INSERT INTO vouchers (type, condition, value, date_expire) VALUES ('Cash', 800000, 100000, '10/1/2021');

ALTER SEQUENCE categories_id_seq RESTART WITH 1;
INSERT INTO categories (id, title) VALUES (1, 'Default');
INSERT INTO categories (id, title) VALUES (2, 'Tops');
INSERT INTO categories (id, title) VALUES (3, 'Bottoms');
INSERT INTO categories (id, title) VALUES (4, 'Innerwear');
INSERT INTO categories (id, title) VALUES (5, 'Outerwear');
INSERT INTO categories (id, title) VALUES (6, 'Accessories');
INSERT INTO categories (id, title, parent_cate_id) VALUES (7, 'T-shirts', 2);
INSERT INTO categories (id, title, parent_cate_id) VALUES (8, 'Sweaters', 2);
INSERT INTO categories (id, title, parent_cate_id) VALUES (9, 'Jeans', 3);
INSERT INTO categories (id, title, parent_cate_id) VALUES (10, 'Shorts', 3);
INSERT INTO categories (id, title, parent_cate_id) VALUES (11, 'Socks', 4);
INSERT INTO categories (id, title, parent_cate_id) VALUES (12, 'Underwear', 4);
INSERT INTO categories (id, title, parent_cate_id) VALUES (13, 'Jackets', 5);
INSERT INTO categories (id, title, parent_cate_id) VALUES (14, 'Coats', 5);
INSERT INTO categories (id, title, parent_cate_id) VALUES (15, 'Belts', 6);
INSERT INTO categories (id, title, parent_cate_id) VALUES (16, 'Sunglasses', 6);

INSERT INTO products (name, category_id, description, price) VALUES ('Dry V-Neck Short Sleeve Color T-Shirt', 7, 'Simple and versatile. Stays dry, giving it a comfortable and dry feeling against the skin.', 146000);
INSERT INTO products (name, category_id, description, price) VALUES ('Crew Neck Short Sleeve T-Shirt', 7, 'One piece with a high degree of perfection that looks simple and has outstanding design and durability.', 244000);
INSERT INTO products (name, category_id, description, price) VALUES ('Extra Fine Merino V Neck Long Sleeve Sweater', 8, '100％ premium Merino wool. A sophisticated knit with updated details.', 784000);
INSERT INTO products (name, category_id, description, price) VALUES ('Ultra Stretch Skinny Jeans', 9, 'Amazing stretch for comfort and a flattering style. Sleek, skinny fit.', 980000);
-- INSERT INTO products (name, category_id, description, price) VALUES ('', , '', );

INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (1, 'S', 'White', 50);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (1, 'M', 'White', 60);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (1, 'L', 'White', 70);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (1, 'S', 'Black', 70);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (1, 'M', 'Black', 80);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (1, 'L', 'Black', 90);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (2, 'XS', 'Gray', 55);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (2, 'M', 'Gray', 65);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (2, 'XL', 'Gray', 75);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (2, 'XS', 'Brown', 75);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (2, 'M', 'Brown', 85);
INSERT INTO product_stocks (product_id, size, color, quantity_remain) VALUES (2, 'XL', 'Brown', 0);

INSERT INTO orders (user_id, status, shipping_address, voucher_id) VALUES (1, 'ToPay', 'So 1 Dai Co Viet', null);
INSERT INTO orders (user_id, status) VALUES (2, 'ToPay');

INSERT INTO product_ordereds (cart_id, stock_id, quantity) VALUES (1, 1, 12);
INSERT INTO product_ordereds (cart_id, stock_id, quantity) VALUES (1, 2, 12);
INSERT INTO product_ordereds (cart_id, stock_id, quantity) VALUES (2, 7, 12);
INSERT INTO product_ordereds (cart_id, stock_id, quantity) VALUES (2, 8, 12);