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
--     BEFORE DELETE ON "Users"
--     FOR EACH ROW
-- EXECUTE PROCEDURE test_if_user_needs_rights_to_execute_procedure();


-- REAL USER SCRIPT
CREATE USER backend WITH  password 'backend';
-- I don't need a permission to execute the procedure but I need a permission to operate with the tables the procedure works with if there is any trigger to that table
GRANT SELECT, INSERT, UPDATE, DELETE ON public."Users" TO backend;

