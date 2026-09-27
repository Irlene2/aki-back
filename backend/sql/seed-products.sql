INSERT INTO products(category_id,name,description,price,image_url,stock_quantity,minimum_stock,sku)
SELECT c.id, v.name, v.description, v.price, v.image_url, v.stock_quantity, v.minimum_stock, v.sku
FROM (VALUES
('Hambúrgueres','Aki Classic','Pão brioche, blend artesanal, queijo, alface, tomate e molho especial.',24.90,'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=900&q=85',50,10,'AKI-BUR-001'),
('Hambúrgueres','X-Bacon Aki','Blend artesanal, queijo, bacon crocante e molho especial da casa.',29.90,'https://images.unsplash.com/photo-1553979459-d2229ba7433b?auto=format&fit=crop&w=900&q=85',50,10,'AKI-BUR-002'),
('Hambúrgueres','Smash Duplo','Dois smash burgers, cheddar cremoso, cebola e molho Aki.',34.90,'https://images.unsplash.com/photo-1600891964092-4316c288032e?auto=format&fit=crop&w=900&q=85',40,8,'AKI-BUR-003'),
('Hambúrgueres','X-Egg Especial','Carne, queijo, ovo, presunto, alface, tomate e maionese.',27.90,'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=900&q=85',40,8,'AKI-BUR-004'),
('Porções','Batata Frita','Batatas douradas, crocantes e sequinhas.',14.90,'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=900&q=85',60,10,'AKI-POR-001'),
('Porções','Batata Cheddar & Bacon','Batata crocante coberta com cheddar e bacon.',19.90,'https://images.unsplash.com/photo-1585109649139-366815a0d713?auto=format&fit=crop&w=900&q=85',50,10,'AKI-POR-002'),
('Porções','Onion Rings','Anéis de cebola empanados, dourados e crocantes.',17.90,'https://images.unsplash.com/photo-1639024471283-03518883512d?auto=format&fit=crop&w=900&q=85',40,8,'AKI-POR-003'),
('Porções','Nuggets Crocantes','Nuggets crocantes acompanhados de molho especial.',16.90,'https://images.unsplash.com/photo-1562967916-eb82221dfb92?auto=format&fit=crop&w=900&q=85',50,10,'AKI-POR-004'),
('Hot Dogs','Hot Dog Especial','Salsicha, purê, queijo, milho, batata palha e molhos.',22.90,'https://img0.didiglobal.com/static/soda_public/img_54443e1df42a6c452fceaab6bd1c54e6.jpg',40,8,'AKI-HOT-001'),
('Hot Dogs','Hot Dog Bacon','Salsicha, bacon, queijo, milho, ervilha e batata palha.',26.90,'https://www.thedailymeal.com/img/gallery/10-creative-hot-dog-ideas-for-your-next-backyard-bash-slideshow/2_bacon%20dog_andiphoto-Shutterstock.jpg',40,8,'AKI-HOT-002'),
('Combos','Combo Aki Classic','Aki Classic, batata frita e refrigerante lata.',36.90,'https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=900&q=85',30,6,'AKI-COM-001'),
('Combos','Combo X-Bacon','X-Bacon, batata cheddar com bacon e refrigerante.',45.90,'https://images.unsplash.com/photo-1550317138-10000687a72b?auto=format&fit=crop&w=900&q=85',30,6,'AKI-COM-002'),
('Combos','Combo Família','Dois hambúrgueres, batata grande e duas bebidas.',69.90,'https://images.unsplash.com/photo-1565299507177-b0ac66763828?auto=format&fit=crop&w=900&q=85',20,4,'AKI-COM-003'),
('Bebidas','Milkshake Chocolate','Milkshake cremoso de chocolate com cobertura.',16.90,'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=900&q=85',30,6,'AKI-BEB-001'),
('Bebidas','Milkshake Morango','Milkshake cremoso de morango com calda.',16.90,'https://images.unsplash.com/photo-1553787499-6f9133860278?auto=format&fit=crop&w=900&q=85',30,6,'AKI-BEB-002'),
('Bebidas','Refrigerante Lata','Coca-Cola, Guaraná ou Pepsi — 350 ml.',6.00,'https://images.unsplash.com/photo-1629203849820-fdd70d49c38e?auto=format&fit=crop&w=900&q=85',80,15,'AKI-BEB-003'),
('Bebidas','Suco de Laranja','Suco natural de laranja, preparado na hora — 300 ml.',8.90,'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=900&q=85',50,10,'AKI-BEB-004'),
('Bebidas','Suco de Maracujá','Suco refrescante de maracujá — 300 ml.',9.90,'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=900&q=85',50,10,'AKI-BEB-005'),
('Bebidas','Suco de Morango','Suco cremoso de morango, servido gelado — 300 ml.',10.90,'https://images.unsplash.com/photo-1553530666-ba11a7da3888?auto=format&fit=crop&w=900&q=85',50,10,'AKI-BEB-006'),
('Bebidas','Suco de Abacaxi com Hortelã','Suco natural de abacaxi com hortelã — 300 ml.',9.90,'https://espaconatelie.com.br/wp-content/uploads/2024/09/Suco-de-abacaxi-com-hortela.jpg',50,10,'AKI-BEB-007'),
('Sobremesas','Açaí Especial','Açaí com banana, morango, granola e leite em pó.',21.90,'https://upload.wikimedia.org/wikipedia/commons/a/ad/A%C3%A7a%C3%AD.jpg',30,6,'AKI-SOB-001'),
('Sobremesas','Sorvete Cremoso','Duas bolas de sorvete cremoso nos sabores chocolate, morango ou creme.',12.90,'https://upload.wikimedia.org/wikipedia/commons/1/12/Ice_Cream_Scoops.JPG',30,6,'AKI-SOB-002'),
('Sobremesas','Pudim de Leite','Pudim de leite condensado cremoso com calda de caramelo.',10.90,'https://live.staticflickr.com/3311/3544225805_df46b4d51e_o.jpg',30,6,'AKI-SOB-003'),
('Sobremesas','Brownie com Sorvete','Brownie de chocolate com sorvete e calda.',19.90,'https://images.unsplash.com/photo-1564355808539-22fda35bed7e?auto=format&fit=crop&w=900&q=85',30,6,'AKI-SOB-004')
) AS v(category,name,description,price,image_url,stock_quantity,minimum_stock,sku)
JOIN categories c ON c.name=v.category
ON CONFLICT (sku) DO NOTHING;
