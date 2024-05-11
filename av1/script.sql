-- CARREGA O CSV DE PEDIDOS PARA A TABELA TEMPORÁRIA
COPY OrderLoader FROM './pedido.sql' DELIMITER ',' CSV HEADER;

-- INSERINDO OS CLIENTES QUE NÃO ESTÃO CADASTRADOS
INSERT INTO Customers 
    SELECT cpf, buyer_name, buyer_email, buyer_phone_number
    FROM OrderLoader WHERE NOT EXISTS (
        SELECT 1
        FROM Customers
        WHERE Customers.cpf = OrderLoader.cpf
    );

-- INSERINDO PEDIDOS E ALTERANDO STATUS
INSERT INTO Orders
    SELECT
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
            WHEN payment_date IS NOT NULL THEN 'PAGAMENTO REALIZADO'
            ELSE 'PAGAMENTO PENDENTE'
        END AS status
    FROM OrderLoader;

-- INSERINDO ITENS DE PEDIDO
INSERT INTO OrderItems (order_id, sku, product_name, purchased_quantity, currency, item_price)
    SELECT order_id, sku, product_name, purchased_quantity, currency, item_price
    FROM OrderLoader;

-- INSERINDO PRODUTOS QUE NÃO ESTÃO CADASTRADOS
INSERT INTO Products (sku, name)
    SELECT sku, product_name FROM OrderLoader
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
    JOIN Orders ON Orders.order_id = OrderItems.id
    ORDER BY OrderItems.purchased_quantity * OrderItems.item_price;

-- VERIFICAR E ATUALIZAR O ESTOQUE
WITH MovementItems AS (
    SELECT
        product_id,
        SUM(CASE WHEN movement_type = 'SAÍDA' THEN -quantity ELSE quantity END) AS total_quantity
    FROM StockMovements
    GROUP BY product_id
);

-- ATUALIZAR A QUANTIDADE DISPONÍVEL DE PRODUTOS
UPDATE Products p
SET available_quantity = available_quantity - im.total_quantity
FROM MovementItems im
WHERE p.id = im.product_id
AND p.available_quantity >= im.total_quantity;

-- ADICIONAR REGISTROS DE REABASTECIMENTO DE ESTOQUE
INSERT INTO Restocking (product_id, needed_quantity)
SELECT
    im.product_id,
    -im.total_quantity  -- Quantidade negativa indica que é necessário reabastecer o estoque
FROM MovementItems im
JOIN Products p ON p.id = im.product_id
WHERE p.available_quantity < im.total_quantity;

-- LIMPANDO A TABELA TEMPORÁRIA
TRUNCATE TABLE OrderLoader;
