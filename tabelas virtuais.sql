CREATE DATABASE vendas_online_db;


USE vendas_online_db;


CREATE TABLE clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(120),
    cidade VARCHAR(60),
    ativo BIT DEFAULT 1
);


CREATE INDEX idx_cidade
ON clientes(cidade);


CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pedido DATE NOT NULL,

    CONSTRAINT FK_pedidos_clientes
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);


CREATE INDEX idx_data_pedido
ON pedidos(data_pedido);

USE vendas_online_db;


INSERT INTO clientes (nome, cpf, cidade)
VALUES
('Ana Souza', '11111111111', 'São Paulo'),
('Bruno Lima', '22222222222', 'São Paulo'),
('Carla Nunes', '33333333333', 'Rio de Janeiro'),
('Diego Martins', '44444444444', 'Curitiba'),
('Elisa Rocha', '55555555555', 'São Paulo');

INSERT INTO pedidos (id_cliente, valor, data_pedido)
VALUES
(1, 150.00, '2025-01-10'),
(1, 89.90, '2025-02-05'),
(2, 320.00, '2025-03-12'),
(3, 500.00, '2025-04-01'),
(3, 75.50, '2025-04-15'),
(4, 120.00, '2025-05-02');

SELECT * FROM clientes;

SELECT * FROM pedidos;

CREATE TABLE entregas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    data_entrega DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    valor_frete DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_entregas_pedidos
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);

CREATE INDEX idx_status_entrega
ON entregas(status);

INSERT INTO entregas (id_pedido, data_entrega, status, valor_frete)
VALUES
(1, '2025-01-13', 'Entregue', 25.00),
(2, '2025-02-07', 'Entregue', 18.50),
(3, '2025-03-20', 'Cancelada', 0.00),
(4, '2025-04-05', 'Entregue', 35.00),
(5, '2025-04-17', 'Pendente', 28.90),
(6, '2025-05-06', 'Entregue', 22.00);

SELECT * FROM entregas;

CREATE VIEW vw_resumo_entregas AS
SELECT
    COUNT(*) AS total_entregas,
    AVG(valor_frete) AS media_valor_frete
FROM entregas;

CREATE VIEW vw_entregas_concluidas AS
SELECT
    e.id_pedido,
    p.valor AS valor_pedido,
    e.valor_frete,
    e.data_entrega
FROM entregas e
INNER JOIN pedidos p
    ON e.id_pedido = p.id
WHERE e.status = 'Entregue';

SELECT * FROM vw_entregas_concluidas;
SELECT * FROM vw_resumo_entregas;
