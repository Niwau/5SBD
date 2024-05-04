-- pedidos
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
    ship_country VARCHAR(100)
);

-- itens do pedido
CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INT,
    sku VARCHAR(255),
    product_name VARCHAR(255),
    quantity_purchased INT,
    currency VARCHAR(10),
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
    upc VARCHAR(255),
    name VARCHAR(255),
    stock INT
);

-- compras
CREATE TABLE Purchases (
    id SERIAL PRIMARY KEY,
    product_id INT,
    quantity INT,
    purchase_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(id)
);
