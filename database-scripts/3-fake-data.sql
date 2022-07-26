-- ALTER SEQUENCE "Users_id_seq" RESTART WITH 1;
-- ALTER SEQUENCE "Vouchers_id_seq" RESTART WITH 1;
-- ALTER SEQUENCE "Category_id_seq" RESTART WITH 1;

INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Bernie Durber', 'IZcgux48NGem', '082 375 6548', '62 Glendale Parkway');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Helenelizabeth McLane', 'noKAk44', '008 987 3714', '2379 Briar Crest Drive');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Janos Goricke', 'x3GrtAhLjR6i', '002 294 6913', '4 Mockingbird Lane');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Grazia Fagg', 'CxODMW1r4sMV', '070 783 4375', '83 American Ash Center');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Ursa Juanico', '114NTAyiakVn', '071 376 4776', '0281 North Road');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Zelda MacAlaster', 'zyRp43nbq', '047 217 7786', '2109 Lunder Drive');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Feodora Abrahm', 'V2OgkE', '000 421 9071', '5878 Buena Vista Park');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Anette Gippes', 'dy6hJUvD5p', '036 190 9019', '668 Veith Terrace');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Didi Tante', 'Z8lHtVYxez', '049 917 5366', '03 Meadow Ridge Point');
INSERT INTO "Users" (name, password, phonenum, address) VALUES ('Ortensia Leeman', 'm4YPNK4aCh0', '061 772 9248', '746 Delladonna Trail');

INSERT INTO "Vouchers" (type, condition, value, date_expire) VALUES ('FreeShip', 50., 5, '7/9/2022');
INSERT INTO "Vouchers" (type, condition, value, date_expire) VALUES ('Discount', 50, 15, '6/21/2022');
INSERT INTO "Vouchers" (type, condition, value, date_expire) VALUES ('Discount', 70, 20, '12/31/2021');
INSERT INTO "Vouchers" (type, condition, value, date_expire) VALUES ('Discount', 99.99, 30, '10/26/2021');
INSERT INTO "Vouchers" (type, condition, value, date_expire) VALUES ('Cash', 150, 20, '10/1/2021');

INSERT INTO "Category" (id, title) VALUES (1, 'Tops');
INSERT INTO "Category" (id, title) VALUES (2, 'Bottoms');
INSERT INTO "Category" (id, title) VALUES (3, 'Innerwear');
INSERT INTO "Category" (id, title) VALUES (4, 'Outerwear');
INSERT INTO "Category" (id, title) VALUES (5, 'Accessories', 0);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('T-shirts', 1);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Sweaters', 1);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Jeans', 2);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Shorts', 2);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Socks', 3);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Underwear', 3);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Jackets', 4);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Coats', 4);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Belts', 5);
INSERT INTO "Category" (title, parent_cate_id) VALUES ('Sunglasses', 5);