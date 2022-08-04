
--BACKEND USER
CREATE USER backend WITH  password 'backend';
-- I don't need a permission to execute the procedure but I need a permission to operate with the tables the procedure works with if there is any trigger to that table
GRANT SELECT, INSERT, UPDATE, DELETE ON public."users" TO backend;
GRANT SELECT,UPDATE ON public."vouchers", public."orders" TO backend;
GRANT SELECT,UPDATE, INSERT ON public."orders", public."product_ordereds" TO backend;
GRANT SELECT ON public."products",  public."categories", public."product_stocks" TO backend;


--EMPLOYEE USER
CREATE USER employee WITH  password 'employee';
GRANT SELECT,UPDATE ON public."users", public."orders", public."product_ordereds" TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON public."vouchers", public."products", public."product_stocks", public."categories"  TO employee;