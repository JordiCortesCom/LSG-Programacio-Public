-- ============================================
-- Schema de referència del curs Spring Boot + BBDD
-- Taula única: products (sense relacions)
-- ============================================

CREATE DATABASE IF NOT EXISTS products_db;
USE products_db;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    price       DECIMAL(10,2) NOT NULL,
    description TEXT,
    category    VARCHAR(50),
    stock       INT DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dades inicials per treballar des de la Sessió 2
INSERT INTO products (name, price, description, category, stock) VALUES
('Poma Golden',     1.20, 'Poma dolça d''origen espanyol',          'Fruita',      150),
('Plàtan Canàries', 0.90, 'Plàtan de les Illes Canàries',           'Fruita',      200),
('Enciam Iceberg',  0.75, 'Enciam fresc de producció local',        'Verdura',      80),
('Tomàquet Pera',   2.10, 'Tomàquet ideal per amanides',             'Verdura',     120),
('Llet Sencera',    1.05, 'Llet sencera 1L de vaca de pastura',     'Lactis',      300),
('Iogurt Natural',  0.45, 'Iogurt natural sense sucre afegit',      'Lactis',      250),
('Pa de Motlle',    1.80, 'Pa de motlle integral 500g',              'Forn',        100),
('Croissant',       0.60, 'Croissant de mantega artesanal',          'Forn',        180),
('Arròs Bomba',     2.50, 'Arròs bomba 1kg ideal per paella',       'Cereals',      90),
('Pasta Fusilli',   1.15, 'Pasta de blat dur 500g',                  'Cereals',     200),
('Pechuga de Pollo',5.90, 'Pechuga de pollastre fresca 1kg',        'Carn',         60),
('Salmó Fresc',     8.50, 'Filet de salmó atlàntic 400g',           'Peix',         40),
('Oli d''Oliva',    4.75, 'Oli d''oliva verge extra 1L',            'Condiments',  150),
('Sal Marina',      0.80, 'Sal marina gruixuda 1kg',                 'Condiments',  300),
('Xocolata Negra',  2.30, 'Xocolata 70% cacau 100g',                'Snacks',      170),
('Aigua Mineral',   0.35, 'Aigua mineral natural 1.5L',              'Begudes',     500),
('Suc de Taronja',  1.60, 'Suc de taronja natural 1L',              'Begudes',     220),
('Cafe Mòlt',       3.20, 'Cafè 100% aràbica mòlt 250g',           'Begudes',     130),
('Formatge Manxec', 6.40, 'Formatge manxec curat 300g',             'Lactis',       55),
('Mel de Flors',    5.10, 'Mel artesanal de flors silvestres 500g', 'Condiments',   70);
