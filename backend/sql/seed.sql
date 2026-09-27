INSERT INTO roles (name, description) VALUES
  ('ADMINISTRADOR', 'Acesso administrativo completo'),
  ('COLABORADOR', 'Acesso operacional'),
  ('ENTREGADOR', 'Acesso às entregas'),
  ('CLIENTE', 'Acesso à área do cliente')
ON CONFLICT (name) DO NOTHING;

INSERT INTO permissions (code, description) VALUES
  ('dashboard.read', 'Visualizar dashboard'),
  ('orders.read', 'Visualizar pedidos'),
  ('orders.manage', 'Gerenciar pedidos'),
  ('products.read', 'Visualizar produtos'),
  ('products.manage', 'Cadastrar e alterar produtos'),
  ('stock.read', 'Visualizar estoque'),
  ('stock.manage', 'Gerenciar estoque'),
  ('payments.read', 'Visualizar pagamentos'),
  ('payments.manage', 'Gerenciar pagamentos'),
  ('users.read', 'Visualizar usuários'),
  ('users.manage', 'Gerenciar usuários'),
  ('deliveries.read', 'Visualizar entregas'),
  ('deliveries.manage', 'Gerenciar entregas'),
  ('reports.read', 'Visualizar relatórios')
ON CONFLICT (code) DO NOTHING;

INSERT INTO categories (name, description) VALUES
  ('Hambúrgueres', 'Hambúrgueres e sanduíches'),
  ('Porções', 'Porções e acompanhamentos'),
  ('Hot Dogs', 'Hot dogs'),
  ('Combos', 'Combos do cardápio'),
  ('Bebidas', 'Bebidas e sucos'),
  ('Sobremesas', 'Sobremesas, açaí, sorvete e pudim')
ON CONFLICT (name) DO NOTHING;

-- Administrador recebe todas as permissões.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r CROSS JOIN permissions p
WHERE r.name = 'ADMINISTRADOR'
ON CONFLICT DO NOTHING;

-- Colaborador: operação de pedidos, produtos e estoque.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r JOIN permissions p ON p.code IN (
  'dashboard.read','orders.read','orders.manage','products.read',
  'stock.read','stock.manage'
)
WHERE r.name = 'COLABORADOR'
ON CONFLICT DO NOTHING;

-- Entregador: entregas e consulta de pedidos.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r JOIN permissions p ON p.code IN ('orders.read','deliveries.read','deliveries.manage')
WHERE r.name = 'ENTREGADOR'
ON CONFLICT DO NOTHING;

-- Cliente: catálogo e seus pedidos.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r JOIN permissions p ON p.code IN ('products.read','orders.read')
WHERE r.name = 'CLIENTE'
ON CONFLICT DO NOTHING;

INSERT INTO categories (name, description) VALUES
('Bebidas','Bebidas geladas'),('Sobremesas','Doces e sobremesas'),('Açaí','Açaí e complementos')
ON CONFLICT (name) DO NOTHING;

INSERT INTO products (category_id,name,description,price,image_url,stock_quantity,minimum_stock)
SELECT c.id,'Aki Burger','Pão, carne, queijo, alface e molho especial',24.90,'./assets/menu/aki-burger.jpg',50,10 FROM categories c WHERE c.name='Hambúrgueres'
AND NOT EXISTS (SELECT 1 FROM products WHERE name='Aki Burger');
INSERT INTO products (category_id,name,description,price,image_url,stock_quantity,minimum_stock)
SELECT c.id,'Batata Frita','Porção de batata crocante',12.90,'./assets/menu/batata.jpg',50,10 FROM categories c WHERE c.name='Porções'
AND NOT EXISTS (SELECT 1 FROM products WHERE name='Batata Frita');
INSERT INTO products (category_id,name,description,price,image_url,stock_quantity,minimum_stock)
SELECT c.id,'Refrigerante Lata','Lata 350ml',6.00,'./assets/menu/refrigerante.jpg',80,15 FROM categories c WHERE c.name='Bebidas'
AND NOT EXISTS (SELECT 1 FROM products WHERE name='Refrigerante Lata');
