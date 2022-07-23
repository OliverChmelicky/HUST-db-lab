CREATE TABLE "Users" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "password" varchar NOT NULL,
  "phonenum" varchar NOT NULL,
  "address" varchar NOT NULL
);

CREATE TABLE "Orders" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT 'now()',
  "total_price" integer NOT NULL,
  "cart_status" varchar NOT NULL,
  "shipping_address" varchar NOT NULL,
  "shipping_fee" integer NOT NULL,
  "voucher_id" bigserial NOT NULL,
  "payment_info" varchar NOT NULL
);

CREATE TABLE "Vouchers" (
  "id" bigserial PRIMARY KEY,
  "title" varchar NOT NULL,
  "condition" integer NOT NULL DEFAULT 0,
  "value" integer NOT NULL,
  "date_expire" timestamptz NOT NULL
);

CREATE TABLE "Products" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "category_id" integer NOT NULL,
  "description" varchar,
  "status" varchar NOT NULL DEFAULT 'PENDING',
  "price" integer NOT NULL
);

CREATE TABLE "Category" (
  "id" bigserial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar,
  "parent_cate_id" bigint NOT NULL
);

CREATE TABLE "ProductStocks" (
  "id" bigserial PRIMARY KEY,
  "color" varchar NOT NULL,
  "size" varchar NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity_remain" integer NOT NULL
);

CREATE TABLE "ProductOrdereds" (
  "id" bigserial PRIMARY KEY,
  "cart_id" bigint NOT NULL,
  "stock_id" bigint NOT NULL,
  "quantity" integer NOT NULL
);

CREATE INDEX ON "Users" ("name");

CREATE INDEX ON "Users" ("address");

CREATE INDEX ON "Orders" ("user_id");

CREATE INDEX ON "Orders" ("user_id", "cart_status");

CREATE INDEX ON "Vouchers" ("title");

CREATE INDEX ON "Products" ("name");

CREATE INDEX ON "Category" ("title");

CREATE INDEX ON "ProductStocks" ("product_id");

CREATE INDEX ON "ProductOrdereds" ("cart_id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("voucher_id") REFERENCES "Vouchers" ("id");

ALTER TABLE "Products" ADD FOREIGN KEY ("category_id") REFERENCES "Category" ("id");

ALTER TABLE "Category" ADD FOREIGN KEY ("parent_cate_id") REFERENCES "Category" ("id");

ALTER TABLE "ProductStocks" ADD FOREIGN KEY ("product_id") REFERENCES "Products" ("id");

ALTER TABLE "ProductOrdereds" ADD FOREIGN KEY ("cart_id") REFERENCES "Orders" ("id");

ALTER TABLE "ProductOrdereds" ADD FOREIGN KEY ("stock_id") REFERENCES "ProductStocks" ("id");
