CREATE TYPE "cart_status" AS ENUM (
    'ToPay',
    'ToShip',
    'ToReceive',
    'Completed',
    'Cancel'
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
    "condition" integer NOT NULL DEFAULT 0,
    "value" integer NOT NULL,
    "date_expire" timestamp NOT NULL
);
CREATE TABLE "Category" (
    "id" bigserial PRIMARY KEY,
    "title" varchar NOT NULL,
    "description" varchar,
    "parent_cate_id" bigint REFERENCES "Category" ("id")
);
CREATE TABLE "Products" (
    "id" bigserial PRIMARY KEY,
    "name" varchar NOT NULL,
    "category_id" bigint NOT NULL REFERENCES "Category" ("id"),
    "description" varchar,
    "price" integer NOT NULL
);
CREATE TABLE "ProductStocks" (
    "id" bigserial PRIMARY KEY,
    "color" varchar NOT NULL,
    "size" varchar NOT NULL,
    "product_id" bigint REFERENCES "Products" ("id"),
    "quantity_remain" integer NOT NULL
);
CREATE TABLE "Orders" (
    "id" bigserial PRIMARY KEY,
    "user_id" bigint NOT NULL REFERENCES "Users" ("id"),
    "created_at" timestamp NOT NULL DEFAULT 'now()',
    "total_price" integer NOT NULL,
    "status" cart_status NOT NULL DEFAULT 'ToPay',
    "shipping_address" varchar NOT NULL,
    "shipping_fee" integer NOT NULL,
    "voucher_id" bigint NOT NULL REFERENCES "Vouchers" ("id"),
    "payment_info" varchar NOT NULL
);
CREATE TABLE "ProductOrdereds" (
    "id" bigserial PRIMARY KEY,
    "cart_id" bigint NOT NULL REFERENCES "Orders" ("id"),
    "stock_id" bigint NOT NULL REFERENCES "ProductStocks" ("id"),
    "quantity" integer NOT NULL
);
CREATE INDEX ON "Users" ("name");
CREATE INDEX ON "Users" ("address");
CREATE INDEX ON "Orders" ("user_id");
CREATE INDEX ON "Orders" ("user_id", "status");
CREATE INDEX ON "Vouchers" ("title");
CREATE INDEX ON "Products" ("name");
CREATE INDEX ON "Category" ("title");
CREATE INDEX ON "ProductStocks" ("product_id");
CREATE INDEX ON "ProductOrdereds" ("cart_id");s