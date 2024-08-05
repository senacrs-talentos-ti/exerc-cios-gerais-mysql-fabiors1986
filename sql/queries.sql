CREATE DATABASE STORE;
-- 1-Crie a tabela CLIENTS com as seguintes colunas
USE STORE;
CREATE TABLE clients( 
id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50)not null,
    email VARCHAR(50)not null
  );
  -- 2-Crie a tabela PRODUCTS com as seguintes colunas
  use store;
  create table products(
  id int auto_increment primary key,
  nome varchar(50) not null,
  price decimal(10,2)not null
  );
  -- Crie a tabela ORDERS com as seguintes colunas
  use store;
CREATE TABLE ORDERS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    order_date DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);
-- 4 - Crie a tabela ORDER_ITEMS com as seguintes colunas
use store;
create table orders_itens(
order_id int,
product_id int,
quantity int not null,
price decimal(10,2) not null,
foreign key(order_id) references ORDERS(id),
foreign key(product_id) references products(id)
);
  -- Insira dados nas tabelas CLIENTS e PRODUCTS.
  use store;
  insert into clients(nome,email)values
('fabio','rodrigues@com'),
('khaled','borges@com'),
('lucio','lucio@com'),
('paulim','paulin@com'),
('nanse','nanse@com'),
('vaca','vaca@com');
---------------------------
 insert into products(nome,price)values
('monitor',2500),
('notebook',4500),
('mouse',40),
('cpu','2000'),
('caixa de som','70'),
('webcam','35');
-- 6 - Insira dados na tabela ORDERS.
INSERT INTO ORDERS (client_id,order_date,total) values
(1,'2024-05-18',3),
(2,'2024-05-20',2),
(3,'2024-05-24',1),
(2,'2024-06-02',4),
(4,'2024-05-05',2);
-- Insira dados na tabela ORDER_ITEMS.
use store;
insert into orders_itens(order_id,product_id,quantity,price) values
(1,1,2,300),
(2,2,2,300),
(3,3,2,300),
(4,4,2,300);
select * from orders_itens;
/* Atualize o preço de um produto na tabela PRODUCTS 
 e todos os registros relacionados na tabela ORDER_ITEMS.*/
 use store;
 UPDATE products SET price = 2550 WHERE id = 1;
 update orders_itens set quantity = 3 where order_id = 3 and product_id =3;

# Delete um cliente e todos os pedidos relacionados.
use store;
delete from orders_itens where order_id = 4 and product_id =4;
delete from ORDERS where client_id = 4;
delete from clients where id = 4;
select *from clients;
# Altere a tabela CLIENTS para adicionar uma coluna de data de nascimento (birthdate);
use store;
ALTER TABLE clients
ADD COLUMN birthdate DATE;
-- Faça uma consulta usando JOIN para listar todos os pedidos com os nomes dos 
# clientes e os nomes dos produtos.
use store;
select clients.nome as clients,products.nome as products
from clients
inner join products
on clients.id=products.id;
#Faça uma consulta usando LEFT JOIN para listar todos os clientes 
#e seus pedidos, incluindo clientes sem pedidos.
use store;
select clients.nome as clients,ORDERS.client_id as order_
from clients
left join ORDERS
on clients.id = ORDERS.client_id;
/*Faça uma consulta usando RIGHT JOIN para listar todos os produtos e os 
 pedidos que os contêm, incluindo produtos que não foram pedidos. */
 use store;
 select products.nome as products, ORDERS.id as orders 
from ORDERS
inner join orders_itens on ORDERS.id = orders_itens.order_id
right join products on products.id = orders_itens.product_id;
-- Utilize funções de agregação para obter o total de vendas e a quantidade total de itens vendidos.
use store;
-- Total de Vendas
SELECT SUM(ORDERS.total) AS total_vendas, SUM(orders_itens.quantity) AS quantidade_total_itens
FROM ORDERS
inner JOIN orders_itens
on ORDERS.id = orders_itens.order_id;
select * from ORDERS;
-- Faça uma consulta para listar todos os clientes e a quantidade total de pedidos realizados por 
-- cada um, ordenados pela quantidade de pedidos em ordem decrescente.
 use store;
SELECT 
    clients.nome AS client_nome,
    COUNT(ORDERS.id) AS total_orders
FROM clients
LEFT JOIN ORDERS ON clients.id = ORDERS.client_id
GROUP BY clients.nome
ORDER BY total_orders DESC;
-- Faça uma consulta para listar todos os produtos e a quantidade total de 
-- cada produto vendido, ordenados pela quantidade em ordem decrescente.
use store;
SELECT 
    products.nome AS products_nome,
    sum(orders_itens.product_id) AS total_orders
FROM products
LEFT JOIN orders_itens ON products.id = orders_itens.product_id
GROUP BY products.nome
ORDER BY total_orders DESC;
-- Faça uma consulta para listar todos os clientes e o valor total gasto 
-- por cada um, ordenados pelo valor gasto em ordem decrescente.
use store;
select clients.nome as nome_clientes,
sum(orders_itens.price) as total_price
from orders_itens
inner join ORDERS ON orders_itens.order_id = ORDERS.id
right join clients on clients.id = ORDERS.client_id
GROUP BY clients.nome
ORDER BY total_price DESC;

select * from products;
-- Faça uma consulta para listar os 3 produtos mais vendidos 
-- (em quantidade) e o total de vendas de cada um.
use store;
select products.nome as products_nome,
sum(orders_itens.price) as total_price
from orders_itens
right join products on products.id = orders_itens.product_id
group by products_nome
order by total_price desc
limit 3;
-- Faça uma consulta para listar a média de 
-- quantidade de produtos por pedido para cada cliente.
use store;
SELECT TRUNCATE(AVG(orders_itens.quantity), 2) as qtd_pro, clients.nome 
FROM clients
inner join ORDERS on ORDERS.client_id = clients.id
inner join orders_itens on orders_itens.order_id = ORDERS.id
group by clients.nome;
select * from orders_itens;
-- Faça uma consulta para listar o total de pedidos e o total de clientes por mês.
use store;
SELECT 
    month(ORDERS.order_date) AS mes,
    COUNT(ORDERS.client_id) AS total_pedidos,
    COUNT(clients.id) AS total_clientes
FROM 
    ORDERS
inner JOIN 
    clients  ON ORDERS.client_id = clients.id
GROUP BY 
month(ORDERS.order_date)
ORDER BY 
    mes;
   -- Faça uma consulta para listar os produtos que nunca foram vendidos.
   use store;
select products.nome as prod_nome
from orders_itens
right join products on orders_itens.product_id = products.id
where orders_itens.order_id is null;

-- Faça uma consulta para listar os pedidos que contêm mais de 2 itens diferentes.
use store;
SELECT orders_itens.order_id as orders, COUNT(distinct orders_itens.product_id) as produtos
FROM orders_itens
GROUP BY orders
having produtos > 1;
-- Faça uma consulta para listar os clientes que fizeram pedidos no último mês.
use store;
SELECT 
    month(ORDERS.order_date) AS mes,
    COUNT(clients.id) AS total_clientes
FROM 
    ORDERS
inner JOIN 
    clients  ON ORDERS.client_id = clients.id
GROUP BY 
month(ORDERS.order_date)
ORDER BY 
    mes;


-- Faça uma consulta para listar os clientes com o maior valor médio por pedido.












