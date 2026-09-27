require('dotenv').config();

const env = {
  port: Number(process.env.PORT || 3000),
  nodeEnv: process.env.NODE_ENV || 'development',
  corsOrigin: process.env.CORS_ORIGIN || '*',
  apiPrefix: process.env.API_PREFIX || '/api/v1',
  databaseUrl: process.env.DATABASE_URL || '',
  jwtSecret: process.env.JWT_SECRET || 'dev-only-change-me',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '8h',
  paymentProvider: process.env.PAYMENT_PROVIDER || 'mock',
  whatsappProvider: process.env.WHATSAPP_PROVIDER || 'mock'
};
if (env.nodeEnv === 'production' && env.jwtSecret === 'dev-only-change-me') throw new Error('JWT_SECRET deve ser configurado em produção.');
module.exports = env;
