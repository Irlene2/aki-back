const { Pool } = require('pg');
const env = require('./env');

if (!env.databaseUrl) {
  console.warn('DATABASE_URL não configurada. Configure o arquivo .env antes de usar o banco.');
}

const pool = new Pool({
  connectionString: env.databaseUrl || undefined,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

pool.on('error', (error) => {
  console.error('Erro inesperado no pool PostgreSQL:', error.message);
});

const query = (text, params) => pool.query(text, params);

const checkDatabase = async () => {
  const result = await query('SELECT NOW() AS now');
  return result.rows[0];
};

module.exports = { pool, query, checkDatabase };
