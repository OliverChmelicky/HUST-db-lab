CREATE TABLE IF NOT EXISTS public."Users"
(
    uid integer NOT NULL,
    name character varying NOT NULL,
    password character varying NOT NULL,
    phonenum character varying NOT NULL,
    address character varying NOT NULL,
    PRIMARY KEY (uid)
);

CREATE TABLE IF NOT EXISTS public."Orders"
(
    card_id integer NOT NULL,
    user_id integer NOT NULL,
    created_date timestamp without time zone NOT NULL,
    total_price integer NOT NULL,
    cart_status character varying NOT NULL,
    shipping_address character varying NOT NULL,
    shipping_fee integer NOT NULL,
    voucher_id integer NOT NULL,
    payment_info character varying NOT NULL,
    PRIMARY KEY (card_id)
);

CREATE TABLE IF NOT EXISTS public."Vouchers"
(
    voucher_id integer NOT NULL,
    condition integer,
    value integer NOT NULL,
    date_expire timestamp without time zone,
    PRIMARY KEY (voucher_id)
);

CREATE TABLE IF NOT EXISTS public."Products"
(
    product_id integer NOT NULL,
    p_name character varying NOT NULL,
    category_id integer NOT NULL,
    description character varying,
    status character varying,
    price integer NOT NULL,
    PRIMARY KEY (product_id)
);

CREATE TABLE IF NOT EXISTS public."ProductDetail"
(
    pd_id integer NOT NULL,
    color character varying NOT NULL,
    size character varying NOT NULL,
    product_id integer NOT NULL,
    PRIMARY KEY (pd_id)
);

CREATE TABLE IF NOT EXISTS public."Category"
(
    category_id integer NOT NULL,
    title character varying NOT NULL,
    description character varying,
    parent_category integer,
    PRIMARY KEY (category_id)
);

CREATE TABLE IF NOT EXISTS public."Stocks"
(
    pv_id integer NOT NULL,
    quantity_remain integer NOT NULL,
    PRIMARY KEY (pv_id)
);

CREATE TABLE IF NOT EXISTS public."ProductOrdereds"
(
    po_id integer NOT NULL,
    cart_id integer NOT NULL,
    pv_id integer NOT NULL,
    quantity integer NOT NULL,
    PRIMARY KEY (po_id)
);