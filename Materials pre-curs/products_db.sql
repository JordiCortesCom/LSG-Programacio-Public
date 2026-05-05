
-- Creació de la BBDD i l'usuari
CREATE DATABASE IF NOT EXISTS products_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE products_db;

-- Esborrem la taula si existeix per començar de zero
DROP TABLE IF EXISTS products;

-- Creació de la taula
CREATE TABLE products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    stock INT DEFAULT 0
);

-- Inserció de 20 registres de demostració (Supermercat)
INSERT INTO products (name, price, description, category, stock) VALUES
-- Fruita
('Poma Golden', 1.20, 'Poma dolça i cruixent', 'Fruita', 150),
('Maduixa del Maresme', 3.50, 'Maduixes fresques de temporada', 'Fruita', 40),
('Plàtan de Canàries', 1.80, 'Plàtan dolç i nutritiu', 'Fruita', 200),
('Taronja de València', 1.50, 'Taronja d''esprémer', 'Fruita', 100),
('Raïm Moscatell', 2.90, 'Raïm dolç', 'Fruita', 30),

-- Verdura
('Enciam Iceberg', 0.80, 'Enciam fresc i cruixent', 'Verdura', 80),
('Tomaquet de Pera', 1.90, 'Tomàquet ideal per a salses', 'Verdura', 120),
('Cebes (Malla 1kg)', 1.50, 'Cebes dolces', 'Verdura', 150),
('Bleda', 1.10, 'Bleda fresca manat', 'Verdura', 25),
('Pebrot Vermell', 2.20, 'Pebrot per escalivar', 'Verdura', 60),

-- Lactis
('Llet Sencera 1L', 0.95, 'Llet UHT pasteuritzada', 'Lactis', 300),
('Iogurt Natural (Pack 4)', 1.20, 'Iogurts sense sucres afegits', 'Lactis', 100),
('Formatge Cheddar Llescat', 2.50, 'Formatge madurat llescat', 'Lactis', 85),
('Mantega', 1.80, 'Mantega tradicional', 'Lactis', 45),
('Formatge Fresc', 1.95, 'Formatge de burgos', 'Lactis', 50),

-- Condiments i Snacks
('Oli d''Oliva Verge Extra 1L', 5.50, 'Oli d''oliva verge', 'Condiments', 60),
('Sal Fina', 0.40, 'Sal marina fina 1kg', 'Condiments', 200),
('Patates Fregides', 1.30, 'Patates clàssiques amb sal', 'Snacks', 110),
('Cacauets Torrats', 1.50, 'Cacauets sense sal', 'Snacks', 90),
('Xocolata Negra 85%', 2.10, 'Xocolata intensa', 'Snacks', 75);
