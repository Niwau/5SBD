-- pedidos
CREATE TYPE OrderStatus AS ENUM ('PAGAMENTO PENDENTE', 'PAGAMENTO REALIZADO', 'FINALIZADO');

CREATE TABLE IF NOT EXISTS Orders (
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
    order_id VARCHAR(255),
    sku VARCHAR(255),
    product_name VARCHAR(255),
    purchased_quantity INT,
    currency VARCHAR(3),
    item_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
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

-- CRIANDO TABELA DE CARGA
CREATE TEMP TABLE IF NOT EXISTS OrderLoader (
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

-- CARREGA O CSV DE PEDIDOS PARA A TABELA TEMPORÁRIA
COPY OrderLoader FROM 'C:\Users\Guilherme\Desktop\pedido.csv' DELIMITER ',' CSV HEADER;

-- INSERINDO OS CLIENTES QUE NÃO ESTÃO CADASTRADOS
INSERT INTO Customers (cpf, name, email, phone)
    SELECT DISTINCT cpf, buyer_name, buyer_email, buyer_phone_number
    FROM OrderLoader WHERE NOT EXISTS (
        SELECT 1
        FROM Customers
        WHERE Customers.cpf = OrderLoader.cpf
    );

-- INSERINDO PEDIDOS E ALTERANDO STATUS
INSERT INTO Orders (
		order_id,
        purchase_date,
        payments_date,
        buyer_email,
        buyer_name,
        cpf,
        buyer_phone_number,
        ship_address_1,
        ship_address_2,
        ship_address_3,
        ship_city,
        ship_state,
        ship_postal_code,
        ship_country,
		status
	)
    SELECT DISTINCT
		order_id,
        purchase_date,
        payments_date,
        buyer_email,
        buyer_name,
        cpf,
        buyer_phone_number,
        ship_address_1,
        ship_address_2,
        ship_address_3,
        ship_city,
        ship_state,
        ship_postal_code,
        ship_country,
        CASE
            WHEN payments_date IS NOT NULL THEN 'PAGAMENTO REALIZADO'::OrderStatus
            ELSE 'PAGAMENTO PENDENTE'::OrderStatus
        END AS status
    FROM OrderLoader;

-- INSERINDO ITENS DE PEDIDO
INSERT INTO OrderItems (order_id, sku, product_name, purchased_quantity, currency, item_price)
    SELECT order_id, sku, product_name, purchased_quantity, currency, item_price
    FROM OrderLoader;

-- INSERINDO PRODUTOS QUE NÃO ESTÃO CADASTRADOS
INSERT INTO Products (sku, name)
    SELECT DISTINCT sku, product_name FROM OrderLoader
    WHERE NOT EXISTS ( 
        SELECT 1
        FROM Products
        WHERE Products.sku = OrderLoader.sku
    );

-- ATUALIZANDO A TABELA DE MOVIMENTAÇÃO DE ESTOQUE
INSERT INTO StockMovements (product_id, quantity, price, movement_type, movement_date)
    SELECT
        Orders.id,
        OrderItems.purchased_quantity,
        OrderItems.item_price,
        'SAÍDA',
        Orders.purchase_date
    FROM OrderItems
    JOIN Orders ON Orders.order_id = OrderItems.order_id
    ORDER BY OrderItems.purchased_quantity * OrderItems.item_price DESC;

-- VERIFICAR E ATUALIZAR O ESTOQUE


-- LIMPANDO A TABELA TEMPORÁRIA
TRUNCATE TABLE OrderLoader;
