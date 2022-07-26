DROP TABLE IF EXISTS "ProductOrdereds";
DROP TABLE IF EXISTS "Orders";
DROP TABLE IF EXISTS "ProductStocks";
DROP TABLE IF EXISTS "Products";
DROP TABLE IF EXISTS "Categories";
DROP TABLE IF EXISTS "Vouchers";
DROP TABLE IF EXISTS "Users";

DROP TYPE IF EXISTS "cart_status";
DROP TYPE IF EXISTS "voucher_type";

CREATE TYPE "cart_status" AS ENUM (
    'ToPay',
    'ToShip',
    'ToReceive',
    'Completed',
    'Cancel'
);

CREATE TYPE "voucher_type" AS ENUM (
    'Cash',
    'Discount',
    'FreeShip'
);

CREATE TABLE "Users" (
    "id" bigserial PRIMARY KEY,
    "name" varchar NOT NULL,
    "password" varchar NOT NULL,
    "phonenum" varchar NOT NULL,
    "address" varchar NOT NULL
);

CREATE TABLE "Vouchers" (
    "id" bigserial PRIMARY KEY,
    "title" varchar NOT NULL,
    "type" voucher_type NOT NULL,
    "condition" NUMERIC(2) NOT NULL DEFAULT 0,
    "value" integer NOT NULL,
    "date_expire" timestamptz NOT NULL
);

CREATE TABLE "Categories" (
    "id" bigserial PRIMARY KEY,
    "title" varchar NOT NULL,
    "description" varchar,
    "parent_cate_id" bigint DEFAULT 0 REFERENCES "Categories" ("id") ON DELETE CASCADE
);

CREATE TABLE "Products" (
    "id" bigserial PRIMARY KEY,
    "name" varchar NOT NULL,
    "category_id" bigint NOT NULL DEFAULT 0 REFERENCES "Categories" ("id") ON DELETE SET DEFAULT,
    "description" varchar,
    "price" integer NOT NULL
);

CREATE TABLE "ProductStocks" (
    "id" bigserial PRIMARY KEY,
    "color" varchar NOT NULL,
    "size" varchar NOT NULL,
    "product_id" bigint REFERENCES "Products" ("id") ON DELETE CASCADE,
    "quantity_remain" integer NOT NULL
);

CREATE TABLE "Orders" (
    "id" bigserial PRIMARY KEY,
    "user_id" bigint NOT NULL REFERENCES "Users" ("id") ON DELETE CASCADE,			-- 
    "created_at" timestamptz NOT NULL DEFAULT 'now()',
    "total_price" integer NOT NULL,
    "status" cart_status NOT NULL DEFAULT 'ToPay',
    "shipping_address" varchar NOT NULL,
    "shipping_fee" integer NOT NULL,
    "voucher_id" bigint NOT NULL REFERENCES "Vouchers" ("id") ON DELETE CASCADE,	--
    "payment_info" varchar NOT NULL
);

CREATE TABLE "ProductOrdereds" (
    "id" bigserial PRIMARY KEY,
    "cart_id" bigint NOT NULL REFERENCES "Orders" ("id") ON DELETE CASCADE,				--
    "stock_id" bigint NOT NULL REFERENCES "ProductStocks" ("id")  ON DELETE CASCADE,	--
    "quantity" integer NOT NULL
);

CREATE INDEX ON "Users" ("name");
CREATE INDEX ON "Users" ("address");
CREATE INDEX ON "Orders" ("user_id");
CREATE INDEX ON "Orders" ("user_id", "status");
CREATE INDEX ON "Vouchers" ("title");
CREATE INDEX ON "Products" ("name");
CREATE INDEX ON "Categories" ("title");
CREATE INDEX ON "ProductStocks" ("product_id");
CREATE INDEX ON "ProductOrdereds" ("cart_id");