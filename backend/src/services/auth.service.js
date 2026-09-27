const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');
const env = require('../config/env');

async function findUserByEmail(email) {
  const { rows } = await db.query(`SELECT u.id,u.name,u.email,u.phone,u.password_hash,u.active,r.id role_id,r.name role_name,
    COALESCE(array_agg(DISTINCT p.code) FILTER (WHERE p.code IS NOT NULL),'{}') permissions
    FROM users u JOIN roles r ON r.id=u.role_id LEFT JOIN role_permissions rp ON rp.role_id=r.id LEFT JOIN permissions p ON p.id=rp.permission_id
    WHERE LOWER(u.email)=LOWER($1) GROUP BY u.id,r.id,r.name`, [email]);
  return rows[0];
}
async function findUserById(id) { const { rows } = await db.query(`SELECT u.id,u.name,u.email,u.phone,u.password_hash,u.active,r.id role_id,r.name role_name, COALESCE(array_agg(DISTINCT p.code) FILTER (WHERE p.code IS NOT NULL),'{}') permissions FROM users u JOIN roles r ON r.id=u.role_id LEFT JOIN role_permissions rp ON rp.role_id=r.id LEFT JOIN permissions p ON p.id=rp.permission_id WHERE u.id=$1 GROUP BY u.id,r.id,r.name`, [id]); return rows[0]; }
async function authenticateUser(email, password) {
  const user = await findUserByEmail(email);
  if (!user || !user.active || !(await bcrypt.compare(password, user.password_hash))) return null;
  return user;
}
function publicUser(user) { const { password_hash, ...safe } = user; return safe; }
function issueToken(user) {
  return jwt.sign({ sub:user.id, role:user.role_name, permissions:user.permissions }, env.jwtSecret, { expiresIn: env.jwtExpiresIn });
}
async function registerClient({name,email,phone,password}) {
  const exists = await findUserByEmail(email);
  if (exists) throw Object.assign(new Error('E-mail já cadastrado.'), { status:409 });
  const role = (await db.query(`SELECT id,name FROM roles WHERE name='CLIENTE'`)).rows[0];
  const hash = await bcrypt.hash(password, 12);
  const { rows } = await db.query(`INSERT INTO users(role_id,name,email,phone,password_hash) VALUES($1,$2,$3,$4,$5)
    RETURNING id,name,email,phone,active,created_at`, [role.id,name,email,phone||null,hash]);
  const user = await findUserByEmail(email); return { user: publicUser(user), token: issueToken(user) };
}
module.exports = { findUserByEmail, findUserById, authenticateUser, publicUser, issueToken, registerClient };
