const fs = require('fs');
const path = require('path');
const { pool } = require('../src/config/database');

const run = async () => {
  const schema = fs.readFileSync(path.join(__dirname, '../sql/schema.sql'), 'utf8');
  const seed = fs.readFileSync(path.join(__dirname, '../sql/seed.sql'), 'utf8');
const migrationsDir = path.join(__dirname, '../sql/migrations');
const migrations = fs.readdirSync(migrationsDir).filter(f=>f.endsWith('.sql')).sort().map(f=>fs.readFileSync(path.join(migrationsDir,f),'utf8'));
const products = fs.readFileSync(path.join(__dirname, '../sql/seed-products.sql'), 'utf8');

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query(schema);
    await client.query(seed);
    for (const migration of migrations) await client.query(migration);
    await client.query(products);
    await client.query('COMMIT');
    console.log('Banco AKI Delivery inicializado com sucesso.');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Falha ao inicializar o banco:', error.message);
    process.exitCode = 1;
  } finally {
    client.release();
    await pool.end();
  }
};

run();
