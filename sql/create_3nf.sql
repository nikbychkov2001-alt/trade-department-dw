-- ============================================
-- Создаем схему 3NF для торгового отдела
-- ============================================
CREATE SCHEMA IF NOT EXISTS "3nf";
SET search_path TO "3nf";

-- ============================================
-- Таблица: Клиенты
-- ============================================
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- ============================================
-- Таблица: Товары
-- ============================================
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

-- ============================================
-- Таблица: Сотрудники (Менеджеры торгового отдела)
-- ============================================
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    position VARCHAR(50) NOT NULL
);

-- ============================================
-- Таблица: Заказы (продажи торгового отдела)
-- ============================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL CHECK (status IN ('новый', 'оплачен', 'отгружен', 'отменен')),
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id) ON DELETE SET NULL
);

-- ============================================
-- Таблица: Позиции заказа (связь многие-ко-многим)
-- ============================================
CREATE TABLE order_item (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id)
        REFERENCES product (product_id) ON DELETE CASCADE
);

-- ============================================
-- Индексы
-- ============================================
CREATE INDEX idx_customer_phone ON customer (phone);
CREATE INDEX idx_order_status ON orders (status);
CREATE INDEX idx_order_customer ON orders (customer_id);
