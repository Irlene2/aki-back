-- Integridade e índices adicionais para a próxima fase da plataforma.
CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email_lower ON users (LOWER(email));
CREATE INDEX IF NOT EXISTS idx_products_active_name ON products(active,name);
CREATE INDEX IF NOT EXISTS idx_stock_movements_product_created ON stock_movements(product_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_payments_status_created ON payments(status,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_deliveries_driver_status ON deliveries(driver_id,status);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id,read_at,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_addresses_user_created ON addresses(user_id,created_at DESC);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='payments_change_for_nonnegative') THEN
    ALTER TABLE payments ADD CONSTRAINT payments_change_for_nonnegative CHECK (change_for IS NULL OR change_for >= 0);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='products_preparation_positive') THEN
    ALTER TABLE products ADD CONSTRAINT products_preparation_positive CHECK (preparation_minutes > 0);
  END IF;
END $$;
