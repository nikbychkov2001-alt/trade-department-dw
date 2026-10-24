-- ============================================
-- Первичные тестовые данные для торгового отдела
-- ============================================
SET search_path TO "3nf";

INSERT INTO customer (full_name, phone, email, address) VALUES
('Иван Петров', '+79161234567', 'petrov@mail.ru', 'г. Москва, ул. Ленина, д. 10'),
('Анна Смирнова', '+79269876543', 'smirnova@gmail.com', 'г. Москва, пр. Мира, д. 25');

INSERT INTO product (name, category, price, stock_quantity) VALUES
('Ноутбук ASUS', 'Электроника', 75000.00, 15),
('Смартфон Samsung', 'Электроника', 45000.00, 30),
('Офисное кресло', 'Мебель', 12000.00, 10);

INSERT INTO employee (full_name, phone, position) VALUES
('Сергей Васильев', '+79035554433', 'Менеджер по продажам'),
('Елена Кузнецова', '+79037778899', 'Старший менеджер');

INSERT INTO orders (order_date, status, customer_id, employee_id, total_amount) VALUES
(CURRENT_TIMESTAMP - INTERVAL '2 days', 'отгружен', 1, 1, 120000.00),
(CURRENT_TIMESTAMP - INTERVAL '1 day', 'оплачен', 2, 2, 45000.00);

INSERT INTO order_item (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 75000.00, 75000.00),
(1, 2, 1, 45000.00, 45000.00),
(2, 2, 1, 45000.00, 45000.00);
