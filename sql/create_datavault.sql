-- ============================================
-- Схема Data Vault для торгового отдела
-- ============================================
CREATE SCHEMA IF NOT EXISTS dv;
SET search_path TO dv;

-- ============================================
-- HUBS (Хабы)
-- ============================================
CREATE TABLE hub_customer (
    customer_hkey UUID PRIMARY KEY,
    customer_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_product (
    product_hkey UUID PRIMARY KEY,
    product_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_employee (
    employee_hkey UUID PRIMARY KEY,
    employee_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_order (
    order_hkey UUID PRIMARY KEY,
    order_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- ============================================
-- LINKS (Ссылки)
-- ============================================
CREATE TABLE link_order_customer (
    link_order_customer_hkey UUID PRIMARY KEY,
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    customer_hkey UUID NOT NULL REFERENCES hub_customer(customer_hkey),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE link_order_employee (
    link_order_employee_hkey UUID PRIMARY KEY,
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    employee_hkey UUID NOT NULL REFERENCES hub_employee(employee_hkey),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE link_order_product (
    link_order_product_hkey UUID PRIMARY KEY,
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    product_hkey UUID NOT NULL REFERENCES hub_product(product_hkey),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- ============================================
-- SATELLITES (Сателлиты)
-- ============================================
CREATE TABLE sat_customer (
    customer_hkey UUID NOT NULL REFERENCES hub_customer(customer_hkey),
    full_name VARCHAR(100),
    email VARCHAR(100),
    address TEXT,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_hkey, load_date)
);

CREATE TABLE sat_product (
    product_hkey UUID NOT NULL REFERENCES hub_product(product_hkey),
    name VARCHAR(150),
    category VARCHAR(50),
    price NUMERIC(10,2),
    stock_quantity INT,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (product_hkey, load_date)
);

CREATE TABLE sat_employee (
    employee_hkey UUID NOT NULL REFERENCES hub_employee(employee_hkey),
    full_name VARCHAR(100),
    position VARCHAR(50),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (employee_hkey, load_date)
);

CREATE TABLE sat_order (
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    order_date TIMESTAMP,
    status VARCHAR(30),
    total_amount NUMERIC(12,2),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (order_hkey, load_date)
);

CREATE TABLE sat_order_item (
    link_order_product_hkey UUID NOT NULL REFERENCES link_order_product(link_order_product_hkey),
    quantity INT,
    unit_price NUMERIC(10,2),
    subtotal NUMERIC(12,2),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (link_order_product_hkey, load_date)
);
