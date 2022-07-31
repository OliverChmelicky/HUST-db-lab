-- -- testing structures
-- CREATE TABLE IF NOT EXISTS public."testik"
-- (
--     uid varchar
-- );
--
--
-- CREATE OR REPLACE FUNCTION test_if_user_needs_rights_to_execute_procedure()
--     RETURNS trigger AS
-- $$
-- BEGIN
--     INSERT INTO testik (uid) VALUES (OLD.name);
--     return OLD;
-- END;
-- $$
--     LANGUAGE plpgsql;
--
--
--
-- CREATE TRIGGER test_if_user_needs_rights_trigger
--     BEFORE DELETE ON "users"
--     FOR EACH ROW
-- EXECUTE PROCEDURE test_if_user_needs_rights_to_execute_procedure();


-- REAL USER SCRIPT

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