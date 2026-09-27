-- Identificador numérico amigável para o cliente e equipe.
CREATE SEQUENCE IF NOT EXISTS order_number_seq START 100001;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS order_number BIGINT;
UPDATE orders SET order_number = nextval('order_number_seq') WHERE order_number IS NULL;
ALTER TABLE orders ALTER COLUMN order_number SET DEFAULT nextval('order_number_seq');
ALTER TABLE orders ALTER COLUMN order_number SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_orders_order_number ON orders(order_number);

-- Configurações básicas da operação.
CREATE TABLE IF NOT EXISTS company_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_name VARCHAR(160) NOT NULL DEFAULT 'AKI Delivery',
  phone VARCHAR(30),
  whatsapp VARCHAR(30),
  delivery_fee NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (delivery_fee >= 0),
  minimum_order NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (minimum_order >= 0),
  estimated_delivery_minutes INTEGER NOT NULL DEFAULT 45 CHECK (estimated_delivery_minutes > 0),
  opening_time TIME,
  closing_time TIME,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Preferências/endereço do cliente ficam no banco, não apenas no navegador.
CREATE INDEX IF NOT EXISTS idx_addresses_user_id ON addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_order_status_history_order_id_created ON order_status_history(order_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_delivery_locations_recorded_at ON delivery_locations(delivery_id, recorded_at DESC);

-- Auditoria mínima para operações administrativas.
CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(100) NOT NULL,
  entity VARCHAR(100) NOT NULL,
  entity_id UUID,
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_created ON audit_logs(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity ON audit_logs(entity, entity_id);

-- Carrinho persistido opcionalmente para permitir continuidade entre dispositivos/sessões.
CREATE TABLE IF NOT EXISTS carts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS cart_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(cart_id, product_id)
);

-- Campos úteis para catálogo sem quebrar a estrutura atual.
ALTER TABLE products ADD COLUMN IF NOT EXISTS sku VARCHAR(80);
ALTER TABLE products ADD COLUMN IF NOT EXISTS preparation_minutes INTEGER NOT NULL DEFAULT 15 CHECK (preparation_minutes > 0);
CREATE UNIQUE INDEX IF NOT EXISTS uq_products_sku ON products(sku) WHERE sku IS NOT NULL;

-- Integridade operacional: cada pedido novo começa seu histórico.
CREATE OR REPLACE FUNCTION fn_order_status_history() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO order_status_history(order_id,status,changed_by,note)
    VALUES(NEW.id,NEW.status,NULL,'Pedido criado');
  ELSIF TG_OP = 'UPDATE' AND NEW.status IS DISTINCT FROM OLD.status THEN
    INSERT INTO order_status_history(order_id,status,changed_by,note)
    VALUES(NEW.id,NEW.status,NULL,'Status atualizado');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_order_status_history ON orders;
CREATE TRIGGER trg_order_status_history
AFTER INSERT OR UPDATE OF status ON orders
FOR EACH ROW EXECUTE FUNCTION fn_order_status_history();

-- Atualização automática de updated_at.
CREATE OR REPLACE FUNCTION fn_touch_updated_at() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_users_updated_at ON users;
CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();
DROP TRIGGER IF EXISTS trg_products_updated_at ON products;
CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();
DROP TRIGGER IF EXISTS trg_orders_updated_at ON orders;
CREATE TRIGGER trg_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();
DROP TRIGGER IF EXISTS trg_company_settings_updated_at ON company_settings;
CREATE TRIGGER trg_company_settings_updated_at BEFORE UPDATE ON company_settings FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();

INSERT INTO company_settings(company_name, delivery_fee, minimum_order, estimated_delivery_minutes)
SELECT 'AKI Delivery', 5.00, 15.00, 45
WHERE NOT EXISTS (SELECT 1 FROM company_settings);

