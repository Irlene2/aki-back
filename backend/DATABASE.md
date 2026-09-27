# Banco de dados — AKI Delivery

## Tecnologia

PostgreSQL 16 via Docker Compose.

## Estrutura atual

- usuários, perfis e permissões;
- endereços;
- categorias e produtos;
- estoque e movimentações;
- pedidos e itens;
- pagamentos;
- entregas e localização;
- histórico de status;
- notificações;
- mensagens WhatsApp;
- configurações da empresa;
- auditoria;
- carrinho persistente;
- número amigável do pedido.

## Inicialização

```bash
cd backend
npm install
copy .env.example .env
# Linux/macOS: cp .env.example .env
docker compose up -d
npm run db:init
npm run db:seed-admin
npm run dev
```

No desenvolvimento, o `seed-admin.js` usa `ADMIN_EMAIL` e `ADMIN_PASSWORD` do ambiente. Altere a senha antes de usar o sistema fora de um ambiente local.

## Estado da criação

Os scripts SQL e o `docker-compose.yml` estão preparados. A execução física do PostgreSQL depende de Docker/PostgreSQL disponível na máquina de desenvolvimento.
