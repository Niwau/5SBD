-- tabela de carga
CREATE TEMP TABLE OrderLoader (
    order_id VARCHAR(255),
    order_item_id INT,
    purchase_date DATE,
    payments_date DATE,
    buyer_email VARCHAR(255),
    buyer_name VARCHAR(255),
    cpf VARCHAR(14),
    buyer_phone_number VARCHAR(20),
    sku VARCHAR(255),
    product_name VARCHAR(255),
    purchased_quantity INT,
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

-- pedidos
CREATE TYPE OrderStatus AS ENUM ('PAGAMENTO PENDENTE', 'PAGAMENTO REALIZADO', 'FINALIZADO');

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    order_id VARCHAR(255) UNIQUE,
    purchase_date DATE,
    payments_date DATE,
    buyer_email VARCHAR(255),
    buyer_name VARCHAR(255),
    cpf VARCHAR(14),
    buyer_phone_number VARCHAR(20),
    ship_address_1 VARCHAR(255),
    ship_address_2 VARCHAR(255),
    ship_address_3 VARCHAR(255),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(100),
    status OrderStatus
);

-- itens do pedido
CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INT,
    sku VARCHAR(255),
    product_name VARCHAR(255),
    purchased_quantity INT,
    currency VARCHAR(3),
    item_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(id)
);

-- clientes
CREATE TABLE Customers (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20)
);

-- produtos
CREATE TABLE Products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(255) UNIQUE,
    name VARCHAR(255),
    available_quantity INT DEFAULT 0
);

-- movimentação de estoque
CREATE TYPE MovementType AS ENUM ('ENTRADA', 'SAÍDA');

CREATE TABLE StockMovements (
    id SERIAL PRIMARY KEY,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    movement_type MovementType,
    movement_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(id)
);


-- compras
CREATE TABLE Restocking (
    id SERIAL PRIMARY KEY,
    product_id INT,
    needed_quantity INT,
    FOREIGN KEY (product_id) REFERENCES Products(id)
);