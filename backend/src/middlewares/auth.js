const jwt = require('jsonwebtoken');
const env = require('../config/env');

function authenticate(req, res, next) {
  const header = req.headers.authorization || '';
  const [type, token] = header.split(' ');
  if (type !== 'Bearer' || !token) return res.status(401).json({ error: 'Token de acesso ausente.' });
  try { req.auth = jwt.verify(token, env.jwtSecret); next(); }
  catch { return res.status(401).json({ error: 'Token inválido ou expirado.' }); }
}
function requirePermission(code) {
  return (req, res, next) => {
    if (!req.auth?.permissions?.includes(code)) return res.status(403).json({ error: 'Permissão insuficiente.' });
    next();
  };
}
module.exports = { authenticate, requirePermission };
