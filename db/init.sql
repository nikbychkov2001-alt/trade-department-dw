CREATE TABLE IF NOT EXISTS board_games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    min_players INT NOT NULL,
    max_players INT NOT NULL,
    duration_minutes INT NOT NULL,
    genre VARCHAR(100),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Первичные данные клубной коллекции
INSERT INTO board_games (title, min_players, max_players, duration_minutes, genre) VALUES
('Каркассон', 2, 5, 45, 'Стратегия'),
('Колонизаторы (Catan)', 3, 4, 90, 'Экономическая'),
('Имаджинариум', 4, 7, 30, 'Ассоциации'),
('Монополия', 2, 6, 120, 'Экономическая'),
('Манчкин', 3, 6, 60, 'Карточная / Пародия');
