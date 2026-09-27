# AKI Delivery — Backend e API

## Etapas 1 a 15

A API foi evoluída sobre PostgreSQL e agora cobre autenticação JWT, usuários, produtos, pedidos, pagamentos, WhatsApp, entregas/localização, notificações, histórico, relatórios, dashboard e permissões.

### Subir ambiente
```bash
npm install
copy .env.example .env
# Linux/macOS: cp .env.example .env
docker compose up -d
npm run db:init
npm run db:seed-admin
npm run dev
```

Admin de desenvolvimento padrão: `admin@akidelivery.local` / `Admin@12345`. Altere `ADMIN_PASSWORD` antes de uso real.

### Principais endpoints
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/register`
- `GET /api/v1/auth/me`
- `GET/POST/PUT /api/v1/products`
- `GET/POST /api/v1/orders`
- `PATCH /api/v1/orders/:id/status`
- `GET /api/v1/orders/:id/history`
- `GET/POST /api/v1/stock`
- `GET/POST /api/v1/deliveries`
- `GET/PATCH /api/v1/payments`
- `GET/POST /api/v1/whatsapp`
- `GET/PATCH /api/v1/notifications`
- `GET /api/v1/reports/dashboard`
- `GET /api/v1/reports/financial`
- `GET/POST/PATCH /api/v1/admin/users`

### Integrações externas
Pagamentos, WhatsApp Business e mapas foram estruturados para receber provedores reais por configuração. O pacote entregue não inventa credenciais nem simula uma integração externa como se fosse produção: o modo `mock` é explicitamente identificado.

### Segurança
JWT, bcrypt, Helmet, CORS configurável, validação básica de entrada, controle de permissões, transações PostgreSQL e bloqueio de estoque negativo.

## Banco revisado

A estrutura de dados recebeu uma segunda camada de complementação em `sql/migrations/002_core_complement.sql`, incluindo número do pedido, configurações da empresa, auditoria, carrinho persistente, SKU/preparo de produtos e triggers de histórico/`updated_at`. O catálogo completo do frontend está em `sql/seed-products.sql`.

Consulte também `DATABASE.md`.
