-- tabela de carga
CREATE TEMP TABLE temp_orders (
    order_id VARCHAR(255),
    order_item_id INT,
    purchase_date DATE,
    payments_date DATE,
    buyer_email VARCHAR(255),
    buyer_name VARCHAR(255),
    cpf VARCHAR(14),
    buyer_phone_number VARCHAR(20),
    sku VARCHAR(255),
    upc VARCHAR(255),
    product_name VARCHAR(255),
    quantity_purchased INT,
    currency VARCHAR(10),
    item_price DECIMAL(10, 2),
    ship_service_level VARCHAR(255),
    recipient_name VARCHAR(255),
    ship_address_1 VARCHAR(255),
    ship_address_2 VARCHAR(255),
    ship_address_3 VARCHAR(255),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(100),
    ioss_number VARCHAR(255)
);

-- carrega o csv para a tabela temporária
COPY temp_orders FROM 'C:\Users\Guilherme\Desktop\pedido.csv' DELIMITER ',' CSV HEADER;

-- insere os dados nas tabelas definitivas
INSERT INTO Orders (order_id, purchase_date, payments_date, buyer_email, buyer_name, cpf, buyer_phone_number, ship_address_1, ship_address_2, ship_address_3, ship_city, ship_state, ship_postal_code, ship_country)
SELECT DISTINCT order_id, purchase_date, payments_date, buyer_email, buyer_name, cpf, buyer_phone_number, ship_address_1, ship_address_2, ship_address_3, ship_city, ship_state, ship_postal_code, ship_country
FROM temp_orders
ON CONFLICT DO NOTHING;

-- insere os dados na tabela itens do pedido
INSERT INTO OrderItems (order_id, sku, product_name, quantity_purchased, currency, item_price)
SELECT O.id, temp_orders.sku, temp_orders.product_name, temp_orders.quantity_purchased, temp_orders.currency, temp_orders.item_price
FROM temp_orders
INNER JOIN Orders O ON O.order_id = temp_orders.order_id;

-- insere os dados na tabela clientes
INSERT INTO Customers (cpf, name, email, phone)
SELECT DISTINCT cpf, buyer_name, buyer_email, buyer_phone_number
FROM temp_orders
ON CONFLICT DO NOTHING;

-- insere os dados na tabela produtos sem repetir
INSERT INTO Products (sku, upc, name, stock)
SELECT DISTINCT sku, upc, product_name, 0
FROM temp_orders
WHERE NOT EXISTS (
    SELECT 1
    FROM Products
    WHERE Products.sku = temp_orders.sku
);

-- insere os dados na tabela compras
INSERT INTO Purchases (product_id, quantity, purchase_date)
SELECT P.id, temp_orders.quantity_purchased, temp_orders.purchase_date
FROM temp_orders
JOIN Products P ON P.sku = temp_orders.sku
ON CONFLICT DO NOTHING;

-- limpa a tabela temporária
TRUNCATE TABLE temp_orders;
