DROP TABLE IF EXISTS product_ordereds;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_stocks;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS vouchers;
DROP TABLE IF EXISTS users;

DROP TYPE IF EXISTS cart_status;
DROP TYPE IF EXISTS voucher_type;

CREATE TYPE cart_status AS ENUM (
    'ToPay',
    'ToShip',
    'ToReceive',
    'Completed',
    'Cancel'
);

CREATE TYPE voucher_type AS ENUM (
    'Cash',
    'Discount',
    'FreeShip'
);

CREATE TABLE users (
    id bigserial PRIMARY KEY,
    name varchar NOT NULL,
    password varchar NOT NULL,
    phonenum varchar NOT NULL,
    address varchar NOT NULL
);

CREATE TABLE vouchers (
    id bigserial PRIMARY KEY,
    title varchar NOT NULL,
    type voucher_type NOT NULL,
    condition NUMERIC(2) NOT NULL DEFAULT 0,
    value integer NOT NULL,
    date_expire timestamptz NOT NULL
);

CREATE TABLE categories (
    id bigserial PRIMARY KEY,
    title varchar NOT NULL,
    description varchar,
    parent_cate_id bigint DEFAULT 0 REFERENCES categories (id) ON DELETE CASCADE
);

CREATE TABLE products (
    id bigserial PRIMARY KEY,
    name varchar NOT NULL,
    category_id bigint NOT NULL DEFAULT 0 REFERENCES categories (id) ON DELETE SET DEFAULT,
    description varchar,
    price integer NOT NULL
);

CREATE TABLE product_stocks (
    id bigserial PRIMARY KEY,
    product_id bigint REFERENCES products (id) ON DELETE CASCADE,
    color varchar NOT NULL,
    size varchar NOT NULL,
    quantity_remain integer NOT NULL
);

CREATE TABLE orders (
    id bigserial PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES users (id) ON DELETE CASCADE,			-- 
    created_at timestamptz NOT NULL DEFAULT 'now()',
    status cart_status NOT NULL DEFAULT 'ToPay',
    shipping_address varchar NOT NULL,
    shipping_fee integer NOT NULL,
    voucher_id bigint NOT NULL REFERENCES vouchers (id) ON DELETE CASCADE,	--
    total_price integer NOT NULL,
    payment_info varchar NOT NULL
);


CREATE TABLE product_ordereds (
    id bigserial PRIMARY KEY,
    cart_id bigint NOT NULL REFERENCES orders (id) ON DELETE CASCADE,					--
    stock_id bigint NOT NULL REFERENCES product_stocks (id)  ON DELETE CASCADE,			--
    purchase_price int, 
    quantity integer NOT NULL
);

CREATE INDEX ON users (name);
CREATE INDEX ON orders (user_id);
CREATE INDEX ON orders (user_id, status);
CREATE INDEX ON vouchers (title);
CREATE INDEX ON products (name);
CREATE INDEX ON categories (title);
CREATE INDEX ON product_stocks (product_id);
CREATE INDEX ON product_ordereds (cart_id);